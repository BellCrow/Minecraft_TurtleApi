--reactor message
local str_MesQueryStatusType = "Mes_QueryStatus"
local str_MesSetInjectionRate = "Mes_SetInjectionRate"

--laser messages
local str_MesQueryStatusType = "Mes_QueryStatus"
local str_MesRequestFireType = "Mes_RequestFire"
local str_MesStartLoadingType = "Mes_StartLoading"
local str_MesStopLoadingType = "Mes_StopLoading"

--fuel messages


local ReactorInterface = {}
ReactorInterface.__index = ReactorInterface
function ReactorInterface:new(obj_interfaceMessageCommunicator, obj_reactorCommunicator)
    local instance = {}
    setmetatable(instance, ReactorInterface)
    --set fields like this
    --instance.int_value = int_argument
    instance.obj_interfaceMessageCommunicator = obj_interfaceMessageCommunicator
    instance.obj_reactorCommunicator = obj_reactorCommunicator
    return instance
end

function ReactorInterface:table_GetReactorStatus()
    --access fields/properties like:
    --self.fieldName
    --call methods like:
    --self:methodName
end

