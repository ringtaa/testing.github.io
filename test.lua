local TweenService, RunService, UIS = game:GetService("TweenService"), game:GetService("RunService"), game:GetService("UserInputService")
local player = game:GetService("Players").LocalPlayer

local Theme = {
    Background = Color3.fromRGB(15, 15, 15),
    Button = Color3.fromRGB(30, 30, 30),
    Text = Color3.fromRGB(255, 255, 255),
    Stroke = Color3.fromRGB(60, 60, 60),
    TabActive = Color3.fromRGB(35, 35, 35),
    TabInactive = Color3.fromRGB(25, 25, 25)
}

-- Main UI
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size, MainFrame.Position, MainFrame.BackgroundColor3 = UDim2.new(0, 300, 0, 200), UDim2.new(0.10, 0, 0.5, -100), Theme.Background

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color, Instance.new("UIStroke", MainFrame).Thickness = Theme.Stroke, 1.5

local Title = Instance.new("TextLabel", MainFrame)
Title.Text, Title.Size, Title.TextColor3, Title.Font, Title.TextSize = "Ringta's Dead Rails", UDim2.new(1, -40, 0, 30), Theme.Text, Enum.Font.GothamBold, 18

local Subtitle = Instance.new("TextLabel", MainFrame)
Subtitle.Text, Subtitle.Size, Subtitle.TextColor3, Subtitle.Font, Subtitle.TextSize, Subtitle.TextTransparency = "v1.0 | Gui", UDim2.new(1, -40, 0, 15), Theme.Text, Enum.Font.Gotham, 12, 0.5

local CloseButton = Instance.new("TextButton", MainFrame)
CloseButton.Text, CloseButton.Size, CloseButton.Position, CloseButton.BackgroundColor3, CloseButton.TextColor3 = "×", UDim2.new(0, 25, 0, 25), UDim2.new(1, -30, 0, 5), Theme.Button, Theme.Text
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

local MinimizeButton = Instance.new("TextButton", MainFrame)
MinimizeButton.Text, MinimizeButton.Size, MinimizeButton.Position = "-", UDim2.new(0, 25, 0, 25), UDim2.new(1, -60, 0, 5)
MinimizeButton.BackgroundColor3, MinimizeButton.TextColor3 = Theme.Button, Theme.Text

local TabsContainer = Instance.new("Frame", MainFrame)
TabsContainer.Size, TabsContainer.Position, TabsContainer.BackgroundTransparency = UDim2.new(1, -30, 0, 30), UDim2.new(0, 15, 0, 55), 1

local LatestContainer, OldContainer = Instance.new("ScrollingFrame", MainFrame), Instance.new("ScrollingFrame", MainFrame)
for _, Container in ipairs({LatestContainer, OldContainer}) do
    Container.Size, Container.Position, Container.ScrollBarThickness, Container.BackgroundTransparency = UDim2.new(1, -30, 0, 110), UDim2.new(0, 15, 0, 90), 4, 1
end
OldContainer.Visible = false

local function CreateButton(text, callback, parent)
    local Button = Instance.new("TextButton", parent)
    Button.Text, Button.Size, Button.BackgroundColor3, Button.TextColor3 = text, UDim2.new(1, 0, 0, 36), Theme.Button, Theme.Text
    local ButtonStroke = Instance.new("UIStroke", Button)
    ButtonStroke.Color, ButtonStroke.Transparency = Theme.Stroke, 0.7

    Button.MouseEnter:Connect(function()
        TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {Transparency = 0.3}):Play()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
    end)
    Button.MouseLeave:Connect(function()
        TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {Transparency = 0.7}):Play()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Button}):Play()
    end)
    Button.MouseButton1Click:Connect(function()
        callback()
    end)
end

-- Teleport Functions
CreateButton("TP to Castle", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/castletpfast.github.io/refs/heads/main/FASTCASTLE.lua"))() end, LatestContainer)
CreateButton("TP to End", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/gumanba/Scripts/refs/heads/main/DeadRails"))() end, LatestContainer)
CreateButton("TP to Fort", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/Tpfort.github.io/refs/heads/main/Tpfort.lua"))() end, LatestContainer)
CreateButton("AFK AutoFarm Bond", function() _G['EndGameOnlyMode'] = true; loadstring(game:HttpGet("https://raw.githubusercontent.com/NebulaHubOfc/Public/refs/heads/main/Loader.lua"))() end, OldContainer)
CreateButton("AFK AutoFarm Bond (No Key)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/TwoGunVolley/Earlyfixed/refs/heads/main/Protected_1408189441085576.txt"))() end, OldContainer)

-- Tabs
local LatestTab, OldTab = Instance.new("TextButton", TabsContainer), Instance.new("TextButton", TabsContainer)
LatestTab.Text, OldTab.Text = "Latest", "Old"
LatestTab.MouseButton1Click:Connect(function()
    LatestContainer.Visible, OldContainer.Visible = true, false
end)
OldTab.MouseButton1Click:Connect(function()
    OldContainer.Visible, LatestContainer.Visible = true, false
end)
