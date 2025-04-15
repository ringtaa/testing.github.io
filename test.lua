local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Theme
local Theme = {
    Background = Color3.fromRGB(15, 15, 15),
    Background2 = Color3.fromRGB(25, 25, 25),
    Button = Color3.fromRGB(30, 30, 30),
    Text = Color3.fromRGB(255, 255, 255),
    Accent = Color3.fromRGB(255, 255, 255),
    Accent2 = Color3.fromRGB(200, 200, 200),
    ToggleOn = Color3.fromRGB(100, 255, 100),
    ToggleOff = Color3.fromRGB(255, 100, 100),
    TabActive = Color3.fromRGB(40, 40, 40),
    TabInactive = Color3.fromRGB(25, 25, 25),
    Stroke = Color3.fromRGB(60, 60, 60)
}

-- Main UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RingtasDeadRailsUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Background Gradient Effect
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 15)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
})
Gradient.Rotation = 45

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.10, 0, 0.5, -100)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false -- Start hidden
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Gradient:Clone().Parent = MainFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Theme.Stroke
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.3
UIStroke.Parent = MainFrame

-- Glow Effect
local Glow = Instance.new("ImageLabel")
Glow.Name = "Glow"
Glow.Image = "rbxassetid://5028857084"
Glow.ImageColor3 = Color3.fromRGB(50, 50, 50)
Glow.ScaleType = Enum.ScaleType.Slice
Glow.SliceCenter = Rect.new(24, 24, 276, 276)
Glow.SliceScale = 0.45
Glow.BackgroundTransparency = 1
Glow.Size = UDim2.new(1, 30, 1, 30)
Glow.Position = UDim2.new(0, -15, 0, -15)
Glow.ZIndex = -1
Glow.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Text = "Ringta's Dead Rails"
Title.Size = UDim2.new(1, -40, 0, 30)
Title.Position = UDim2.new(0, 15, 0, 5)
Title.BackgroundTransparency = 1
Title.TextColor3 = Theme.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Subtitle
local Subtitle = Instance.new("TextLabel")
Subtitle.Name = "Subtitle"
Subtitle.Text = "v1.0 | Gui"
Subtitle.Size = UDim2.new(1, -40, 0, 15)
Subtitle.Position = UDim2.new(0, 15, 0, 30)
Subtitle.BackgroundTransparency = 1
Subtitle.TextColor3 = Theme.Text
Subtitle.TextTransparency = 0.5
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 12
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = MainFrame

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Text = "×"
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0, 5)
CloseButton.BackgroundColor3 = Theme.Button
CloseButton.TextColor3 = Theme.Text
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 20
CloseButton.Parent = MainFrame

local CloseUICorner = Instance.new("UICorner")
CloseUICorner.CornerRadius = UDim.new(0, 6)
CloseUICorner.Parent = CloseButton

local CloseStroke = Instance.new("UIStroke")
CloseStroke.Color = Theme.Stroke
CloseStroke.Thickness = 1
CloseStroke.Transparency = 0.5
CloseStroke.Parent = CloseButton

-- Close button animations
CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 60, 60), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Button, TextColor3 = Theme.Text}):Play()
end)

CloseButton.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 300, 0, 0),
        Position = UDim2.new(0.10, 0, 0.5, 0)
    })
    tween:Play()
    tween.Completed:Wait()
    MainFrame.Visible = false
    
    -- Show reopen button only when closed
    local ReopenButton = Instance.new("TextButton")
    ReopenButton.Name = "ReopenButton"
    ReopenButton.Text = "Ringta's Dead Rails"
    ReopenButton.Size = UDim2.new(0, 150, 0, 30)
    ReopenButton.Position = UDim2.new(0, 10, 0, 10)
    ReopenButton.BackgroundColor3 = Theme.Button
    ReopenButton.TextColor3 = Theme.Text
    ReopenButton.Font = Enum.Font.GothamBold
    ReopenButton.TextSize = 14
    ReopenButton.Parent = ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = ReopenButton
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Stroke
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = ReopenButton
    
    -- Reopen button animations
    ReopenButton.MouseEnter:Connect(function()
        TweenService:Create(ReopenButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
    end)
    
    ReopenButton.MouseLeave:Connect(function()
        TweenService:Create(ReopenButton, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Button}):Play()
    end)
    
    ReopenButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 300, 0, 200),
            Position = UDim2.new(0.10, 0, 0.5, -100)
        })
        tween:Play()
        ReopenButton:Destroy()
    end)
end)

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Text = "-"
MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
MinimizeButton.Position = UDim2.new(1, -60, 0, 5)
MinimizeButton.BackgroundColor3 = Theme.Button
MinimizeButton.TextColor3 = Theme.Text
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 20
MinimizeButton.Parent = MainFrame

local MinimizeUICorner = Instance.new("UICorner")
MinimizeUICorner.CornerRadius = UDim.new(0, 6)
MinimizeUICorner.Parent = MinimizeButton

local MinimizeStroke = Instance.new("UIStroke")
MinimizeStroke.Color = Theme.Stroke
MinimizeStroke.Thickness = 1
MinimizeStroke.Transparency = 0.5
MinimizeStroke.Parent = MinimizeButton

-- Track minimized state
local isMinimized = false

-- Minimize button animations
MinimizeButton.MouseEnter:Connect(function()
    TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 255), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)

MinimizeButton.MouseLeave:Connect(function()
    TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Button, TextColor3 = Theme.Text}):Play()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    if isMinimized then
        -- Restore the window
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 300, 0, 200),
            Position = UDim2.new(0.10, 0, 0.5, -100)
        })
        tween:Play()
        MinimizeButton.Text = "-"
        isMinimized = false
        Subtitle.Visible = true
    else
        -- Minimize the window
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 300, 0, 40),
            Position = UDim2.new(0.10, 0, 0.5, -20)
        })
        tween:Play()
        MinimizeButton.Text = "+"
        isMinimized = true
        Subtitle.Visible = false
    end
end)

-- Divider with animation
local Divider = Instance.new("Frame")
Divider.Name = "Divider"
Divider.Size = UDim2.new(1, -30, 0, 1)
Divider.Position = UDim2.new(0, 15, 0, 50)
Divider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Divider.BorderSizePixel = 0
Divider.Parent = MainFrame

-- Tabs Container
local TabsContainer = Instance.new("Frame")
TabsContainer.Name = "TabsContainer"
TabsContainer.Size = UDim2.new(1, -30, 0, 30)
TabsContainer.Position = UDim2.new(0, 15, 0, 55)
TabsContainer.BackgroundTransparency = 1
TabsContainer.Parent = MainFrame

local TabsListLayout = Instance.new("UIListLayout")
TabsListLayout.FillDirection = Enum.FillDirection.Horizontal
TabsListLayout.Padding = UDim.new(0, 5)
TabsListLayout.Parent = TabsContainer

-- Tab Template
local function CreateTab(name)
    local Tab = Instance.new("TextButton")
    Tab.Name = name
    Tab.Text = name
    Tab.Size = UDim2.new(0.5, -5, 1, 0)
    Tab.BackgroundColor3 = Theme.TabInactive
    Tab.TextColor3 = Theme.Text
    Tab.Font = Enum.Font.GothamMedium
    Tab.TextSize = 14
    Tab.AutoButtonColor = false
    Tab.ZIndex = 2
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = Tab
    
    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Theme.Stroke
    ButtonStroke.Thickness = 1
    ButtonStroke.Transparency = 0.7
    ButtonStroke.Parent = Tab
    
    -- Hover animation
    Tab.MouseEnter:Connect(function()
        if Tab.BackgroundColor3 ~= Theme.TabActive then
            TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {Transparency = 0.3}):Play()
            TweenService:Create(Tab, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
        end
    end)
    
    -- Leave animation
    Tab.MouseLeave:Connect(function()
        if Tab.BackgroundColor3 ~= Theme.TabActive then
            TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {Transparency = 0.7}):Play()
            TweenService:Create(Tab, TweenInfo.new(0.2), {BackgroundColor3 = Theme.TabInactive}):Play()
        end
    end)
    
    -- Click animation
    Tab.MouseButton1Down:Connect(function()
        TweenService:Create(Tab, TweenInfo.new(0.1), {Size = UDim2.new(0.48, -5, 0.95, 0)}):Play()
    end)
    
    Tab.MouseButton1Up:Connect(function()
        TweenService:Create(Tab, TweenInfo.new(0.1), {Size = UDim2.new(0.5, -5, 1, 0)}):Play()
    end)
    
    return Tab
end

-- Create Latest Tab
local LatestTab = CreateTab("Latest")
LatestTab.Parent = TabsContainer

-- Create Old Tab
local OldTab = CreateTab("Old")
OldTab.Parent = TabsContainer

-- Scrollable Container for Latest Scripts
local LatestScriptsContainer = Instance.new("ScrollingFrame")
LatestScriptsContainer.Name = "LatestScriptsContainer"
LatestScriptsContainer.Size = UDim2.new(1, -30, 0, 110)
LatestScriptsContainer.Position = UDim2.new(0, 15, 0, 90)
LatestScriptsContainer.BackgroundTransparency = 1
LatestScriptsContainer.BorderSizePixel = 0
LatestScriptsContainer.ScrollBarThickness = 4
LatestScriptsContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
LatestScriptsContainer.ScrollingDirection = Enum.ScrollingDirection.Y
LatestScriptsContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
LatestScriptsContainer.Visible = true
LatestScriptsContainer.Parent = MainFrame

local LatestScriptsLayout = Instance.new("UIListLayout")
LatestScriptsLayout.Padding = UDim.new(0, 8)
LatestScriptsLayout.Parent = LatestScriptsContainer

-- Scrollable Container for Old Scripts
local OldScriptsContainer = Instance.new("ScrollingFrame")
OldScriptsContainer.Name = "OldScriptsContainer"
OldScriptsContainer.Size = UDim2.new(1, -30, 0, 110)
OldScriptsContainer.Position = UDim2.new(0, 15, 0, 90)
OldScriptsContainer.BackgroundTransparency = 1
OldScriptsContainer.BorderSizePixel = 0
OldScriptsContainer.ScrollBarThickness = 4
OldScriptsContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
OldScriptsContainer.ScrollingDirection = Enum.ScrollingDirection.Y
OldScriptsContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
OldScriptsContainer.Visible = false
OldScriptsContainer.Parent = MainFrame

local OldScriptsLayout = Instance.new("UIListLayout")
OldScriptsLayout.Padding = UDim.new(0, 8)
OldScriptsLayout.Parent = OldScriptsContainer

-- Button Template
local function CreateButton(text, callback)
    local Button = Instance.new("TextButton")
    Button.Name = text
    Button.Text = text
    Button.Size = UDim2.new(1, 0, 0, 36)
    Button.BackgroundColor3 = Theme.Button
    Button.TextColor3 = Theme.Text
    Button.Font = Enum.Font.GothamMedium
    Button.TextSize = 14
    Button.AutoButtonColor = false
    Button.ZIndex = 2
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = Button
    
    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Theme.Stroke
    ButtonStroke.Thickness = 1
    ButtonStroke.Transparency = 0.7
    ButtonStroke.Parent = Button
    
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
        -- Pulse effect on click
        TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {Transparency = 0.1, Thickness = 2}):Play()
        TweenService:Create(ButtonStroke, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Transparency = 0.7,
            Thickness = 1
        }):Play()
        
        callback()
    end)
    
    return Button
end

-- Castle Teleport Function
local function TeleportToCastle()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/castletpfast.github.io/refs/heads/main/FASTCASTLE.lua"))()
end

-- End Teleport Function
local function TeleportToEnd()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/gumanba/Scripts/refs/heads/main/DeadRails"))()
end

-- Fort Teleport Function
local function TeleportToFort()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/Tpfort.github.io/refs/heads/main/Tpfort.lua"))()
end

-- AFK AutoFarm Bond Function
local function AFKAutoFarmBond()
    _G['EndGameOnlyMode'] = true;
    script_key="your_key"; --replace your_key with your key.
    loadstring(game:HttpGet("https://raw.githubusercontent.com/NebulaHubOfc/Public/refs/heads/main/Loader.lua"))()
end

-- AFK AutoFarm Bond (No Key) Function
local function AFKAutoFarmBondNoKey()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/TwoGunVolley/Earlyfixed/refs/heads/main/Protected_1408189441085576.txt"))()
end

-- Create Castle Teleport Button
CreateButton("TP to Castle", TeleportToCastle).Parent = LatestScriptsContainer

-- Create End Teleport Button
CreateButton("TP to End", TeleportToEnd).Parent = LatestScriptsContainer

-- Create Fort Teleport Button
CreateButton("TP to Fort", TeleportToFort).Parent = LatestScriptsContainer

--Create AFK AutoFarm Bond Button
CreateButton("AFK AutoFarm Bond",AFKAutoFarmBond).Parent = OldScriptsContainer

--Create AFK AutoFarm Bond (No Key) Button
CreateButton("AFK AutoFarm Bond (No Key)", AFKAutoFarmBondNoKey).Parent = OldScriptsContainer

-- Initialize UI with animation
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.10, 0, 0.5, -100)
MainFrame.Visible = true

-- Keybind to toggle UI
UIS.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightControl then
        if MainFrame.Visible then
            if isMinimized then
                -- Restore from minimized state
                local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 300, 0, 200),
                    Position = UDim2.new(0.10, 0, 0.5, -100)
                })
                tween:Play()
                MinimizeButton.Text = "-"
                isMinimized = false
                Subtitle.Visible = true
            else
                -- Minimize
                local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 300, 0, 40),
                    Position = UDim2.new(0.10, 0, 0.5, -20)
                })
                tween:Play()
                MinimizeButton.Text = "+"
                isMinimized = true
                Subtitle.Visible = false
            end
        else
            -- Open from closed state
            MainFrame.Visible = true
            local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 300, 0, 200),
                Position = UDim2.new(0.10, 0, 0.5, -100)
            })
            tween:Play()
            isMinimized = false
            MinimizeButton.Text = "-"
            Subtitle.Visible = true
        end
    end
end)

-- Smooth dragging effect
local dragStartPos
local startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
        startPos = MainFrame.Position
        
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                connection:Disconnect()
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        if dragStartPos then
            local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStartPos
            local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            
            -- Smooth follow effect
            local tween = TweenService:Create(MainFrame, TweenInfo.new(0.1), {Position = newPos})
            tween:Play()
        end
    end
end)

MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragStartPos = nil
    end
end)

-- Subtle breathing animation for the glow
local breath = 0
RunService.Heartbeat:Connect(function(dt)
    breath = breath + dt * 0.5
    Glow.ImageTransparency = 0.7 + math.sin(breath) * 0.1
end)

-- Make the GUI visible when the script starts
MainFrame.Visible = true

-- Tab Switching Logic
local currentTab = LatestScriptsContainer

LatestTab.MouseButton1Click:Connect(function()
    if currentTab ~= LatestScriptsContainer then
        currentTab.Visible = false
        LatestScriptsContainer.Visible = true
        currentTab = LatestScriptsContainer
        LatestTab.BackgroundColor3 = Theme.TabActive
        OldTab.BackgroundColor3 = Theme.TabInactive
    end
end)

OldTab.MouseButton1Click:Connect(function()
    if currentTab ~= OldScriptsContainer then
        currentTab.Visible = false
        OldScriptsContainer.Visible = true
        currentTab = OldScriptsContainer
        OldTab.BackgroundColor3 = Theme.TabActive
        LatestTab.BackgroundColor3 = Theme.TabInactive
    end
end)
