local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/main/source.lua"))()

local Window = Luna:CreateWindow({
    Name = "JJS HUB",
    Subtitle = "v1.19.2",
    LogoID = nil
})

Window:SetKeybind("T")

-- Notifications (Luna handles notifications separately)
local function notify(title, content, duration)
    Window:CreateNotification({
        Title = title,
        Content = content,
        Duration = duration or 5
    })
end

-- Main Tab for Hub Info
local MainTab = Window:CreateTab({
    Name = "Main",
    Icon = "home"
})

MainTab:CreateLabel({
    Name = "Hub Credits",
    Description = "Script by jjs_dev"
})

MainTab:CreateLabel({
    Name = "Hub Description",
    Description = "A modern hub for various games"
})

-- Custom Module Tab
local CustomModuleTab = Window:CreateTab({
    Name = "Custom Module",
    Icon = "plus"
})

local moduleUrl = ""
CustomModuleTab:CreateTextbox({
    Name = "Module URL",
    Description = "Enter the URL of the custom module",
    Default = "",
    Placeholder = "https://example.com/script.lua",
    Callback = function(value)
        moduleUrl = value
    end
})

CustomModuleTab:CreateButton({
    Name = "Add Module",
    Description = "Load and add the custom module",
    Callback = function()
        if moduleUrl == "" then
            notify("Error", "Please enter a URL")
            return
        end
        notify("Loading", "Module is loading...")
        local success, moduleEx = pcall(loadstring, game:HttpGet(moduleUrl))
        if not success then
            notify("Error", "Failed to load module: " .. tostring(moduleEx))
            return
        end
        local newmodule = moduleEx()
        if newmodule then
            notify("Success", "New module added: " .. (newmodule.Name or "Unknown"))
            -- Here you could dynamically add a new tab or elements, but Luna may not support dynamic tabs easily.
            -- For simplicity, assume it runs in background or add to a list.
        else
            notify("Error", "Module failed to load")
        end
    end
})

-- Example Game Tabs (based on original modules)
local UniversalTab = Window:CreateTab({
    Name = "Universal",
    Icon = "globe"
})
-- Add universal features here, e.g.
UniversalTab:CreateToggle({
    Name = "Some Universal Feature",
    Description = "Toggle this feature",
    Default = false,
    Callback = function(state)
        -- Implement
    end
})

local FleeTab = Window:CreateTab({
    Name = "Flee the Facility",
    Icon = "running"
})
-- Add features

local MurderTab = Window:CreateTab({
    Name = "Murder Mystery 2",
    Description = "MM2 features",
    Icon = "knife"
})
-- Add features

local ForsakenTab = Window:CreateTab({
    Name = "Forsaken",
    Icon = "skull"
})
-- Add features

-- ESP Tab or module
local ESPTab = Window:CreateTab({
    Name = "ESP",
    Icon = "eye"
})
-- Add ESP toggles etc.

-- Floating Button Settings Tab
local SettingsTab = Window:CreateTab({
    Name = "Settings",
    Icon = "settings"
})

SettingsTab:CreateToggle({
    Name = "Visibility",
    Description = "Toggle UI visibility",
    Default = true,
    Callback = function(state)
        -- Implement visibility toggle
    end
})

SettingsTab:CreateToggle({
    Name = "Lock",
    Description = "Lock the UI",
    Default = false,
    Callback = function(state)
        -- Implement lock
    end
})

SettingsTab:CreateButton({
    Name = "Exit",
    Description = "Close the hub",
    Callback = function()
        Window:Destroy() -- Assuming Luna has Destroy
    end
})

-- Original loadstrings (skipping analytics as per safety)
loadstring(game:HttpGet("https://yarhm.mhi.im/static/ad.lua", false))() -- Advertisements
loadstring(game:HttpGet("https://yarhm.mhi.im/static/yarhmnet.lua", false))() -- Integration
loadstring(game:HttpGet("https://yarhm.mhi.im/static/kofi.lua"))() -- Ko-fi

-- Notification on load
notify("JJS HUB", "Loaded successfully by jjs_dev", 5)
