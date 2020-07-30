os.loadAPI("\\Api\\MekanismReactor\\ReactorInterface.lua")
os.loadAPI("\\Api\\Communication\\MessageCommunicator.lua")
os.loadAPI("\\Api\\Gui\\BarGraph.lua")


local communicator = MessageCommunicator.MessageCommunicator:new("back",ReactorInterface.str_GetProtocolName())
local deuteriumGraph = BarGraph.BarGraph:new(2, 3, 30, 3, colors.red, 100)
local tritiumGraph = BarGraph.BarGraph:new(2, 9, 30, 3, colors.green, 100)
local tempGraph = BarGraph.BarGraph:new(2, 15, 30, 3, colors.orange, 500000000)


deuteriumGraph:SetBorderMode(true)
tritiumGraph:SetBorderMode(true)
tempGraph:SetBorderMode(true)
deuteriumGraph:SetShowValue(true)
tritiumGraph:SetShowValue(true)
tempGraph:SetShowValue(true)
term.redirect(peripheral.wrap("right"))
-- term.clear()
-- local testGraph = BarGraph.BarGraph:new(2,20, 60, 3, colors.orange, 500000)
-- testGraph:SetValue(500000)
-- testGraph:Render()

-- os.exit()
while true do
    term.clear()
    communicator:SendMessage(7,"Mes_QueryStatus")
    local _,message = communicator:int_table_ReceiveMessage()

    tempGraph:SetValue(message.Payload.ReactorStatus.plasmaHeat)
    deuteriumGraph:SetValue(message.Payload.FuelStatus.float_deuteriumFraction * 100)
    tritiumGraph:SetValue(message.Payload.FuelStatus.float_tritiumFraction * 100)

    deuteriumGraph:Render()
    tritiumGraph:Render()
    tempGraph:Render()
    
    -- print("Plasmaheat: " .. message.Payload.ReactorStatus.plasmaHeat)
    -- print("Injectionrate: " .. message.Payload.ReactorStatus.injectionRate)
    -- print("Tritium in reactor: " .. message.Payload.ReactorStatus.tritiumLevel)
    -- print("Deuterium in reactor: " .. message.Payload.ReactorStatus.deuteriumLevel)
    -- print("Producing: " .. message.Payload.ReactorStatus.producingAmount)
    -- print("Tritium level in tank: " .. message.Payload.FuelStatus.float_tritiumFraction)
    -- print("Deuterium level in tank: " .. message.Payload.FuelStatus.float_deuteriumFraction)

    os.sleep(0.9)
end
