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
MainFrame.Size = UDim2.new(0, 250, 0, 160)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Theme.Background
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", MainFrame)
Title.Text, Title.Size, Title.Position = "RINGTA SCRIPTS", UDim2.new(1, -20, 0, 30), UDim2.new(0, 10, 0, 10)
Title.BackgroundTransparency, Title.TextColor3, Title.Font, Title.TextSize = 1, Theme.Text, Enum.Font.GothamBold, 16

-- Minimize Button
local MinimizeButton = Instance.new("TextButton", MainFrame)
MinimizeButton.Text, MinimizeButton.Size, MinimizeButton.Position = "-", UDim2.new(0, 20, 0, 20), UDim2.new(1, -25, 0, 5)
MinimizeButton.BackgroundColor3, MinimizeButton.TextColor3 = Theme.Button, Theme.Text
Instance.new("UICorner", MinimizeButton).CornerRadius = UDim.new(0, 6)

-- Reopen Button (Hidden When UI is Active)
local ReopenButton = Instance.new("TextButton", ScreenGui)
ReopenButton.Text, ReopenButton.Size, ReopenButton.Position = "Open RINGTA SCRIPTS", UDim2.new(0, 150, 0, 30), UDim2.new(0.5, 0, 0.02, 0)
ReopenButton.AnchorPoint, ReopenButton.Visible = Vector2.new(0.5, 0), false
ReopenButton.BackgroundColor3, ReopenButton.TextColor3 = Theme.Button, Theme.Text
Instance.new("UICorner", ReopenButton).CornerRadius = UDim.new(0, 6)

-- Dragging State
local isMinimized = false
local dragging, dragStart, startPos

-- Dragging Logic
MainFrame.InputBegan:Connect(function(input)
    if not isMinimized and input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- Minimize Functionality
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = true -- Disable dragging when minimized
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {
        Position = UDim2.new(0.5, 0, 0.02, 0), -- Moves to a higher top-middle position
        Size = UDim2.new(0, 250, 0, 50)       -- Shrinks size
    }):Play()
    wait(0.3)
    MainFrame.Visible = false
    ReopenButton.Visible = true
end)

-- Reopen Functionality
ReopenButton.MouseButton1Click:Connect(function()
    isMinimized = false -- Enable dragging when restored
    ReopenButton.Visible = false
    MainFrame.Visible = true
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {
        Position = UDim2.new(0.5, 0, 0.5, 0), -- Restores original position
        Size = UDim2.new(0, 250, 0, 160)      -- Restores original size
    }):Play()
end)

-- Button Template
local function CreateButton(text, callback, position)
    local Button = Instance.new("TextButton", MainFrame)
    Button.Text, Button.Size, Button.Position = text, UDim2.new(0.8, 0, 0.25, 0), position
    Button.BackgroundColor3, Button.TextColor3 = Theme.Button, Theme.Text
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

    -- Button Hover Effects
    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end)
    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = Theme.Button
    end)

    -- Button Click Event
    Button.MouseButton1Click:Connect(callback)
end

-- Buttons for Functionality
CreateButton("TP to Sterling", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ringtaa/sterlingnotifcation.github.io/refs/heads/main/Sterling.lua'))()
end, UDim2.new(0.1, 0, 0.4, 0))

CreateButton("TP to Train", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ringtaa/train.github.io/refs/heads/main/train.lua'))()
end, UDim2.new(0.1, 0, 0.7, 0))
