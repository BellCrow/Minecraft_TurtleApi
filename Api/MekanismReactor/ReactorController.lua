local ReactorController = {}
ReactorController.__index = ReactorController

local str_ReactorControllerProtocolName = "Api_ReactorController"

function ReactorController:new(obj_messageCommunicator, str_reactorControlSide)
    if(obj_messageCommunicator == nil) then
        error("obj_messageCommunicator" .. "value cannot be nil",2)
    end

    if(str_reactorControlSide == nil) then
        error("str_reactorControlSide" .. "value cannot be nil",2)
    end

    local instance = {}
    setmetatable(instance, ReactorController)
    --set fields like this
    --instance.int_value = int_argument
    instance.obj_messageCommunicator = obj_messageCommunicator
    instance.str_reactorControlSide = str_reactorControlSide
    return instance
end

function ReactorController:RednetLoop()
    --access fields/properties like:
    --self.fieldName
    --call methods like:
    --self:methodName

    while(true)do
        self:ReceiveAndDispatchRednetMessage()
    end
end

function ReactorController:ReceiveAndDispatchRednetMessage()
    --access fields/properties like:
    --self.fieldName
    --call methods like:
    --self:methodName
    local int_senderId, table_message = self.obj_messageCommunicator:int_table_ReceiveMessage(str_LaserControllerProtocolName)
end
