local mon = peripheral.find("monitor")
if not mon then error("No monitor found") end
mon.setTextScale(0.5)

local normalColor = colors.lime
local activeColor = colors.orange

local currentMenu = "GAUGES"

-- Button coordinates
local Buttons = {
    CLIMATE = {x1=5,  y1=3,  x2=10, y2=4, labelPos="top"},
    SUMMARY = {x1=17, y1=3,  x2=22, y2=4, labelPos="top"},
    RADIO   = {x1=29, y1=3,  x2=34, y2=4, labelPos="top"},
    GAUGES  = {x1=5,  y1=22, x2=10, y2=23, labelPos="bottom"},
    OPTIONS = {x1=17, y1=22, x2=22, y2=23, labelPos="bottom"},
    STATUS  = {x1=29, y1=22, x2=34, y2=23, labelPos="bottom"},
}

-- Dashboard variables (manual input)
local RPM = 0
local Fuel = 100
local Trip = 0

-- Draw base
local function drawBase()
    mon.setBackgroundColor(colors.black)
    mon.setTextColor(normalColor)
    mon.clear()
end

-- Draw buttons
local function drawMenuLabels()
    for name, pos in pairs(Buttons) do
        local boxColor = (currentMenu == name) and activeColor or normalColor

        -- Draw box
        mon.setTextColor(boxColor)
        mon.setCursorPos(pos.x1, pos.y1)
        mon.write("+----+")
        mon.setCursorPos(pos.x1, pos.y2)
        mon.write("+----+")

        -- Draw label
        mon.setTextColor(normalColor)
        local labelY = (pos.labelPos == "top") and (pos.y1 - 1) or (pos.y2 + 1)
        mon.setCursorPos(pos.x1, labelY)
        mon.write(name)
    end
end

-- GAUGES page
local function page_GAUGES()
    drawBase()

    -- ASCII dashboard
    local lines = {
"                                    ",
"    CLIMATE    SUMMARY    RADIO     ",
"    +----+     +----+     +----+    ",
"    +----+     +----+     +----+    ",
"                                    ",
"                7=-----             ",
"           6=-----                  ",
"          =-----                    ",
"        5=-----      FUEL   TRIP    ",
"        =-----                      ",
"     4=-----       F ====   =---    ",
"      =-----         ====   =---    ",
"    3======          ====   =---    ",
"     ======          ====   ====    ",
"   2======           ====   ====    ",
"   1======         E ====   ====    ",
"     __                    __ __    ",
"      /RPM          |/\\/\\% L_  /%   ",
"     \\)             |\\/\\/  \\/ /     ",
"                                    ",
"    +----+     +----+     +----+    ",
"    +----+     +----+     +----+    ",
"                                    ",
    }
    for i,line in ipairs(lines) do
        mon.setCursorPos(1,i)
        mon.write(line)
    end

    drawMenuLabels()

    -- Draw initial values
    mon.setTextColor(colors.lime)
    mon.setCursorPos(20,14)
    mon.write(string.format("%3d%%  ", Fuel))
    mon.setCursorPos(30,14)
    mon.write(string.format("%3d km  ", Trip))
    mon.setCursorPos(20,17)
    mon.write(string.format("%4d  ", RPM))
end

-- Other pages
local function page_TEXT(title)
    drawBase()
    mon.setCursorPos(3,8)
    mon.write(title)
    drawMenuLabels()
end

local Pages = {
    CLIMATE = function() page_TEXT("CLIMATE MENU") end,
    SUMMARY = function() page_TEXT("SUMMARY PAGE") end,
    RADIO   = function() page_TEXT("RADIO PAGE") end,
    OPTIONS = function() page_TEXT("OPTIONS PAGE") end,
    STATUS  = function() page_TEXT("STATUS PAGE") end,
    GAUGES  = page_GAUGES,
}

-- Touch handling
local function handleTouch(x,y)
    for name, pos in pairs(Buttons) do
        if x >= pos.x1 and x <= pos.x2 and y >= pos.y1 and y <= pos.y2 then
            currentMenu = name
            Pages[name]()
            return
        end
    end
end

-- Update dashboard (manual input)
local function updateDashboard()
    if currentMenu ~= "GAUGES" then return end

    -- Just rewrite the values at their positions
    mon.setTextColor(colors.lime)
    mon.setCursorPos(20,14)
    mon.write(string.format("%3d%%  ", Fuel))
    mon.setCursorPos(30,14)
    mon.write(string.format("%3d km  ", Trip))
    mon.setCursorPos(20,17)
    mon.write(string.format("%4d  ", RPM))
end

-- Start with GAUGES
Pages.GAUGES()

-- Main loop
while true do
    local eventData = {os.pullEventRaw()}
    local ev = eventData[1]

    if ev == "monitor_touch" then
        local _, side, x, y = table.unpack(eventData, 2)
        handleTouch(x,y)
    end

    -- Update gauges
    updateDashboard()
end
