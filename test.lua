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

-- Function for bond collection
local function CollectBonds()
    while true do
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
                remote:FireServer(closestBond) -- Collect bond immediately if within 10 blocks
            elseif closestDistance <= maxDistance then
                humanoid:MoveTo(closestBond:GetModelCFrame().Position) -- Walk closer to bond within 500 blocks
                humanoid.MoveToFinished:Wait() -- Wait until the player reaches the bond
                remote:FireServer(closestBond) -- Collect bond after moving closer
                task.wait(walkDelay) -- Adds a small delay before moving to the next bond
            end
        else
            -- If no bonds are found, teleport to VampireCastle
            for i = 1, teleportCount do
                humanoidRootPart.CFrame = CFrame.new(teleportPosition)
                wait(0.1)
            end

            -- Handle VampireCastle interactions
            local vampireCastle = Workspace:FindFirstChild(vampireCastleName)
            if vampireCastle and vampireCastle.PrimaryPart then
                print("VampireCastle at:", vampireCastle.PrimaryPart.Position.Z)
                local closestGun = nil

                -- Search for MaximGun near VampireCastle
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
                        print("Seated on MaximGun.")
                        task.wait(2) -- Wait 2 seconds
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping) -- Jump out
                        enableNoclip()
                    else
                        warn("No VehicleSeat on MaximGun.")
                    end
                else
                    -- Handle fallback to a Chair
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
                        print("Seated on Chair at Z:", foundChair.Position.Z)
                        task.wait(2) -- Wait 2 seconds
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping) -- Jump out
                        enableNoclip()
                    else
                        warn("No MaximGun or Chair found near VampireCastle.")
                    end
                end
            else
                warn("VampireCastle missing or invalid PrimaryPart.")
            end
        end

        task.wait(0.1) -- Prevent rapid loop iteration
    end
end

-- Start bond collection in a separate thread
spawn(CollectBonds)

-- Disable collisions for character parts
RunService.Stepped:Connect(function()
    for _, descendant in pairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false
        end
    end
end)

-- Cannon tweening logic
for z = startZ, endZ, stepZ do
    if stopTweening then break end
    local adjustedY = math.max(y, 3)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local goal = {CFrame = CFrame.new(Vector3.new(x, adjustedY, z))}
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)
    tween:Play()
    tween.Completed:Wait()
    for _, item in pairs(Workspace:GetDescendants()) do
        if item:IsA("Model") and item.Name == "Cannon" then
            local vehicleSeat = item:FindFirstChild("VehicleSeat")
            if vehicleSeat then
                character:PivotTo(vehicleSeat.CFrame)
                vehicleSeat:Sit(humanoid)
                task.wait(2) -- Wait 2 seconds before jumping
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping) -- Jump out
                stopTweening = true
                break
            end
        end
    end
end

if not stopTweening then
    warn("No cannon with a seat found along the specified Z range.")
end
