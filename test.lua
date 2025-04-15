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

local visitedBanks = {} -- Track visited banks
local visitedChairs = {} -- Track visited chairs
local lastProcessedZ = nil -- Track Z-coordinate of the last processed bank
local teleportCount = 10 -- Maximum attempts to interact with chairs

-- Function to check if a bank is genuinely new and far enough from the last processed bank
local function isNewBank(bank)
    local bankZ = bank.PrimaryPart.Position.Z
    if not lastProcessedZ or math.abs(bankZ - lastProcessedZ) >= 5000 then
        return true -- Bank is new and far enough away
    else
        return false -- Bank is too close to the last processed one
    end
end

-- Function to find the closest unvisited chair near a bank
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

-- Function to process the bank and sit on one chair
local function processNewBank(bank)
    print("Processing new bank at Z:", bank.PrimaryPart.Position.Z)
    local chair = findClosestChair(bank)
    if chair then
        print("Sitting on a chair near bank:", bank.Name)
        visitedChairs[chair] = true -- Mark chair as visited
        rootPart.CFrame = chair:GetPivot()
        chair.Seat:Sit(character:WaitForChild("Humanoid"))
    else
        print("No unvisited chairs found near bank:", bank.Name)
    end
end

-- Function to search for a truly new bank and process it
local function findNewBank()
    for _, template in pairs({"MediumTownTemplate", "SmallTownTemplate", "LargeTownTemplate"}) do
        local town = workspace.Towns:FindFirstChild(template)
        local bank = town and town:FindFirstChild("Buildings") and town.Buildings:FindFirstChild("Bank")
        if bank and bank.PrimaryPart and not visitedBanks[bank] then
            if isNewBank(bank) then
                visitedBanks[bank] = true -- Mark the bank as visited
                lastProcessedZ = bank.PrimaryPart.Position.Z -- Update last processed Z-coordinate
                return bank -- Return the new bank
            end
        end
    end
    return nil -- No new banks found
end

-- Function to move forward at least 5000 blocks and search for a new bank
local function moveToNextBank()
    local currentZ = rootPart.Position.Z
    print("Moving forward at least 5000 blocks...")

    -- Ensure movement of at least 5000 blocks
    local targetZ = currentZ - 5000
    while currentZ > targetZ do
        currentZ = currentZ - 2000 -- Move 2000 blocks per step
        local tween = TweenService:Create(rootPart, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {CFrame = CFrame.new(57, 3, currentZ)})
        tween:Play()
        tween.Completed:Wait() -- Wait for the tween to complete
    end

    print("Searching for a new bank beyond 5000 blocks...")
    local newBank = findNewBank()
    if newBank then
        processNewBank(newBank) -- Process the new bank and sit on one chair
    else
        warn("No new banks found after moving forward 5000 blocks.")
    end
end

-- Execute the function to move forward and search for a new bank
moveToNextBank()
