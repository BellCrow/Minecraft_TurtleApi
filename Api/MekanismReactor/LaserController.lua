
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
    
]]

LaserController = {}
LaserController.__index = LaserController


str_LaserControllerProtocolName = "Api_LaserController"

str_MesQueryStatusType = "Mes_QueryStatus"
str_MesRequestFireType = "Mes_RequestFire"
str_MesStartLoadingType = "Mes_StartLoading"
str_MesStopLoadingType = "Mes_StopLoading"

function LaserController:new(
    str_loaderControlRedstoneSide,
    str_laserAmplifierRedstoneSide,
    
    str_laserAmplifierQuerySide,
    float_percentFireThreshold,
    str_modemSide,
    bool_debugMode)
    local instance = {}
    setmetatable(instance, LaserController)
    
    instance.str_loaderControlRedstoneSide = str_loaderControlRedstoneSide
    instance.str_laserAmplifierRedstoneSide = str_laserAmplifierRedstoneSide
    instance.obj_laserAmplifierWrap = peripheral.wrap(str_laserAmplifierQuerySide)
    instance.float_percentFireThreshold = float_percentFireThreshold
    instance.bool_debugMode = bool_debugMode or false
    rednet.open(str_modemSide)
    return instance
end

function LaserController:void_RednetLoop()
    --receiver a request from any client with commands
    while(true) do 
        self:void_ReceiveAndDispatchRednetMessage()
    end
end

function LaserController:void_ReceiveAndDispatchRednetMessage()

    if(self.bool_debugMode)then
        print("Waiting for message...")
    end

    int_senderId,str_data = rednet.receive(str_LaserControllerProtocolName)
    local table_parsedLaserCommand = textutils.unserialize(str_data)

    if(self.bool_debugMode)then 
        print("Recv. message from " .. int_senderId .. " Type: ".. table_parsedLaserCommand.MessageType)
    end

    if(table_parsedLaserCommand.MessageType == nil) then
        self:void_SendMalformedMessageError(int_senderId)
    else 
        self:void_HandleMessage(table_parsedLaserCommand,int_senderId)
    end
end

function LaserController:void_HandleMessage(table_parsedLaserCommand, int_receiverId)
    if(table_parsedLaserCommand.MessageType == str_MesQueryStatusType) then 
        local table_result = {}
        table_result.MessageType = str_MesQueryStatusType
        table_result.Data = {}
        local table_laserStatusData = self:table_GetLaserStats()
        table_result.Data.int_loadedEnergy = table_laserStatusData.int_loadedEnergy
        table_result.Data.int_maxEnergy = table_laserStatusData.int_maxEnergy
        self:void_SendMessage(int_receiverId, table_result)
    elseif (table_parsedLaserCommand.MessageType == str_MesRequestFireType) then 
        
        local table_result = {}
        table_result.MessageType = table_parsedLaserCommand.MessageType
        table_result.Data = true
        self:FireLaser()
        
        self:void_SendMessage(int_receiverId, table_result)
    elseif (table_parsedLaserCommand.MessageType == str_Mes)
    else
        self:void_SendMalformedMessageError(int_receiverId)
    end
end

function LaserController:FireLaser()
    
    redstone.setOutput(self.str_laserAmplifierRedstoneSide,true)
    os.sleep(2)
    redstone.setOutput(self.str_laserAmplifierRedstoneSide,false)
end

function LaserController:void_SendMessage(int_receiverId, table_message)
    if(self.bool_debugMode)then 
        print("Sending message to ".. int_receiverId .. " Type: " .. table_message.MessageType)
    end
    rednet.send(int_receiverId,textutils.serialize(table_message),str_LaserControllerProtocolName)
end

function LaserController:void_SendMalformedMessageError(int_receiverId)
    local table_malformedMessageError = {}
    table_malformedMessageError.MessageType = "MalformedMessage"
    self:void_SendMessage(int_receiverId, table_malformedMessageError)
end

function LaserController:table_GetLaserStats()
    local int_loadedEnergy = self.obj_laserAmplifierWrap.getEnergy()
    local int_maxEnergy = self.obj_laserAmplifierWrap.getMaxEnergy()

    local table_result = {}
    table_result.int_loadedEnergy = int_loadedEnergy
    table_result.int_maxEnergy = int_maxEnergy

    return table_result
end