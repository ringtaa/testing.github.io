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

-- Function to move to the next bank
local function moveToNextBank()
    local startTime = tick() -- Record the start time
    local currentZ = rootPart.Position.Z -- Track the current Z position

    print("Tweening for at least 5 seconds...") -- Debugging message
    repeat
        currentZ = currentZ - 1500 -- Incrementally move 1500 blocks farther along the Z-axis
        local tween = TweenService:Create(rootPart, TweenInfo.new(1, Enum.EasingStyle.Linear), {CFrame = CFrame.new(57, 3, currentZ)})
        tween:Play()
        tween.Completed:Wait() -- Wait for each tween to complete
    until (tick() - startTime) >= 5 -- Ensure minimum 5 seconds of tweening

    -- Search for banks and chairs after completing the required tweening
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
                return -- Stop after successfully finding and sitting on a chair
            else
                print("No unvisited chairs found near bank:", bank.Name)
            end
        end
    end
    warn("No more banks or chairs to visit.")
end

-- Execute the function to move to the next bank and chair
moveToNextBank()
