local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local Theme = {Background = Color3.fromRGB(15, 15, 15), Button = Color3.fromRGB(30, 30, 30), Text = Color3.fromRGB(255, 255, 255)}

-- Main UI
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size, MainFrame.Position, MainFrame.BackgroundColor3, MainFrame.Visible = UDim2.new(0, 300, 0, 200), UDim2.new(0.10, 0, 0.5, -100), Theme.Background, true

local Title, CloseButton, MinimizeButton = Instance.new("TextLabel", MainFrame), Instance.new("TextButton", MainFrame), Instance.new("TextButton", MainFrame)
Title.Text, Title.Size, Title.TextColor3, Title.Font, Title.TextSize = "Ringta's Dead Rails", UDim2.new(1, -40, 0, 30), Theme.Text, Enum.Font.GothamBold, 18
CloseButton.Text, MinimizeButton.Text, CloseButton.Size, MinimizeButton.Size, MinimizeButton.Position = "×", "-", UDim2.new(0, 25, 0, 25), UDim2.new(0, 25, 0, 25), UDim2.new(1, -60, 0, 5)

local isMinimized = false

CloseButton.MouseButton1Click:Connect(function() MainFrame.Visible = false end)
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local size, position = (isMinimized and UDim2.new(0, 300, 0, 40) or UDim2.new(0, 300, 0, 200)), (isMinimized and UDim2.new(0.10, 0, 0.5, -20) or UDim2.new(0.10, 0, 0.5, -100))
    MinimizeButton.Text = isMinimized and "+" or "-"
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = size, Position = position}):Play()
end)

-- Scrollable Containers
local LatestScriptsContainer, OldScriptsContainer = Instance.new("ScrollingFrame", MainFrame), Instance.new("ScrollingFrame", MainFrame)
for _, container in ipairs({LatestScriptsContainer, OldScriptsContainer}) do
    container.Size, container.Position, container.BorderSizePixel = UDim2.new(1, -30, 0, 110), UDim2.new(0, 15, 0, 90), 0
    container.ScrollBarThickness, container.ScrollBarImageColor3, container.BackgroundTransparency = 4, Color3.fromRGB(100, 100, 100), 1
end
OldScriptsContainer.Visible = false

-- Button Template
local function CreateButton(text, callback, parent)
    local Button = Instance.new("TextButton", parent)
    Button.Text, Button.Size, Button.BackgroundColor3, Button.TextColor3 = text, UDim2.new(1, 0, 0, 36), Theme.Button, Theme.Text
    local ButtonStroke = Instance.new("UIStroke", Button)
    ButtonStroke.Color, ButtonStroke.Thickness, ButtonStroke.Transparency = Color3.fromRGB(60, 60, 60), 1, 0.7

    -- Hover animation
    Button.MouseEnter:Connect(function()
        TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {Transparency = 0.3}):Play()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
    end)

    -- Leave animation
    Button.MouseLeave:Connect(function()
        TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {Transparency = 0.7}):Play()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Button}):Play()
    end)

    -- Click animation
    Button.MouseButton1Down:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(0.98, 0, 0, 34)}):Play()
    end)

    Button.MouseButton1Up:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 36)}):Play()
    end)

    -- Click event
    Button.MouseButton1Click:Connect(function()
        TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {Transparency = 0.1, Thickness = 2}):Play()
        TweenService:Create(ButtonStroke, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Transparency = 0.7, Thickness = 1}):Play()
        callback()
    end)
end

-- Buttons for Functionality
CreateButton("TP to Castle", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/castletpfast.github.io/refs/heads/main/FASTCASTLE.lua"))() end, LatestScriptsContainer)
CreateButton("TP to End", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/gumanba/Scripts/refs/heads/main/DeadRails"))() end, LatestScriptsContainer)
CreateButton("TP to Fort", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/Tpfort.github.io/refs/heads/main/Tpfort.lua"))() end, LatestScriptsContainer)
CreateButton("AFK AutoFarm Bond", function() _G['EndGameOnlyMode'] = true; loadstring(game:HttpGet("https://raw.githubusercontent.com/NebulaHubOfc/Public/refs/heads/main/Loader.lua"))() end, OldScriptsContainer)
CreateButton("AFK AutoFarm Bond (No Key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/TwoGunVolley/Earlyfixed/refs/heads/main/Protected_1408189441085576.txt"))() end, OldScriptsContainer)

-- Initialize Latest Container as Default
LatestScriptsContainer.Visible = true
OldScriptsContainer.Visible = false
