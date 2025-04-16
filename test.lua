local TweenService, UIS, rs = game:GetService("TweenService"), game:GetService("UserInputService"), game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer

-- Theme Setup
local Theme = {
    Background = Color3.fromRGB(15, 15, 15),
    Button = Color3.fromRGB(30, 30, 30),
    Text = Color3.fromRGB(255, 255, 255)
}

-- Main UI
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 350, 0, 230)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Theme.Background

-- Rainbow Outline for Main Frame
local frameOutline = Instance.new("UIStroke")
frameOutline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
frameOutline.Thickness = 3
frameOutline.Parent = MainFrame
local hue = 0
rs.RenderStepped:Connect(function()
    hue = (hue + 0.005) % 1
    frameOutline.Color = Color3.fromHSV(hue, 1, 1)
end)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", MainFrame)
Title.Text, Title.Size, Title.Position = "RINGTA SCRIPTS", UDim2.new(1, -20, 0, 20), UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency, Title.TextColor3, Title.Font, Title.TextSize = 1, Theme.Text, Enum.Font.GothamBold, 14

-- Tabs Frame
local TabsFrame = Instance.new("Frame", MainFrame)
TabsFrame.Size = UDim2.new(0, 100, 1, -40)
TabsFrame.Position = UDim2.new(0, 10, 0, 30)
TabsFrame.BackgroundColor3 = Theme.Button
Instance.new("UICorner", TabsFrame).CornerRadius = UDim.new(0, 6)

-- Tab Buttons
local Tabs = {}
local TabContentFrame = Instance.new("Frame", MainFrame)
TabContentFrame.Size = UDim2.new(1, -120, 1, -40)
TabContentFrame.Position = UDim2.new(0, 110, 0, 30)
TabContentFrame.BackgroundColor3 = Theme.Background
TabContentFrame.ClipsDescendants = true
Instance.new("UICorner", TabContentFrame).CornerRadius = UDim.new(0, 6)

local function CreateTab(tabName)
    local TabButton = Instance.new("TextButton", TabsFrame)
    TabButton.Text, TabButton.Size, TabButton.Position = tabName, UDim2.new(1, -10, 0, 30), UDim2.new(0, 5, 0, (#Tabs * 35))
    TabButton.BackgroundColor3, TabButton.TextColor3 = Theme.Button, Theme.Text
    Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 6)
    
    local TabFrame = Instance.new("Frame", TabContentFrame)
    TabFrame.Size = UDim2.new(1, 0, 1, 0)
    TabFrame.Visible = (#Tabs == 0) -- Default to showing the first tab
    table.insert(Tabs, TabFrame)
    
    TabButton.MouseButton1Click:Connect(function()
        for _, frame in pairs(Tabs) do
            frame.Visible = false
        end
        TabFrame.Visible = true
    end)
    return TabFrame
end

-- Button Template
local function CreateButton(parent, text, callback, position)
    local Button = Instance.new("TextButton", parent)
    Button.Text, Button.Size, Button.Position = text, UDim2.new(0.8, 0, 0.12, 0), position
    Button.BackgroundColor3, Button.TextColor3 = Theme.Button, Theme.Text
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

    -- Button Hover Effects
    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end)
    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = Theme.Button
    end)

    Button.MouseButton1Click:Connect(callback)
end

-- Main Tab for Teleports
local MainTab = CreateTab("Main")

CreateButton(MainTab, "TP to Train", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ringtaa/train.github.io/refs/heads/main/train.lua'))()
end, UDim2.new(0.1, 0, 0.2, 0))

CreateButton(MainTab, "TP to Sterling", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ringtaa/sterlingnotifcation.github.io/refs/heads/main/Sterling.lua'))()
end, UDim2.new(0.1, 0, 0.34, 0))

CreateButton(MainTab, "TP to TeslaLab", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ringtaa/tptotesla.github.io/refs/heads/main/Tptotesla.lua'))()
end, UDim2.new(0.1, 0, 0.48, 0))

CreateButton(MainTab, "TP to Castle", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/castletpfast.github.io/refs/heads/main/FASTCASTLE.lua"))()
end, UDim2.new(0.1, 0, 0.62, 0))

CreateButton(MainTab, "TP to Fort", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/Tpfort.github.io/refs/heads/main/Tpfort.lua"))()
end, UDim2.new(0.1, 0, 0.76, 0))

-- Other Tab for Additional Features
local OtherTab = CreateTab("Other")

CreateButton(OtherTab, "TP to Bank", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/Tptobank.github.io/refs/heads/main/Banktp.lua"))()
end, UDim2.new(0.1, 0, 0.2, 0))

-- Minimize Button
local MinimizeButton = Instance.new("TextButton", MainFrame)
MinimizeButton.Text, MinimizeButton.Size, MinimizeButton.Position = "-", UDim2.new(0, 20, 0, 20), UDim2.new(1, -25, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Changed to bright green for better visibility
MinimizeButton.TextColor3 = Theme.Text
Instance.new("UICorner", MinimizeButton).CornerRadius = UDim.new(0, 6)

-- Reopen Button (Hidden When UI is Minimized)
local ReopenButton = Instance.new("TextButton", ScreenGui)
ReopenButton.Text, ReopenButton.Size, ReopenButton.Position = "Open RINGTA SCRIPTS", UDim2.new(0, 150, 0, 30), UDim2.new(0.5, 0, 0, -22)
ReopenButton.AnchorPoint, ReopenButton.Visible = Vector2.new(0.5, 0), false
ReopenButton.BackgroundColor3, ReopenButton.TextColor3 = Theme.Button, Theme.Text
Instance.new("UICorner", ReopenButton).CornerRadius = UDim.new(0, 6)

local isMinimized = false

-- Minimize Functionality
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = true
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, -0.7, 0),
        Size = UDim2.new(0, 250, 0, 50)
    }):Play()
    wait(0.3)
    MainFrame.Visible = false
    ReopenButton.Visible = true
end)

-- Reopen Functionality
ReopenButton.MouseButton1Click:Connect(function()
    isMinimized = false
    ReopenButton.Visible = false
    MainFrame.Visible = true
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 350, 0, 230)
    }):Play()
end)
