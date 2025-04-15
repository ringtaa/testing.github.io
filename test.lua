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

local visitedBanks = {} -- Tracks visited banks by their unique name
local visitedChairs = {} -- Tracks visited chairs by their unique name
local lastBankZ = nil -- Tracks the Z-coordinate of the last bank

-- Function to find the closest unvisited chair near a bank
local function findClosestChair(bank)
    local closestChair, closestDistance = nil, math.huge
    for _, chair in pairs(workspace.RuntimeItems:GetDescendants()) do
        if chair.Name == "Chair" and chair:FindFirstChild("Seat") and not visitedChairs[chair.Name] then
            local dist = (bank.PrimaryPart.Position - chair.Seat.Position).Magnitude
            if dist < closestDistance then
                closestChair, closestDistance = chair, dist
            end
        end
    end
    return closestChair
end

-- Function to find a new bank that is genuinely new and far enough away
local function findNewBank()
    for _, template in pairs({"MediumTownTemplate", "SmallTownTemplate", "LargeTownTemplate"}) do
        local town = workspace.Towns:FindFirstChild(template)
        local bank = town and town:FindFirstChild("Buildings") and town.Buildings:FindFirstChild("Bank")
        if bank and bank.PrimaryPart and not visitedBanks[bank.Name] then
            local bankZ = bank.PrimaryPart.Position.Z
            -- Ensure the bank is at least 5000 blocks away from the last processed bank
            if not lastBankZ or math.abs(bankZ - lastBankZ) >= 5000 then
                visitedBanks[bank.Name] = true -- Mark the bank as visited
                lastBankZ = bankZ -- Update the last processed Z-coordinate
                return bank -- Return the new bank
            end
        end
    end
    return nil -- No new banks found
end

-- Function to process the bank: teleport and attempt to sit 10 times
local function processNewBank(bank)
    print("Processing new bank at Z:", bank.PrimaryPart.Position.Z)
    for i = 1, 10 do
        print("Teleport attempt:", i)
        rootPart.CFrame = bank.PrimaryPart.CFrame -- Teleport to the bank's location
        local chair = findClosestChair(bank) -- Find a chair near the bank
        if chair then
            print("Sitting on a chair near bank:", bank.Name)
            visitedChairs[chair.Name] = true -- Mark the chair as visited
            rootPart.CFrame = chair:GetPivot()
            chair.Seat:Sit(character:WaitForChild("Humanoid"))
            print("Successfully sat down. Stopping script.") -- Stop script after sitting
            return -- Stop all further execution after sitting down
        else
            print("No unvisited chairs found near bank during attempt:", i)
        end
    end
    print("Finished 10 teleport attempts but couldn't sit on any chair.")
end

-- Function to move forward continuously until a new bank is found
local function moveToNextBank()
    local currentZ = rootPart.Position.Z
    print("Searching for a new bank...")

    while currentZ > -49000 do -- Keep moving forward until reaching -49k
        currentZ = currentZ - 2000 -- Move 2000 blocks per step
        local tween = TweenService:Create(rootPart, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {CFrame = CFrame.new(57, 3, currentZ)})
        tween:Play()
        tween.Completed:Wait() -- Wait for each tween to complete

        -- Check if a new bank is found
        local newBank = findNewBank()
        if newBank then
            print("Found a new bank at Z:", newBank.PrimaryPart.Position.Z)
            processNewBank(newBank) -- Process the new bank
            return -- Stop further movement after finding and processing the bank
        end
    end
    warn("Reached -49k Z position but no new banks were found.")
end

-- Execute the function to continuously move forward and process banks
moveToNextBank()
