local mon = peripheral.find("monitor")
if not mon then error("No monitor found") end
mon.setTextScale(0.5)

-- ======================================================================
-- Button system
-- ======================================================================
local Buttons = {}

local function addButton(name, x1, y1, x2, y2, callback)
    Buttons[#Buttons+1] = {
        name=name,
        x1=x1, y1=y1, x2=x2, y2=y2,
        callback=callback
    }
end

local function drawButton(b)
    mon.setBackgroundColor(colors.orange)
    for y=b.y1, b.y2 do
        mon.setCursorPos(b.x1, y)
        mon.write(string.rep(" ", b.x2 - b.x1 + 1))
    end

    mon.setTextColor(colors.black)
    mon.setCursorPos(b.x1 + 1, math.floor((b.y1 + b.y2) / 2))
    mon.write(b.name)
end

local function drawButtons()
    for _,b in ipairs(Buttons) do
        drawButton(b)
    end
end

local function handleTouch(x,y)
    for _,b in ipairs(Buttons) do
        if x>=b.x1 and x<=b.x2 and y>=b.y1 and y<=b.y2 then
            b.callback()
            return
        end
    end
end

-- ======================================================================
-- Common Button Bar (on all screens)
-- ======================================================================
local function installButtonBar(handlers)
    Buttons = {}

    -- Top row
    addButton("CLIMATE",  5, 2, 14, 4, handlers.climate)
    addButton("SUMMARY", 17, 2, 26, 4, handlers.summary)
    addButton("RADIO",   29, 2, 37, 4, handlers.radio)

    -- Bottom row
    addButton("GAUGES",  5, 21, 14, 23, handlers.gauges)
    addButton("OPTIONS", 17, 21, 26, 23, handlers.options)
    addButton("STATUS",  29, 21, 37, 23, handlers.status)
end

-- ======================================================================
-- Menu pages
-- ======================================================================
local function drawBase()
    mon.setBackgroundColor(colors.black)
    mon.setTextColor(colors.lime)
    mon.clear()
end

local function page_CLIMATE()
    drawBase()
    mon.setCursorPos(2,6)
    mon.write("CLIMATE CONTROL MENU")
    drawButtons()
end

local function page_SUMMARY()
    drawBase()
    mon.setCursorPos(2,6)
    mon.write("SUMMARY INFORMATION PAGE")
    drawButtons()
end

local function page_RADIO()
    drawBase()
    mon.setCursorPos(2,6)
    mon.write("RADIO CONTROL INTERFACE")
    drawButtons()
end

local function page_GAUGES()
    drawBase()

    -- Insert your ASCII dashboard here
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

    drawButtons()
end

local function page_OPTIONS()
    drawBase()
    mon.setCursorPos(2,6)
    mon.write("OPTIONS / SETTINGS MENU")
    drawButtons()
end

local function page_STATUS()
    drawBase()
    mon.setCursorPos(2,6)
    mon.write("SYSTEM STATUS PAGE")
    drawButtons()
end

-- ======================================================================
-- Button handler map
-- ======================================================================
local handlers = {
    climate = page_CLIMATE,
    summary = page_SUMMARY,
    radio   = page_RADIO,
    gauges  = page_GAUGES,
    options = page_OPTIONS,
    status  = page_STATUS,
}

-- Create button bar once
installButtonBar(handlers)

-- ======================================================================
-- Start in GAUGES menu
-- ======================================================================
page_GAUGES()

-- ======================================================================
-- Event loop
-- ======================================================================
while true do
    local ev, side, x, y = os.pullEvent("monitor_touch")
    handleTouch(x, y)
end
