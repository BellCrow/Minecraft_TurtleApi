
--[[
    the movement requests must be made up from commands from the legalMovementList
    the movehandler api expects movement requests as a table made up the following syntax
    moveTable = {
        u = 1, --moves one upward
        f = 4, --moves forward
        d = 8, --moves 8 downward
        l = 1, --turns one time left
        sl = 2,--strafes 2 blocks to the left
        t = 1, --turns around ones
    }
--]]
local legalMovementCommands = {
    u = 1,
     --up
    d = 1,
     --down
    f = 1,
     --forward
    b = 1,
     --back
    l = 0,
     --left
    r = 0,
     --right
    t = 0, --turns around
    sl = 1,
     --strafe left
    sr = 1
 --strafe right
}

MoveHandler = {}
MoveHandler.__index = MoveHandler

--public api
function MoveHandler:new(obj_FuelHandlerInstanceArg)
    local instance = {}
    setmetatable(instance, MoveHandler)
    instance.obj_fuelHandlerInstance = obj_FuelHandlerInstanceArg
    return instance
end
 --

--[[will return a resultcode:
0 move succesfull
1 not enough fuel for move found in turtle/turtleInventory-> move was not attempted
2 move was blocked by entitie blocked
3 move list is corrupt
]]
function MoveHandler:int_ExecuteMoveTable(
    table_moveList)
    if (not self:bool_CheckMoveListLegal(table_moveList)) then
        return 3
    end
    local maxRange = self.obj_fuelHandlerInstance:int_getMoveRange()
    if (self:int_CalculateCostOfMoveList(table_moveList) > maxRange) then
        return 1
    end

    for index, moveListEntry in ipairs(table_moveList) do
        for moveSign,moveCount in pairs(moveListEntry) do
            if (not self:HandleMoveListEtry(moveSign, moveCount)) then
                return 2
            end
        end
    end
    return 0
end

function MoveHandler:HandleMoveListEtry(str_moveSign, int_moveCount)
    if (str_moveSign == "u") then
        return self:bool_MoveUp(int_moveCount, nil)
    end
    if (str_moveSign == "d") then
        return self:bool_MoveDown(int_moveCount, nil)
    end
    if (str_moveSign == "b") then
        return self:bool_MoveBack(int_moveCount, nil)
    end
    if (str_moveSign == "f") then
        return self:bool_MoveForward(int_moveCount, nil)
    end
    if (str_moveSign == "l") then
        return self:bool_TurnLeft(int_moveCount, nil)
    end
    if (str_moveSign == "r") then
        return self:bool_TurnRight(int_moveCount, nil)
    end
    if (str_moveSign == "sr") then
        return self:bool_StrafeRight(int_moveCount, nil)
    end
    if (str_moveSign == "sl") then
        return self:bool_StrafeLeft(int_moveCount, nil)
    end
end

function MoveHandler:int_CalculateCostOfMoveList(table_moveList)
    if (not self:bool_CheckMoveListLegal(table_moveList)) then
        return math.nan
    end

    local movementCost = 0

    for index, moveListEntry in ipairs(table_moveList) do
        for moveSign,moveDistance in pairs(moveListEntry) do
            movementCost = movementCost + self:int_GetCostOfMoveSign(moveSign) * moveDistance
        end
    end

    return movementCost
end

function MoveHandler:int_getMoveRange()
    return self.obj_fuelHandlerInstance:int_getMoveRange()
end

function MoveHandler:ConvertExecuteMovelistReturnCodeToString(int_returnCode)
    local returnTable = {
        [0] = "Move was succesfull",
        [1] = "Not enough fuel was found to eceute the movement list. The excecution was not attempted",
        [2] = "The movelist was started to be executed, but at some point an entitie blocked the turtle",
        [3] = "The movelist contained characters, that are deemed illegal"
    }

    return returnTable[int_returnCode]
end

--the stepfunction will be executed after each step.
--ergo if you step 4 times forward, the function will be executed 4 times
function MoveHandler:bool_MoveForward(int_stepCount, func_stepFunction, var_funcArg)
    return self:bool_ApplyMoveFunc(int_stepCount, turtle.forward, func_stepFunction,var_funcArg)
end

function MoveHandler:bool_MoveUp(int_stepCount, func_stepFunction, var_funcArg)
    return self:bool_ApplyMoveFunc(int_stepCount, turtle.up, func_stepFunction,var_funcArg)
end

function MoveHandler:bool_MoveDown(int_stepCount, func_stepFunction, var_funcArg)
    return self:bool_ApplyMoveFunc(int_stepCount, turtle.down, func_stepFunction,var_funcArg)
end

function MoveHandler:bool_MoveBack(int_stepCount, func_stepFunction, var_funcArg)
    return self:bool_ApplyMoveFunc(int_stepCount, turtle.back, func_stepFunction,var_funcArg)
end

function MoveHandler:bool_StrafeLeft(int_stepCount, func_stepFunction, var_funcArg)
    turtle.turnLeft()
    local success = self:bool_ApplyMoveFunc(int_stepCount, turtle.forward, func_stepFunction,var_funcArg)
    turtle.turnRight()
    return success
end

function MoveHandler:bool_StrafeRight(int_stepCount, func_stepFunction, var_funcArg)
    turtle.turnRight()
    local success = self:bool_ApplyMoveFunc(int_stepCount, turtle.forward, func_stepFunction,var_funcArg)
    turtle.turnLeft()

    return success
end

function MoveHandler:bool_TurnLeft(int_stepCount, func_stepFunction, var_funcArg)

    local success = self:bool_ApplyMoveFunc(int_stepCount, turtle.turnLeft, func_stepFunction,var_funcArg)
    return success
end

function MoveHandler:bool_TurnRight(int_stepCount, func_stepFunction, var_funcArg)
    local success = self:bool_ApplyMoveFunc(int_stepCount, turtle.turnRight, func_stepFunction,var_funcArg)
    return success
end

--private api

function MoveHandler:int_GetCostOfMoveSign(str_moveSign)
    if (not self:bool_IsMoveSignLegal(str_moveSign)) then
        return math.nan
    end
    return legalMovementCommands[str_moveSign]
end

function MoveHandler:bool_CheckMoveListLegal(table_moveList)
    for index, moveListEntry in ipairs(table_moveList) do
        for moveSign, moveCount in pairs(moveListEntry) do
            if (not self:bool_IsMoveSignLegal(moveSign)) then
                return false
            end
        end
    end

    return true
end

function MoveHandler:bool_IsMoveSignLegal(str_moveSign)
    for moveSign, cost in pairs(legalMovementCommands) do
        if (str_moveSign == moveSign) then
            return true
        end
    end
    return false
end

function MoveHandler:bool_ExcuteList(table_moveList)
    for moveSign, moveDistance in pairs(table_moveList) do
    end
end

function MoveHandler:bool_ApplyMoveFunc(int_repeatCounter, func_moveFunc, func_stepFunc, var_funcArg)
    if (not self.obj_fuelHandlerInstance:bool_refuelOnDemand()) then
        return false
    end
    for i = 0, int_repeatCounter - 1 do
        if (not self.obj_fuelHandlerInstance:bool_refuelOnDemand()) then
            return false
        end
        if (not func_moveFunc()) then
            return false
        end

        if (func_stepFunc ~= nil) then
            --even if the function has no arguments or nil is supplied as arg, this call will still work
            func_stepFunc(var_funcArg)
        end
    end
    return true
end
