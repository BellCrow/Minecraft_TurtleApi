
--[[
    The laser controller can be controlled via rednet messages.
    You simply send a LaserControllerRequests and get a
    corresponding LaserReply from the laser back.

    The lasercontrol requests are formed in the following way 

    {
        MessageType : [a string depicting the type of command command types and data is listed below],
        --optional---
        Data: any kind of table, that has al fields set, that the message type demands
    }

    The laser control will reply with a laser control reply message wich are tables structured in the same way as the requests
    only that the data, thats returned are table(s) filled with data, that were requested.
    The following messages and theire results are currently available

    Send:
    {
        MessageType : "Mes_QueryStatus",
        Data: [ignored]
    }
    Receive:
    {
        MessageType : "Mes_QueryStatus",
        Data:{
            int_loadedEnergy, --the currently amount of loaded charge in the laser amplifier (unit unknown (?))
            int_maxEnergy,--the maximum amount of loaded charge in the laser amplifier (unit unknown (?))
        }
    }

    Send:
    {
        --request the server to activate the supply of energy to the laser and thus start loading the amplifier
        MessageType : "Mes_StartLoading",
        Data: [ignored]
    }
    Receive:
    {
        MessageType : "Mes_StartLoading",
        Data:bool depicting if the action was successful
    }
    
    Send:
    {
        --request the server to deactivate the supply of energy to the laser and thus stop loading the amplifier
        MessageType : "Mes_StopLoading",
        Data: [ignored]
    }
    Receive:
    {
        MessageType : "Mes_StopLoading",
        Data:bool depicting if the action was successful
    }
]]

LaserController = {}
LaserController.__index = LaserController

local str_LaserControllerProtocolName = "Api_LaserController"
local str_MesQueryStatusType = "Mes_QueryStatus"
local str_MesRequestFireType = "Mes_RequestFire"
local str_MesStartLoadingType = "Mes_StartLoading"
local str_MesStopLoadingType = "Mes_StopLoading"

function LaserController:new(
    str_loaderControlRedstoneSide,
    str_laserAmplifierRedstoneSide,
    str_laserAmplifierQuerySide,
    float_percentFireThreshold,
    obj_messageCommunicator,
    bool_debugMode)

    if(str_loaderControlRedstoneSide == nil) then
        error("str_loaderControlRedstoneSide " .. "value cannot be nil",2)
    end
    if(str_laserAmplifierRedstoneSide == nil) then
        error("str_laserAmplifierRedstoneSide " .. "value cannot be nil",2)
    end
    if(str_laserAmplifierQuerySide == nil) then
        error("str_laserAmplifierQuerySide " .. "value cannot be nil",2)
    end
    if(str_laserAmplifierQuerySide == nil) then
        error("str_laserAmplifierQuerySide " .. "value cannot be nil",2)
    end
    if(float_percentFireThreshold == nil) then
        error("float_percentFireThreshold " .. "value cannot be nil",2)
    end
    if(obj_messageCommunicator == nil) then
        error("obj_messageCommunicator " .. "value cannot be nil",2)
    end

    local instance = {}
    setmetatable(instance, LaserController)
    instance.str_loaderControlRedstoneSide = str_loaderControlRedstoneSide
    instance.str_laserAmplifierRedstoneSide = str_laserAmplifierRedstoneSide
    instance.obj_laserAmplifierWrap = peripheral.wrap(str_laserAmplifierQuerySide)
    instance.float_percentFireThreshold = float_percentFireThreshold
    instance.obj_messageCommunicator = obj_messageCommunicator
    instance.bool_debugMode = bool_debugMode or false
    instance.bool_loading = false
    return instance
end

function LaserController:RednetLoop()
    --receiver a request from any client with commands
    while(true) do
        self:ReceiveAndDispatchRednetMessage()
    end
end

function LaserController:ReceiveAndDispatchRednetMessage()

    if(self.bool_debugMode)then
        print("Waiting for message...")
    end

    local int_senderId, table_message = self.obj_messageCommunicator:int_table_ReceiveMessage(str_LaserControllerProtocolName)

    if(self.bool_debugMode)then 
        print("Recv. message from " .. int_senderId .. " Type: ".. table_message.MessageType)
    end

    if(table_message.MessageType == nil) then
        self:SendMalformedMessageError(int_senderId)
    else
        self:HandleMessage(table_message,int_senderId)
    end
end

function LaserController:HandleMessage(table_parsedLaserCommand, int_receiverId)
    if(table_parsedLaserCommand.MessageType == str_MesQueryStatusType) then
        local table_result = {}
        table_result.MessageType = str_MesQueryStatusType
        table_result.Data = {}
        local table_laserStatusData = self:table_GetLaserStats()
        table_result.Data.int_loadedEnergy = table_laserStatusData.int_loadedEnergy
        table_result.Data.int_maxEnergy = table_laserStatusData.int_maxEnergy
        self:SendMessage(int_receiverId, table_result)
    elseif (table_parsedLaserCommand.MessageType == str_MesRequestFireType) then 
        local table_result = {}
        table_result.MessageType = table_parsedLaserCommand.MessageType
        table_result.Data = true
        self:FireLaser()
        self:SendMessage(int_receiverId, table_result)
    elseif (table_parsedLaserCommand.MessageType == str_MesStartLoadingType) then
        self:StartLoading()
        local table_result = {}
        table_result.MessageType = str_MesStartLoadingType
        table_result.Data = true
        self:SendMessage(int_receiverId,table_result)
    elseif (table_parsedLaserCommand.MessageType == str_MesStopLoadingType) then
        self:StopLoading()
        local table_result = {}
        table_result.MessageType = str_MesStopLoadingType
        table_result.Data = true
        self:SendMessage(int_receiverId,table_result)
    else
        self:SendMalformedMessageError(int_receiverId)
    end
end

function LaserController:FireLaser()
    redstone.setOutput(self.str_laserAmplifierRedstoneSide,true)
    os.sleep(2)
    redstone.setOutput(self.str_laserAmplifierRedstoneSide,false)
end

function LaserController:SendMessage(int_receiverId, table_message)
    if(self.bool_debugMode)then
        print("Sending message to ".. int_receiverId .. " Type: " .. table_message.MessageType)
    end
    self.obj_messageCommunicator:SendMessage(int_receiverId,table_message,str_LaserControllerProtocolName)
end

function LaserController:SendMalformedMessageError(int_receiverId)
    local table_malformedMessageError = {}
    table_malformedMessageError.MessageType = "MalformedMessage"
    self:SendMessage(int_receiverId, table_malformedMessageError)
end

function LaserController:table_GetLaserStats()
    local int_loadedEnergy = self.obj_laserAmplifierWrap.getEnergy()
    local int_maxEnergy = self.obj_laserAmplifierWrap.getMaxEnergy()

    local table_result = {}
    table_result.int_loadedEnergy = int_loadedEnergy
    table_result.int_maxEnergy = int_maxEnergy
    table_result.bool_isLoading = self.bool_isLoading
    return table_result
end

function LaserController:StartLoading()
    redstone.setOutput(self.str_loaderControlRedstoneSide, false)
    self.bool_loading = true
end

function LaserController:StopLoading()
    if(self.bool_debugMode) then
        print("Stop loading laser amplifier setting side")
    end
    redstone.setOutput(self.str_loaderControlRedstoneSide, true)
    self.bool_loading = false
end