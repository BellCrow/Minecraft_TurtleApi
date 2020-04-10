os.loadAPI("\\Api\\Communication\\MessageCommunicator.lua")
os.loadAPI("\\Api\\MekanismReactor\\FuelController.lua")

local reactorControllerId = 9

local reactorCommunicator = MessageCommunicator.MessageCommunicator:new("back",FuelController.str_GetProtocolName())

while true do 
    term.clear()
    reactorCommunicator:SendMessage(reactorControllerId,"Mes_QueryStatus")
    local senderId, message = reactorCommunicator:int_table_ReceiveMessage()
    print("Deuterium: " .. message.Payload.float_deuteriumFraction)
    print("Tritium: " .. message.Payload.float_tritiumFraction)
    os.sleep(0.5)
end
