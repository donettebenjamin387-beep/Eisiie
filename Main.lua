-- Flashlight Hub v1.0
-- Revamped by jjs_dev
-- A custom, sleek Roblox script hub with essential features from YARHM.
-- Features: Universal (Fly, ESP, Notifications), MM2-specific (Auto-shoot, Kill Aura, etc.)
-- Custom GUI: Modern dark theme, draggable menu, toggles/buttons, clean layout.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

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

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlashlightHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- Main Menu Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true

-- Corner rounding
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Stroke for border
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 200, 100)  -- Warm flashlight accent
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 40)

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Parent = TitleBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Flashlight Hub v1.0"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "Close"
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -30, 0, 5)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Font = Enum.Font.Gotham
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseButton

-- Content ScrollingFrame
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "Content"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.Position = UDim2.new(0, 0, 0, 40)
ContentFrame.Size = UDim2.new(1, 0, 1, -40)
ContentFrame.ScrollBarThickness = 6
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 200, 100)

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Parent = ContentFrame
ContentLayout.Padding = UDim.new(0, 5)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.FillDirection = Enum.FillDirection.Vertical
ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Universal Section
local UniversalSection = Instance.new("Frame")
UniversalSection.Name = "Universal"
UniversalSection.Parent = ContentFrame
UniversalSection.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
UniversalSection.BorderSizePixel = 0
UniversalSection.Size = UDim2.new(1, -10, 0, 120)

local UniCorner = Instance.new("UICorner")
UniCorner.CornerRadius = UDim.new(0, 6)
UniCorner.Parent = UniversalSection

local UniTitle = Instance.new("TextLabel")
UniTitle.Parent = UniversalSection
UniTitle.BackgroundTransparency = 1
UniTitle.Size = UDim2.new(1, 0, 0, 30)
UniTitle.Font = Enum.Font.GothamSemibold
UniTitle.Text = "Universal Features"
UniTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
UniTitle.TextSize = 14
UniTitle.TextXAlignment = Enum.TextXAlignment.Left
UniTitle.Position = UDim2.new(0, 10, 0, 5)

-- Fly Toggle
local FlyToggle = Instance.new("TextButton")
FlyToggle.Name = "Fly"
FlyToggle.Parent = UniversalSection
FlyToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FlyToggle.BorderSizePixel = 0
FlyToggle.Position = UDim2.new(0, 10, 0, 40)
FlyToggle.Size = UDim2.new(1, -20, 0, 30)
FlyToggle.Font = Enum.Font.Gotham
FlyToggle.Text = "Fly: OFF"
FlyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyToggle.TextSize = 12

local FlyCorner = Instance.new("UICorner")
FlyCorner.CornerRadius = UDim.new(0, 4)
FlyCorner.Parent = FlyToggle

-- ESP Toggle
local ESPToggle = Instance.new("TextButton")
ESPToggle.Name = "ESP"
ESPToggle.Parent = UniversalSection
ESPToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ESPToggle.BorderSizePixel = 0
ESPToggle.Position = UDim2.new(0, 10, 0, 75)
ESPToggle.Size = UDim2.new(1, -20, 0, 30)
ESPToggle.Font = Enum.Font.Gotham
ESPToggle.Text = "ESP: OFF"
ESPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPToggle.TextSize = 12

local ESPCorner = Instance.new("UICorner")
ESPCorner.CornerRadius = UDim.new(0, 4)
ESPCorner.Parent = ESPToggle

-- MM2 Section
local MM2Section = Instance.new("Frame")
MM2Section.Name = "MM2"
MM2Section.Parent = ContentFrame
MM2Section.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MM2Section.BorderSizePixel = 0
MM2Section.Size = UDim2.new(1, -10, 0, 200)

local MM2Corner = Instance.new("UICorner")
MM2Corner.CornerRadius = UDim.new(0, 6)
MM2Corner.Parent = MM2Section

local MM2Title = Instance.new("TextLabel")
MM2Title.Parent = MM2Section
MM2Title.BackgroundTransparency = 1
MM2Title.Size = UDim2.new(1, 0, 0, 30)
MM2Title.Font = Enum.Font.GothamSemibold
MM2Title.Text = "Murder Mystery 2 Features"
MM2Title.TextColor3 = Color3.fromRGB(255, 255, 255)
MM2Title.TextSize = 14
MM2Title.TextXAlignment = Enum.TextXAlignment.Left
MM2Title.Position = UDim2.new(0, 10, 0, 5)

-- Auto Shoot Button
local AutoShootButton = Instance.new("TextButton")
AutoShootButton.Name = "AutoShoot"
AutoShootButton.Parent = MM2Section
AutoShootButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AutoShootButton.BorderSizePixel = 0
AutoShootButton.Position = UDim2.new(0, 10, 0, 40)
AutoShootButton.Size = UDim2.new(1, -20, 0, 30)
AutoShootButton.Font = Enum.Font.Gotham
AutoShootButton.Text = "Auto Shoot Murderer"
AutoShootButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoShootButton.TextSize = 12

local AutoShootCorner = Instance.new("UICorner")
AutoShootCorner.CornerRadius = UDim.new(0, 4)
AutoShootCorner.Parent = AutoShootButton

-- Kill Aura Toggle
local KillAuraToggle = Instance.new("TextButton")
KillAuraToggle.Name = "KillAura"
KillAuraToggle.Parent = MM2Section
KillAuraToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
KillAuraToggle.BorderSizePixel = 0
KillAuraToggle.Position = UDim2.new(0, 10, 0, 75)
KillAuraToggle.Size = UDim2.new(1, -20, 0, 30)
KillAuraToggle.Font = Enum.Font.Gotham
KillAuraToggle.Text = "Kill Aura: OFF"
KillAuraToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
KillAuraToggle.TextSize = 12

local KillAuraCorner = Instance.new("UICorner")
KillAuraCorner.CornerRadius = UDim.new(0, 4)
KillAuraCorner.Parent = KillAuraToggle

-- Shoot Murderer Button
local ShootMurdererButton = Instance.new("TextButton")
ShootMurdererButton.Name = "ShootMurderer"
ShootMurdererButton.Parent = MM2Section
ShootMurdererButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ShootMurdererButton.BorderSizePixel = 0
ShootMurdererButton.Position = UDim2.new(0, 10, 0, 110)
ShootMurdererButton.Size = UDim2.new(1, -20, 0, 30)
ShootMurdererButton.Font = Enum.Font.Gotham
ShootMurdererButton.Text = "Shoot Murderer"
ShootMurdererButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ShootMurdererButton.TextSize = 12

local ShootMurdererCorner = Instance.new("UICorner")
ShootMurdererCorner.CornerRadius = UDim.new(0, 4)
ShootMurdererCorner.Parent = ShootMurdererButton

-- Fling Murderer Button
local FlingMurdererButton = Instance.new("TextButton")
FlingMurdererButton.Name = "FlingMurderer"
FlingMurdererButton.Parent = MM2Section
FlingMurdererButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FlingMurdererButton.BorderSizePixel = 0
FlingMurdererButton.Position = UDim2.new(0, 10, 0, 145)
FlingMurdererButton.Size = UDim2.new(1, -20, 0, 30)
FlingMurdererButton.Font = Enum.Font.Gotham
FlingMurdererButton.Text = "Fling Murderer"
FlingMurdererButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlingMurdererButton.TextSize = 12

local FlingMurdererCorner = Instance.new("UICorner")
FlingMurdererCorner.CornerRadius = UDim.new(0, 4)
FlingMurdererCorner.Parent = FlingMurdererButton

-- Credits Label
local CreditsLabel = Instance.new("TextLabel")
CreditsLabel.Parent = MainFrame
CreditsLabel.BackgroundTransparency = 1
CreditsLabel.Position = UDim2.new(0, 10, 1, -25)
CreditsLabel.Size = UDim2.new(1, -20, 0, 20)
CreditsLabel.Font = Enum.Font.Gotham
CreditsLabel.Text = "Revamped by jjs_dev | Illuminate Your Gameplay"
CreditsLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
CreditsLabel.TextSize = 10
CreditsLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Variables for features
local flying = false
local espEnabled = false
local killAuraEnabled = false
local autoShooting = false
local bodyVelocity = nil
local bodyAngularVelocity = nil

-- Fly Function (from original features)
local function toggleFly()
    flying = not flying
    FlyToggle.Text = "Fly: " .. (flying and "ON" or "OFF")
    FlyToggle.BackgroundColor3 = flying and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(50, 50, 50)
    
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
    else
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyAngularVelocity then bodyAngularVelocity:Destroy() end
    end
end

-- ESP Function (simplified from original)
local ESP = {}
local function createESP(player)
    if player == LocalPlayer then return end
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

local function toggleESP()
    espEnabled = not espEnabled
    ESPToggle.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
    ESPToggle.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(50, 50, 50)
    
    if espEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            createESP(player)
        end
        Players.PlayerAdded:Connect(createESP)
        LocalPlayer.CharacterAdded:Connect(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then createESP(player) end
            end
        end)
    else
        for player, esp in pairs(ESP) do
            if esp.billboard then esp.billboard:Destroy() end
        end
        ESP = {}
    end
end

-- MM2 Helpers (from original)
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

-- Auto Shoot (from original, simplified)
local function toggleAutoShoot()
    autoShooting = not autoShooting
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
    end
end

-- Kill Aura (from original)
local function toggleKillAura()
    killAuraEnabled = not killAuraEnabled
    KillAuraToggle.Text = "Kill Aura: " .. (killAuraEnabled and "ON" or "OFF")
    KillAuraToggle.BackgroundColor3 = killAuraEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(50, 50, 50)
    
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

-- Event Connections
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

FlyToggle.MouseButton1Click:Connect(toggleFly)
ESPToggle.MouseButton1Click:Connect(toggleESP)
AutoShootButton.MouseButton1Click:Connect(toggleAutoShoot)
KillAuraToggle.MouseButton1Click:Connect(toggleKillAura)
ShootMurdererButton.MouseButton1Click:Connect(shootMurderer)
FlingMurdererButton.MouseButton1Click:Connect(flingMurderer)

-- Initial notification
notify("Flashlight Hub", "Loaded! Triple-click to open if hidden.", 5)

-- Auto-open (simulate triple-click by making visible)
MainFrame.Visible = true

-- Animation on load
local openTween = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, -200, 0.5, -150)
})
openTween:Play()

print("Flashlight Hub loaded by jjs_dev!")
