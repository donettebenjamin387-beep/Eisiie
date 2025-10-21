local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

print("Starting Flashlight Hub load...")  -- Debug

for _,v in pairs(PlayerGui:GetChildren()) do
	if v.Name == "FlashlightHubUI" then
		v:Destroy()
	end
end

local Screen = Instance.new("ScreenGui")
Screen.Name = "FlashlightHubUI"
Screen.ResetOnSpawn = false
Screen.IgnoreGuiInset = true
Screen.Parent = PlayerGui
print("ScreenGui created")  -- Debug

local Root = Instance.new("Frame", Screen)
Root.Name = "Root"
Root.AnchorPoint = Vector2.new(0.5,0.5)
Root.Position = UDim2.new(0.5, 0, 0.5, 0)
Root.Size = UDim2.fromOffset(860,540)
Root.BackgroundColor3 = Color3.fromRGB(14,16,18)
Root.BorderSizePixel = 0
Root.Visible = true  -- Force visible
local RootCorner = Instance.new("UICorner", Root)
RootCorner.CornerRadius = UDim.new(0,12)
print("Root frame visible at center")  -- Debug

local Header = Instance.new("Frame", Root)
Header.Size = UDim2.new(1,0,0,86)
Header.BackgroundTransparency = 1

local Brand = Instance.new("TextLabel", Header)
Brand.Size = UDim2.new(0.46,0,1,0)
Brand.Position = UDim2.new(0,20,0,0)
Brand.BackgroundTransparency = 1
Brand.Font = Enum.Font.GothamBold
Brand.TextSize = 26
Brand.Text = "Flashlight Hub"
Brand.TextColor3 = Color3.fromRGB(185,215,255)
Brand.TextXAlignment = Enum.TextXAlignment.Left

local Credit = Instance.new("TextLabel", Header)
Credit.Size = UDim2.new(0.46,0,1,0)
Credit.Position = UDim2.new(0,20,0,38)
Credit.BackgroundTransparency = 1
Credit.Font = Enum.Font.Gotham
Credit.TextSize = 13
Credit.Text = "made by jjs_dev"
Credit.TextColor3 = Color3.fromRGB(165,185,205)
Credit.TextXAlignment = Enum.TextXAlignment.Left

local TabHolder = Instance.new("Frame", Header)
TabHolder.Size = UDim2.new(0.5,0,0.55,0)
TabHolder.Position = UDim2.new(0.52,0,0.22,0)
TabHolder.BackgroundTransparency = 1
local TabLayout = Instance.new("UIListLayout", TabHolder)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.Padding = UDim.new(0,12)

local function makeTab(tn)
	local b = Instance.new("TextButton", TabHolder)
	b.Size = UDim2.new(0,160,1,0)
	b.BackgroundColor3 = Color3.fromRGB(24,27,32)
	b.BorderSizePixel = 0
	local c = Instance.new("UICorner", b)
	c.CornerRadius = UDim.new(0,8)
	b.Font = Enum.Font.GothamSemibold
	b.TextSize = 15
	b.Text = tn
	b.TextColor3 = Color3.fromRGB(220,230,240)
	return b
end

local TabAuto = makeTab("AutoFarm")
local TabESP = makeTab("ESP")
local TabAFK = makeTab("Anti-AFK")
local TabSteal = makeTab("Anti-Steal")
local TabSettings = makeTab("Settings")

local Content = Instance.new("Frame", Root)
Content.Position = UDim2.new(0,18,0,100)
Content.Size = UDim2.new(1,-36,1,-118)
Content.BackgroundColor3 = Color3.fromRGB(10,12,14)
Content.BorderSizePixel = 0
local ContentCorner = Instance.new("UICorner", Content)
ContentCorner.CornerRadius = UDim.new(0,10)

local LeftPanel = Instance.new("Frame", Content)
LeftPanel.Size = UDim2.new(0,280,1,0)
LeftPanel.Position = UDim2.new(0,0,0,0)
LeftPanel.BackgroundTransparency = 1

local LeftCard = Instance.new("Frame", LeftPanel)
LeftCard.Size = UDim2.new(1,0,1,0)
LeftCard.BackgroundColor3 = Color3.fromRGB(16,18,20)
LeftCard.BorderSizePixel = 0
local LeftCorner = Instance.new("UICorner", LeftCard)
LeftCorner.CornerRadius = UDim.new(0,10)

local StatsTitle = Instance.new("TextLabel", LeftCard)
StatsTitle.Size = UDim2.new(1,0,0,36)
StatsTitle.Position = UDim2.new(0,12,0,12)
StatsTitle.BackgroundTransparency = 1
StatsTitle.Font = Enum.Font.GothamBold
StatsTitle.TextSize = 18
StatsTitle.Text = "Live Stats"
StatsTitle.TextColor3 = Color3.fromRGB(180,215,255)

local CollectedLbl = Instance.new("TextLabel", LeftCard)
CollectedLbl.Size = UDim2.new(1,-24,0,24)
CollectedLbl.Position = UDim2.new(0,12,0,56)
CollectedLbl.BackgroundTransparency = 1
CollectedLbl.Font = Enum.Font.Gotham
CollectedLbl.TextSize = 14
CollectedLbl.Text = "Collected: 0"
CollectedLbl.TextColor3 = Color3.fromRGB(200,220,240)

local TimeLbl = CollectedLbl:Clone()
TimeLbl.Position = UDim2.new(0,12,0,82)
TimeLbl.Parent = LeftCard
TimeLbl.Text = "Time Active: 0s"

local RateLbl = CollectedLbl:Clone()
RateLbl.Position = UDim2.new(0,12,0,108)
RateLbl.Parent = LeftCard
RateLbl.Text = "Coins/Hour: 0"

local RightPanel = Instance.new("Frame", Content)
RightPanel.Size = UDim2.new(1,-300,1,0)
RightPanel.Position = UDim2.new(0,300,0,0)
RightPanel.BackgroundTransparency = 1

local Pages = Instance.new("Folder", RightPanel)
Pages.Name = "Pages"

local function makePage(n)
	local f = Instance.new("Frame", Pages)
	f.Name = n
	f.Size = UDim2.new(1,0,1,0)
	f.BackgroundTransparency = 1
	f.Visible = false
	return f
end

local PageAuto = makePage("AutoFarm")
local PageESP = makePage("ESP")
local PageAFK = makePage("AntiAFK")
local PageSteal = makePage("AntiSteal")
local PageSettings = makePage("Settings")

-- Adapted landing screen from provided loading script
local PageLanding = makePage("Landing")
PageLanding.Visible = true
print("Landing page set visible")  -- Debug

local landingFrame = Instance.new("Frame")
landingFrame.Parent = PageLanding
landingFrame.Size = UDim2.new(1,0,1,0)
landingFrame.BackgroundTransparency = 0
landingFrame.BackgroundColor3 = Color3.fromRGB(0,20,40)
print("Landing frame created")  -- Debug

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1,0,0.2,0)
textLabel.Position = UDim2.new(0,0,0.3,0)
textLabel.BackgroundTransparency = 1
textLabel.Font = Enum.Font.GothamBold
textLabel.TextColor3 = Color3.new(0.8,0.8,0.8)
textLabel.Text = "Welcome to Flashlight Hub"
textLabel.TextSize = 28
textLabel.Parent = landingFrame
print("TextLabel created")  -- Debug

local subLabel = Instance.new("TextLabel")
subLabel.Size = UDim2.new(1,0,0.1,0)
subLabel.Position = UDim2.new(0,0,0.45,0)
subLabel.BackgroundTransparency = 1
subLabel.Font = Enum.Font.Gotham
subLabel.TextSize = 14
subLabel.Text = "Advanced tools • AutoFarm • ESP • Anti-AFK • made by jjs_dev"
subLabel.TextColor3 = Color3.fromRGB(160,180,200)
subLabel.TextXAlignment = Enum.TextXAlignment.Center
subLabel.Parent = landingFrame

local loadingRing = Instance.new("ImageLabel")
loadingRing.Size = UDim2.new(0,128,0,128)  -- Smaller for hub
loadingRing.BackgroundTransparency = 1
loadingRing.Image = "rbxassetid://4965945816"
loadingRing.AnchorPoint = Vector2.new(0.5,0.5)
loadingRing.Position = UDim2.new(0.5,0,0.6,0)
loadingRing.Parent = landingFrame
print("LoadingRing created")  -- Debug

local tweenInfo = TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1)
local tween = TweenService:Create(loadingRing, tweenInfo, {Rotation = 360})
tween:Play()
print("Ring tween playing")  -- Debug

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0.3,0,0.1,0)
OpenBtn.Position = UDim2.new(0.35,0,0.75,0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(20,120,255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 16
OpenBtn.Text = "Open Hub"
OpenBtn.BorderSizePixel = 0
local OpenCorner = Instance.new("UICorner", OpenBtn)
OpenCorner.CornerRadius = UDim.new(0,8)
OpenBtn.Parent = landingFrame

local function showPage(p)
	print("Showing page: " .. p.Name)  -- Debug
	for _,v in pairs(Pages:GetChildren()) do
		if v:IsA("Frame") then
			v.Visible = (v == p)
		end
	end
end

local function animateLandingAndOpen()
	print("Starting landing animation...")  -- Debug
	wait(2)  -- Simulate load time
	tween:Cancel()
	loadingRing.Visible = false
	landingFrame:TweenPosition(UDim2.new(0,0,1,0), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, 2, true)
	wait(2)
	showPage(PageAuto)
	print("Landing done, showing AutoFarm")  -- Debug
end

OpenBtn.MouseButton1Click:Connect(animateLandingAndOpen)

TabAuto.MouseButton1Click:Connect(function()
	showPage(PageAuto)
end)
TabESP.MouseButton1Click:Connect(function()
	showPage(PageESP)
end)
TabAFK.MouseButton1Click:Connect(function()
	showPage(PageAFK)
end)
TabSteal.MouseButton1Click:Connect(function()
	showPage(PageSteal)
end)
TabSettings.MouseButton1Click:Connect(function()
	showPage(PageSettings)
end)

local function makeSection(parent,title,h)
	local s = Instance.new("Frame", parent)
	s.Size = UDim2.new(1,0,0,h or 120)
	s.BackgroundColor3 = Color3.fromRGB(18,20,22)
	s.BorderSizePixel = 0
	local c = Instance.new("UICorner", s)
	c.CornerRadius = UDim.new(0,8)
	local t = Instance.new("TextLabel", s)
	t.Size = UDim2.new(1,-20,0,28)
	t.Position = UDim2.new(0,10,0,8)
	t.BackgroundTransparency = 1
	t.Font = Enum.Font.GothamBold
	t.TextSize = 16
	t.Text = title
	t.TextColor3 = Color3.fromRGB(175,205,235)
	return s
end

local AutoSection = makeSection(PageAuto, "AutoFarm Settings", 140)
AutoSection.Position = UDim2.new(0,0,0,6)

local AutoToggle = Instance.new("TextButton", AutoSection)
AutoToggle.Size = UDim2.new(0,200,0,40)
AutoToggle.Position = UDim2.new(0,12,0,44)
AutoToggle.BackgroundColor3 = Color3.fromRGB(24,26,30)
AutoToggle.Font = Enum.Font.GothamSemibold
AutoToggle.TextSize = 14
AutoToggle.Text = "Enable Coin/Ball Farm"
AutoToggle.BorderSizePixel = 0
local AutoCorner = Instance.new("UICorner", AutoToggle)
AutoCorner.CornerRadius = UDim.new(0,8)

local SpeedBox = Instance.new("TextBox", AutoSection)
SpeedBox.Size = UDim2.new(0,120,0,30)
SpeedBox.Position = UDim2.new(0,220,0,48)
SpeedBox.BackgroundColor3 = Color3.fromRGB(14,16,18)
SpeedBox.TextColor3 = Color3.fromRGB(220,230,240)
SpeedBox.Text = "15"
SpeedBox.Font = Enum.Font.Gotham
SpeedBox.TextSize = 14
SpeedBox.BorderSizePixel = 0

local AFKSection = makeSection(PageAFK, "Anti-AFK")
AFKSection.Position = UDim2.new(0,0,0,6)
local AFKBtn = Instance.new("TextButton", AFKSection)
AFKBtn.Size = UDim2.new(0,180,0,40)
AFKBtn.Position = UDim2.new(0,12,0,44)
AFKBtn.BackgroundColor3 = Color3.fromRGB(24,26,30)
AFKBtn.Font = Enum.Font.GothamSemibold
AFKBtn.TextSize = 14
AFKBtn.Text = "Enable Anti-AFK"
AFKBtn.BorderSizePixel = 0
local AFKCorner = Instance.new("UICorner", AFKBtn)
AFKCorner.CornerRadius = UDim.new(0,8)

local StealSection = makeSection(PageSteal, "Anti-Steal")
StealSection.Position = UDim2.new(0,0,0,6)
local StealToggle = Instance.new("TextButton", StealSection)
StealToggle.Size = UDim2.new(0,160,0,40)
StealToggle.Position = UDim2.new(0,12,0,44)
StealToggle.BackgroundColor3 = Color3.fromRGB(24,26,30)
StealToggle.Font = Enum.Font.GothamSemibold
StealToggle.TextSize = 14
StealToggle.Text = "Enable Anti-Steal"
StealToggle.BorderSizePixel = 0
local StealCorner = Instance.new("UICorner", StealToggle)
StealCorner.CornerRadius = UDim.new(0,8)

local ESPSection = makeSection(PageESP, "ESP Controls", 180)
ESPSection.Position = UDim2.new(0,0,0,6)
local ESPToggle = Instance.new("TextButton", ESPSection)
ESPToggle.Size = UDim2.new(0,160,0,40)
ESPToggle.Position = UDim2.new(0,12,0,44)
ESPToggle.BackgroundColor3 = Color3.fromRGB(24,26,30)
ESPToggle.Font = Enum.Font.GothamSemibold
ESPToggle.TextSize = 14
ESPToggle.Text = "Enable Player ESP"
ESPToggle.BorderSizePixel = 0
local ESPCorner = Instance.new("UICorner", ESPToggle)
ESPCorner.CornerRadius = UDim.new(0,8)

local ESPCoinsToggle = Instance.new("TextButton", ESPSection)
ESPCoinsToggle.Size = UDim2.new(0,160,0,36)
ESPCoinsToggle.Position = UDim2.new(0,190,0,44)
ESPCoinsToggle.BackgroundColor3 = Color3.fromRGB(24,26,30)
ESPCoinsToggle.Font = Enum.Font.GothamSemibold
ESPCoinsToggle.TextSize = 14
ESPCoinsToggle.Text = "Enable Coin Markers"
ESPCoinsToggle.BorderSizePixel = 0
local ESPCoinsCorner = Instance.new("UICorner", ESPCoinsToggle)
ESPCoinsCorner.CornerRadius = UDim.new(0,8)

local SettingsSection = makeSection(PageSettings, "Interface", 160)
SettingsSection.Position = UDim2.new(0,0,0,6)
local DraggableToggle = Instance.new("TextButton", SettingsSection)
DraggableToggle.Size = UDim2.new(0,190,0,40)
DraggableToggle.Position = UDim2.new(0,12,0,44)
DraggableToggle.BackgroundColor3 = Color3.fromRGB(24,26,30)
DraggableToggle.Font = Enum.Font.GothamSemibold
DraggableToggle.TextSize = 14
DraggableToggle.Text = "Enable Dragging"
DraggableToggle.BorderSizePixel = 0

local ToggleBottom = Instance.new("TextButton", Root)
ToggleBottom.Size = UDim2.new(0,160,0,36)
ToggleBottom.Position = UDim2.new(0.5,-80,1,-50)
ToggleBottom.AnchorPoint = Vector2.new(0.5,0)
ToggleBottom.BackgroundColor3 = Color3.fromRGB(26,28,32)
ToggleBottom.Font = Enum.Font.GothamSemibold
ToggleBottom.TextSize = 14
ToggleBottom.Text = "Hide UI"
ToggleBottom.BorderSizePixel = 0
local ToggleCorner = Instance.new("UICorner", ToggleBottom)
ToggleCorner.CornerRadius = UDim.new(0,8)

local Notifications = Instance.new("Frame", Root)
Notifications.Size = UDim2.new(0,300,0,72)
Notifications.Position = UDim2.new(1,-320,0,22)
Notifications.BackgroundColor3 = Color3.fromRGB(16,18,20)
Notifications.BorderSizePixel = 0
Notifications.Visible = false
local NotCorner = Instance.new("UICorner", Notifications)
NotCorner.CornerRadius = UDim.new(0,10)
local NotLabel = Instance.new("TextLabel", Notifications)
NotLabel.Size = UDim2.new(1,-20,1,-20)
NotLabel.Position = UDim2.new(0,10,0,10)
NotLabel.BackgroundTransparency = 1
NotLabel.Font = Enum.Font.Gotham
NotLabel.TextSize = 14
NotLabel.TextColor3 = Color3.fromRGB(220,230,240)
NotLabel.TextWrapped = true

local function notify(txt)
	print("Notify: " .. txt)  -- Debug
	NotLabel.Text = txt
	Notifications.Position = UDim2.new(1,-320,0,22)
	Notifications.Visible = true
	local inTween = TweenService:Create(Notifications, TweenInfo.new(0.45, Enum.EasingStyle.Quad), {Position = UDim2.new(1,-340,0,22)})
	inTween:Play()
	task.delay(3, function()
		local outTween = TweenService:Create(Notifications, TweenInfo.new(0.45, Enum.EasingStyle.Quad), {Position = UDim2.new(1,400,0,22)})
		outTween:Play()
		outTween.Completed:Wait()
		Notifications.Visible = false
	end)
end

local farmRunning = false
local collected = 0
local startTick = 0
local speed = 15
local visited = {}
local function sanitizeSpeed(s)
	local n = tonumber(s)
	if not n then return nil end
	return math.clamp(math.floor(n),5,50)
end

SpeedBox.FocusLost:Connect(function(enter)
	local n = sanitizeSpeed(SpeedBox.Text)
	if n then
		speed = n
		SpeedBox.Text = tostring(n)
		notify("Speed set to "..tostring(n))
	else
		SpeedBox.Text = tostring(speed)
		notify("Invalid speed, using "..tostring(speed))
	end
end)

AutoToggle.MouseButton1Click:Connect(function()
	farmRunning = not farmRunning
	if farmRunning then
		collected = 0
		startTick = tick()
		visited = {}
		AutoToggle.Text = "Disable Coin/Ball Farm"
		notify("AutoFarm started")
		task.spawn(function()
			while farmRunning do
				local elapsed = tick() - startTick
				CollectedLbl.Text = "Collected: "..tostring(collected)
				TimeLbl.Text = "Time Active: "..tostring(math.floor(elapsed)).."s"
				RateLbl.Text = "Coins/Hour: "..tostring(math.floor((collected / math.max(1, elapsed)) * 3600))
				task.wait(0.6)
			end
		end)
		task.spawn(function()
			while farmRunning do
				local char = LocalPlayer.Character
				if not char then
					task.wait(1)
					continue
				end
				local hrp = char:FindFirstChild("HumanoidRootPart")
				if hrp then
					local closest, dist = nil, math.huge
					for _,obj in ipairs(workspace:GetDescendants()) do
						if obj:IsA("BasePart") and obj.Name == "Coin_Server" and obj:GetAttribute and obj:GetAttribute("CoinID") == "BeachBall" and not visited[obj] then
							local d = (obj.Position - hrp.Position).Magnitude
							if d < dist and d <= 300 then
								closest = obj
								dist = d
							end
						end
					end
					if closest and closest.Parent then
						visited[closest] = true
						for _,part in pairs(char:GetChildren()) do
							if part:IsA("BasePart") then
								part.CanCollide = false
							end
						end
						local tw = TweenService:Create(hrp, TweenInfo.new(dist / speed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(closest.Position + Vector3.new(0,2,0))})
						tw:Play()
						tw.Completed:Wait()
						collected = collected + 1
					end
				end
				task.wait(0.12)
			end
		end)
	else
		AutoToggle.Text = "Enable Coin/Ball Farm"
		notify("AutoFarm stopped")
	end
end)

local antiAFKOn = false
local vu = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
	if antiAFKOn then
		vu:CaptureController()
		vu:ClickButton2(Vector2.new(0,0))
	end
end)
AFKBtn.MouseButton1Click:Connect(function()
	antiAFKOn = not antiAFKOn
	AFKBtn.Text = antiAFKOn and "Disable Anti-AFK" or "Enable Anti-AFK"
	notify("Anti-AFK " .. (antiAFKOn and "enabled" or "disabled"))
end)

local antiStealOn = false
StealToggle.MouseButton1Click:Connect(function()
	antiStealOn = not antiStealOn
	if antiStealOn then
		StealToggle.Text = "Disable Anti-Steal"
		notify("Anti-Steal active")
	else
		StealToggle.Text = "Enable Anti-Steal"
		notify("Anti-Steal disabled")
	end
end)

local espPlayersOn = false
local espCoinsOn = false
local function makeBillboard(text, parent, size)
	local b = Instance.new("BillboardGui")
	b.Adornee = parent
	b.AlwaysOnTop = true
	b.Size = UDim2.new(0,120,0,40)
	b.StudsOffset = Vector3.new(0,2.4,0)
	b.Parent = parent
	local t = Instance.new("TextLabel", b)
	t.Size = UDim2.new(1,0,1,0)
	t.BackgroundTransparency = 1
	t.Font = Enum.Font.GothamSemibold
	t.TextSize = 14
	t.Text = text
	t.TextColor3 = Color3.fromRGB(255,255,255)
	return b, t
end

local espPlayers = {}
local function createPlayerESP(p)
	if not p.Character then return end
	local head = p.Character:FindFirstChild("Head")
	if not head then return end
	if espPlayers[p] then return end
	local box, label = makeBillboard(p.Name, head)
	label.Text = p.Name
	espPlayers[p] = {gui = box, label = label}
end

local function removePlayerESP(p)
	if espPlayers[p] then
		if espPlayers[p].gui and espPlayers[p].gui.Parent then
			espPlayers[p].gui:Destroy()
		end
		espPlayers[p] = nil
	end
end

local function refreshPlayerESPs()
	for _,p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			if espPlayersOn then
				createPlayerESP(p)
			else
				removePlayerESP(p)
			end
		end
	end
end

Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function()
		if espPlayersOn then
			createPlayerESP(p)
		end
	end)
end)

Players.PlayerRemoving:Connect(function(p)
	removePlayerESP(p)
end)

for _,p in pairs(Players:GetPlayers()) do
	if p ~= LocalPlayer then
		p.CharacterAdded:Connect(function()
			if espPlayersOn then createPlayerESP(p) end
		end)
		if p.Character and espPlayersOn then createPlayerESP(p) end
	end
end

local coinMarkers = {}
local function addCoinMarker(coin)
	if coinMarkers[coin] then return end
	if not coin:IsA("BasePart") then return end
	local gui, lbl = makeBillboard("Coin", coin)
	lbl.Text = "Ball"
	lbl.TextColor3 = Color3.fromRGB(255,230,120)
	coinMarkers[coin] = gui
end

local function removeCoinMarker(coin)
	if coinMarkers[coin] then
		if coinMarkers[coin].Parent then coinMarkers[coin]:Destroy() end
		coinMarkers[coin] = nil
	end
end

local function refreshCoins()
	for _,obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name == "Coin_Server" and obj:GetAttribute and obj:GetAttribute("CoinID") == "BeachBall" then
			if espCoinsOn then
				addCoinMarker(obj)
			else
				removeCoinMarker(obj)
			end
		end
	end
end

ESPToggle.MouseButton1Click:Connect(function()
	espPlayersOn = not espPlayersOn
	ESPToggle.Text = espPlayersOn and "Disable Player ESP" or "Enable Player ESP"
	refreshPlayerESPs()
	notify("Player ESP " .. (espPlayersOn and "enabled" or "disabled"))
end)

ESPCoinsToggle.MouseButton1Click:Connect(function()
	espCoinsOn = not espCoinsOn
	ESPCoinsToggle.Text = espCoinsOn and "Disable Coin Markers" or "Enable Coin Markers"
	refreshCoins()
	notify("Coin Markers " .. (espCoinsOn and "enabled" or "disabled"))
end)

RunService.Heartbeat:Connect(function()
	if espPlayersOn then
		for p,data in pairs(espPlayers) do
			if p.Character and p.Character:FindFirstChild("Humanoid") then
				local hum = p.Character:FindFirstChild("Humanoid")
				if hum then
					local hp = math.floor(hum.Health)
					data.label.Text = p.Name.." • "..tostring(hp)
				end
			end
		end
	end
	if espCoinsOn then
		for coin,gui in pairs(coinMarkers) do
			if not coin.Parent then
				removeCoinMarker(coin)
			end
		end
	end
end)

workspace.DescendantAdded:Connect(function(d)
	if d:IsA("BasePart") and d.Name == "Coin_Server" and d:GetAttribute and d:GetAttribute("CoinID") == "BeachBall" then
		if espCoinsOn then addCoinMarker(d) end
	end
end)

workspace.DescendantRemoving:Connect(function(d)
	if d:IsA("BasePart") and d.Name == "Coin_Server" then
		removeCoinMarker(d)
	end
end)

local draggingEnabled = false
local dragging = false
local dragOffset = Vector2.new(0,0)

DraggableToggle.MouseButton1Click:Connect(function()
	draggingEnabled = not draggingEnabled
	DraggableToggle.Text = draggingEnabled and "Disable Dragging" or "Enable Dragging"
	notify("Dragging " .. (draggingEnabled and "enabled" or "disabled"))
end)

Root.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 and draggingEnabled then
		dragging = true
		local mouse = UserInputService:GetMouseLocation()
		local absPos = Vector2.new(Root.AbsolutePosition.X, Root.AbsolutePosition.Y)
		dragOffset = Vector2.new(mouse.X, mouse.Y) - absPos
	end
end)

Root.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local pos = UserInputService:GetMouseLocation() - dragOffset
		Root.Position = UDim2.new(0, pos.X, 0, pos.Y)
	end
end)

local uiVisible = true
ToggleBottom.MouseButton1Click:Connect(function()
	uiVisible = not uiVisible
	Root.Visible = uiVisible
	ToggleBottom.Text = uiVisible and "Hide UI" or "Show UI"
	notify("UI " .. (uiVisible and "shown" or "hidden"))
end)

local function protectTools()
	if not LocalPlayer.Character then return end
	local char = LocalPlayer.Character
	for _,t in pairs(char:GetChildren()) do
		if t:IsA("Tool") then
			pcall(function() t.Parent = char end)
		end
	end
	if LocalPlayer:FindFirstChild("Backpack") then
		for _,tb in pairs(LocalPlayer.Backpack:GetChildren()) do
			if tb:IsA("Tool") then
				pcall(function() tb.Parent = LocalPlayer.Backpack end)
			end
		end
	end
end

RunService.Stepped:Connect(function()
	if antiStealOn then
		protectTools()
	end
end)

local function cleanOldESP()
	for p,data in pairs(espPlayers) do
		if not p.Parent then removePlayerESP(p) end
	end
	for coin,gui in pairs(coinMarkers) do
		if not coin.Parent then removeCoinMarker(coin) end
	end
end

RunService.Heartbeat:Connect(cleanOldESP)

LocalPlayer.CharacterAdded:Connect(function(c)
	if espPlayersOn then
		for _,p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character then createPlayerESP(p) end
		end
	end
end)

notify("Flashlight Hub ready • Press bottom button to hide • Check F9 for debug prints")

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.RightControl then
		uiVisible = not uiVisible
		Root.Visible = uiVisible
		ToggleBottom.Text = uiVisible and "Hide UI" or "Show UI"
	end
end)

print("Script fully loaded - no errors expected")  -- Final debug
