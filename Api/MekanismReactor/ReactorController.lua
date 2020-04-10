ReactorController = {}
ReactorController.__index = ReactorController

local str_MesQueryStatusType = "Mes_QueryStatus"
local str_MesSetInjectionRate = "Mes_SetInjectionRate"

local str_ReactorControllerProtocolName = "Api_ReactorController"

function ReactorController:new(obj_messageCommunicator, str_reactorControlSide)
    if(obj_messageCommunicator == nil) then
        error("obj_messageCommunicator" .. "value cannot be nil",2)
    end

    if(str_reactorControlSide == nil) then
        error("str_reactorControlSide" .. "value cannot be nil",2)
    end
    obj_messageCommunicator:SetProtocolName(str_ReactorControllerProtocolName)
    local instance = {}
    setmetatable(instance, ReactorController)
    --set fields like this
    --instance.int_value = int_argument
    instance.obj_messageCommunicator = obj_messageCommunicator
    instance.obj_reactorWrap = peripheral.wrap(str_reactorControlSide)
    return instance
end

function GetProtocolName()
    return str_ReactorControllerProtocolName
end

function ReactorController:RednetLoop()
    while(true)do
        self:ReceiveAndDispatchRednetMessage()
    end
end

function ReactorController:ReceiveAndDispatchRednetMessage()
    io.write("Waiting for message...")
    local int_senderId, table_message
    = self.obj_messageCommunicator:int_table_ReceiveMessage()
    print("message received from " .. tostring(int_senderId))
    self:HandleMessage(table_message,int_senderId)
end

function ReactorController:HandleMessage(table_message,int_senderId)
    if(table_message.MessageType == str_MesQueryStatusType) then
        local table_reactorStatus = self:table_QueryStatus();
        self.obj_messageCommunicator:SendMessage(int_senderId,str_MesQueryStatusType,table_reactorStatus)
    elseif table_message.MessageType == str_MesSetInjectionRate then
        self:SetInjectionRate(table_message.Payload)
        self.obj_messageCommunicator:SendMessage(int_senderId,str_MesSetInjectionRate,true)
    else
        self.obj_messageCommunicator:SendMalformedMessageError("Unrecognized message type " .. table_message.MessageType .. " in reactor controller")
    end
end

function ReactorController:SetInjectionRate(int_injectionRate)
    self.obj_reactorWrap.setInjectionRate(int_injectionRate)
end

function ReactorController:table_QueryStatus()
    local result = {}
    result.plasmaHeat = self.obj_reactorWrap.getPlasmaHeat()
    result.injectionRate = self.obj_reactorWrap.getInjectionRate()
    result.isIgnited = self.obj_reactorWrap.isIgnited()
    result.canIgnite = self.obj_reactorWrap.canIgnite()
    result.producingAmount = self.obj_reactorWrap.getProducing()
    return result
end

function ReactorController:SendMalformedMessageError(int_receiverId)
    local table_malformedMessageError = {}
    table_malformedMessageError.MessageType = "MalformedMessage"
    self:SendMessage(int_receiverId, table_malformedMessageError)
end