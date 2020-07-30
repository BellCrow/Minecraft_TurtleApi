os.loadAPI("\\Api\\MekanismReactor\\FuelController.lua")
os.loadAPI("\\Api\\MekanismReactor\\LaserController.lua")
os.loadAPI("\\Api\\MekanismReactor\\ReactorController.lua")

--reactor message
local str_reactor_MesQueryStatusType = "Mes_QueryStatus"
local str_reactor_MesSetInjectionRate = "Mes_SetInjectionRate"

--laser messages
local str_laser_MesQueryStatusType = "Mes_QueryStatus"
local str_laser_MesRequestFireType = "Mes_RequestFire"
local str_laser_MesStartLoadingType = "Mes_StartLoading"
local str_laser_MesStopLoadingType = "Mes_StopLoading"

--fuel messages
local str_fuel_MesQueryStatusType = "Mes_QueryStatus"

--interface messages 
local str_MesQueryStatusType = "Mes_QueryStatus"
local str_MesIgniteType = "Mes_Ignite"

local str_ReactorInterfaceProtocolName = "ReactorInterfaceProtocol"

ReactorInterface = {}
ReactorInterface.__index = ReactorInterface
function ReactorInterface:new(obj_interfaceCommunicator,
     obj_reactorCommunicator,int_reactorControllerId,
      obj_fuelCommunicator,int_fuelControllerId,
       obj_laserCommunicator, int_laserControllerId)

    if(obj_interfaceCommunicator == nil) then
        error("obj_interfaceCommunicator" .. " value cannot be nil",2)
    end
    if(obj_reactorCommunicator == nil) then
        error("obj_reactorCommunicator" .. " value cannot be nil",2)
    end
    if(int_reactorControllerId == nil) then
        error("int_reactorControllerId" .. " value cannot be nil",2)
    end
    if(int_fuelControllerId == nil) then
        error("int_fuelControllerId" .. " value cannot be nil",2)
    end
    if(obj_fuelCommunicator == nil) then
        error("obj_fuelCommunicator" .. " value cannot be nil",2)
    end
    if(obj_laserCommunicator == nil) then
        error("obj_laserCommunicator" .. " value cannot be nil",2)
    end
    if(int_laserControllerId == nil) then
        error("int_laserControllerId" .. " value cannot be nil",2)
    end

    print("Using protocol " .. str_GetProtocolName())
    obj_interfaceCommunicator:SetProtocolName(str_GetProtocolName())
    obj_reactorCommunicator:SetProtocolName(ReactorController.str_GetProtocolName())
    obj_laserCommunicator:SetProtocolName(LaserController.str_GetProtocolName())
    obj_fuelCommunicator:SetProtocolName(FuelController.str_GetProtocolName())
    local instance = {}
    setmetatable(instance, ReactorInterface)
    --set fields like this
    --instance.int_value = int_argument
    instance.obj_interfaceCommunicator = obj_interfaceCommunicator
    instance.obj_reactorCommunicator = obj_reactorCommunicator
    instance.int_reactorControllerId = int_reactorControllerId
    instance.obj_fuelCommunicator = obj_fuelCommunicator
    instance.int_fuelControllerId = int_fuelControllerId
    instance.obj_laserCommunicator = obj_laserCommunicator
    instance.int_laserControllerId = int_laserControllerId
    return instance
end

function ReactorInterface:RednetLoop()
    --receive a request from any client with commands
    while(true) do
        self:ReceiveAndDispatchRednetMessage()
    end
end

function ReactorInterface:ReceiveAndDispatchRednetMessage()

    print("Waiting for message...")
    local int_senderId, table_message = self.obj_interfaceCommunicator:int_table_ReceiveMessage()

    print("Recv. message from " .. int_senderId .. " Type: ".. table_message.MessageType)
    self:HandleMessage(table_message,int_senderId)
end

function ReactorInterface:HandleMessage(table_message,int_senderId)
    if table_message.MessageType == str_MesQueryStatusType then
        local reactorStatus = self:table_GetReactorStatus()
        self.obj_interfaceCommunicator:SendMessage(int_senderId,str_MesQueryStatusType,reactorStatus)
    elseif table_message.MessageType == str_MesIgniteType then
        self.obj_interfaceCommunicator:SendMessage(int_senderId,str_MesIgniteType,self:table_IgniteReactor())
    else
        self.obj_interfaceCommunicator:SendMalformedMessageError(int_senderId,"Unknown message id " .. tostring(table_message.MessageType))
    end
end

function ReactorInterface:table_IgniteReactor()
    local result = {}
    local aggregatedReactorStatus = self:table_GetReactorStatus()
    local laserStatus = aggregatedReactorStatus.LaserStatus
    local float_laserLoadFraction = laserStatus.int_loadedEnergy / laserStatus.int_maxEnergy
    if float_laserLoadFraction <= 0.5 then
        result.Success = false;
        result.Reason = "The laser amplifier is currently at" .. float_laserLoadFraction * 100 .. "%. At least 50% is needed"
        return result
    end
    local reactorStatus = aggregatedReactorStatus.ReactorStatus
    if reactorStatus.injectionRate < 6 then
        result.Success = false
        result.Reason = "The fuel injection rate is currently at " .. reactorStatus.injectionRate .. ". At least 6 is needed"
        return result
    end
    if reactorStatus.tritiumLevel <= 980 or reactorStatus.deuteriumLevel <= 980 then
        result.Success = false
        result.Reason = "Detected missing fuel supply. Make sure, there is a continues supply of tritium and deuterium to the reactor"
        return result
    end

    self.obj_laserCommunicator:SendMessage(self.int_laserControllerId, str_laser_MesRequestFireType)
    local _, resultMessage = self.obj_laserCommunicator:int_table_ReceiveMessage()
    if resultMessage.Payload == false then
        result.Success = false
        result.Reason = "Unknown error during firing of laser occured"
        return result
    end
end

function int_RoundFloat(float_value, int_numberOfDecimals)
    int_decimalShiftValue = int_numberOfDecimals * 10
    float_multipliedNumber = float_value * int_decimalShiftValue
    intValue = math.floor(float_multipliedNumber)
    return intValue / int_decimalShiftValue

end

function ReactorInterface:table_GetReactorStatus()
    local result = {}
    self.obj_laserCommunicator:SendMessage(self.int_laserControllerId,str_laser_MesQueryStatusType)
    local _, message = self.obj_laserCommunicator:int_table_ReceiveMessage()
    result.LaserStatus = message.Payload

    self.obj_reactorCommunicator:SendMessage(self.int_reactorControllerId,str_reactor_MesQueryStatusType)
    local _, message = self.obj_reactorCommunicator:int_table_ReceiveMessage()
    result.ReactorStatus = message.Payload

    self.obj_fuelCommunicator:SendMessage(self.int_fuelControllerId,str_fuel_MesQueryStatusType)
    local _, message = self.obj_fuelCommunicator:int_table_ReceiveMessage()
    result.FuelStatus = message.Payload
    return result
end

--statics 
function str_GetProtocolName()
    return str_ReactorInterfaceProtocolName
end