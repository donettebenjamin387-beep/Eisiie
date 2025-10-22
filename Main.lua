-- Flashlight Hub v1.1
-- Revamped by jjs_dev
-- Improvements: Mini toggle button on drag/hold, visibility toggle, enhanced UI with gradients, animations, and modern styling.

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

-- Mini Toggle Button (for quick access without full menu)
local MiniButton = Instance.new("TextButton")
MiniButton.Name = "MiniToggle"
MiniButton.Parent = ScreenGui
MiniButton.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
MiniButton.BorderSizePixel = 0
MiniButton.Position = UDim2.new(0, 20, 0, 20)
MiniButton.Size = UDim2.new(0, 50, 0, 50)
MiniButton.Font = Enum.Font.GothamBold
MiniButton.Text = "💡"
MiniButton.TextColor3 = Color3.fromRGB(30, 30, 30)
MiniButton.TextSize = 20
MiniButton.Visible = true

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0, 25)  -- Circular button
MiniCorner.Parent = MiniButton

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color = Color3.fromRGB(255, 255, 255)
MiniStroke.Thickness = 1.5
MiniStroke.Parent = MiniButton

-- Hover animation for MiniButton
local function tweenMini(hover)
    local targetColor = hover and Color3.fromRGB(255, 220, 120) or Color3.fromRGB(255, 200, 100)
    local targetTextColor = hover and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 30)
    TweenService:Create(MiniButton, TweenInfo.new(0.2), {BackgroundColor3 = targetColor, TextColor3 = targetTextColor}):Play()
end

MiniButton.MouseEnter:Connect(function() tweenMini(true) end)
MiniButton.MouseLeave:Connect(function() tweenMini(false) end)

-- Main Menu Frame (initially hidden)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
MainFrame.Size = UDim2.new(0, 450, 0, 350)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false  -- Start hidden

-- Enhanced background gradient
local BackgroundGradient = Instance.new("UIGradient")
BackgroundGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
}
BackgroundGradient.Rotation = 45
BackgroundGradient.Parent = MainFrame

-- Corner rounding
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Enhanced stroke with gradient
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 200, 100)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

local StrokeGradient = Instance.new("UIGradient")
StrokeGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 180, 80))
}
StrokeGradient.Rotation = 90
StrokeGradient.Parent = UIStroke

-- Title Bar (enhanced)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 50)

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
}
TitleGradient.Rotation = 0
TitleGradient.Parent = TitleBar

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Parent = TitleBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(1, -80, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "💡 Flashlight Hub v1.1"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Position = UDim2.new(0, 15, 0, 0)

-- Visibility Toggle Button (new feature)
local VisibilityToggle = Instance.new("TextButton")
VisibilityToggle.Name = "VisibilityToggle"
VisibilityToggle.Parent = TitleBar
VisibilityToggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
VisibilityToggle.BorderSizePixel = 0
VisibilityToggle.Position = UDim2.new(1, -70, 0, 10)
VisibilityToggle.Size = UDim2.new(0, 30, 0, 30)
VisibilityToggle.Font = Enum.Font.Gotham
VisibilityToggle.Text = "👁"
VisibilityToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
VisibilityToggle.TextSize = 16

local VisCorner = Instance.new("UICorner")
VisCorner.CornerRadius = UDim.new(0, 15)
VisCorner.Parent = VisibilityToggle

local visVisible = true
local function toggleVisibility()
    visVisible = not visVisible
    VisibilityToggle.Text = visVisible and "👁" or "🙈"
    VisibilityToggle.BackgroundColor3 = visVisible and Color3.fromRGB(100, 100, 100) or Color3.fromRGB(200, 200, 200)
    MainFrame.Visible = visVisible
end
VisibilityToggle.MouseButton1Click:Connect(toggleVisibility)

-- Close Button (enhanced)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "Close"
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -35, 0, 10)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 15)
CloseCorner.Parent = CloseButton

-- Hover for Close
local function tweenClose(hover)
    local targetColor = hover and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(255, 50, 50)
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
end
CloseButton.MouseEnter:Connect(function() tweenClose(true) end)
CloseButton.MouseLeave:Connect(function() tweenClose(false) end)

-- Content ScrollingFrame (enhanced)
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "Content"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.Position = UDim2.new(0, 0, 0, 50)
ContentFrame.Size = UDim2.new(1, 0, 1, -50)
ContentFrame.ScrollBarThickness = 8
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 200, 100)
ContentFrame.ScrollBarImageTransparency = 0.5

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Parent = ContentFrame
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.FillDirection = Enum.FillDirection.Vertical
ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Universal Section (enhanced with icons)
local UniversalSection = Instance.new("Frame")
UniversalSection.Name = "Universal"
UniversalSection.Parent = ContentFrame
UniversalSection.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
UniversalSection.BorderSizePixel = 0
UniversalSection.Size = UDim2.new(1, -20, 0, 140)

local UniGradient = Instance.new("UIGradient")
UniGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 55, 55)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
}
UniGradient.Rotation = 90
UniGradient.Parent = UniversalSection

local UniCorner = Instance.new("UICorner")
UniCorner.CornerRadius = UDim.new(0, 8)
UniCorner.Parent = UniversalSection

local UniTitle = Instance.new("TextLabel")
UniTitle.Parent = UniversalSection
UniTitle.BackgroundTransparency = 1
UniTitle.Size = UDim2.new(1, 0, 0, 35)
UniTitle.Font = Enum.Font.GothamBold
UniTitle.Text = "🌐 Universal Features"
UniTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
UniTitle.TextSize = 15
UniTitle.TextXAlignment = Enum.TextXAlignment.Left
UniTitle.Position = UDim2.new(0, 15, 0, 5)

-- Fly Toggle (enhanced)
local FlyToggle = Instance.new("TextButton")
FlyToggle.Name = "Fly"
FlyToggle.Parent = UniversalSection
FlyToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
FlyToggle.BorderSizePixel = 0
FlyToggle.Position = UDim2.new(0, 15, 0, 45)
FlyToggle.Size = UDim2.new(1, -30, 0, 35)
FlyToggle.Font = Enum.Font.GothamSemibold
FlyToggle.Text = "✈ Fly: OFF"
FlyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyToggle.TextSize = 13

local FlyGradient = Instance.new("UIGradient")
FlyGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 70, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
}
FlyGradient.Parent = FlyToggle

local FlyCorner = Instance.new("UICorner")
FlyCorner.CornerRadius = UDim.new(0, 6)
FlyCorner.Parent = FlyToggle

-- ESP Toggle (enhanced)
local ESPToggle = Instance.new("TextButton")
ESPToggle.Name = "ESP"
ESPToggle.Parent = UniversalSection
ESPToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ESPToggle.BorderSizePixel = 0
ESPToggle.Position = UDim2.new(0, 15, 0, 85)
ESPToggle.Size = UDim2.new(1, -30, 0, 35)
ESPToggle.Font = Enum.Font.GothamSemibold
ESPToggle.Text = "👁 ESP: OFF"
ESPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPToggle.TextSize = 13

local ESPGradient = Instance.new("UIGradient")
ESPGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 70, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
}
ESPGradient.Parent = ESPToggle

local ESPCorner = Instance.new("UICorner")
ESPCorner.CornerRadius = UDim.new(0, 6)
ESPCorner.Parent = ESPToggle

-- MM2 Section (enhanced)
local MM2Section = Instance.new("Frame")
MM2Section.Name = "MM2"
MM2Section.Parent = ContentFrame
MM2Section.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MM2Section.BorderSizePixel = 0
MM2Section.Size = UDim2.new(1, -20, 0, 220)

local MM2Gradient = Instance.new("UIGradient")
MM2Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 55, 55)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
}
MM2Gradient.Rotation = 90
MM2Gradient.Parent = MM2Section

local MM2Corner = Instance.new("UICorner")
MM2Corner.CornerRadius = UDim.new(0, 8)
MM2Corner.Parent = MM2Section

local MM2Title = Instance.new("TextLabel")
MM2Title.Parent = MM2Section
MM2Title.BackgroundTransparency = 1
MM2Title.Size = UDim2.new(1, 0, 0, 35)
MM2Title.Font = Enum.Font.GothamBold
MM2Title.Text = "🔪 Murder Mystery 2 Features"
MM2Title.TextColor3 = Color3.fromRGB(255, 255, 255)
MM2Title.TextSize = 15
MM2Title.TextXAlignment = Enum.TextXAlignment.Left
MM2Title.Position = UDim2.new(0, 15, 0, 5)

-- Auto Shoot Button (enhanced)
local AutoShootButton = Instance.new("TextButton")
AutoShootButton.Name = "AutoShoot"
AutoShootButton.Parent = MM2Section
AutoShootButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AutoShootButton.BorderSizePixel = 0
AutoShootButton.Position = UDim2.new(0, 15, 0, 45)
AutoShootButton.Size = UDim2.new(1, -30, 0, 35)
AutoShootButton.Font = Enum.Font.GothamSemibold
AutoShootButton.Text = "🎯 Auto Shoot: OFF"
AutoShootButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoShootButton.TextSize = 13

local AutoShootGradient = Instance.new("UIGradient")
AutoShootGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 70, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
}
AutoShootGradient.Parent = AutoShootButton

local AutoShootCorner = Instance.new("UICorner")
AutoShootCorner.CornerRadius = UDim.new(0, 6)
AutoShootCorner.Parent = AutoShootButton

-- Kill Aura Toggle (enhanced)
local KillAuraToggle = Instance.new("TextButton")
KillAuraToggle.Name = "KillAura"
KillAuraToggle.Parent = MM2Section
KillAuraToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
KillAuraToggle.BorderSizePixel = 0
KillAuraToggle.Position = UDim2.new(0, 15, 0, 85)
KillAuraToggle.Size = UDim2.new(1, -30, 0, 35)
KillAuraToggle.Font = Enum.Font.GothamSemibold
KillAuraToggle.Text = "⚔ Kill Aura: OFF"
KillAuraToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
KillAuraToggle.TextSize = 13

local KillAuraGradient = Instance.new("UIGradient")
KillAuraGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 70, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
}
KillAuraGradient.Parent = KillAuraToggle

local KillAuraCorner = Instance.new("UICorner")
KillAuraCorner.CornerRadius = UDim.new(0, 6)
KillAuraCorner.Parent = KillAuraToggle

-- Shoot Murderer Button (enhanced)
local ShootMurdererButton = Instance.new("TextButton")
ShootMurdererButton.Name = "ShootMurderer"
ShootMurdererButton.Parent = MM2Section
ShootMurdererButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ShootMurdererButton.BorderSizePixel = 0
ShootMurdererButton.Position = UDim2.new(0, 15, 0, 125)
ShootMurdererButton.Size = UDim2.new(1, -30, 0, 35)
ShootMurdererButton.Font = Enum.Font.GothamSemibold
ShootMurdererButton.Text = "🔫 Shoot Murderer"
ShootMurdererButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ShootMurdererButton.TextSize = 13

local ShootMurdererGradient = Instance.new("UIGradient")
ShootMurdererGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 70, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
}
ShootMurdererGradient.Parent = ShootMurdererButton

local ShootMurdererCorner = Instance.new("UICorner")
ShootMurdererCorner.CornerRadius = UDim.new(0, 6)
ShootMurdererCorner.Parent = ShootMurdererButton

-- Fling Murderer Button (enhanced)
local FlingMurdererButton = Instance.new("TextButton")
FlingMurdererButton.Name = "FlingMurderer"
FlingMurdererButton.Parent = MM2Section
FlingMurdererButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
FlingMurdererButton.BorderSizePixel = 0
FlingMurdererButton.Position = UDim2.new(0, 15, 0, 165)
FlingMurdererButton.Size = UDim2.new(1, -30, 0, 35)
FlingMurdererButton.Font = Enum.Font.GothamSemibold
FlingMurdererButton.Text = "💥 Fling Murderer"
FlingMurdererButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlingMurdererButton.TextSize = 13

local FlingMurdererGradient = Instance.new("UIGradient")
FlingMurdererGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 70, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
}
FlingMurdererGradient.Parent = FlingMurdererButton

local FlingMurdererCorner = Instance.new("UICorner")
FlingMurdererCorner.CornerRadius = UDim.new(0, 6)
FlingMurdererCorner.Parent = FlingMurdererButton

-- Credits Label (enhanced)
local CreditsLabel = Instance.new("TextLabel")
CreditsLabel.Parent = MainFrame
CreditsLabel.BackgroundTransparency = 1
CreditsLabel.Position = UDim2.new(0, 15, 1, -30)
CreditsLabel.Size = UDim2.new(1, -30, 0, 25)
CreditsLabel.Font = Enum.Font.Gotham
CreditsLabel.Text = "✨ Revamped by jjs_dev | Illuminate Your Gameplay ✨"
CreditsLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
CreditsLabel.TextSize = 12
CreditsLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Variables for features
local flying = false
local espEnabled = false
local killAuraEnabled = false
local autoShooting = false
local bodyVelocity = nil
local bodyAngularVelocity = nil

-- Drag detection for MiniButton show/hide logic
local dragging = false
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)

MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Show MiniButton when dragging (point 1: mini button on hold/drag)
RunService.Heartbeat:Connect(function()
    if dragging and MiniButton.Visible then
        MiniButton.Visible = false  -- Hide mini when full menu is open and dragging
    end
end)

-- Fly Function (unchanged, but add animation feedback)
local function toggleFly()
    flying = not flying
    FlyToggle.Text = "✈ Fly: " .. (flying and "ON" or "OFF")
    local targetColor = flying and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(60, 60, 60)
    TweenService:Create(FlyToggle, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = targetColor}):Play()
    
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
                
                local inputBeganConn = UserInputService.InputBegan:Connect(function(input)
                    if input.KeyCode == Enum.KeyCode.W then keys.W = true end
                    if input.KeyCode == Enum.KeyCode.S then keys.S = true end
                    if input.KeyCode == Enum.KeyCode.A then keys.A = true end
                    if input.KeyCode == Enum.KeyCode.D then keys.D = true end
                end)
                
                local inputEndedConn = UserInputService.InputEnded:Connect(function(input)
                    if input.KeyCode == Enum.KeyCode.W then keys.W = false end
                    if input.KeyCode == Enum.KeyCode.S then keys.S = false end
                    if input.KeyCode == Enum.KeyCode.A then keys.A = false end
                    if input.KeyCode == Enum.KeyCode.D then keys.D = false end
                end)
                
                local heartbeatConn = RunService.Heartbeat:Connect(function()
                    if not flying then 
                        inputBeganConn:Disconnect()
                        inputEndedConn:Disconnect()
                        heartbeatConn:Disconnect()
                        return 
                    end
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

-- ESP Function (unchanged)
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
    ESPToggle.Text = "👁 ESP: " .. (espEnabled and "ON" or "OFF")
    local targetColor = espEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(60, 60, 60)
    TweenService:Create(ESPToggle, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = targetColor}):Play()
    
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
        notify("Flashlight Hub", "ESP enabled.")
    else
        for player, esp in pairs(ESP) do
            if esp.billboard then esp.billboard:Destroy() end
        end
        ESP = {}
        notify("Flashlight Hub", "ESP disabled.")
    end
end

-- MM2 Helpers (unchanged)
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

-- Auto Shoot (enhanced with toggle animation)
local function toggleAutoShoot()
    autoShooting = not autoShooting
    AutoShootButton.Text = "🎯 Auto Shoot: " .. (autoShooting and "ON" or "OFF")
    local targetColor = autoShooting and Color3.fromRGB(255, 100, 0) or Color3.fromRGB(60, 60, 60)
    TweenService:Create(AutoShootButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = targetColor}):Play()
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

-- Kill Aura (enhanced)
local function toggleKillAura()
    killAuraEnabled = not killAuraEnabled
    KillAuraToggle.Text = "⚔ Kill Aura: " .. (killAuraEnabled and "ON" or "OFF")
    local targetColor = killAuraEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(60, 60, 60)
    TweenService:Create(KillAuraToggle, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = targetColor}):Play()
    
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

-- Shoot Murderer (enhanced with animation)
local function shootMurderer()
    if findSheriff() ~= LocalPlayer then
        notify("Flashlight Hub", "You must be Sheriff!")
        TweenService:Create(ShootMurdererButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 0, 0)}):Play()
        wait(0.5)
        TweenService:Create(ShootMurdererButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
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
            TweenService:Create(ShootMurdererButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 255, 0)}):Play()
            wait(0.3)
            TweenService:Create(ShootMurdererButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
        end
    end
end

-- Fling Murderer (enhanced)
local function flingMurderer()
    local murderer = findMurderer()
    if not murderer then
        notify("Flashlight Hub", "No murderer found!")
        return
    end
    miniFling(murderer)
    notify("Flashlight Hub", "Murderer flung!")
    TweenService:Create(FlingMurdererButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}):Play()
    wait(0.3)
    TweenService:Create(FlingMurdererButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
end

-- Event Connections
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniButton.Visible = true  -- Show mini on close
    ScreenGui:Destroy()  -- Or just hide if preferred
end)

FlyToggle.MouseButton1Click:Connect(toggleFly)
ESPToggle.MouseButton1Click:Connect(toggleESP)
AutoShootButton.MouseButton1Click:Connect(toggleAutoShoot)
KillAuraToggle.MouseButton1Click:Connect(toggleKillAura)
ShootMurdererButton.MouseButton1Click:Connect(shootMurderer)
FlingMurdererButton.MouseButton1Click:Connect(flingMurderer)

-- MiniButton toggle (point 1 & 2: quick access)
MiniButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    MiniButton.Visible = not MainFrame.Visible
    if MainFrame.Visible then
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -225, 0.5, -175),
            Size = UDim2.new(0, 450, 0, 350)
        }):Play()
    end
end)

-- Initial notification
notify("Flashlight Hub", "Loaded! Click the mini lightbulb to open.", 5)

-- Auto-open mini only
MiniButton.Visible = true
MainFrame.Visible = false

print("Flashlight Hub v1.1 loaded by jjs_dev!")
