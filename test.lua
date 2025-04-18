local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Variables for step tweening
local x = 57
local y = 3
local startZ = 30000
local endZ = -49032.99
local stepZ = -2000
local duration = 0.5
local stopTweening = false
local unicornFound = false

-- Notification (Runs Concurrently)
spawn(function()
    StarterGui:SetCore("SendNotification", {
        Title = "RINGTA MADE THIS!",
        Text = "discord.gg/ringta",
        Icon = "rbxassetid://99581962287910",
        Duration = 15 -- Notification duration
    })
end)

-- Step-tweening logic to search for the Unicorn
for z = startZ, endZ, stepZ do
    if stopTweening then break end

    -- Tweening step
    humanoidRootPart.CFrame = CFrame.new(Vector3.new(x, y, z))
    task.wait(duration)

    -- Check for Unicorn
    local runtimeEntities = workspace:FindFirstChild("RuntimeEntities")
    if runtimeEntities then
        local unicorn = runtimeEntities:FindFirstChild("Unicorn")
        if unicorn and unicorn:IsA("Model") then
            local unicornSeat = workspace:FindFirstChild("Unicorn"):FindFirstChild("VehicleSeat")
            print("Unicorn found at:", unicorn.Position)
            unicornFound = true
            stopTweening = true
            break
        end
    end
end

-- Attempt to TP 10 times to sit on Unicorn's VehicleSeat
if unicornFound then
    local unicornSeat = workspace:FindFirstChild("Unicorn"):FindFirstChild("VehicleSeat")
    if unicornSeat then
        local seated = false
        for i = 1, 10 do
            humanoidRootPart.CFrame = CFrame.new(unicornSeat.Position)
            task.wait(0.1)
            if humanoid.SeatPart == unicornSeat then
                seated = true
                print("Seated on Unicorn's VehicleSeat after", i, "attempt(s)!")
                break
            end
        end
        if not seated then
            print("Failed to sit on Unicorn's VehicleSeat after 10 attempts. Finding fallback...")
        end
    else
        print("Unicorn has no VehicleSeat. Finding fallback...")
    end

    -- Fallback logic: Closest Horse or Chair
    if not humanoid.SeatPart then
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

        -- Sit on the fallback option
        if closestFallback then
            for i = 1, 10 do
                humanoidRootPart.CFrame = CFrame.new(closestFallback.Position)
                task.wait(0.1)
            end
            closestFallback:Sit(humanoid)
            print("Fallback seat selected! Seated on:", closestFallback.Name)
        else
            warn("No fallback seat or horse found!")
        end
    end
else
    warn("No Unicorn found during tweening!")
end
