os.loadAPI("\\Api\\MekanismReactor\\LaserController.lua")
os.loadAPI("\\Api\\Communication\\MessageCommunicator.lua")

local obj_com = MessageCommunicator.MessageCommunicator:new("right")
local obj_controller = LaserController.LaserController:new(
    "top",
    "left",
    "bottom",
    0,
    obj_com,
    true
)

obj_controller:RednetLoop()