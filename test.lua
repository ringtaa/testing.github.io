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

local visitedBanks = {}
local visitedChairs = {}

local teleportCount = 10 -- Maximum number of teleport attempts
local delayTime = 0.1 -- Delay between each teleportation

-- Function to find the closest unvisited chair near the current bank
local function findClosestChair(bank)
    local closestChair, closestDistance = nil, math.huge
    for _, chair in pairs(workspace.RuntimeItems:GetDescendants()) do
        if chair.Name == "Chair" and chair:FindFirstChild("Seat") and not visitedChairs[chair] then
            local dist = (bank.PrimaryPart.Position - chair.Seat.Position).Magnitude
            if dist < closestDistance then
                closestChair, closestDistance = chair, dist
            end
        end
    end
    return closestChair
end

-- Function to search for banks and chairs
local function searchForBankAndChair()
    for _, template in pairs({"MediumTownTemplate", "SmallTownTemplate", "LargeTownTemplate"}) do
        local town = workspace.Towns:FindFirstChild(template)
        local bank = town and town:FindFirstChild("Buildings") and town.Buildings:FindFirstChild("Bank")
        if bank and bank.PrimaryPart and not visitedBanks[bank] then
            visitedBanks[bank] = true

            -- Find the closest unvisited chair near the bank
            local chair = findClosestChair(bank)
            if chair then
                print("Found chair near bank:", bank.Name)
                visitedChairs[chair] = true -- Mark chair as visited
                rootPart.CFrame = chair:GetPivot()
                chair.Seat:Sit(character:WaitForChild("Humanoid"))
                return true -- Found a bank and chair
            else
                print("No unvisited chairs found near bank:", bank.Name)
            end
        end
    end
    return false -- No new banks or chairs found
end

-- Function to move to the next bank with extended tweening if necessary
local function moveToNextBank()
    local currentZ = rootPart.Position.Z -- Start from current Z position
    local attempts = 0 -- Count teleport attempts
    print("Attempting to find a new bank...") -- Debugging message

    while currentZ > -49000 and attempts < teleportCount do -- Limit teleport attempts and ensure movement until -49k
        attempts = attempts + 1
        currentZ = currentZ - 2000 -- Move 2000 blocks farther along the Z-axis
        local tween = TweenService:Create(rootPart, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {CFrame = CFrame.new(57, 3, currentZ)})
        tween:Play()
        tween.Completed:Wait() -- Wait for each tween to complete

        wait(delayTime) -- Delay between each teleportation

        -- Try to find a bank and chair after each movement
        if searchForBankAndChair() then
            return -- Stop if a new bank and chair are found
        end
    end
    warn("Reached -49k Z position or exceeded teleport attempts but no new banks or chairs were found.")
end

-- Execute the function to move to the next bank and chair
moveToNextBank()
