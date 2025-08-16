term.setPaletteColour(colours.white, 0XFBF2B7)
term.setPaletteColour(colours.black, 0X020202)
function DelInst()
term.setCursorPos(3,18)
    write("Deleting Installer...                    ")
    sleep(0.5)
    shell.run("delete install.lua")
    write("Rebooting...                             ")
    sleep(0.5)
    shell.run("reboot")
end
local options = {
    "[Blastdoor Server] v1.0 ",
    "[Pip-Boy] v3.1          ",
    "[Blastdoor Term] v0.0   ",
    "[Basic Terminal] v0.0   "
}

local selected = 1

-- Function to draw the menu with highlight
local function drawMenu()
    term.clear()
    term.setCursorPos(1,1)
    print("")
    print("===Welcome to Vault-Tec===")
    print("| Automatic terminal     |")
    print("| installer.       v0.3a |")
    print("==========================")
    print("    (Most options need    ")
    print("       configuring)       ")
    print(" Please select an option: ")
    print("")
    for i, option in ipairs(options) do
        if i == selected then
            -- Invert text for highlight
            io.write(" ")
            term.setBackgroundColor(colors.white)
            term.setTextColor(colors.black)
            print(option)
            term.setBackgroundColor(colors.black)
            term.setTextColor(colors.white)
        else
            print("",option)
        end
    end
end

drawMenu()

-- Listen for user input to navigate the menu
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
    term.setCursorPos(3,18)
        if selected == 1 then
        write("Installing ExtBlstCtrl...    ")
        elseif selected == 2 then
        write("Installing Pip-OS...        ")
        elseif selected == 3 then
        write("Installing ExtVltTerm...      ")
        elseif selected == 4 then
        write("Installing IntVltTerm...         ")
        end
    elseif key == keys.q then
        break
    end
end
