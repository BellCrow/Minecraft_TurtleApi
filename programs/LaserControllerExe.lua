os.loadAPI("\\Api\\MekanismReactor\\LaserController.lua")

obj_controller = LaserController.LaserController:new(
    "up",
    "bottom",
    "bottom",
    0,
    "right",
    true
)

obj_controller:void_RednetLoop()