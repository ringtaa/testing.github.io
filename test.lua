local TweenService, UIS = game:GetService("TweenService"), game:GetService("UserInputService")
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
MainFrame.Size, MainFrame.Position = UDim2.new(0, 250, 0, 120), UDim2.new(0.5, -125, 0.5, -60)
MainFrame.AnchorPoint, MainFrame.BackgroundColor3 = Vector2.new(0.5, 0.5), Theme.Background
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", MainFrame)
Title.Text, Title.Size, Title.Position = "RINGTA SCRIPTS", UDim2.new(1, -20, 0, 30), UDim2.new(0, 10, 0, 10)
Title.BackgroundTransparency, Title.TextColor3, Title.Font, Title.TextSize = 1, Theme.Text, Enum.Font.GothamBold, 16

-- Minimize Button
local MinimizeButton = Instance.new("TextButton", MainFrame)
MinimizeButton.Text, MinimizeButton.Size, MinimizeButton.Position = "-", UDim2.new(0, 20, 0, 20), UDim2.new(1, -25, 0, 5)
MinimizeButton.BackgroundColor3, MinimizeButton.TextColor3 = Theme.Button, Theme.Text
Instance.new("UICorner", MinimizeButton).CornerRadius = UDim.new(0, 6)

-- Reopen Button (Initially Hidden)
local ReopenButton = Instance.new("TextButton", ScreenGui)
ReopenButton.Text, ReopenButton.Size, ReopenButton.Position = "Open RINGTA SCRIPTS", UDim2.new(0, 150, 0, 30), UDim2.new(0.5, -75, 0.5, 50)
ReopenButton.AnchorPoint, ReopenButton.Visible = Vector2.new(0.5, 0.5), false
ReopenButton.BackgroundColor3, ReopenButton.TextColor3 = Theme.Button, Theme.Text
Instance.new("UICorner", ReopenButton).CornerRadius = UDim.new(0, 6)

-- Minimize Functionality
MinimizeButton.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    wait(0.3)
    MainFrame.Visible = false
    ReopenButton.Visible = true
end)

-- Reopen Functionality
ReopenButton.MouseButton1Click:Connect(function()
    ReopenButton.Visible = false
    MainFrame.Visible = true
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 250, 0, 120)}):Play()
end)

-- TP Button
local TPButton = Instance.new("TextButton", MainFrame)
TPButton.Text, TPButton.Size, TPButton.Position = "TP to Sterling", UDim2.new(0.8, 0, 0.3, 0), UDim2.new(0.1, 0, 0.5, 0)
TPButton.BackgroundColor3, TPButton.TextColor3 = Theme.Button, Theme.Text
Instance.new("UICorner", TPButton).CornerRadius = UDim.new(0, 6)

-- TP Button Functionality
TPButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ringtaa/sterlingnotifcation.github.io/refs/heads/main/Sterling.lua'))()
end)
