local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid", 5)
local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)

if not humanoid or not humanoidRootPart then
    error("Character is missing Humanoid or HumanoidRootPart!")
end

local remote = ReplicatedStorage.Packages.RemotePromise.Remotes:FindFirstChild("C_ActivateObject")
assert(remote, "Remote function C_ActivateObject not found!")

-- Bond collection variables
local maxDistance = 500 -- Only walk to bonds within 500 blocks
local collectDistance = 10 -- Collect bonds when within 10 blocks
local walkDelay = 0.1 -- Small delay between walking to bonds

-- Cannon tweening variables
local x = 57
local y = 3
local startZ = 30000
local endZ = -49032.99
local stepZ = -2000
local duration = 0.5
local stopTweening = false

-- Vampire Castle variables
local teleportPosition = Vector3.new(57, 3, -9000)
local teleportCount = 10
local delayTime = 0.1
local vampireCastleName = "VampireCastle"
local maximGunName = "MaximGun"
local chairName = "Chair"

-- Enable noclip mode function
local function enableNoclip()
    RunService.Stepped:Connect(function()
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
    print("Noclip mode enabled.")
end

-- Function for infinite bond collection
local function CollectBonds()
    while true do
        local bondFolder = Workspace:FindFirstChild("RuntimeItems")
        if not bondFolder then
            print("RuntimeItems folder not found in Workspace! Retrying...")
            task.wait(1)
            continue
        end

        local closestBond = nil
        local closestDistance = math.huge
        for _, bond in pairs(bondFolder:GetChildren()) do
            if bond:IsA("Model") and bond.Name:match("Bond") then
                local distance = (humanoidRootPart.Position - bond:GetModelCFrame().Position).Magnitude
                if distance < closestDistance then
                    closestBond = bond
                    closestDistance = distance
                end
            end
        end

        if closestBond then
            print("Found bond:", closestBond.Name, "Distance:", closestDistance)
            if closestDistance <= collectDistance then
                print("Collecting bond:", closestBond.Name)
                remote:FireServer(closestBond)
            elseif closestDistance <= maxDistance then
                humanoid:MoveTo(closestBond:GetModelCFrame().Position)
                humanoid.MoveToFinished:Wait()
                remote:FireServer(closestBond)
                task.wait(walkDelay)
            end
        else
            print("No bonds found in current area.")
            break -- Exit loop if no bonds are found
        end

        task.wait(0.1)
    end
end

-- Function for cannon detection during tweening
local function FindCannonWhileTweening()
    for z = startZ, endZ, stepZ do
        if stopTweening then break end

        -- Tweening to next position
        local goalPosition = Vector3.new(x, y, z)
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        local tween = TweenService:Create(humanoidRootPart, tweenInfo, { CFrame = CFrame.new(goalPosition) })
        tween:Play()
        tween.Completed:Wait()

        -- Check for cannon
        local cannon = nil
        for _, item in pairs(Workspace:GetDescendants()) do
            if item:IsA("Model") and item.Name == "Cannon" then
                cannon = item
                break
            end
        end

        if cannon then
            local seat = cannon:FindFirstChild("VehicleSeat")
            if seat then
                print("Cannon found! Sitting on VehicleSeat.")
                character:PivotTo(seat.CFrame)
                seat:Sit(humanoid)
                task.wait(2)
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                spawn(CollectBonds) -- Resume bond collection
                stopTweening = true
                break
            end
        end
    end
end

-- Function for Vampire Castle logic
local function TeleportToVampireCastle()
    for i = 1, teleportCount do
        humanoidRootPart.CFrame = CFrame.new(teleportPosition)
        task.wait(delayTime)
    end

    local vampireCastle = Workspace:FindFirstChild(vampireCastleName)
    if vampireCastle and vampireCastle.PrimaryPart then
        local closestGun = nil

        -- Search for MaximGun near the castle
        for _, item in pairs(Workspace.RuntimeItems:GetDescendants()) do
            if item:IsA("Model") and item.Name == maximGunName then
                local dist = (item.PrimaryPart.Position - vampireCastle.PrimaryPart.Position).Magnitude
                if dist <= 500 then
                    closestGun = item
                    break
                end
            end
        end

        if closestGun then
            local seat = closestGun:FindFirstChild("VehicleSeat")
            if seat then
                character:PivotTo(seat.CFrame)
                seat:Sit(humanoid)
                task.wait(2)
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                spawn(CollectBonds) -- Resume bond collection
                enableNoclip()
            else
                warn("No VehicleSeat on MaximGun.")
            end
        else
            -- Fallback to chair if no MaximGun is found
            local foundChair = nil
            for _, chair in pairs(Workspace.RuntimeItems:GetDescendants()) do
                if chair.Name == chairName then
                    local seat = chair:FindFirstChild("Seat")
                    if seat and seat.Position.Z >= -9500 and seat.Position.Z <= -9000 then
                        foundChair = seat
                        break
                    end
                end
            end

            if foundChair then
                character:PivotTo(foundChair.CFrame)
                foundChair:Sit(humanoid)
                task.wait(2)
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                spawn(CollectBonds) -- Resume bond collection
                enableNoclip()
            else
                warn("No VampireCastle, MaximGun, or Chair found!")
            end
        end
    else
        warn("VampireCastle missing or invalid PrimaryPart!")
    end
end

-- Start bond collection and cannon search
spawn(CollectBonds)
FindCannonWhileTweening()
TeleportToVampireCastle()
