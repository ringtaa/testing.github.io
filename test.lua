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

-- Vampire Castle variables
local teleportPosition = Vector3.new(57, 3, -9000)
local teleportCount = 10
local delayTime = 0.1

-- Function to get the nearest bond
local function GetNearestBond()
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

    return closestBond, closestDistance
end

-- Function to collect bonds infinitely
local function CollectBonds()
    while collectingBonds do
        local bond, distance = GetNearestBond()
        if bond then
            if distance <= collectDistance then
                remote:FireServer(bond) -- Collect bond if close enough
            elseif distance <= maxDistance then
                humanoid:MoveTo(bond:GetModelCFrame().Position) -- Move closer to bond
                humanoid.MoveToFinished:Wait() -- Wait for completion
                remote:FireServer(bond) -- Collect after moving closer
                task.wait(walkDelay)
            end
        else
            print("No bonds detected.")
        end

        task.wait(0.1) -- Avoid rapid iteration
    end
end

-- Function to enable noclip mode
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

-- Function to teleport and handle Vampire Castle logic
local function HandleVampireCastle()
    for i = 1, teleportCount do
        humanoidRootPart.CFrame = CFrame.new(teleportPosition)
        task.wait(delayTime)
    end

    local vampireCastle = Workspace:FindFirstChild("VampireCastle")
    if vampireCastle and vampireCastle.PrimaryPart then
        print("VampireCastle at Z:", vampireCastle.PrimaryPart.Position.Z)

        local closestGun
        for _, item in pairs(Workspace.RuntimeItems:GetDescendants()) do
            if item:IsA("Model") and item.Name == "MaximGun" then
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
                print("Seated on MaximGun.")
                task.wait(2) -- Wait 2 seconds
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping) -- Jump after sitting
                enableNoclip() -- Enable noclip
            else
                warn("No VehicleSeat on MaximGun.")
            end
        else
            local foundChair = nil
            for _, chair in pairs(Workspace.RuntimeItems:GetDescendants()) do
                if chair.Name == "Chair" then
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
                print("Seated on Chair at Z:", foundChair.Position.Z)
                task.wait(2) -- Wait 2 seconds
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping) -- Jump after sitting
                enableNoclip() -- Enable noclip
            else
                warn("No VampireCastle, MaximGun, or Chair found.")
            end
        end
    else
        warn("VampireCastle missing or invalid PrimaryPart.")
    end
end

-- Start infinite bond collection in a separate thread
spawn(CollectBonds)

-- Call Vampire Castle handler
HandleVampireCastle()
