os.loadAPI("\\Api\\Communication\\MessageCommunicator.lua")
os.loadAPI("\\Api\\MekanismReactor\\ReactorController.lua")

local reactorControllerId = 6

local reactorCommunicator = MessageCommunicator.MessageCommunicator:new("back",ReactorController.GetProtocolName())

reactorCommunicator:SendMessage(reactorControllerId,"Mes_SetInjectionRate",10)
local senderId, message = reactorCommunicator:int_table_ReceiveMessage()

print(message.MessageType)
print(message.Payload)