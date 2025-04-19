local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")


local SPEED = 750


local function isUnicorn(model)
    return (
        model.Name:lower():find("unicorn") or
        model:FindFirstChild("Horn") or
        model:FindFirstChildWhichIsA("MeshPart") and model:FindFirstChildWhichIsA("MeshPart").Name:lower():find("unicorn")
    )
end

-- Scan Workspace for unicorns
local function scanForUnicorn()
    for _, descendant in pairs(Workspace:GetDescendants()) do
        if descendant:IsA("Model") and isUnicorn(descendant) then
            return descendant
        end
    end
    return nil
end


local function tweenToPosition(targetCFrame)
    local distance = (rootPart.Position - targetCFrame.Position).Magnitude
    local duration = distance / SPEED
    
    local tweenInfo = TweenInfo.new(
        duration,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out,
        0,
        false,
        0
    )
    
    local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    
    return tween
end


local function startHunting()
    local path = {
        
        CFrame.new(0, 5, 0),
        CFrame.new(1000, 5, 0),
        CFrame.new(2000, 5, 0),
        
    }
    
    for _, waypoint in ipairs(path) do
        local tween = tweenToPosition(waypoint)
        
        -- Check for unicorns while moving
        local connection
        connection = RunService.Heartbeat:Connect(function()
            local unicorn = scanForUnicorn()
            if unicorn then
                tween:Cancel()
                connection:Disconnect()
                warn("🦄 UNICORN FOUND AT:", unicorn:GetPivot().Position)
                return
            end
        end)
        
        tween.Completed:Wait()
        connection:Disconnect()
    end
    
    warn("Finished path. No unicorns found.")
end


startHunting()
