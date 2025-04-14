local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local remote = ReplicatedStorage.Packages.RemotePromise.Remotes.C_ActivateObject

-- Bond collection variables
local maxDistance = 500
local collectDistance = 10
local walkDelay = 0.1
local collectingBonds = true

-- Function to collect bonds
local function AreBondsNearby()
    for _, bond in pairs(Workspace.RuntimeItems:GetChildren()) do
        if bond:IsA("Model") and bond.Name:match("Bond") then
            local distance = (humanoidRootPart.Position - bond:GetModelCFrame().Position).Magnitude
            if distance <= maxDistance then
                return true
            end
        end
    end
    return false
end

local function CollectBonds()
    while collectingBonds do
        local closestBond = nil
        local closestDistance = math.huge
        for _, bond in pairs(Workspace.RuntimeItems:GetChildren()) do
            if bond:IsA("Model") and bond.Name:match("Bond") then
                local distance = (humanoidRootPart.Position - bond:GetModelCFrame().Position).Magnitude
                if distance < closestDistance then
                    closestBond = bond
                    closestDistance = distance
                end
            end
        end

        if closestBond then
            if closestDistance <= collectDistance then
                remote:FireServer(closestBond)
            elseif closestDistance <= maxDistance then
                humanoid:MoveTo(closestBond:GetModelCFrame().Position)
                humanoid.MoveToFinished:Wait()
                remote:FireServer(closestBond)
                task.wait(walkDelay)
            end
        end

        task.wait(0.1)
    end
end

-- Start bond collection
spawn(CollectBonds)

-- Disable collisions
RunService.Stepped:Connect(function()
    for _, descendant in pairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false
        end
    end
end)

-- Tween to Cannon
local x = 57
local y = 3
local startZ = 30000
local endZ = -49032.99
local stepZ = -2000
local duration = 0.5
local stopTweening = false

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
                task.wait(2)
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                stopTweening = true
                break
            end
        end
    end
end

if not stopTweening then
    warn("No cannon with a seat found along the specified Z range.")
end

-- Wait until no bonds are left near cannon
task.wait(5)
while AreBondsNearby() do
    task.wait(1)
end

-- Teleport to Vampire Castle
local teleportPosition = Vector3.new(57, 3, -9000)
for i = 1, 10 do
    humanoidRootPart.CFrame = CFrame.new(teleportPosition)
    task.wait(0.1)
end

-- Wait and jump to begin collection again
task.wait(3)
humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
