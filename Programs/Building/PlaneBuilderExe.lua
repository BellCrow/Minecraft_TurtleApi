os.loadAPI("\\Api\\Moving\\TurtleMove.lua")
os.loadAPI("\\Api\\Moving\\Fuel.lua")

os.loadAPI("\\Api\\Building\\PlaneBuilder.lua")

local table_fuelSlots = {10,11}

local obj_fuelApi = Fuel.FuelHandler:new(table_fuelSlots)

local obj_turtleMover = TurtleMove.MoveHandler:new(obj_fuelApi)

local table_buildingSlots = {1,2,3}
local obj_planeBuilder = PlaneBuilder.PlaneBuilder:new(obj_turtleMover, table_buildingSlots)

obj_planeBuilder:void_BuildPlane(5,1)
