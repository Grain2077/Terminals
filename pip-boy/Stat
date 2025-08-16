--Get date
local function dateLoop()
    while runDateLoop do
        term.setCursorPos(1,20)
        term.clearLine()
        term.setBackgroundColour(colours.green)
        write(os.date(" %d-%b-%Y  %R       "))
        term.setBackgroundColour(colours.black)

    -- Instead of sleep, wait for a short timer so we can break early
      local timer = os.startTimer(0.1)
      repeat
          local event, id = os.pullEvent()
          if event == "timer" and id == timer then
              break
          elseif event == "terminate" or not runDateLoop then
              return
          end
      until false
   end
end

--Print text centred
local function printCentered(text)
 local w, _ = term.getSize()
 local padding = math.floor((w - #text) / 2)
 term.clearLine()
 term.setCursorPos(padding + 1, select(2, term.getCursorPos()))
 print(text)
end

--Print User
local username
if fs.exists("user.txt") then
 local f = fs.open("user.txt", "r")
 username = f.readAll()
 f.close()
else
 reboot()
end

--Set Colours
term.setPaletteColour(colours.black,0x000F1C)
term.setPaletteColour(colours.green,0x01423A)
term.setPaletteColour(colours.lime,0x0DDA85)
term.setBackgroundColour(colours.black)
term.setTextColour(colours.lime)
runDateLoop = true
local optionLeft = false
local optionRight = false
local option1 = false
local option2 = false

--Set Options
local options = {
    "[Status]              ",
    "[Special]             "
}

local selected = 1

-- Function to draw the menu with highlight
local function drawMenu()
    term.clear()
    term.setCursorPos(1,1)
    print("A>  [STAT] ITEM  DATA   <D")

--Underline
write(string.char(175))
write(string.char(175))
write(string.char(175))
write(string.char(175))
write(string.char(175))
write("    ")
write(string.char(175))
write(string.char(175))
write(string.char(175))
write(string.char(175))
write(string.char(175))
write(string.char(175))
write(string.char(175))
write(string.char(175))
write(string.char(175))
write(string.char(175))
write(string.char(175))
write(string.char(175))
write(string.char(175))
write(string.char(175))
write(string.char(175))
write(string.char(175))
write(string.char(175))
term.setCursorPos(1,3)
    print("          _____")
    print("          |   |")
    print("          |   |")
    print("    +-----+---+-----+")
    print("    +-----+   +-----+")
    print("          |   |")
    print("          +-+-+") 
    print("          | | |")
    print("          | | |")
    print("          | | |")
    print("          +-+-+")
    print("")
    printCentered(username)
    print("") 
    for i, option in ipairs(options) do
        if i == selected then
            -- Invert text for highlight
            io.write("  ")
            term.setBackgroundColour(colours.lime)
            term.setTextColor(colours.black)
            print(option)
            term.setBackgroundColour(colours.black)
            term.setTextColour(colours.lime)
        else
            print(" ",option)
        end
    end
end
drawMenu()

-- Listen for user input to navigate the menu
local function keyLoop()
while true do
    local event, key = os.pullEvent("key")
    if key == keys.down then
        selected = selected + 1
        if selected > #options then selected = 1 end
        drawMenu()
    elseif key == keys.up then
        selected = selected - 1
        if selected < 1 then selected = #options end
        drawMenu()
    elseif key == keys.enter then
        term.setCursorPos(3,19)
--Option 1
        if selected == 1 then
        runDateLoop = false
        write("Accessing...")
        option1 = true
--Option 2
        elseif selected == 2 then
		runDateLoop = false
        write("Accessing...")
        option2 = true
        end
--Menu keys
    elseif key == keys.a then
        runDateLoop = false
		optionLeft = true
    elseif key == keys.d then
        runDateLoop = false
		optionRight = true
    end
end
end
parallel.waitForAny(dateLoop, keyLoop)

--Menu Left program
if optionLeft then
    os.run({}, "Data")
end

--Menu Right program
if optionRight then
    os.run({}, "Item")
end

--Option 1 program
if option1 then
    os.reboot()
end

--Option 2 program
if option2 then
    os.reboot()
end
