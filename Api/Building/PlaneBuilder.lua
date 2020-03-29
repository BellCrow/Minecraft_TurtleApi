
--public API
PlaneBuilder = {}
PlaneBuilder.__index = PlaneBuilder

function PlaneBuilder:new(
    
    obj_turtleMover,
    table_blockSlots)
    local instance = {}
    setmetatable(instance, PlaneBuilder)
    instance.obj_turtleMover = obj_turtleMover
    instance.table_blockSlots = table_blockSlots
    return instance
end

function PlaneBuilder:void_BuildPlane(
    int_width,
    int_length)
    --move onto the work area
    self.obj_turtleMover:bool_MoveForward(1,bool_MovementAction,
    self)
    for i = 0, int_width - 1,1 do
        if(self:int_SelectNextViableBlockSlot(self.table_blockSlots) == -1) then
            print("Error: Ran out of blocks")
            return
        end
        self.obj_turtleMover:bool_MoveForward(
            int_length - 1,
            bool_MovementAction,
            self)
            --only make a turn, if we are not at the end of field
            if(i ~= int_width - 1) then
                if(i % 2 == 0 ) then 
                    self.obj_turtleMover:bool_TurnLeft(1,nil,nil)
                    self.obj_turtleMover:bool_MoveForward(1,bool_MovementAction,
                    self)
                    self.obj_turtleMover:bool_TurnLeft(1,nil,nil)
                else
                    self.obj_turtleMover:bool_TurnRight(1,nil,nil)
                    self.obj_turtleMover:bool_MoveForward(1,bool_MovementAction,
                    self)
                    self.obj_turtleMover:bool_TurnRight(1,nil,nil)
                end
            end
    end
end

function PlaneBuilder:int_SelectNextViableBlockSlot()
    for i,v in ipairs(self.table_blockSlots) do
        turtle.select(v)
        if(turtle.getItemCount() > 0) then
            return 0
        end
    end
    return -1
end

function bool_MovementAction(obj_selfArg)
    if(obj_selfArg:int_SelectNextViableBlockSlot() == -1)then
        return false
    end
    turtle.placeDown()
    return true
end