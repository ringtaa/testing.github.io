local player = game.Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

-- Main Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size, MainFrame.Position = UDim2.new(0, 250, 0, 120), UDim2.new(0.5, -125, 0.5, -60)
MainFrame.AnchorPoint, MainFrame.BackgroundColor3 = Vector2.new(0.5, 0.5), Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- Title
local Title = Instance.new("TextLabel", MainFrame)
Title.Text, Title.Size, Title.Position = "RINGTA SCRIPTS", UDim2.new(1, -20, 0, 30), UDim2.new(0, 10, 0, 10)
Title.BackgroundTransparency, Title.TextColor3, Title.Font, Title.TextSize = 1, Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 16

-- Button
local Button = Instance.new("TextButton", MainFrame)
Button.Text, Button.Size, Button.Position = "TP to Sterling", UDim2.new(0.8, 0, 0.3, 0), UDim2.new(0.1, 0, 0.5, 0)
Button.BackgroundColor3, Button.TextColor3, Button.Font, Button.TextSize = Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255), Enum.Font.GothamMedium, 14
Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

-- Button Hover Effects
Button.MouseEnter:Connect(function()
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)
Button.MouseLeave:Connect(function()
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
end)

-- Button Functionality
Button.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ringtaa/sterlingnotifcation.github.io/refs/heads/main/Sterling.lua'))()
end)
