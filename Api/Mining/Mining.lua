os.loadAPI("API_NullReporter.lua")

MiningHandler = {}
MiningHandler.__index = MiningHandler

---Creates a new instance of the MiningHandler
--@ param obj_turtleMoveApi An instance of the move api, that will be used to move the turtle around while mining
function MiningHandler:New(obj_turtleMoveApi)
    local instance = {}
    instance.obj_turtleMoveApi = obj_turtleMoveApi
    setmetatable(instance, MiningHandler)
end