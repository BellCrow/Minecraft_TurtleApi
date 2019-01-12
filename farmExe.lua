os.loadAPI("fuelApi.lua")
os.loadAPI("turtleMoveApi.lua")
os.loadAPI("farmApi.lua")

fuelSlots = {15,16}
seedSlots = {1,2}
fuelHelper = fuelApi.FuelHandler:new(fuelSlots)

turtleMover = turtleMoveApi.MoveHandler:new(fuelHelper)

moveList = {}
table.insert(moveList,{f = 4})
table.insert(moveList,{l = 1})
table.insert(moveList,{f = 4})

farmHandler = farmApi.FarmHandler:new(turtleMover,moveList,moveList,3,6,seedSlots)

print(farmHandler:bool_DoRun())
