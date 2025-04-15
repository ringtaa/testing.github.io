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
local excludedZones = {} -- Keeps track of Z-coordinates to avoid within 5000 blocks
local teleportCount = 10 -- Maximum attempts to find nearby chairs
local delayTime = 0.1 -- Delay between chair attempts

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

-- Function to search for banks and chairs while excluding zones within 5000 blocks
local function searchForBankAndChair(currentZ)
    for _, template in pairs({"MediumTownTemplate", "SmallTownTemplate", "LargeTownTemplate"}) do
        local town = workspace.Towns:FindFirstChild(template)
        local bank = town and town:FindFirstChild("Buildings") and town.Buildings:FindFirstChild("Bank")
        if bank and bank.PrimaryPart and not visitedBanks[bank] then
            -- Check if this bank's Z-coordinate is in an excluded zone
            local bankZ = bank.PrimaryPart.Position.Z
            local isExcluded = false
            for _, zone in pairs(excludedZones) do
                if math.abs(bankZ - zone) <= 5000 then
                    isExcluded = true
                    break
                end
            end

            if not isExcluded then
                visitedBanks[bank] = true
                table.insert(excludedZones, bankZ) -- Save this bank's Z-coordinate as an excluded zone
                print("Found NEW bank at Z:", bankZ)

                -- Iterate nearby chairs and attempt to sit
                for i = 1, teleportCount do
                    local chair = findClosestChair(bank)
                    if chair then
                        print("Attempt " .. i .. ": Sitting on chair near bank:", bank.Name)
                        visitedChairs[chair] = true -- Mark chair as visited
                        rootPart.CFrame = chair:GetPivot()
                        chair.Seat:Sit(character:WaitForChild("Humanoid"))
                        wait(delayTime) -- Delay between chair attempts
                    else
                        print("No unvisited chairs found during attempt:", i)
                    end
                end
                return true -- Successfully found a new bank
            else
                print("Bank at Z:", bankZ, "is in an excluded zone. Skipping.")
            end
        end
    end
    return false -- No new banks found
end

-- Function to move forward until a NEW bank is found
local function moveToNextBank()
    local currentZ = rootPart.Position.Z
    print("Attempting to find a new bank...")

    while currentZ > -49000 do -- Keep moving forward until reaching -49k
        currentZ = currentZ - 2000 -- Move 2000 blocks farther along the Z-axis
        local tween = TweenService:Create(rootPart, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {CFrame = CFrame.new(57, 3, currentZ)})
        tween:Play()
        tween.Completed:Wait() -- Wait for each tween to complete

        -- Check for a new bank at this position
        if searchForBankAndChair(currentZ) then
            return -- Stop if a new bank is found and processed
        end
        print("Continuing to search for a new bank...")
    end
    warn("Reached -49k Z position but no new banks were found.")
end

-- Execute the function to move forward and process banks
moveToNextBank()
