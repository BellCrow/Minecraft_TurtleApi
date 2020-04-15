os.loadAPI("\\Api\\MekanismReactor\\ReactorInterface.lua")
os.loadAPI("\\Api\\MekanismReactor\\FuelController.lua")
os.loadAPI("\\Api\\MekanismReactor\\LaserController.lua")
os.loadAPI("\\Api\\MekanismReactor\\ReactorController.lua")

os.loadAPI("\\Api\\Communication\\MessageCommunicator.lua")


local laserCom = MessageCommunicator.MessageCommunicator:new("back", LaserController.str_GetProtocolName())
local fuelCom = MessageCommunicator.MessageCommunicator:new("back", FuelController.str_GetProtocolName())
local reactorCom = MessageCommunicator.MessageCommunicator:new("back", ReactorController.str_GetProtocolName())

local interfaceCom = MessageCommunicator.MessageCommunicator:new("back", ReactorInterface.str_GetProtocolName())

reactorInterface = ReactorInterface.ReactorInterface:new(interfaceCom,
reactorCom,6,
fuelCom,9,
laserCom,1)

reactorInterface:RednetLoop()