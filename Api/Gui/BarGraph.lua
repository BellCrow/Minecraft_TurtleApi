BarGraph = {}
BarGraph.__index = BarGraph
-- all values are given as pixels, that are limited by the height and width of the monitor you use.
function BarGraph:new(int_posX, int_posY, int_width, int_height, color_drawColor, float_maxValue)
    local instance = {}
    setmetatable(instance, BarGraph)

    instance.int_posX = int_posX
    instance.int_posY = int_posY
    instance.int_width = int_width
    instance.int_height = int_height
    instance.color_drawColor = color_drawColor
    instance.float_maxValue = float_maxValue

    instance.int_value = 0

    -- implicit values
    instance.bool_renderBorder = false
    instance.color_borderColor = nil
    instance.bool_usePercentValue = false
    instance.bool_renderValue = false

    --calculated values
    instance.int_barEndX = int_posX + int_width
    instance.int_barEndY = int_posY + int_height
    return instance
end

function BarGraph:Render()
    -- save currentBackgroundColor to restore later as not to destroy context for other draws
    local color_savedBackGroundColor = term.getBackgroundColor()

    self:_RenderValueBar()

    if (self.bool_renderBorder) then
        self:_RenderBorder()
    end

    if (self.bool_renderValue) then
        self:_RenderValue()
    end

    term.setBackgroundColor(color_savedBackGroundColor)
end

function BarGraph:_RenderValue()
    local str_valueString = tostring(self.float_value)
    local int_barMiddleX = math.floor(self.int_posX + self.int_width / 2)
    local int_barMiddleY = math.floor(self.int_posY + self.int_height / 2)

    local int_textStartWriteX = int_barMiddleX - string.len(str_valueString) / 2

    local int_oldCursorPosX, int_oldCursorPosY = term.getCursorPos()
    term.setCursorPos(int_textStartWriteX, int_barMiddleY)
    term.write(str_valueString)
    term.setCursorPos(int_oldCursorPosX, int_oldCursorPosY)
end

function BarGraph:_RenderBorder()
    paintutils.drawBox(self.int_posX, self.int_posY, self.int_barEndX, self.int_barEndY, self.color_drawColor)
end

function BarGraph:_RenderValueBar()
    local float_fractionOfBarToFill = self.float_value / self.float_maxValue
    local int_barWidthForCurrentValue = math.floor(self.int_width * float_fractionOfBarToFill)

    local int_valueBarEndX = self.int_posX + int_barWidthForCurrentValue
    local int_valueBarEndY = self.int_posY + self.int_height

    paintutils.drawFilledBox(self.int_posX, self.int_posY, int_valueBarEndX, int_valueBarEndY, self.color_drawColor)
end

function BarGraph:SetValue(int_value)
    self.float_value = int_value
end

function BarGraph:SetBorderMode(bool_renderBorders)
    self.bool_renderBorder = bool_renderBorders
end

function BarGraph:SetShowValue(bool_renderValue)
    self.bool_renderValue = bool_renderValue
end
