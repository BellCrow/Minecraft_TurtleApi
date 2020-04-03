local MessageCommunicator = {}
MessageCommunicator.__index = MessageCommunicator

function MessageCommunicator:new(str_rednetModemSide)
    if(str_rednetModemSide == nil) then
        error("str_rednetModemSide" .. "value cannot be nil", 2)
    end

    local instance = {}
    setmetatable(instance, MessageCommunicator)
    --set fields like this
    --instance.int_value = int_argument
    
    if(not rednet.isOpen())then
        rednet.open(str_rednetModemSide)
    end
    return instance
end

function MessageCommunicator:SendMessage(int_receiverId, table_messageToSend)
    --access fields/properties like:
    --self.fieldName
    --call methods like:
    --self:methodName
    if(table_messageToSend == nil) then
        error("table_messageToSend" .. "value cannot be nil",2)
    end
    local str_serialzedMesage = textutils.serialize(table_messageToSend)
    rednet.send
end