local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local remote = ReplicatedStorage.Packages.RemotePromise.Remotes.CActivateObject

local maxDistance = 500 -- Only walk to bonds within 500 blocks
local collectDistance = 10 -- Collect bonds when within 10 blocks
local walkDelay = 0.1 -- Small delay between walking to bonds

local function GetNearestBond()
    local closestBond = nil
    local closestDistance = math.huge
    for , bond in pairs(Workspace.RuntimeItems:GetChildren()) do
        if bond:IsA("Model") and bond.Name:match("Bond") then
            local distance = (humanoidRootPart.Position - bond:GetModelCFrame().Position).Magnitude
            if distance < closestDistance then
                closestBond = bond
                closestDistance = distance
            end
        end
    end
    return closestBond, closestDistance
end

RunService.Heartbeat:Connect(function()
    local bond, distance = GetNearestBond()
    if bond then
        if distance <= collectDistance then
            remote:FireServer(bond) -- Collect bond immediately if within 10 blocks
        elseif distance <= maxDistance then
            humanoid:MoveTo(bond:GetModelCFrame().Position) -- Walk closer to bond within 500 blocks
            humanoid.MoveToFinished:Wait() -- Wait until the player reaches the bond
            remote:FireServer(bond) -- Collect bond after moving closer
            task.wait(walkDelay) -- Adds a small delay before moving to the next bond
        end
    end
end)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local x = 57
local y = 3
local startZ = 30000
local endZ = -49032.99
local stepZ = -2000
local duration = 0.5
local stopTweening = false

RunService.Stepped:Connect(function()
    for _, descendant in pairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false
        end
    end
end)

for z = startZ, endZ, stepZ do
    if stopTweening then break end
    local adjustedY = math.max(y, 3)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local goal = {CFrame = CFrame.new(Vector3.new(x, adjustedY, z))}
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)
    tween:Play()
    tween.Completed:Wait()
    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("Model") and item.Name == "Cannon" then
            local vehicleSeat = item:FindFirstChild("VehicleSeat")
            if vehicleSeat then
                character:PivotTo(vehicleSeat.CFrame)
                vehicleSeat:Sit(humanoid)
                task.wait(2) -- Waits 2 seconds before jumping
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping) -- Properly sets the jump state
                stopTweening = true
                break
            end
        end
    end
end

if not stopTweening then
    warn("No cannon with a seat found along the specified Z range.")
end
