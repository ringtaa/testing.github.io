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

local visitedBanks = {} -- List of all visited banks
local visitedChairs = {} -- List of all visited chairs
local lastProcessedZ = nil -- Keep track of the Z-coordinate of the last processed bank
local teleportCount = 10 -- Number of ticks to try sitting on chairs
local delayTime = 0.1 -- Delay between ticks

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

-- Function to find a new bank, ensuring it's 5000 blocks away from the last processed Z
local function findNewBank(currentZ)
    for _, template in pairs({"MediumTownTemplate", "SmallTownTemplate", "LargeTownTemplate"}) do
        local town = workspace.Towns:FindFirstChild(template)
        local bank = town and town:FindFirstChild("Buildings") and town.Buildings:FindFirstChild("Bank")
        if bank and bank.PrimaryPart and not visitedBanks[bank] then
            local bankZ = bank.PrimaryPart.Position.Z
            -- Ensure the bank is at least 5000 blocks farther along the Z-axis
            if not lastProcessedZ or math.abs(bankZ - lastProcessedZ) >= 5000 then
                visitedBanks[bank] = true -- Mark the bank as visited
                lastProcessedZ = bankZ -- Update the last processed Z-coordinate
                return bank -- Return the new bank
            end
        end
    end
    return nil -- No new bank found
end

-- Function to tick on the spot at a new bank and sit on one chair
local function processNewBank(bank)
    print("Processing new bank at Z:", bank.PrimaryPart.Position.Z)
    for i = 1, teleportCount do
        local chair = findClosestChair(bank)
        if chair then
            print("Attempting to sit on chair near bank:", bank.Name)
            visitedChairs[chair] = true -- Mark the chair as visited
            rootPart.CFrame = chair:GetPivot()
            chair.Seat:Sit(character:WaitForChild("Humanoid"))
            return -- Stop after sitting on one chair
        else
            print("No unvisited chairs found near bank during attempt:", i)
            wait(delayTime) -- Wait before the next tick
        end
    end
end

-- Function to move forward and find a new bank
local function moveToNextBank()
    local currentZ = rootPart.Position.Z
    print("Searching for a new bank...")

    while currentZ > -49000 do -- Keep moving forward until reaching -49k
        currentZ = currentZ - 2000 -- Incrementally move 2000 blocks forward
        local tween = TweenService:Create(rootPart, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {CFrame = CFrame.new(57, 3, currentZ)})
        tween:Play()
        tween.Completed:Wait() -- Wait for each tween to complete

        -- Check if a new bank is found
        local newBank = findNewBank(currentZ)
        if newBank then
            processNewBank(newBank) -- Process the new bank and its chairs
            return -- Stop further movement
        end
    end
    warn("No new banks found before reaching -49k.")
end

-- Execute the function to search for and process a new bank
moveToNextBank()
