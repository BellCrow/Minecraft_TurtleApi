os.loadApi("\\Api\\Building\\PlaneBuilder.lua")
os.loadApi("\\Api\\Moving\\TurtleMove.lua")
os.loadApi("\\Api\\Moving\\Fuel.lua")

table_fuelSlots = {10,11}
obj_fueApi = Fuel.new(table_fuelSlots)

obj_turtleMover = TurtleMove.new(obj_fueApi)

table_buildingSlots = {1,2,3}
obj_planeBuilder = PlaneBuilder.new(obj_turtleMover, table_buildingSlots)

obj_planeBuilder:void_BuildPlane(5,6)