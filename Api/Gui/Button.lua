Button = {}
Button.__index = Button
function Button:new(str_buttonText, int_leftTopX, int_leftTopY, int_width, int_height)
    local instance = {}
    setmetatable(instance, Button)
    --set fields like this
    --instance.int_value = int_argument
    if(str_buttonText == nil) then
        error("str_buttonText" .. " value cannot be nil",2)
    end
    
    instance.str_buttonText = str_buttonText
    
    instance.int_leftTopX = int_leftTopX
    instance.int_leftTopY = int_leftTopY
    instance.int_width = int_width
    instance.int_height = int_height
    return instance
end

function Button:Render()

    --access fields/properties like:
    --self.fieldName
    --call methods like:
    --self:methodName
end