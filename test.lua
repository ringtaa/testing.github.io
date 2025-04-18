local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
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

-- Step-based tweening to search for Unicorn and fallback to Horses
for z = startZ, endZ, stepZ do
    if stopTweening then break end

    -- Tween smoothly to the next position
    tweenTo(Vector3.new(x, y, z), duration)

    -- Check for Unicorn in Workspace
    local unicorn = workspace:FindFirstChild("Unicorn")
    if unicorn and unicorn:IsA("Model") then
        local unicornSeat = unicorn:FindFirstChild("VehicleSeat")
        logEntity("Unicorn", unicorn.PrimaryPart.Position)

        if unicornSeat then
            unicornFound = true
            stopTweening = true

            -- Sit on the Unicorn's seat immediately
            tweenTo(unicornSeat.Position, duration)
            unicornSeat:Sit(humanoid)
            print("Successfully seated on Unicorn!")
            break
        else
            print("Unicorn does not have a seat. Proceeding to fallback...")
            unicornFound = true
            stopTweening = true
            break
        end
    end

    -- Check for Horses in Workspace.Model_Horse
    local horseWorkspace = workspace:FindFirstChild("Model_Horse")
    if horseWorkspace then
        for _, vehicleSeat in pairs(horseWorkspace:GetChildren()) do
            if vehicleSeat:IsA("VehicleSeat") then
                logEntity("Horse", vehicleSeat.Position)
            end
        end
    end
end

-- Fallback Logic: Closest Horse or Chair
if not unicornFound then
    print("No Unicorn found during tweening. Searching for fallback options...")

    local horseWorkspace = workspace:FindFirstChild("Model_Horse")
    local closestFallback = nil
    local fallbackDistance = math.huge

    -- Search for horses with VehicleSeats in Workspace.Model_Horse
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

    -- Sit on the fallback option
    if closestFallback then
        tweenTo(closestFallback.Position, duration)
        closestFallback:Sit(humanoid)
        print("Fallback seat selected! Seated on:", closestFallback.Name)
    else
        warn("No fallback seat or horse found!")
    end
end
