os.loadAPI("\\Api\\Moving\\TurtleMove.lua")
os.loadAPI("\\Api\\Moving\\Fuel.lua")

os.loadAPI("\\Api\\Mining\\Excavating.lua")

table_fuelSlots = {10,11}

obj_fuelApi = Fuel.FuelHandler:new(table_fuelSlots)

obj_turtleMover = TurtleMove.MoveHandler:new(obj_fuelApi)

local obj_excavater = Excavating.Excavater:New(obj_turtleMover)

excDims = {x = -5, y = 4, z = 6}
obj_excavater:ExcavateCuboid(excDims)
