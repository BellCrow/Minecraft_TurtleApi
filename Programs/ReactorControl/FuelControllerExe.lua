os.loadAPI("\\Api\\MekanismReactor\\FuelController.lua")
os.loadAPI("\\Api\\Communication\\MessageCommunicator.lua")

messageCommunicator = MessageCommunicator.MessageCommunicator:new("top")
fuelController = FuelController.FuelController:new(messageCommunicator,"left","right")
fuelController:RednetLoop()