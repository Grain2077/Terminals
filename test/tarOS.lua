local mon = peripheral.find("monitor")
if not mon then error("No monitor found") end
mon.setTextScale(0.5)

-- Colors
local normalColor = colors.lime
local activeColor = colors.orange

-- ============================================================
-- MENU STATE
-- ============================================================
local currentMenu = "GAUGES"

-- ============================================================
-- BUTTON COORDINATES
-- ============================================================
local Buttons = {
    CLIMATE = {x1=5,  y1=3,  x2=10, y2=4},
    SUMMARY = {x1=17, y1=3,  x2=22, y2=4},
    RADIO   = {x1=29, y1=3,  x2=34, y2=4},

    GAUGES  = {x1=5,  y1=22, x2=10, y2=23},
    OPTIONS = {x1=17, y1=22, x2=22, y2=23},
    STATUS  = {x1=29, y1=22, x2=34, y2=23},
}

-- ============================================================
-- DRAW HELPERS
-- ============================================================
local function drawBase()
    mon.setBackgroundColor(colors.black)
    mon.setTextColor(normalColor)
    mon.clear()
end

-- ============================================================
-- DRAW BUTTON BOXES + LABELS
-- Turns the ASCII box orange when active
-- ============================================================
local function drawMenuLabels()
    for name, pos in pairs(Buttons) do
        local boxColor = (currentMenu == name) and activeColor or normalColor

        -- Draw top line of box
        mon.setTextColor(boxColor)
        mon.setCursorPos(pos.x1, pos.y1)
        mon.write("+----+")

        -- Draw bottom line of box
        mon.setCursorPos(pos.x1, pos.y2)
        mon.write("+----+")

        -- Draw label (always lime)
        mon.setTextColor(normalColor)
        mon.setCursorPos(pos.x1, pos.y2 + 1)
        mon.write(name)
    end
end

-- ============================================================
-- MENU PAGES
-- ============================================================
local function page_GAUGES()
    drawBase()

    -- GAUGES ASCII dashboard (your original art)
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
end

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

-- ============================================================
-- TOUCH HANDLING
-- ============================================================
local function handleTouch(x,y)
    for name, pos in pairs(Buttons) do
        if x >= pos.x1 and x <= pos.x2 and y >= pos.y1 and y <= pos.y2 then
            currentMenu = name
            Pages[name]()
            return
        end
    end
end

-- ============================================================
-- STARTUP
-- ============================================================
Pages.GAUGES()

-- ============================================================
-- MAIN LOOP
-- ============================================================
while true do
    local ev, side, x, y = os.pullEvent("monitor_touch")
    handleTouch(x, y)
end
