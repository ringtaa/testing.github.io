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
MainFrame.Size = UDim2.new(0, 350, 0, 230) -- Updated length
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
    hue = (hue + 0.005) % 1 -- Increase 0.005 to make it faster. Decrease for slower
    frameOutline.Color = Color3.fromHSV(hue, 1, 1) -- The second value is Saturation, and the last value is Value or brightness. bro pls add me as UI Designer
end) -- Loop
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", MainFrame)
Title.Text, Title.Size, Title.Position = "RINGTA SCRIPTS", UDim2.new(1, -20, 0, 20), UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency, Title.TextColor3, Title.Font, Title.TextSize = 1, Theme.Text, Enum.Font.GothamBold, 14

-- Minimize Button
local MinimizeButton = Instance.new("TextButton", MainFrame)
MinimizeButton.Text, MinimizeButton.Size, MinimizeButton.Position = "-", UDim2.new(0, 20, 0, 20), UDim2.new(1, -25, 0, 5)
MinimizeButton.BackgroundColor3, MinimizeButton.TextColor3 = Theme.Button, Theme.Text
Instance.new("UICorner", MinimizeButton).CornerRadius = UDim.new(0, 6)

-- Reopen Button (Hidden When UI is Minimized)
local ReopenButton = Instance.new("TextButton", ScreenGui)
ReopenButton.Text, ReopenButton.Size, ReopenButton.Position = "Open RINGTA SCRIPTS", UDim2.new(0, 150, 0, 30), UDim2.new(0.5, 0, 0, -22)
ReopenButton.AnchorPoint, ReopenButton.Visible = Vector2.new(0.5, 0), false
ReopenButton.BackgroundColor3, ReopenButton.TextColor3 = Theme.Button, Theme.Text
Instance.new("UICorner", ReopenButton).CornerRadius = UDim.new(0, 6)

-- Dragging State
local isMinimized = false
local dragging, dragInput, dragStart, startPos

-- Improved Drag Functionality (Supports Mouse and Touch)
local function updateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

Title.InputBegan:Connect(function(input)
    if not isMinimized and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
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

Title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- Minimize Functionality
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = true -- Disable dragging when minimized
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, -0.7, 0), -- MUCH higher top-middle position
        Size = UDim2.new(0, 250, 0, 50)        -- Shrinks size
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
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0, 170), -- Restores original position
        Size = UDim2.new(0, 350, 0, 230)      -- Restores original size
    }):Play()
end)

-- Button Template
local function CreateButton(text, callback, position)
    local Button = Instance.new("TextButton", MainFrame)
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

-- Buttons for Functionality
CreateButton("TP to Train", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ringtaa/train.github.io/refs/heads/main/train.lua'))()
end, UDim2.new(0.1, 0, 0.2, 0))

CreateButton("TP to Sterling", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ringtaa/sterlingnotifcation.github.io/refs/heads/main/Sterling.lua'))()
end, UDim2.new(0.1, 0, 0.34, 0))

CreateButton("TP to TeslaLab", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ringtaa/tptotesla.github.io/refs/heads/main/Tptotesla.lua'))()
end, UDim2.new(0.1, 0, 0.48, 0))

CreateButton("TP to Castle", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/castletpfast.github.io/refs/heads/main/FASTCASTLE.lua"))()
end, UDim2.new(0.1, 0, 0.62, 0))

CreateButton("TP to Fort", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/Tpfort.github.io/refs/heads/main/Tpfort.lua"))()
end, UDim2.new(0.1, 0, 0.76, 0))
