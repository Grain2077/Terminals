local monitor = peripheral.find("monitor")
monitor.setTextScale(1)

-- Stores current page's buttons
local buttons = {}

-- Add a button
function addButton(name, x1, y1, x2, y2, callback)
    buttons[name] = {
        x1 = x1, y1 = y1,
        x2 = x2, y2 = y2,
        callback = callback
    }
end

-- Draw all buttons on the screen
function drawButtons()
    monitor.setBackgroundColor(colors.black)
    monitor.clear()
    monitor.setTextColor(colors.white)

    for name, b in pairs(buttons) do
        monitor.setCursorPos(b.x1, b.y1)
        monitor.setBackgroundColor(colors.blue)
        monitor.write(string.rep(" ", b.x2 - b.x1 + 1))
        monitor.setCursorPos(b.x1 + 1, b.y1)
        monitor.write(name)
    end
end

-- Check if the touch hit a button
function handleTouch(x, y)
    for name, b in pairs(buttons) do
        if x >= b.x1 and x <= b.x2 and y == b.y1 then
            b.callback()
        end
    end
end

-- ========================
-- ==  MENU DEFINITIONS  ==
-- ========================

function mainMenu()
    buttons = {}
    addButton("Play",     2, 2, 12, 2, function() gameMenu() end)
    addButton("Settings", 2, 4, 12, 4, function() settingsMenu() end)
    addButton("Exit",     2, 6, 12, 6, function() print("Goodbye!") end)
    drawButtons()
end

function gameMenu()
    buttons = {}
    addButton("Start Game", 2, 2, 14, 2, function() print("Game starting...") end)
    addButton("Back",       2, 4, 12, 4, mainMenu)
    drawButtons()
end

function settingsMenu()
    buttons = {}
    addButton("Sound", 2, 2, 10, 2, function() print("Sound toggled") end)
    addButton("Back",  2, 4, 10, 4, mainMenu)
    drawButtons()
end

-- Start program
mainMenu()

-- Event loop
while true do
    local event, side, x, y = os.pullEvent("monitor_touch")
    handleTouch(x, y)
end
