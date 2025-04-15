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
local lastProcessedZ = nil -- Track the Z-coordinate of the last processed bank
local teleportCount = 10 -- Number of ticks to try sitting on chairs

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

-- Function to find a new bank that's at least 5000 blocks away from the last processed Z
local function findNewBank()
    for _, template in pairs({"MediumTownTemplate", "SmallTownTemplate", "LargeTownTemplate"}) do
        local town = workspace.Towns:FindFirstChild(template)
        local bank = town and town:FindFirstChild("Buildings") and town.Buildings:FindFirstChild("Bank")
        if bank and bank.PrimaryPart and not visitedBanks[bank] then
            local bankZ = bank.PrimaryPart.Position.Z
            -- Ensure the bank is at least 5000 blocks away
            if not lastProcessedZ or math.abs(bankZ - lastProcessedZ) >= 5000 then
                visitedBanks[bank] = true -- Mark the bank as visited
                lastProcessedZ = bankZ -- Update last processed Z-coordinate
                return bank -- Return the new bank
            end
        end
    end
    return nil -- No new banks found
end

-- Function to process a new bank and sit on one chair
local function processNewBank(bank)
    print("Processing new bank at Z:", bank.PrimaryPart.Position.Z)
    local chair = findClosestChair(bank)
    if chair then
        print("Sitting on a chair near bank:", bank.Name)
        visitedChairs[chair] = true -- Mark the chair as visited
        rootPart.CFrame = chair:GetPivot()
        chair.Seat:Sit(character:WaitForChild("Humanoid"))
    else
        print("No unvisited chairs found near bank:", bank.Name)
    end
end

-- Function to tween for at least 5 seconds before processing a bank
local function tweenForFiveSeconds()
    local startTime = tick() -- Start the timer
    local currentZ = rootPart.Position.Z -- Start from current Z position

    while (tick() - startTime) < 5 do -- Continue tweening for at least 5 seconds
        currentZ = currentZ - 2000 -- Move 2000 blocks farther along the Z-axis
        local tween = TweenService:Create(rootPart, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {CFrame = CFrame.new(57, 3, currentZ)})
        tween:Play()
        tween.Completed:Wait() -- Wait for the tween to complete
    end
    return currentZ -- Return the final Z position after tweening
end

-- Function to move forward and process a new bank
local function moveToNextBank()
    print("Searching for a new bank...")
    local finalZ = tweenForFiveSeconds() -- Tween for 5 seconds first
    local newBank = findNewBank() -- Search for a new bank after tweening
    if newBank then
        processNewBank(newBank) -- Process the found bank and sit on one chair
    else
        warn("No new banks found after 5 seconds of tweening.")
    end
end

-- Execute the function to search for and process a new bank
moveToNextBank()
