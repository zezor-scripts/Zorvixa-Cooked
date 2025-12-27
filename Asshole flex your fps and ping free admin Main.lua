-- Ultimate Stats Spoofer GUI v7 - DARK RED THEME | Clean Professional Look
-- No emoji spam | Sleek dark red & black | Mobile perfect | Min/Max FPS/Ping | Unlimited

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local StatUpdateEvent = ReplicatedStorage:WaitForChild("StatUpdateEvent")

-- === DEFAULTS ===
local defaultDevice = "Windows"
local defaultMinFPS = 1400
local defaultMaxFPS = 1600
local defaultMinPing = 5
local defaultMaxPing = 20

-- Live values
local currentDevice = defaultDevice
local minFPS = defaultMinFPS
local maxFPS = defaultMaxFPS
local minPing = defaultMinPing
local maxPing = defaultMaxPing
local currentColor = Color3.fromRGB(0, 162, 255)  -- Will auto-update based on device

-- Exact mobile orange from game
local mobileColor = Color3.new(1, 0.6666666865348816, 0)

-- === CLEAN DARK RED THEME ===
local theme = {
    bg = Color3.fromRGB(15, 15, 15),           -- Almost black
    frame = Color3.fromRGB(25, 25, 30),         -- Deep dark gray
    input = Color3.fromRGB(40, 40, 45),
    accent = Color3.fromRGB(200, 40, 40),       -- Blood red
    accentHover = Color3.fromRGB(230, 60, 60),
    title = Color3.fromRGB(180, 30, 30),
    text = Color3.new(1, 1, 1),
    textDim = Color3.fromRGB(180, 180, 180),
    border = Color3.fromRGB(60, 60, 70),
    success = Color3.fromRGB(0, 200, 100)
}

local function getColorForDevice(deviceName)
    local lower = string.lower(deviceName)
    if string.find(lower, "mobile") or string.find(lower, "iphone") or string.find(lower, "android") or string.find(lower, "phone") then
        return mobileColor
    elseif string.find(lower, "windows") or string.find(lower, "pc") or string.find(lower, "desktop") then
        return Color3.fromRGB(0, 162, 255)
    elseif string.find(lower, "ps") or string.find(lower, "playstation") then
        return Color3.fromRGB(0, 100, 255)
    elseif string.find(lower, "xbox") then
        return Color3.fromRGB(0, 200, 50)
    elseif string.find(lower, "mac") or string.find(lower, "apple") then
        return Color3.fromRGB(220, 220, 220)
    else
        return mobileColor
    end
end

local function updateColor()
    currentColor = getColorForDevice(currentDevice)
end

-- Random values in range
local function getRandomFPS()
    if minFPS >= maxFPS then return minFPS end
    return math.random(minFPS, maxFPS)
end

local function getRandomPing()
    if minPing >= maxPing then return minPing end
    return math.random(minPing, maxPing)
end

local function getFakeArgs()
    return {
        {
            Device = currentDevice,
            FPS = getRandomFPS(),
            DeviceColor = currentColor,
            Ping = getRandomPing()
        }
    }
end

-- === METATABLE HOOK ===
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = function(self, ...)
    local method = getnamecallmethod()
    if self == StatUpdateEvent and method == "FireServer" then
        return oldNamecall(self, table.unpack(getFakeArgs()))
    end
    return oldNamecall(self, ...)
end
setreadonly(mt, true)

updateColor()
StatUpdateEvent:FireServer(table.unpack(getFakeArgs()))

-- === GUI ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StatsSpoofer"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- Toggle Button (clean red circle)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 65, 0, 65)
ToggleButton.Position = UDim2.new(1, -75, 1, -75)
ToggleButton.BackgroundColor3 = theme.accent
ToggleButton.Text = ""
ToggleButton.ZIndex = 10
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 32)
ToggleCorner.Parent = ToggleButton

local ToggleIcon = Instance.new("TextLabel")
ToggleIcon.Size = UDim2.new(1, 0, 1, 0)
ToggleIcon.BackgroundTransparency = 1
ToggleIcon.Text = "STATS"
ToggleIcon.TextColor3 = Color3.new(1,1,1)
ToggleIcon.TextScaled = true
ToggleIcon.Font = Enum.Font.GothamBold
ToggleIcon.Rotation = 45
ToggleIcon.Parent = ToggleButton

-- Main Frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 280, 0, 480)
Frame.Position = UDim2.new(1, 20, 0.5, -240)
Frame.BackgroundColor3 = theme.frame
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 16)
FrameCorner.Parent = Frame

local FrameBorder = Instance.new("UIStroke")
FrameBorder.Color = theme.border
FrameBorder.Thickness = 1
FrameBorder.Parent = Frame

-- Title Bar
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = theme.title
Title.Text = "Stats Spoofer"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 16)
TitleCorner.Parent = Title

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -45, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Title

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = CloseBtn

-- Drag functionality
local dragging = false
local dragStart = nil
local startPos = nil

local function updateDrag(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
    end
end)

Title.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateDrag(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Toggle animation
local isOpen = false
local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local function openGUI()
    isOpen = true
    TweenService:Create(Frame, tweenInfo, {Position = UDim2.new(1, -300, 0.5, -240)}):Play()
end

local function closeGUI()
    isOpen = false
    TweenService:Create(Frame, tweenInfo, {Position = UDim2.new(1, 20, 0.5, -240)}):Play()
end

ToggleButton.Activated:Connect(function()
    if isOpen then closeGUI() else openGUI() end
end)

CloseBtn.Activated:Connect(closeGUI)

-- Device Input
local DeviceLabel = Instance.new("TextLabel")
DeviceLabel.Size = UDim2.new(1, -20, 0, 25)
DeviceLabel.Position = UDim2.new(0, 10, 0, 60)
DeviceLabel.BackgroundTransparency = 1
DeviceLabel.Text = "Device Name"
DeviceLabel.TextColor3 = theme.textDim
DeviceLabel.TextXAlignment = Enum.TextXAlignment.Left
DeviceLabel.Font = Enum.Font.Gotham
DeviceLabel.Parent = Frame

local DeviceBox = Instance.new("TextBox")
DeviceBox.Size = UDim2.new(1, -20, 0, 40)
DeviceBox.Position = UDim2.new(0, 10, 0, 85)
DeviceBox.BackgroundColor3 = theme.input
DeviceBox.Text = defaultDevice
DeviceBox.PlaceholderText = "e.g. RTX 4090"
DeviceBox.TextColor3 = theme.text
DeviceBox.TextScaled = true
DeviceBox.Font = Enum.Font.Gotham
DeviceBox.Parent = Frame

local DeviceBoxCorner = Instance.new("UICorner")
DeviceBoxCorner.CornerRadius = UDim.new(0, 8)
DeviceBoxCorner.Parent = DeviceBox

DeviceBox.FocusLost:Connect(function(enter)
    if enter and DeviceBox.Text ~= "" then
        currentDevice = DeviceBox.Text
        updateColor()
    end
end)

-- FPS Range
local FPSLabel = Instance.new("TextLabel")
FPSLabel.Size = UDim2.new(1, -20, 0, 25)
FPSLabel.Position = UDim2.new(0, 10, 0, 135)
FPSLabel.BackgroundTransparency = 1
FPSLabel.Text = "FPS Range"
FPSLabel.TextColor3 = theme.textDim
FPSLabel.TextXAlignment = Enum.TextXAlignment.Left
FPSLabel.Font = Enum.Font.Gotham
FPSLabel.Parent = Frame

local MinFPSBox = Instance.new("TextBox")
MinFPSBox.Size = UDim2.new(0.48, -10, 0, 40)
MinFPSBox.Position = UDim2.new(0, 10, 0, 160)
MinFPSBox.BackgroundColor3 = theme.input
MinFPSBox.Text = tostring(defaultMinFPS)
MinFPSBox.PlaceholderText = "Min"
MinFPSBox.TextColor3 = theme.text
MinFPSBox.TextScaled = true
MinFPSBox.Parent = Frame

local MaxFPSBox = Instance.new("TextBox")
MaxFPSBox.Size = UDim2.new(0.48, -10, 0, 40)
MaxFPSBox.Position = UDim2.new(0.52, 0, 0, 160)
MaxFPSBox.BackgroundColor3 = theme.input
MaxFPSBox.Text = tostring(defaultMaxFPS)
MaxFPSBox.PlaceholderText = "Max"
MaxFPSBox.TextColor3 = theme.text
MaxFPSBox.TextScaled = true
MaxFPSBox.Parent = Frame

-- Ping Range
local PingLabel = Instance.new("TextLabel")
PingLabel.Size = UDim2.new(1, -20, 0, 25)
PingLabel.Position = UDim2.new(0, 10, 0, 210)
PingLabel.BackgroundTransparency = 1
PingLabel.Text = "Ping Range"
PingLabel.TextColor3 = theme.textDim
PingLabel.TextXAlignment = Enum.TextXAlignment.Left
PingLabel.Font = Enum.Font.Gotham
PingLabel.Parent = Frame

local MinPingBox = Instance.new("TextBox")
MinPingBox.Size = UDim2.new(0.48, -10, 0, 40)
MinPingBox.Position = UDim2.new(0, 10, 0, 235)
MinPingBox.BackgroundColor3 = theme.input
MinPingBox.Text = tostring(defaultMinPing)
MinPingBox.PlaceholderText = "Min"
MinPingBox.TextColor3 = theme.text
MinPingBox.TextScaled = true
MinPingBox.Parent = Frame

local MaxPingBox = Instance.new("TextBox")
MaxPingBox.Size = UDim2.new(0.48, -10, 0, 40)
MaxPingBox.Position = UDim2.new(0.52, 0, 0, 235)
MaxPingBox.BackgroundColor3 = theme.input
MaxPingBox.Text = tostring(defaultMaxPing)
MaxPingBox.PlaceholderText = "Max"
MaxPingBox.TextColor3 = theme.text
MaxPingBox.TextScaled = true
MaxPingBox.Parent = Frame

-- Apply inputs
MinFPSBox.FocusLost:Connect(function(enter) if enter then local n = tonumber(MinFPSBox.Text) if n then minFPS = math.floor(n) end end end)
MaxFPSBox.FocusLost:Connect(function(enter) if enter then local n = tonumber(MaxFPSBox.Text) if n then maxFPS = math.floor(n) end end end)
MinPingBox.FocusLost:Connect(function(enter) if enter then local n = tonumber(MinPingBox.Text) if n then minPing = math.floor(n) end end end)
MaxPingBox.FocusLost:Connect(function(enter) if enter then local n = tonumber(MaxPingBox.Text) if n then maxPing = math.floor(n) end end end)

-- Presets (clean, no emojis in UI)
local presets = {
    "Mobile", "iPhone 15 Pro", "Android",
    "Windows", "RTX 4090", "PC",
    "PlayStation 5", "Xbox Series X", "MacBook Pro"
}

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 0, 140)
ScrollFrame.Position = UDim2.new(0, 10, 0, 290)
ScrollFrame.BackgroundColor3 = theme.input
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.ScrollBarImageColor3 = theme.accent
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, #presets * 45)
ScrollFrame.Parent = Frame

local ScrollCorner = Instance.new("UICorner")
ScrollCorner.CornerRadius = UDim.new(0, 10)
ScrollCorner.Parent = ScrollFrame

local y = 5
for _, preset in ipairs(presets) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, y)
    btn.BackgroundColor3 = theme.bg
    btn.Text = preset
    btn.TextColor3 = theme.text
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = ScrollFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = theme.accent}):Play()
        btn.TextColor3 = Color3.new(1,1,1)
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = theme.bg}):Play()
        btn.TextColor3 = theme.text
    end)

    btn.Activated:Connect(function()
        currentDevice = preset
        DeviceBox.Text = preset
        updateColor()
        -- High FPS for PC presets
        if preset:find("RTX") or preset:find("PC") or preset:find("Windows") then
            minFPS = 4800; maxFPS = 5200
            MinFPSBox.Text = "4800"; MaxFPSBox.Text = "5200"
        end
    end)

    y = y + 45
end

-- Color Preview
local ColorPreview = Instance.new("Frame")
ColorPreview.Size = UDim2.new(1, -20, 0, 45)
ColorPreview.Position = UDim2.new(0, 10, 1, -75)
ColorPreview.BackgroundColor3 = currentColor
ColorPreview.BorderSizePixel = 2
ColorPreview.BorderColor3 = theme.accent
ColorPreview.Parent = Frame

local PreviewCorner = Instance.new("UICorner")
PreviewCorner.CornerRadius = UDim.new(0, 10)
PreviewCorner.Parent = ColorPreview

local PreviewLabel = Instance.new("TextLabel")
PreviewLabel.Size = UDim2.new(1,0,1,0)
PreviewLabel.BackgroundTransparency = 1
PreviewLabel.Text = "Current Color"
PreviewLabel.TextColor3 = Color3.new(1,1,1)
PreviewLabel.TextScaled = true
PreviewLabel.Font = Enum.Font.GothamBold
PreviewLabel.Parent = ColorPreview

-- Status
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -20, 0, 25)
Status.Position = UDim2.new(0, 10, 1, -25)
Status.BackgroundTransparency = 1
Status.Text = "Active"
Status.TextColor3 = theme.success
Status.TextScaled = true
Status.Font = Enum.Font.GothamBold
Status.Parent = Frame

-- Live preview update
spawn(function()
    while ScreenGui.Parent do
        ColorPreview.BackgroundColor3 = currentColor
        task.wait(0.2)
    end
end)

-- Backup fire loop
spawn(function()
    while ScreenGui.Parent do
        StatUpdateEvent:FireServer(table.unpack(getFakeArgs()))
        task.wait(1.5)
    end
end)

print("Dark Red Stats Spoofer loaded - Clean, professional, undetectable.")
