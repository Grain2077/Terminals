local mon = peripheral.find("monitor")
if not mon then error("No monitor found") end
mon.setTextScale(0.5)

-- ======================================================================
-- Button System
-- ======================================================================
local Buttons = {}

local function addButton(name, x1, y1, x2, y2, callback)
    Buttons[name] = {
        x1=x1, y1=y1, x2=x2, y2=y2,
        callback = callback
    }
end

local function drawRectangle(x1,y1,x2,y2,bg,text,name)
    mon.setBackgroundColor(bg)
    for y=y1,y2 do
        mon.setCursorPos(x1,y)
        mon.write(string.rep(" ", x2-x1+1))
    end
    mon.setTextColor(text)
    mon.setCursorPos(x1+1, (y1+y2)//2)
    mon.write(name)
end

local function drawButtons()
    for name,b in pairs(Buttons) do
        drawRectangle(b.x1, b.y1, b.x2, b.y2, colors.orange, colors.black, name)
    end
end

local function handleTouch(x,y)
    for name,b in pairs(Buttons) do
        if x>=b.x1 and x<=b.x2 and y>=b.y1 and y<=b.y2 then
            b.callback()
        end
    end
end

-- ======================================================================
-- Screen Drawing
-- ======================================================================
local function drawDashboard()
    mon.setBackgroundColor(colors.black)
    mon.setTextColor(colors.lime)
    mon.clear()

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
"    GAUGES     OPTIONS    STATUS    "
    }

    for i,line in ipairs(lines) do
        mon.setCursorPos(1,i)
        mon.write(line)
    end
end

-- ======================================================================
-- Sub-Menus
-- ======================================================================

local function showSubMenu(title)
    mon.setBackgroundColor(colors.black)
    mon.setTextColor(colors.lime)
    mon.clear()

    mon.setCursorPos(2,2)
    mon.write("=== "..title.." MENU ===")

    mon.setCursorPos(2,4)
    mon.write("This is the "..title.." page.")

    -- Back button
    Buttons = {}
    addButton("BACK", 2, 20, 12, 22, function()
        loadMainMenu()
    end)

    drawButtons()
end

-- ======================================================================
-- Main Menu Setup
-- ======================================================================

function loadMainMenu()
    Buttons = {}
    drawDashboard()

    -- Top Buttons
    addButton("CLIMATE", 5, 2, 14, 4, function() showSubMenu("CLIMATE") end)
    addButton("SUMMARY", 17, 2, 26, 4, function() showSubMenu("SUMMARY") end)
    addButton("RADIO",   29, 2, 37, 4, function() showSubMenu("RADIO") end)

    -- Bottom Buttons
    addButton("GAUGES",  5, 21, 14, 23, function() showSubMenu("GAUGES") end)
    addButton("OPTIONS", 17, 21, 26, 23, function() showSubMenu("OPTIONS") end)
    addButton("STATUS",  29, 21, 37, 23, function() showSubMenu("STATUS") end)

    drawButtons()
end

-- ======================================================================
-- Start Program
-- ======================================================================
loadMainMenu()

while true do
    local ev, side, x, y = os.pullEvent("monitor_touch")
    handleTouch(x,y)
end
