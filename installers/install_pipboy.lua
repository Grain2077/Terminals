-- Pip-Boy Installer for CC:Tweaked
local APP_NAME = "pip-boy"

-- Files to install (relative to repo root)
local FILES = {
    "pip-boy/startup.lua",
    "pip-boy/Stat.lua",
    "pip-boy/Item.lua",
    "pip-boy/Data.lua",
    "pip-boy/DataFol/VaultDoor.lua"
}

-- Helper: download a file with retries
local function http_get_file(url, save_path)
    local max_retries = 3
    for attempt = 1, max_retries do
        local resp = http.get(url)
        if resp then
            local content = resp.readAll()
            resp.close()

            -- ensure directory exists
            local dir = fs.getDir(save_path)
            if dir ~= "" and not fs.exists(dir) then fs.makeDir(dir) end

            -- write file
            local f = fs.open(save_path, "w")
            if f then
                f.write(content)
                f.close()
                return true
            end
        end
        sleep(0.5)
    end
    return false
end

-- Install workflow
print("=== Installing " .. APP_NAME .. " ===")

for _, file in ipairs(FILES) do
    local url = "https://raw.githubusercontent.com/Grain2077/Terminals/main/" .. file
    local cache_path = "/.install-cache/" .. APP_NAME .. "/" .. file
    local dest_path = "/" .. file   -- installs directly into /pip-boy/...

    -- download into cache
    if http_get_file(url, cache_path) then
        -- ensure final destination exists
        local dir = fs.getDir(dest_path)
        if dir ~= "" and not fs.exists(dir) then fs.makeDir(dir) end

        -- copy file from cache to live filesystem
        if fs.exists(dest_path) then fs.delete(dest_path) end
        fs.copy(cache_path, dest_path)
        print("✔ Installed " .. dest_path)
    else
        print("✘ Failed to download " .. file)
    end
end

print("=== Installation complete for " .. APP_NAME .. " ===")
