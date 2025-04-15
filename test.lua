local player = game.Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

-- Main Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 150)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

-- UI Styling
local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "Sterling TP Script"
Title.Size = UDim2.new(1, -20, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 10)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

-- Button
local Button = Instance.new("TextButton", MainFrame)
Button.Text = "TP to Sterling"
Button.Size = UDim2.new(0.8, 0, 0.3, 0)
Button.Position = UDim2.new(0.1, 0, 0.5, 0)
Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Font = Enum.Font.GothamMedium
Button.TextSize = 14

local ButtonCorner = Instance.new("UICorner", Button)
ButtonCorner.CornerRadius = UDim.new(0, 6)

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
