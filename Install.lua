term.setPaletteColour(colours.white, 0XFBF2B7)
term.setPaletteColour(colours.black, 0X020202)
local options = {
    "[External Blastdoor Controller] v0.1           ",
    "[Pip-Boy] v0.1                                 ",
    "[External Vault Terminal] v0.1                 ",
    "[Internal Vault Terminal] v0.1                 "
}

local selected = 1

-- Function to draw the menu with highlight
local function drawMenu()
    term.clear()
    term.setCursorPos(1,2)
    print("  Welcome to Vault-Tec (TM) VaultNet")
    print("")
    print("  ==============Welcome to Vault-Tec=============")
    print("  |Automatic terminal installer.             v0.1|")
    print("  ===============================================")
    print("    (Almost every option will need configuring)")
    print("              Please select an option:")
    print("")
    for i, option in ipairs(options) do
        if i == selected then
            -- Invert text for highlight
            io.write("  ")
            term.setBackgroundColor(colors.white)
            term.setTextColor(colors.black)
            print(option)
            term.setBackgroundColor(colors.black)
            term.setTextColor(colors.white)
        else
            print(" ",option)
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
        print("Accessing Logs...")
        elseif selected == 2 then
        print("Connecting...")
        elseif selected == 3 then
        print("Access EMS...")
        end
    elseif key == keys.q then
        break
    end
end
