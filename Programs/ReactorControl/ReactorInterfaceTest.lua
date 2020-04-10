os.loadAPI("\\Api\\MekanismReactor\\ReactorInterface.lua")
os.loadAPI("\\Api\\Communication\\MessageCommunicator.lua")


print("Using " .. ReactorInterface.str_GetProtocolName())
communicator = MessageCommunicator.MessageCommunicator:new("back",ReactorInterface.str_GetProtocolName())

communicator:SendMessage(7,"Mes_QueryStatus")
local _,message = communicator:int_table_ReceiveMessage()

print(message.MessageType)
