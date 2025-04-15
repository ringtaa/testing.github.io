local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

RunService.Stepped:Connect(function()
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
end)

local visitedChairs = {} -- Tracks visited chairs by their unique name
local lastSittingZ = nil -- Stores the Z-coordinate of the last sitting location

-- Function to find the closest unvisited chair and ensure distance requirements
local function findClosestChair()
    local closestChair, closestDistance = nil, math.huge
    for _, chair in pairs(workspace.RuntimeItems:GetDescendants()) do
        if chair.Name == "Chair" and chair:FindFirstChild("Seat") and not visitedChairs[chair.Name] then
            local chairZ = chair.Seat.Position.Z
            -- Ensure the chair is at least 5000 blocks away from the last sitting location
            if not lastSittingZ or math.abs(chairZ - lastSittingZ) >= 5000 then
                local dist = (rootPart.Position - chair.Seat.Position).Magnitude
                if dist < closestDistance then
                    closestChair, closestDistance = chair, dist
                end
            end
        end
    end
    return closestChair
end

-- Function to move forward continuously and sit down
local function moveAndSit()
    local currentZ = rootPart.Position.Z
    print("Searching for a chair...")

    while currentZ > -49000 do -- Keep moving forward until reaching -49k
        currentZ = currentZ - 2000 -- Move 2000 blocks per step
        local tween = TweenService:Create(rootPart, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {CFrame = CFrame.new(57, 3, currentZ)})
        tween:Play()
        tween.Completed:Wait() -- Wait for the tween to complete

        -- Check for a valid chair at this position
        local chair = findClosestChair()
        if chair then
            print("Sitting on a chair at Z:", chair.Seat.Position.Z)
            visitedChairs[chair.Name] = true -- Mark the chair as visited
            lastSittingZ = chair.Seat.Position.Z -- Save the Z-coordinate of the sitting location
            rootPart.CFrame = chair:GetPivot()
            chair.Seat:Sit(character:WaitForChild("Humanoid"))
            return -- Stop execution immediately after sitting on the first chair
        end
    end
    warn("Reached -49k Z position but no valid chairs were found.")
end

-- Execute the function to move forward and sit down
moveAndSit()
