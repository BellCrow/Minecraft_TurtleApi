MessageCommunicator = {}
MessageCommunicator.__index = MessageCommunicator

function MessageCommunicator:new(str_rednetModemSide)
    if(str_rednetModemSide == nil) then
        error("str_rednetModemSide" .. "value cannot be nil", 2)
    end

    local instance = {}
    setmetatable(instance, MessageCommunicator)

    if(not rednet.isOpen())then
        rednet.open(str_rednetModemSide)
    end
    return instance
end

function MessageCommunicator:SendMessage(int_receiverId, table_messageToSend, str_protocolName)
    --access fields/properties like:
    --self.fieldName
    --call methods like:
    --self:methodName
    if(int_receiverId == nil) then
        error("int_receiverId" .. "value cannot be nil",2)
    end
    if(table_messageToSend == nil) then
        error("table_messageToSend" .. "value cannot be nil",2)
    end

    local str_serializedMessage = textutils.serialize(table_messageToSend)
    rednet.send(int_receiverId, str_serializedMessage, str_protocolName)
end

function MessageCommunicator:int_table_ReceiveMessage(str_protocolName, int_timeOut)
    local int_receiverid, str_serializedMessage = rednet.receive(str_protocolName, int_timeOut)
    if str_serializedMessage == nil then
        return nil
    end
    local table_deserializedMessage = textutils.unserialize(str_serializedMessage)
    return int_receiverid, table_deserializedMessage
end