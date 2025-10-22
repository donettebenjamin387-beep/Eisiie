local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/main/Source.lua"))()

local Window = Luna:CreateWindow({
    Name = "JJS HUB | 99 NIGHTS SCRIPT",
    Subtitle = "v1 [dev]",
    LogoID = nil, -- Add your logo asset ID if desired
})

Window:SetKeybind("T")

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local function teleportItem(item, cframe)
    if not item or not cframe then return end
    if item:IsA("Model") and item.PrimaryPart then
        item:PivotTo(cframe)
    elseif item:IsA("BasePart") then
        item.CFrame = cframe
    end
end

local function getPlayerCFrame()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    return CFrame.new(hrp.Position.X, hrp.Position.Y - 1, hrp.Position.Z)
end    

local BringTab = Window:CreateTab({
    Name = "BRING ITEMS",
    Icon = "package"
})

local dropdowns = {
    Food = {
        "Cooked Morsel", "Cooked Steak", "Cake", "Stew", "Hearty Stew",
        "Seafood Chower", "Steak Dinner", "Pumpkin Soup", "BBQ Ribs", "Carrot Cake"
    },
    Ribs = {
        "Ribs", "Morsel", "Berry", "Carrot", "Chilli", "Corn", "Pumpkin", "Apple", "Steak"
    },
    Scrap = {
        "Tyre", "Old Radio", "Broken Microwave", "Broken Fan", "Sheet Metal",
        "Bolt", "Metal Chair", "Old Car Engineer", "Washing Machine", "Forest Gem",
        "Forest Gem Fragment"
    },
    Fuel = {
        "Sapling", "Log", "Chair", "Coal", "Fuel Canister", "Biofuel", "Oil Barrel"
    },
    Items = {
        "Old Sack", "Good Sack", "Infernal Sack", "Giant Sack", "Old Axe", "Good Axe",
        "Ice Axe", "Strong Axe", "Chainsaw", "Admin Axe", "Old Flashlight", "Strong Flashlight",
        "Old Rod", "Good Rod", "Strong Rod", "Leather Body", "Iron Body", "Poision Armor",
        "Thorn Body", "Riot Shield", "Alien Armor", "Spear", "Monigstar", "Katana",
        "Laser Sword", "Ice Sword", "Poison Spear", "Inferno Sword", "Trident",
        "Cultist King Mace", "Revolver", "Revolver Ammo", "Rifle", "Rifle Ammo",
        "Tatcal Shotgun", "Shotgun Ammo", "Kunai", "Ray Gun", "Laser Cannon", "Crossbow",
        "Medkit", "Bandage" -- novos itens adicionados
    }
}

local selectedItems = { "None" } 
local itemCount = 10

for category, list in pairs(dropdowns) do
    table.insert(list, 1, "None") 
    BringTab:CreateDropdown({
        Name = category:upper() .. " DROPDOWN (Multi)",
        Description = "SELECT " .. category:upper(),
        Options = list,
        CurrentOption = { "None" },
        MultipleOptions = true,
        Callback = function(option)
            selectedItems = option
            print(category .. " selected: " .. HttpService:JSONEncode(option))
        end
    })
end

BringTab:CreateTextbox({
    Name = "ITEM COUNT",
    Description = "NUMBER OF ITEMS TO BRING (1-10000, >100 MAY LAG!)",
    Default = tostring(itemCount),
    Placeholder = "10",
    Callback = function(input)
        local num = tonumber(input)
        if not num or num < 1 then
            itemCount = 1
        elseif num > 10000 then
            itemCount = 10000
        else
            itemCount = num
        end
        if itemCount > 100 then
            Window:CreateNotification({
                Title = "WARNING",
                Content = "Bringing more than 100 items may cause lag!",
                Duration = 5
            })
        end
    end
})

BringTab:CreateButton({
    Name = "BRING SELECTED ITEMS",
    Description = "BRINGS SELECTED ITEM(S) BELOW YOU",
    Callback = function()
        local ItemsFolder = workspace:FindFirstChild("Items")
        if not ItemsFolder then return end
        local brought = 0
        local playerCFrame = getPlayerCFrame()
        for _, itemName in ipairs(selectedItems) do
            if itemName ~= "None" then
                for _, item in ipairs(ItemsFolder:GetChildren()) do
                    if brought >= itemCount then break end
                    if item.Name == itemName then
                        teleportItem(item, playerCFrame)
                        brought = brought + 1
                    end
                end
            end
        end
        print("Brought " .. brought .. " item(s): " .. HttpService:JSONEncode(selectedItems))
    end
})

local AutoTab = Window:CreateTab({
    Name = "AUTO FEATURES",
    Icon = "settings"
})

-- Variáveis de controle
local running = false
local treeType = "Small Tree"
local axeNames = { "Old Axe", "Good Axe", "Strong Axe", "Chainsaw" }
local multiHits = 3

-- Função principal
local function startLoop()
    task.spawn(function()
        while running do
            local player = game:GetService("Players").LocalPlayer
            local inv = player:WaitForChild("Inventory")
            local axe = nil
            -- Pega a primeira ferramenta válida
            for _, v in ipairs(axeNames) do
                if inv:FindFirstChild(v) then
                    axe = inv[v]
                    break
                end
            end
            if axe then
                local targetTree = workspace:WaitForChild("Map"):WaitForChild("Foliage"):FindFirstChild(treeType)
                if targetTree then
                    for i = 1, multiHits do
                        local args = {
                            targetTree,
                            axe,
                            "22_8763377746",
                            CFrame.new(-7.693432331085205, 5.408633232116699, 149.1598663330078, -0.997268795967102, 1.884811595687097e-08, 0.07385756820440292, 1.873402410978997e-08, 1, -2.237524610038122e-09, -0.07385756820440292, -8.477641366688715e-10, -0.997268795967102)
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("ToolDamageObject"):InvokeServer(unpack(args))
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end

-- Toggle
AutoTab:CreateToggle({
    Name = "AUTO TREE CUT",
    Description = "Automatically cuts trees",
    Default = false,
    Callback = function(state)
        running = state
        if running then
            startLoop()
        end
    end
})

-- Input quantidade
AutoTab:CreateTextbox({
    Name = "MULTI HIT",
    Description = "Number of times to send Remote (1-100, default 3)",
    Default = "3",
    Placeholder = "Enter number...",
    Callback = function(input)
        local num = tonumber(input)
        if num then
            if num > 100 then num = 100 end
            if num < 1 then num = 1 end
            multiHits = num
            if num > 5 then
                Window:CreateNotification({
                    Title = "WARNING",
                    Content = "Above 5 may cause LAG!",
                    Duration = 5
                })
            end
        end
    end
})

-- Dropdown árvore
AutoTab:CreateDropdown({
    Name = "TREE TYPE",
    Description = "Select tree type",
    Options = { "Small Tree", "BigTree2" },
    CurrentOption = "Small Tree",
    MultipleOptions = false,
    Callback = function(option)
        treeType = option
    end
})

-- Variáveis Bunny hunt
local hunting = false
local huntRadius = 50 -- valor inicial
local huntFolder = workspace:WaitForChild("Characters")

-- Função do loop Bunny
local function startHuntLoop()
    task.spawn(function()
        while hunting do
            local player = game:GetService("Players").LocalPlayer
            local char = player.Character or player.CharacterAdded:Wait()
            local root = char:WaitForChild("HumanoidRootPart")
            local inv = player:WaitForChild("Inventory")
            local axe = nil
            for _, v in ipairs(axeNames) do
                if inv:FindFirstChild(v) then
                    axe = inv[v]
                    break
                end
            end
            if axe then
                for _, mob in ipairs(huntFolder:GetChildren()) do
                    if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") then
                        local dist = (mob.HumanoidRootPart.Position - root.Position).Magnitude
                        if dist <= huntRadius then
                            local args = {
                                mob,
                                axe,
                                "21_8763377746",
                                CFrame.new(-51.6545524597168, 4.068472385406494, 56.23427200317383, 0.1663663387298584, -3.6390201074709694e-08, 0.9860640168190002, 2.616167371627398e-08, 1, 3.2490564905174324e-08, -0.9860640168190002, 2.0391748734027715e-08, 0.1663663387298584)
                            }
                            game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("ToolDamageObject"):InvokeServer(unpack(args))
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end

-- Toggle Bunny hunt
AutoTab:CreateToggle({
    Name = "KILL AURA",
    Description = "Attacks all mobs in range",
    Default = false,
    Callback = function(state)
        hunting = state
        if hunting then
            startHuntLoop()
        end
    end
})

-- Input Distance
AutoTab:CreateTextbox({
    Name = "ATTACK RANGE",
    Description = "Radius in studs to attack mobs (default 50)",
    Default = "50",
    Placeholder = "Enter studs...",
    Callback = function(input)
        local num = tonumber(input)
        if num then
            if num > 1000 then num = 1000 end -- limite de segurança
            if num < 10 then num = 10 end
            huntRadius = num
            if num > 300 then
                Window:CreateNotification({
                    Title = "WARNING",
                    Content = "High range may cause LAG!",
                    Duration = 5
                })
            end
        end
    end
})

-- 🌍 CHILDREN TELEPORT + MAP LOADER
local selectedChild = nil
local teleporting = false

-- 🔽 DROPDOWN
AutoTab:CreateDropdown({
    Name = "CHILDS DROPDOWN",
    Description = "SELECT A CHILD TO TELEPORT",
    Options = { "Lost Child", "Lost Child2", "Lost Child3", "Lost Child4" },
    CurrentOption = "Lost Child",
    MultipleOptions = false,
    Callback = function(option)
        selectedChild = option
    end
})

-- 🔘 TP BUTTON
AutoTab:CreateButton({
    Name = "TP CHILD CLICK",
    Description = "TELEPORT TO SELECTED CHILD",
    Callback = function()
        if selectedChild then
            local child = workspace:FindFirstChild(selectedChild)
            if child and child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart") then
                local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    root.CFrame = child:FindFirstChildWhichIsA("BasePart").CFrame + Vector3.new(0, 5, 0)
                end
            end
        end
    end
})

-- 🔄 LOAD MAP TOGGLE
AutoTab:CreateToggle({
    Name = "LOAD MAP TOGGLE",
    Description = "TELEPORT AROUND THE MAP FOR 15 SECONDS",
    Default = false,
    Callback = function(state)
        teleporting = state
        if teleporting then
            task.spawn(function()
                local char = game.Players.LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    local original = root.CFrame
                    local places = {}
                    -- pega pontos para teleportar (tudo que for BasePart no workspace)
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("BasePart") then
                            table.insert(places, v)
                        end
                    end
                    local start = tick()
                    while teleporting and tick() - start < 15 do
                        for _, part in ipairs(places) do
                            if not teleporting then break end
                            root.CFrame = part.CFrame + Vector3.new(0, 5, 0)
                            task.wait(0.2)
                        end
                    end
                    -- volta pro lugar original
                    root.CFrame = original
                    teleporting = false
                end
            end)
        end
    end
})

local PlayerTab = Window:CreateTab({
    Name = "PLAYER FEATURES",
    Icon = "user"
})

-- Variáveis gerais
local noclipEnabled = false
local speedEnabled = false
local gravityEnabled = false
local flyEnabled = false
local speedValue = 16
local gravityValue = 194.6
local flySpeed = 50
local flying = false
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Atualiza Character se respawnar
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")
end)

-- NOCLIP
local function noclipLoop()
    RunService.Stepped:Connect(function()
        if noclipEnabled and character and character:FindFirstChild("HumanoidRootPart") then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)
end
noclipLoop()

PlayerTab:CreateToggle({
    Name = "NOCLIP TOGGLE",
    Description = "Walk through walls",
    Default = false,
    Callback = function(state)
        noclipEnabled = state
    end
})

PlayerTab:CreateKeybind({
    Name = "NOCLIP TOGGLE KEYBIND",
    Description = "Keybind to toggle noclip",
    CurrentBind = "N",
    Callback = function()
        noclipEnabled = not noclipEnabled
    end
})

-- SPEED
local function speedLoop()
    task.spawn(function()
        while true do
            if speedEnabled and humanoid then
                humanoid.WalkSpeed = speedValue
            end
            task.wait(0.1)
        end
    end)
end
speedLoop()

PlayerTab:CreateToggle({
    Name = "SPEED TOGGLE",
    Description = "Enable custom walkspeed",
    Default = false,
    Callback = function(state)
        speedEnabled = state
        if not state and humanoid then
            humanoid.WalkSpeed = 16
        end
    end
})

PlayerTab:CreateTextbox({
    Name = "SPEED INPUT",
    Description = "Custom walkspeed value",
    Default = "16",
    Placeholder = "Enter speed...",
    Callback = function(input)
        local num = tonumber(input)
        if num then
            speedValue = num
        end
    end
})

PlayerTab:CreateKeybind({
    Name = "SPEED TOGGLE KEYBIND",
    Description = "Keybind to toggle speed",
    CurrentBind = "M",
    Callback = function()
        speedEnabled = not speedEnabled
        if not speedEnabled and humanoid then
            humanoid.WalkSpeed = 16
        end
    end
})

-- GRAVITY
local function gravityLoop()
    task.spawn(function()
        while true do
            if gravityEnabled then
                workspace.Gravity = gravityValue
            end
            task.wait(0.1)
        end
    end)
end
gravityLoop()

PlayerTab:CreateToggle({
    Name = "GRAVITY TOGGLE",
    Description = "Enable custom gravity",
    Default = false,
    Callback = function(state)
        gravityEnabled = state
        if not state then
            workspace.Gravity = 196.2
        end
    end
})

PlayerTab:CreateTextbox({
    Name = "GRAVITY POWER INPUT",
    Description = "Set gravity value",
    Default = "196.2",
    Placeholder = "Enter gravity...",
    Callback = function(input)
        local num = tonumber(input)
        if num then
            gravityValue = num
        end
    end
})

PlayerTab:CreateKeybind({
    Name = "GRAVITY TOGGLE KEYBIND",
    Description = "Keybind to toggle gravity",
    CurrentBind = "B",
    Callback = function()
        gravityEnabled = not gravityEnabled
        if not gravityEnabled then
            workspace.Gravity = 196.2
        end
    end
})

-- FLY
local bodyVel, bodyGyro
local function startFly()
    local root = character:WaitForChild("HumanoidRootPart")
    bodyVel = Instance.new("BodyVelocity")
    bodyVel.Velocity = Vector3.zero
    bodyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVel.Parent = root
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bodyGyro.CFrame = root.CFrame
    bodyGyro.Parent = root
    flying = true
    task.spawn(function()
        while flyEnabled and character and character:FindFirstChild("HumanoidRootPart") do
            local moveDir = humanoid.MoveDirection
            bodyVel.Velocity = (moveDir * flySpeed) + Vector3.new(0, UserInputService:IsKeyDown(Enum.KeyCode.Space) and flySpeed or 0, 0)
            bodyGyro.CFrame = workspace.CurrentCamera.CFrame
            task.wait()
        end
    end)
end

local function stopFly()
    flying = false
    if bodyVel then bodyVel:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
end

PlayerTab:CreateToggle({
    Name = "FLY TOGGLE",
    Description = "Enable flying",
    Default = false,
    Callback = function(state)
        flyEnabled = state
        if state then
            startFly()
        else
            stopFly()
        end
    end
})

PlayerTab:CreateTextbox({
    Name = "FLY SPEED INPUT",
    Description = "Set fly speed",
    Default = "50",
    Placeholder = "Enter fly speed...",
    Callback = function(input)
        local num = tonumber(input)
        if num then
            flySpeed = num
        end
    end
})

PlayerTab:CreateKeybind({
    Name = "FLY TOGGLE KEYBIND",
    Description = "Keybind to toggle fly",
    CurrentBind = "F",
    Callback = function()
        flyEnabled = not flyEnabled
        if flyEnabled then
            startFly()
        else
            stopFly()
        end
    end
})

-- INF JUMP
local infJumpEnabled = false
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

PlayerTab:CreateToggle({
    Name = "INF JUMP TOGGLE",
    Description = "Jump infinitely",
    Default = false,
    Callback = function(state)
        infJumpEnabled = state
    end
})

PlayerTab:CreateKeybind({
    Name = "INF JUMP KEYBIND",
    Description = "Keybind to toggle infinite jump",
    CurrentBind = "J",
    Callback = function()
        infJumpEnabled = not infJumpEnabled
    end
})

-- JUMP POWER
local jumpPowerEnabled = false
local jumpPowerValue = 50
local function updateJumpPower()
    if humanoid then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = jumpPowerValue
    end
end

PlayerTab:CreateToggle({
    Name = "JUMPPOWER TOGGLE",
    Description = "Enable custom jump power",
    Default = false,
    Callback = function(state)
        jumpPowerEnabled = state
        if state then
            updateJumpPower()
        else
            if humanoid then humanoid.JumpPower = 50 end
        end
    end
})

PlayerTab:CreateTextbox({
    Name = "JUMPPOWER INPUT",
    Description = "Set custom jump power",
    Default = "50",
    Placeholder = "Enter jump power...",
    Callback = function(input)
        local num = tonumber(input)
        if num then
            jumpPowerValue = num
            if jumpPowerEnabled then
                updateJumpPower()
            end
        end
    end
})

PlayerTab:CreateKeybind({
    Name = "JUMPPOWER TOGGLE KEYBIND",
    Description = "Keybind to toggle custom jump power",
    CurrentBind = "K",
    Callback = function()
        jumpPowerEnabled = not jumpPowerEnabled
        if jumpPowerEnabled then
            updateJumpPower()
        else
            if humanoid then humanoid.JumpPower = 50 end
        end
    end
})

-- INSTANT INTERACT
local instaInteractEnabled = false
local function instaInteractLoop()
    task.spawn(function()
        while true do
            if instaInteractEnabled then
                for _, prompt in ipairs(workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        prompt.HoldDuration = 0
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end
instaInteractLoop()

PlayerTab:CreateToggle({
    Name = "INSTANT INTERACT TOGGLE",
    Description = "Instantly interact with prompts",
    Default = false,
    Callback = function(state)
        instaInteractEnabled = state
    end
})

PlayerTab:CreateKeybind({
    Name = "INSTANT INTERACT KEYBIND",
    Description = "Keybind to toggle instant interact",
    CurrentBind = "L",
    Callback = function()
        instaInteractEnabled = not instaInteractEnabled
    end
})

-- PLATFORM
local platformEnabled = false
local platformSize = 10
local platformUpEnabled = false
local platformUpSpeed = 5
local platformPart

local function createPlatform()
    if not platformPart then
        platformPart = Instance.new("Part")
        platformPart.Size = Vector3.new(platformSize, 1, platformSize)
        platformPart.Anchored = true
        platformPart.Transparency = 0.8
        platformPart.Color = Color3.new(0,0,0)
        platformPart.Name = "PlayerPlatform"
        platformPart.Parent = workspace
    end
end

local function updatePlatform()
    if platformPart and character and character:FindFirstChild("HumanoidRootPart") then
        local root = character.HumanoidRootPart
        platformPart.Size = Vector3.new(platformSize, 1, platformSize)
        platformPart.CFrame = root.CFrame * CFrame.new(0, -3, 0)
    end
end

task.spawn(function()
    while true do
        if platformEnabled then
            createPlatform()
            updatePlatform()
            if platformUpEnabled then
                platformPart.CFrame = platformPart.CFrame + Vector3.new(0, platformUpSpeed * 0.1, 0)
            end
        elseif platformPart then
            platformPart:Destroy()
            platformPart = nil
        end
        task.wait(0.1)
    end
end)

PlayerTab:CreateToggle({
    Name = "PLATFORM TOGGLE",
    Description = "Creates a platform under you",
    Default = false,
    Callback = function(state)
        platformEnabled = state
    end
})

PlayerTab:CreateTextbox({
    Name = "PLATFORM INPUT",
    Description = "Change platform size",
    Default = "10",
    Placeholder = "Enter size...",
    Callback = function(input)
        local num = tonumber(input)
        if num then
            platformSize = num
        end
    end
})

PlayerTab:CreateToggle({
    Name = "PLATFORM UP TOGGLE",
    Description = "Makes platform rise upwards",
    Default = false,
    Callback = function(state)
        platformUpEnabled = state
    end
})

PlayerTab:CreateTextbox({
    Name = "UP SPEED INPUT",
    Description = "Speed at which platform rises",
    Default = "5",
    Placeholder = "Enter up speed...",
    Callback = function(input)
        local num = tonumber(input)
        if num then
            platformUpSpeed = num
        end
    end
})

local SaplingTab = Window:CreateTab({
    Name = "SAPLING [BETA]",
    Icon = "sprout"
})

-- 🔹 AUTO PLANT SLAPPING CLICK
local AutoPlantSlapping = false
local SlappingNumbers = 3 -- valor inicial de 3

SaplingTab:CreateTextbox({
    Name = "SLAPPING NUMBERS INPUT",
    Description = "SET HOW MANY TIMES TO FIRE REMOTE",
    Default = "3",
    Callback = function(value)
        local num = tonumber(value)
        if num then
            SlappingNumbers = num
        end
    end
})

SaplingTab:CreateButton({
    Name = "AUTO PLANT SLAPPING CLICK",
    Description = "FIRE THE REMOTE WHEN CLICKED",
    Callback = function()
        for i = 1, SlappingNumbers do
            local args = {
                Instance.new("Model", nil),
                Vector3.new(-31.58843231201172, 1.1459615230560303, -37.0241813659668)
            }
            game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestPlantItem"):InvokeServer(unpack(args))
        end
    end
})

SaplingTab:CreateKeybind({
    Name = "AUTO PLANT SLAPPING KEYBIND",
    Description = "KEYBIND TO FIRE AUTO PLANT",
    CurrentBind = "P",
    Callback = function()
        for i = 1, SlappingNumbers do
            local args = {
                Instance.new("Model", nil),
                Vector3.new(-31.58843231201172, 1.1459615230560303, -37.0241813659668)
            }
            game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestPlantItem"):InvokeServer(unpack(args))
        end
    end
})

-- 🔹 SLAPPING PLANT (CUSTOM RANGE + TIMES)
local SlappingPlantToggle = false
local SlappingRange = 100
local SlappingPlantNumbers = 3

SaplingTab:CreateTextbox({
    Name = "SAPLING RANGE INPUT",
    Description = "DISTANCE IN STUDS FROM PLAYER",
    Default = "100",
    Callback = function(value)
        local num = tonumber(value)
        if num then
            SlappingRange = num
        end
    end
})

SaplingTab:CreateTextbox({
    Name = "SAPLING NUMBER INPUT",
    Description = "NUMBER OF TIMES TO FIRE REMOTE",
    Default = "3",
    Callback = function(value)
        local num = tonumber(value)
        if num then
            SlappingPlantNumbers = num
        end
    end
})

SaplingTab:CreateToggle({
    Name = "SAPLING PLANT TOGGLE",
    Description = "PLANT SEED AT CUSTOM RANGE",
    Default = false,
    Callback = function(v)
        SlappingPlantToggle = v
        if SlappingPlantToggle then
            local player = game.Players.LocalPlayer
            local char = player.Character or player.CharacterAdded:Wait()
            local root = char:WaitForChild("HumanoidRootPart")
            for i = 1, SlappingPlantNumbers do
                local args = {
                    Instance.new("Model", nil),
                    root.Position + (root.CFrame.LookVector * SlappingRange)
                }
                game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestPlantItem"):InvokeServer(unpack(args))
            end
        end
    end
})

SaplingTab:CreateKeybind({
    Name = "SAPLING PLANT KEYBIND",
    Description = "KEYBIND TO FIRE CUSTOM RANGE PLANT",
    CurrentBind = "O",
    Callback = function()
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart")
        for i = 1, SlappingPlantNumbers do
            local args = {
                Instance.new("Model", nil),
                root.Position + (root.CFrame.LookVector * SlappingRange)
            }
            game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestPlantItem"):InvokeServer(unpack(args))
        end
    end
})

local HitboxTab = Window:CreateTab({
    Name = "HITBOXTAB",
    Icon = "target"
})

-- Variáveis Bunny Hunt
local hunting2 = false -- Renamed to avoid conflict
local huntRadius2 = 50 -- Renamed
local huntFolder = workspace:WaitForChild("Characters")

-- Lista de armas permitidas
local weaponNames = {
    "Old Axe", "Good Axe", "Ice Axe", "Strong Axe", "Chainsaw", "Admin Axe",
    "Spear", "Monigstar", "Katana",
    "Laser Sword", "Ice Sword", "Poison Spear", "Inferno Sword", "Trident",
    "Cultist King Mace"
}

-- Função principal do loop Bunny Hunt
local function startHuntLoop2()
    task.spawn(function()
        while hunting2 do
            local player = game:GetService("Players").LocalPlayer
            local char = player.Character or player.CharacterAdded:Wait()
            local root = char:WaitForChild("HumanoidRootPart")
            local inv = player:WaitForChild("Inventory")
            -- Procurar primeira arma disponível no inventário
            local weapon = nil
            for _, v in ipairs(weaponNames) do
                if inv:FindFirstChild(v) then
                    weapon = inv[v]
                    break
                end
            end
            -- Se tiver arma, atacar mobs próximos
            if weapon then
                for _, mob in ipairs(huntFolder:GetChildren()) do
                    if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") then
                        local dist = (mob.HumanoidRootPart.Position - root.Position).Magnitude
                        if dist <= huntRadius2 then
                            local args = {
                                mob,
                                weapon,
                                "21_8763377746", -- ID da animação ou evento
                                CFrame.new(-51.65, 4.06, 56.23, 0.166, 0, 0.986, 0, 1, 0, -0.986, 0, 0.166)
                            }
                            game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("ToolDamageObject"):InvokeServer(unpack(args))
                        end
                    end
                end
            end
            task.wait(0.1) -- Pequena pausa para não travar
        end
    end)
end

-- Toggle para ativar/desativar Bunny Hunt
HitboxTab:CreateToggle({
    Name = "KILL AURA [WEAPONS]",
    Description = "Attacks all mobs in range",
    Default = false,
    Callback = function(state)
        hunting2 = state
        if hunting2 then
            startHuntLoop2()
        end
    end
})

-- Input para ajustar o alcance de ataque
HitboxTab:CreateTextbox({
    Name = "ATTACK RANGE",
    Description = "Radius in studs to attack mobs (default 50)",
    Default = "50",
    Placeholder = "Enter studs...",
    Callback = function(input)
        local num = tonumber(input)
        if num then
            if num > 1000 then num = 1000 end -- limite de segurança
            if num < 10 then num = 10 end
            huntRadius2 = num
            if num > 300 then
                Window:CreateNotification({
                    Title = "WARNING",
                    Content = "High range may cause LAG!",
                    Duration = 5
                })
            end
        end
    end
})

local ESPTab = Window:CreateTab({
    Name = "ESP",
    Icon = "eye"
})

-- Variável de controle
local espEnabled = false

-- Função para criar ESP
local function createESP(part)
    if part:FindFirstChild("TreeESP") then return part.TreeESP end
    local bill = Instance.new("BillboardGui")
    bill.Name = "TreeESP"
    bill.Adornee = part
    bill.Size = UDim2.new(6, 0, 2, 0)
    bill.AlwaysOnTop = true
    bill.MaxDistance = 500
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 0.4, 0)
    textLabel.Position = UDim2.new(0, 0, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    textLabel.TextStrokeTransparency = 0
    textLabel.TextScaled = true
    textLabel.Name = "HealthText"
    textLabel.Parent = bill
    local barBack = Instance.new("Frame")
    barBack.Size = UDim2.new(1, 0, 0.25, 0)
    barBack.Position = UDim2.new(0, 0, 0.7, 0)
    barBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    barBack.BorderSizePixel = 0
    barBack.Name = "BarBack"
    barBack.Parent = bill
    local bar = Instance.new("Frame")
    bar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    bar.BorderSizePixel = 0
    bar.Size = UDim2.new(1, 0, 1, 0)
    bar.Name = "HealthBar"
    bar.Parent = barBack
    bill.Parent = part
    return bill
end

-- Função para atualizar ESP
local function updateESP(tree)
    local root = tree:FindFirstChild("HumanoidRootPart") or tree:FindFirstChildWhichIsA("BasePart")
    if not root then return end
    local esp = root:FindFirstChild("TreeESP") or createESP(root)
    local health = tree:GetAttribute("Health") or 0
    local textLabel = esp:FindFirstChild("HealthText")
    local barBack = esp:FindFirstChild("BarBack")
    local bar = barBack and barBack:FindFirstChild("HealthBar")
    if espEnabled and health < 50 then
        esp.Enabled = true
        textLabel.Text = "HEALTH: " .. tostring(health)
        local percent = math.clamp(health / 50, 0, 1)
        bar.Size = UDim2.new(percent, 0, 1, 0)
    else
        esp.Enabled = false
    end
end

-- Loop principal (task.wait)
task.spawn(function()
    while task.wait(1) do
        for _, tree in pairs(workspace:GetDescendants()) do
            if tree:IsA("Model") and (tree.Name == "Small Tree" or tree.Name == "BigTree2") then
                updateESP(tree)
            end
        end
    end
end)

-- 🔘 TOGGLE
ESPTab:CreateToggle({
    Name = "ESP TREE LIVE TOGGLE",
    Description = "ENABLE OR DISABLE TREE ESP",
    Default = false,
    Callback = function(state)
        espEnabled = state
    end
})

-- ⌨️ KEYBIND
ESPTab:CreateKeybind({
    Name = "ESP TREE LIVE KEYBIND",
    Description = "TOGGLE TREE ESP WITH A KEY",
    CurrentBind = Enum.KeyCode.E,
    Callback = function()
        espEnabled = not espEnabled
    end
})

-- Credit
Window:CreateNotification({
    Title = "JJS HUB",
    Content = "Script by jjs_dev",
    Duration = 3
})
