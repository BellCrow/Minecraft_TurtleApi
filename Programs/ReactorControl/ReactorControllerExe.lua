os.loadAPI("\\Api\\Communication\\MessageCommunicator.lua")
os.loadAPI("\\Api\\MekanismReactor\\ReactorController.lua")

local reactorMessageCommunicator = MessageCommunicator.MessageCommunicator:new("top")
local reactorController = ReactorController.ReactorController:new(reactorMessageCommunicator,"back")
reactorController:RednetLoop()