local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Variables for tweening along Z-coordinate
local x = 57
local y = 3
local startZ = 30000
local endZ = -49032.99
local stepZ = -2000
local duration = 0.5
local stopTweening = false
local unicornFound = false

-- Unique logging table
local loggedEntities = {}

-- Function for tweening
local function tweenTo(targetPosition, duration)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local goal = {CFrame = CFrame.new(targetPosition)}
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)
    tween:Play()
    tween.Completed:Wait()
end

-- Helper function to log unique entities
local function logEntity(name, position)
    local roundedX = math.floor(position.X)
    local roundedY = math.floor(position.Y)
    local roundedZ = math.floor(position.Z)
    local key = name .. "_" .. roundedX .. "_" .. roundedY .. "_" .. roundedZ

    if not loggedEntities[key] then
        print(name, "found at coordinates: X =", roundedX, "Y =", roundedY, "Z =", roundedZ)
        loggedEntities[key] = true
    end
end

-- Step-based tweening to search for Unicorn and Horses
for z = startZ, endZ, stepZ do
    if stopTweening then break end

    -- Tween smoothly to the next position
    tweenTo(Vector3.new(x, y, z), duration)

    -- Check for Unicorn in RuntimeEntities
    local runtimeEntities = workspace:FindFirstChild("RuntimeEntities")
    if runtimeEntities then
        local unicorn = runtimeEntities:FindFirstChild("Unicorn")
        if unicorn and unicorn:IsA("Model") then
            logEntity("Unicorn", unicorn.PrimaryPart.Position)
            local unicornSeat = workspace:FindFirstChild("Unicorn"):FindFirstChild("VehicleSeat")
            if unicornSeat then
                unicornFound = true
                stopTweening = true

                -- Attempt to sit on Unicorn's seat immediately
                tweenTo(unicornSeat.Position, duration)
                unicornSeat:Sit(player.Character.Humanoid)
                print("Successfully seated on Unicorn!")
            else
                print("Unicorn has no seat. Proceeding to fallback...")
                unicornFound = true
                stopTweening = true
                break
            end
        end
    end

    -- Check for Horses in RuntimeEntities.Model_Horse
    local horseWorkspace = runtimeEntities:FindFirstChild("Model_Horse")
    if horseWorkspace then
        for _, horse in pairs(horseWorkspace:GetChildren()) do
            if horse:IsA("VehicleSeat") then
                logEntity("Horse", horse.Position)
            end
        end
    end

    -- Check for Horses in ReplicatedStorage.Assets.Entities.Animals.Horse.Animations.Model_Horse
    local replicatedHorseWorkspace = ReplicatedStorage:FindFirstChild("Assets")
    if replicatedHorseWorkspace then
        replicatedHorseWorkspace = replicatedHorseWorkspace:FindFirstChild("Entities")
        if replicatedHorseWorkspace then
            replicatedHorseWorkspace = replicatedHorseWorkspace:FindFirstChild("Animals")
            if replicatedHorseWorkspace then
                replicatedHorseWorkspace = replicatedHorseWorkspace:FindFirstChild("Horse")
                if replicatedHorseWorkspace then
                    replicatedHorseWorkspace = replicatedHorseWorkspace:FindFirstChild("Animations")
                    if replicatedHorseWorkspace then
                        replicatedHorseWorkspace = replicatedHorseWorkspace:FindFirstChild("Model_Horse")
                        if replicatedHorseWorkspace then
                            for _, horse in pairs(replicatedHorseWorkspace:GetChildren()) do
                                if horse:IsA("VehicleSeat") then
                                    logEntity("Horse", horse.Position)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Fallback Logic: Closest Horse or Chair
if not unicornFound then
    print("No Unicorn found during tweening. Searching for fallback options...")

    local horseWorkspace = workspace:FindFirstChild("RuntimeEntities"):FindFirstChild("Model_Horse")
    local chairWorkspace = workspace:FindFirstChild("RuntimeItems")
    local closestFallback = nil
    local fallbackDistance = math.huge

    -- Search for horses with VehicleSeats in RuntimeEntities
    if horseWorkspace then
        for _, vehicleSeat in pairs(horseWorkspace:GetChildren()) do
            if vehicleSeat:IsA("VehicleSeat") then
                local distance = (humanoidRootPart.Position - vehicleSeat.Position).Magnitude
                if distance < fallbackDistance then
                    closestFallback = vehicleSeat
                    fallbackDistance = distance
                end
            end
        end
    end

    -- Search for horses in ReplicatedStorage
    local replicatedHorseWorkspace = ReplicatedStorage:FindFirstChild("Assets")
    if replicatedHorseWorkspace then
        replicatedHorseWorkspace = replicatedHorseWorkspace:FindFirstChild("Entities")
        if replicatedHorseWorkspace then
            replicatedHorseWorkspace = replicatedHorseWorkspace:FindFirstChild("Animals")
            if replicatedHorseWorkspace then
                replicatedHorseWorkspace = replicatedHorseWorkspace:FindFirstChild("Horse")
                if replicatedHorseWorkspace then
                    replicatedHorseWorkspace = replicatedHorseWorkspace:FindFirstChild("Animations")
                    if replicatedHorseWorkspace then
                        replicatedHorseWorkspace = replicatedHorseWorkspace:FindFirstChild("Model_Horse")
                        if replicatedHorseWorkspace then
                            for _, vehicleSeat in pairs(replicatedHorseWorkspace:GetChildren()) do
                                if vehicleSeat:IsA("VehicleSeat") then
                                    local distance = (humanoidRootPart.Position - vehicleSeat.Position).Magnitude
                                    if distance < fallbackDistance then
                                        closestFallback = vehicleSeat
                                        fallbackDistance = distance
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- Search for chairs in RuntimeItems.Chair.Seat
    if chairWorkspace then
        for _, chair in pairs(chairWorkspace:GetChildren()) do
            if chair.Name == "Chair" then
                local seat = chair:FindFirstChild("Seat")
                if seat then
                    local distance = (humanoidRootPart.Position - seat.Position).Magnitude
                    if distance < fallbackDistance then
                        closestFallback = seat
                        fallbackDistance = distance
                    end
                end
            end
        end
    end

    -- Tween to the fallback option and sit
    if closestFallback then
        tweenTo(closestFallback.Position, duration)
        closestFallback:Sit(player.Character.Humanoid)
        print("Fallback seat selected! Seated on:", closestFallback.Name)
    else
        warn("No fallback seat or horse found!")
    end
end
