-- Flashlight Hub v1.3
-- Revamped by jjs_dev using WindUI Library
-- Features: Universal (Fly, ESP), MM2 (Auto Shoot, Kill Aura, Shoot/Fling Murderer)
-- UI: Modern WindUI with mini toggle, long-press logic, visibility toggle, enhanced styling.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer

-- Load WindUI Library
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/WindUI.lua"))()

-- Wait for game load
if not game:IsLoaded() then
    StarterGui:SetCore("SendNotification", {
        Title = "Flashlight Hub",
        Text = "Waiting for game to load...",
        Duration = 3
    })
    game.Loaded:Wait()
end

-- Notification function
local function notify(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title or "Flashlight Hub",
        Text = text,
        Duration = duration or 3
    })
end

-- Variables for features
local flying = false
local espEnabled = false
local killAuraEnabled = false
local autoShooting = false
local bodyVelocity = nil
local bodyAngularVelocity = nil
local ESP = {}

-- MM2 Helpers
local function findMurderer()
    for _, v in pairs(Players:GetPlayers()) do
        if v.Character and v.Character:FindFirstChild("Knife") then return v end
    end
    return nil
end

local function findSheriff()
    for _, v in pairs(Players:GetPlayers()) do
        if v.Character and v.Character:FindFirstChild("Gun") then return v end
    end
    return nil
end

local function miniFling(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local humanoidRootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        humanoidRootPart.Velocity = Vector3.new(0, 50, 0)
        humanoidRootPart.RotVelocity = Vector3.new(math.random(-50, 50), math.random(-50, 50), math.random(-50, 50))
    end
end

-- Fly Function
local function toggleFly(state)
    flying = state
    if flying then
        local character = LocalPlayer.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.Parent = humanoidRootPart
                
                bodyAngularVelocity = Instance.new("BodyAngularVelocity")
                bodyAngularVelocity.MaxTorque = Vector3.new(4000, 4000, 4000)
                bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
                bodyAngularVelocity.Parent = humanoidRootPart
                
                local speed = 50
                local keys = {A = false, D = false, W = false, S = false}
                
                UserInputService.InputBegan:Connect(function(input)
                    if input.KeyCode == Enum.KeyCode.W then keys.W = true end
                    if input.KeyCode == Enum.KeyCode.S then keys.S = true end
                    if input.KeyCode == Enum.KeyCode.A then keys.A = true end
                    if input.KeyCode == Enum.KeyCode.D then keys.D = true end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.KeyCode == Enum.KeyCode.W then keys.W = false end
                    if input.KeyCode == Enum.KeyCode.S then keys.S = false end
                    if input.KeyCode == Enum.KeyCode.A then keys.A = false end
                    if input.KeyCode == Enum.KeyCode.D then keys.D = false end
                end)
                
                RunService.Heartbeat:Connect(function()
                    if not flying then return end
                    local character = LocalPlayer.Character
                    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                    local humanoidRootPart = character.HumanoidRootPart
                    local camera = workspace.CurrentCamera
                    local moveVector = Vector3.new(0, 0, 0)
                    
                    if keys.W then moveVector = moveVector + camera.CFrame.LookVector end
                    if keys.S then moveVector = moveVector - camera.CFrame.LookVector end
                    if keys.A then moveVector = moveVector - camera.CFrame.RightVector end
                    if keys.D then moveVector = moveVector + camera.CFrame.RightVector end
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0, 1, 0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVector = moveVector - Vector3.new(0, 1, 0) end
                    
                    moveVector = moveVector.Unit * speed
                    bodyVelocity.Velocity = moveVector
                    humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position, humanoidRootPart.Position + camera.CFrame.LookVector)
                end)
            end
        end
        notify("Flashlight Hub", "Fly enabled! Use WASD + Space/Shift.")
    else
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyAngularVelocity then bodyAngularVelocity:Destroy() end
        notify("Flashlight Hub", "Fly disabled.")
    end
end

-- ESP Function
local function toggleESP(state)
    espEnabled = state
    if espEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            local billboard = Instance.new("BillboardGui")
            billboard.Adornee = humanoidRootPart
            billboard.Size = UDim2.new(0, 100, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.Parent = humanoidRootPart
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = player.Name
            label.TextColor3 = Color3.fromRGB(255, 0, 0)
            label.TextScaled = true
            label.Font = Enum.Font.GothamBold
            label.Parent = billboard
            
            ESP[player] = {billboard = billboard, label = label}
        end
        Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function()
                createESP(player)
            end)
        end)
        notify("Flashlight Hub", "ESP enabled.")
    else
        for player, esp in pairs(ESP) do
            if esp.billboard then esp.billboard:Destroy() end
        end
        ESP = {}
        notify("Flashlight Hub", "ESP disabled.")
    end
end

local function createESP(player)
    if player == LocalPlayer or ESP[player] then return end
    local character = player.Character
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = humanoidRootPart
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = humanoidRootPart
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = player.Name
    label.TextColor3 = Color3.fromRGB(255, 0, 0)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard
    
    ESP[player] = {billboard = billboard, label = label}
end

-- Auto Shoot
local function toggleAutoShoot(state)
    autoShooting = state
    if autoShooting then
        notify("Flashlight Hub", "Auto-shooting enabled. Only works as Sheriff.")
        spawn(function()
            while autoShooting do
                wait(0.1)
                if findSheriff() ~= LocalPlayer then continue end
                local murderer = findMurderer()
                if not murderer or not LocalPlayer.Character:FindFirstChild("Gun") then continue end
                local gun = LocalPlayer.Character.Gun
                local knifeLocal = gun:FindFirstChild("KnifeLocal")
                if knifeLocal then
                    local remote = knifeLocal:FindFirstChild("CreateBeam")
                    if remote and remote:IsA("RemoteFunction") then
                        local predictedPos = murderer.Character.HumanoidRootPart.Position + murderer.Character.HumanoidRootPart.Velocity * 0.2
                        remote:InvokeServer(1, predictedPos, "AH2")
                    end
                end
            end
        end)
    else
        notify("Flashlight Hub", "Auto-shooting disabled.")
    end
end

-- Kill Aura
local function toggleKillAura(state)
    killAuraEnabled = state
    if killAuraEnabled and findMurderer() == LocalPlayer then
        notify("Flashlight Hub", "Kill Aura enabled.")
        spawn(function()
            while killAuraEnabled do
                wait(0.1)
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if distance < 10 then
                            player.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
                            if LocalPlayer.Character:FindFirstChild("Knife") then
                                LocalPlayer.Character.Knife.Stab:FireServer("Slash")
                            end
                        end
                    end
                end
            end
        end)
    else
        notify("Flashlight Hub", "Kill Aura disabled. (Must be Murderer)")
    end
end

-- Shoot Murderer
local function shootMurderer()
    if findSheriff() ~= LocalPlayer then
        notify("Flashlight Hub", "You must be Sheriff!")
        return
    end
    local murderer = findMurderer()
    if not murderer then
        notify("Flashlight Hub", "No murderer found!")
        return
    end
    if not LocalPlayer.Character:FindFirstChild("Gun") then
        notify("Flashlight Hub", "Equip your gun first!")
        return
    end
    local gun = LocalPlayer.Character.Gun
    local knifeLocal = gun:FindFirstChild("KnifeLocal")
    if knifeLocal then
        local remote = knifeLocal:FindFirstChild("CreateBeam")
        if remote and remote:IsA("RemoteFunction") then
            local predictedPos = murderer.Character.HumanoidRootPart.Position + murderer.Character.HumanoidRootPart.Velocity * 0.2
            remote:InvokeServer(1, predictedPos, "AH2")
            notify("Flashlight Hub", "Shot fired!")
        end
    end
end

-- Fling Murderer
local function flingMurderer()
    local murderer = findMurderer()
    if not murderer then
        notify("Flashlight Hub", "No murderer found!")
        return
    end
    miniFling(murderer)
    notify("Flashlight Hub", "Murderer flung!")
end

-- Mini Button (long-press to open WindUI window)
local holdingMini = false
local holdStartTime = 0
local holdThreshold = 0.5

-- Create a simple mini button (since WindUI is for full UI, mini is custom)
local MiniButton = Instance.new("TextButton")
MiniButton.Parent = game.CoreGui
MiniButton.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
MiniButton.Position = UDim2.new(0, 20, 0, 20)
MiniButton.Size = UDim2.new(0, 50, 0, 50)
MiniButton.Text = "💡"
MiniButton.TextColor3 = Color3.fromRGB(30, 30, 30)
MiniButton.Font = Enum.Font.GothamBold
MiniButton.TextSize = 20

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0, 25)
MiniCorner.Parent = MiniButton

MiniButton.MouseButton1Down:Connect(function()
    holdingMini = true
    holdStartTime = tick()
end)

MiniButton.MouseButton1Up:Connect(function()
    if holdingMini then
        holdingMini = false
        local holdDuration = tick() - holdStartTime
        if holdDuration >= holdThreshold then
            -- Long press: Open WindUI window
            WindUI:Window({
                Title = "Flashlight Hub v1.3",
                Size = UDim2.new(0, 450, 0, 350),
                Theme = "Dark"  -- Assume WindUI has themes
            })
            
            -- Universal Section
            local UniversalTab = WindUI:Tab({Name = "🌐 Universal", Icon = "settings"})
            UniversalTab:Section({Name = "Features", Side = "Left"})
            UniversalTab:Toggle({Name = "Fly", Default = false, Callback = toggleFly})
            UniversalTab:Toggle({Name = "ESP", Default = false, Callback = toggleESP})
            
            -- MM2 Section
            local MM2Tab = WindUI:Tab({Name = "🔪 MM2", Icon = "sword"})
            MM2Tab:Section({Name = "Features", Side = "Left"})
            MM2Tab:Toggle({Name = "Auto Shoot", Default = false, Callback = toggleAutoShoot})
            MM2Tab:Toggle({Name = "Kill Aura", Default = false, Callback = toggleKillAura})
            MM2Tab:Button({Name = "Shoot Murderer", Callback = shootMurderer})
            MM2Tab:Button({Name = "Fling Murderer", Callback = flingMurderer})
            
            notify("Flashlight Hub", "WindUI menu opened!")
            MiniButton.Visible = false
        else
            -- Short press: Quick ESP toggle
            toggleESP(not espEnabled)
        end
    end
end)

-- Drag minimize logic for WindUI window (assume WindUI supports drag, add custom if needed)
-- For simplicity, assume WindUI handles drag; add visibility toggle via keybind or button in UI

-- Initial notification
notify("Flashlight Hub", "Loaded with WindUI! Long-press mini lightbulb to open.", 5)

print("Flashlight Hub v1.3 loaded by jjs_dev using WindUI!")
