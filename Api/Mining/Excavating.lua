debug = true
Excavater = {}
Excavater.__index = Excavater

---Creates a new instance of the Excavater
--@ param obj_turtleMoveApi An instance of the move api, that will be used to move the turtle around while mining
function Excavater:New(obj_turtleMoveApi)
    instance = {}
    instance.obj_turtleMoveApi = obj_turtleMoveApi
    setmetatable(instance, Excavater)
    return instance
end

---Excavates a cuboid shape, determined by the given table
--@ param table_dimensions a table, which must contain integer values in the fields x,y and z
--x and y make up the plane, that you walk on. where positive x values go ro the right of the turtle
--and positives y go in the direction, the turtle looks into
--and positive z values go up into the sky.
--E.g. x = 10, y = 2, z = -3 will excavate a hole, thats:
--10 blocks wide to the right of the turtle
--2 blocks forward in the direction of the turtle
--3 blocks deep into the ground
--Note: the y value cannot be equal to er less than 0. If you need the y 
--value to be zero, please turn the turtle around and use positive y values accordingly
--otheriwse the interpretation of the x values could be unexcpected
--the turtle has to stand in front of the first block in the cuboid to carve out
function Excavater:ExcavateCuboid(table_dimensions)
    if(table_dimensions.x == nil)then
        error("x dimension in table not set")
        return
    end
    if(table_dimensions.y == nil)then
        error("y dimension in table not set")
        return
    end
    if(table_dimensions.y < 0)then
        error("y dimension cannot be negative. Consider turning the turtle around and using positive y values")
        return
    end
    if(table_dimensions.z == nil)then
        error("z dimension in table not set")
        return
    end

    if(table_dimensions.x == 0 or table_dimensions.y == 0 or table_dimensions.z == 0)then
        error("No dimension value can be 0. Please only supply positive dimension values")
        return
    end
    self:InitializeTransitionFunctions(table_dimensions)
    table_dimensions.x = math.abs(table_dimensions.x)
    table_dimensions.y = math.abs(table_dimensions.y)
    table_dimensions.z = math.abs(table_dimensions.z)
    --first step into the cube
    self:MineForward()
    self.obj_turtleMoveApi:bool_MoveForward(1)
    if debug then
        print("Starting with ".. table_dimensions.x .." " .. table_dimensions.y .. " "..table_dimensions.z )
    end
    for z = 0, table_dimensions.z - 1 do
       self:ExcavatePlane(table_dimensions)
       if(not (z == table_dimensions.z -1))then
            self:planeTransitionFunction()
       end
    end
end

function Excavater:ExcavatePlane(table_dimensions)
    for x = 0, table_dimensions.x - 1 do
        self:ExcavateLine(table_dimensions)
        if(not (x == table_dimensions.x -1))then
            self:columnTransitionFunction()
            self:SwitchColumnTransitions()
        end
    end
end

function Excavater:ExcavateLine(table_dimensions)
    -- if(table_dimensions.y - 1 == 0)then 
    --     return 
    -- end
    --we can start at one, as the first block will
    --alwas already be mined. either by the inital 
    --moving into the field or by one of the transition functions
    for y = 1, table_dimensions.y - 1 do
        if debug then
            print(y)
        end
        self:MineForward()
        self.obj_turtleMoveApi:bool_MoveForward(1)
    end
end

function Excavater:InitializeTransitionFunctions(table_cubeDimensions)
    if(table_cubeDimensions.x > 0)then
        self.columnTransitionFunction = Excavater.RightTurnColumnTransition
    else
        self.columnTransitionFunction = Excavater.LeftTurnColumnTransition
    end
    if(table_cubeDimensions.z < 0)then
        self.planeTransitionFunction = Excavater.DownPlaneTransition
    else
        self.planeTransitionFunction = Excavater.UpPlaneTransition
    end
end

function Excavater:SwitchColumnTransitions()
    if(self.columnTransitionFunction == Excavater.RightTurnColumnTransition)then
        self.columnTransitionFunction = Excavater.LeftTurnColumnTransition
    else
        self.columnTransitionFunction = Excavater.RightTurnColumnTransition
    end
end

function Excavater:NegativeYInitialAction()
    result = self.obj_turtleMoveApi:bool_TurnRight(2)
end

function Excavater:RightTurnColumnTransition()
    self.obj_turtleMoveApi:bool_TurnRight(1)
    self:MineForward()
    self.obj_turtleMoveApi:bool_MoveForward(1)

    self.obj_turtleMoveApi:bool_TurnRight(1)
end

function Excavater:LeftTurnColumnTransition()
    self.obj_turtleMoveApi:bool_TurnLeft(1)
    self:MineForward()
    self.obj_turtleMoveApi:bool_MoveForward(1)
    self.obj_turtleMoveApi:bool_TurnLeft(1)
end

function Excavater:UpPlaneTransition()
    self:MineUp()
    self.obj_turtleMoveApi:bool_MoveUp(1)
    self.obj_turtleMoveApi:bool_TurnLeft(2)
end

function Excavater:DownPlaneTransition()
    self:MineDown()
    self.obj_turtleMoveApi:bool_MoveDown(1)
    self.obj_turtleMoveApi:bool_TurnLeft(2)
end

function Excavater:MineForward()
    while (turtle.detect()) do
        turtle.dig()
    end
end

function Excavater:MineUp()
    while (turtle.detectUp()) do
        turtle.digUp()
    end
end

function Excavater:MineDown()
    while (turtle.detectDown()) do
        turtle.digDown()
    end
end