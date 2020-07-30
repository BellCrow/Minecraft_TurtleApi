FuelController = {}
FuelController.__index = FuelController

local debug = false

local str_FuelControllerProtocolName = "Api_FuelController"

local str_MesQueryStatusType = "Mes_QueryStatus"

function FuelController:new(obj_messageCommunicator,str_tritiumFuelSide, str_deuteriumFuelSide)
    if(obj_messageCommunicator == nil) then
        error("obj_messageCommunicator" .. " value cannot be nil",2)
    end
    if(str_tritiumFuelSide == nil) then
        error("str_tritiumFuelSide" .. " value cannot be nil",2)
    end
    if(str_deuteriumFuelSide == nil) then
        error("str_deuteriumFuelSide" .. " value cannot be nil",2)
    end

    if debug then
        print("Setting message communicator protocol to " .. str_GetProtocolName())
    end

    obj_messageCommunicator:SetProtocolName(str_GetProtocolName())

    local instance = {}
    setmetatable(instance, FuelController)
    --set fields like this
    --instance.int_value = int_argument
    instance.obj_messageCommunicator = obj_messageCommunicator
    instance.str_tritiumFuelSide = str_tritiumFuelSide
    instance.str_deuteriumFuelSide = str_deuteriumFuelSide
    return instance
end

function FuelController:RednetLoop()
    --receive a request from any client with commands
    while(true) do
        self:ReceiveAndDispatchRednetMessage()
    end
end

function FuelController:ReceiveAndDispatchRednetMessage()

    print("Waiting for message...")
    local int_senderId, table_message = self.obj_messageCommunicator:int_table_ReceiveMessage()

    print("Recv. message from " .. int_senderId .. " Type: ".. table_message.MessageType)
    self:HandleMessage(table_message,int_senderId)
end

function FuelController:HandleMessage(table_message,int_senderId)
    if table_message.MessageType == str_MesQueryStatusType then
        fuelStatus = self:table_GetFuelStats()
        self.obj_messageCommunicator:SendMessage(int_senderId,str_MesQueryStatusType,fuelStatus)
    else
        self.obj_messageCommunicator:SendMalformedMessageError(int_senderId,"Unknown message id " .. tostring(table_message.MessageType))
    end
end

function FuelController:table_GetFuelStats()
    local deuteriumRedstoneLevel = redstone.getAnalogInput(self.str_deuteriumFuelSide)
    local tritiumRedstoneLevel = redstone.getAnalogInput(self.str_tritiumFuelSide)
    local deuteriumFraction = math.max((deuteriumRedstoneLevel - 1) / 14, 0)
    local tritiumFraction = math.max((tritiumRedstoneLevel - 1) / 14, 0)
    local result = {}
    result.float_tritiumFraction = tritiumFraction
    result.float_deuteriumFraction = deuteriumFraction
    return result
end

--Statics
function str_GetProtocolName()
    return str_FuelControllerProtocolName
end
