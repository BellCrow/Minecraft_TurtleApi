MessageCommunicator = {}
MessageCommunicator.__index = MessageCommunicator

local MalformedMessageType = "Mes_MalformedMessage"

local debug = false

function MessageCommunicator:new(str_rednetModemSide, str_protocolName)
    if(str_rednetModemSide == nil) then
        error("str_rednetModemSide" .. "value cannot be nil", 2)
    end

    local instance = {}
    setmetatable(instance, MessageCommunicator)

    if(not rednet.isOpen())then
        rednet.open(str_rednetModemSide)
    end
    instance.str_protocolName = str_protocolName
    return instance
end

function MessageCommunicator:SetProtocolName(str_protocolName)
    self.str_protocolName = str_protocolName
end

function MessageCommunicator:SendMessage(int_receiverId, str_messageType,table_payload)
    --access fields/properties like:
    --self.fieldName
    --call methods like:
    --self:methodName
    if(int_receiverId == nil) then
        error("int_receiverId" .. " value cannot be nil",2)
    end
    if(str_messageType == nil) then
        error("str_messageType" .. " value cannot be nil",2)
    end
    local message = {}
    message.MessageType = str_messageType
    message.Payload = table_payload
    local str_serializedMessage = textutils.serialize(message)
    if debug then
        print(self.str_protocolName)
    end
    rednet.send(int_receiverId, str_serializedMessage, self.str_protocolName)
end

function MessageCommunicator:int_table_ReceiveMessage(int_timeOut)
    local wellFormedMessageReceived = false
    local int_receiverid
    local str_serializedMessage
    local table_deserializedMessage

    while not wellFormedMessageReceived do
        if debug then
            print("in receive loop")
        end
        int_receiverid, str_serializedMessage = rednet.receive(self.str_protocolName, int_timeOut)
        if str_serializedMessage == nil then
            return nil
        end
        table_deserializedMessage = textutils.unserialize(str_serializedMessage)

        if table_deserializedMessage.MessageType == nil then
            self:SendMalformedMessageError("The sent message must contain a Messagetype, otheriwse it cannot be parsed")
        end
        wellFormedMessageReceived = true
    end
    return int_receiverid, table_deserializedMessage
end

function MessageCommunicator:SendMalformedMessageError(int_receiverId, str_reason)
    self:SendMessage(int_receiverId, MalformedMessageType, str_reason)
end