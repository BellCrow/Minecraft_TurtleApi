
--public API

function PlaneBuilder:new(
    obj_turtleMover,
    table_blockSlots)
    local instance = {}
    setmetatable(instance, PlaneBuilde)
    instance.obj_turtleMover = obj_turtleMover
    instance.table_blockSlots = table_blockSlots
    return instance
end

function PlaneBuilder:void_BuildPlane(
    int_width,
    int_length)
    for i = 0, int_width,1 do
        if(void_SelectNextViableBlockSlot(self.table_blockSlots) == -1) then
            print("Error: Ran out of blocks")
            return
        end
        self.obj_turtleMover:bool_MoveForward(
            int_length,
            bool_MovementAction,
            self)
        self.obj_turtleMover:bool_turnLeft(1,nil,nil)
        self.obj_turtleMover:bool_MoveForward(1,nil,nil)
        self.obj_turtleMover:bool_turnLeft(1,nil,nil)
    end
end

function PlaneBuilder:int_SelectNextViableBlockSlot()
    for i,v in ipairs(self.table_blocSlots) do
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