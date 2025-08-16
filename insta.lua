-- Main Installer (install.lua)
term.setPaletteColour(colours.black, 0x000F1C)
term.setPaletteColour(colours.lime, 0x0DDA85)
term.setBackgroundColor(colours.black)
term.setTextColour(colours.lime)
shell.run("clear")

function DelInst()
    term.setCursorPos(3, 18)
    write("Deleting Installer... ")
    sleep(0.5)
    shell.run("delete install.lua")
    write("Rebooting...\n")
    sleep(0.5)
    shell.run("reboot")
end

local options = {
    "[Blastdoor Server] v1.0 ",
    "[Pip-Boy] v3.1 ",
    "[Blastdoor Term] v0.0 ",
    "[Basic Terminal] v0.0 "
}
local selected = 1

-- Helper: download file from GitHub
local function download_file(url, save_path)
    local resp = http.get(url)
    if resp then
        local content = resp.readAll()
        resp.close()

        local dir = fs.getDir(save_path)
        if dir ~= "" and not fs.exists(dir) then fs.makeDir(dir) end

        local f = fs.open(save_path, "w")
        if f then
            f.write(content)
            f.close()
            return true
        end
    end
    return false
end

-- Draw menu
local function drawMenu()
    term.clear()
    term.setCursorPos(1, 1)
    print("")
    print("===Welcome to Vault-Tec===")
    print("| Automatic terminal |")
    print("| installer. v0.4a   |")
    print("==========================")
    print("(Most options need configuring)")
    print(" Please select an option:")
    print("")
    for i, option in ipairs(options) do
        if i == selected then
            io.write(" ")
            term.setBackgroundColor(colors.lime)
            term.setTextColor(colors.black)
            print(option)
            term.setBackgroundColor(colors.black)
            term.setTextColor(colors.lime)
        else
            print("", option)
        end
    end
end

drawMenu()

-- Handle input
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
        term.setCursorPos(3, 18)

        if selected == 1 then
            write("Running Blastdoor Server installer...\n")
            -- TODO: Add download + run for Blastdoor later

        elseif selected == 2 then
            write("Fetching Pip-Boy installer...\n")
            local url = "https://raw.githubusercontent.com/Grain2077/Terminals/main/installers/install_pipboy.lua"
            local save_path = "install_pipboy.lua"

            if download_file(url, save_path) then
                write("Running Pip-Boy installer...\n")
                shell.run(save_path)
            else
                write("Failed to download Pip-Boy installer!\n")
            end

        elseif selected == 3 then
            write("Running Blastdoor Terminal installer...\n")
            -- TODO: Add download + run for Blastdoor Term later

        elseif selected == 4 then
            write("Running Basic Terminal installer...\n")
            -- TODO: Add download + run for Basic Terminal later
        end

    elseif key == keys.q then
        break
    end
end
