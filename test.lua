local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

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

-- Function for tweening
local function tweenTo(targetPosition, duration)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local goal = {CFrame = CFrame.new(targetPosition)}
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)
    tween:Play()
    tween.Completed:Wait()
end

-- Step-based tweening to search for Unicorn and Horses
for z = startZ, endZ, stepZ do
    if stopTweening then break end

    -- Tween smoothly to the next position
    tweenTo(Vector3.new(x, y, z), duration)

    -- Check for Unicorn
    local runtimeEntities = workspace:FindFirstChild("RuntimeEntities")
    if runtimeEntities then
        local unicorn = runtimeEntities:FindFirstChild("Unicorn")
        if unicorn and unicorn:IsA("Model") then
            local unicornSeat = workspace:FindFirstChild("Unicorn"):FindFirstChild("VehicleSeat")
            print("Unicorn found at coordinates: X:", unicorn.PrimaryPart.Position.X, "Y:", unicorn.PrimaryPart.Position.Y, "Z:", unicorn.PrimaryPart.Position.Z)
            unicornFound = true
            stopTweening = true

            -- Attempt to sit on Unicorn's seat immediately
            if unicornSeat then
                tweenTo(unicornSeat.Position, duration)
                unicornSeat:Sit(player.Character.Humanoid)
                print("Successfully seated on Unicorn!")
            else
                print("Unicorn has no seat. Proceeding to fallback...")
            end
            break
        end

        -- Check for Horses
        local horseWorkspace = runtimeEntities:FindFirstChild("Model_Horse")
        if horseWorkspace then
            for _, horse in pairs(horseWorkspace:GetChildren()) do
                if horse:IsA("VehicleSeat") then
                    print("Horse found at coordinates: X:", horse.Position.X, "Y:", horse.Position.Y, "Z:", horse.Position.Z)
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

    -- Search for horses with VehicleSeats
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
