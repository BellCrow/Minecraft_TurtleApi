-- Fuel class for handling refueling of a turtle in simply manners
FuelHandler = {}
FuelHandler.__index = FuelHandler

local minSlotNumber = 1
local maxSlotNumber = 16

local fuelNameEnergyMapping = { ["minecraft:coal"] = 80}

--public api

---creates a new instance of the fuelhandler
--@param fuelSlotsArg a talbe with numbers representing the slots to llok in for fuelitems
function FuelHandler:new(fuelSlotsArg)
    if(fuelSlotsArg == nil) then
        error("supplied null as fuelslots argument")
    end
    for index,value in ipairs(fuelSlotsArg) do
        if(value > maxSlotNumber or value < minSlotNumber) then
            error("Suplied illegal index as fuel slot")
        end
    end

    local instance = {}
    setmetatable(instance,FuelHandler)
    instance.fuelSlots = fuelSlotsArg

    instance:checkFuelLegal()

    return instance
end

function FuelHandler:bool_refuelOnDemand()
    if(turtle.getFuelLevel() ~= 0) then
        return true
    end
    selectedSlot = turtle.getSelectedSlot() 
    nextFuelslot = self:int_getNextFullFuelSlot()
    if(nextFuelslot == -1) then
        return false
    end
    turtle.select(nextFuelslot)
    turtle.refuel(1)
    turtle.select(selectedSlot)
    return true
end

function FuelHandler:int_getMoveRange()
    movementRange = 0
    for index,fuelSlot in ipairs(self.fuelSlots) do
        
        --only check fuel level, even if there are any fuel items
        if(turtle.getItemCount(fuelSlot) > 0) then
            
            local fuelSlotItem = turtle.getItemDetail(fuelSlot)
            movementRange = movementRange + int_getMovementCountForFuelItem(fuelSlotItem.name) * fuelSlotItem.count
        end
    end

    return movementRange + turtle.getFuelLevel()
end

--private api
function FuelHandler:checkFuelLegal()
    for index,fuelSlot in ipairs(self.fuelSlots) do
        --only check fuel level, even if there are any fuel items
        if(turtle.getItemCount(fuelSlot) > 0) then
            local fuelSlotItem = turtle.getItemDetail(fuelSlot)
            if(not b_isLegalFuelItem(fuelSlotItem.name)) then
                error("Illegal fuel item in slot "..fuelSlot.." "..fuelSlotItem.name)
            end
        end
    end
end

function FuelHandler:int_getNextFullFuelSlot()
    for index,fuelSlot in ipairs(self.fuelSlots) do
        if(turtle.getItemCount(fuelSlot) > 0) then
            return fuelSlot
        end
    end
    return -1
end

function b_isLegalFuelItem(str_fuelItemName)
    for index,value in pairs(fuelNameEnergyMapping) do
        if(index == str_fuelItemName) then 
            return true
        end
    end
    return false
end

function int_getMovementCountForFuelItem(str_fuelItemName)
    if(not b_isLegalFuelItem(str_fuelItemName)) then
        return math.nan
    end
    return fuelNameEnergyMapping[str_fuelItemName]
end