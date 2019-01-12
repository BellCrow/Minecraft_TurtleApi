os.loadAPI("fuelApi.lua")
os.loadAPI("turtleMoveApi.lua")
os.loadAPI("farmApi.lua")

fuelSlots = {15,16}
seedSlots = {1,2,3,4,5}
fuelHelper = fuelApi.FuelHandler:new(fuelSlots)

turtleMover = turtleMoveApi.MoveHandler:new(fuelHelper)

moveToFarmList = {}
table.insert(moveToFarmList,{f = 4})
table.insert(moveToFarmList,{l = 1})
table.insert(moveToFarmList,{f = 4})

moveFromFarmList = {}
table.insert(moveFromFarmList,{b = 4})
table.insert(moveFromFarmList,{r = 1})
table.insert(moveFromFarmList,{b = 4})

farmHandler = farmApi.FarmHandler:new(turtleMover,moveToFarmList,moveFromFarmList,20,10,seedSlots)

print(farmHandler:bool_DoRun())

