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

-- Function to find the closest chair near the current bank
local function findClosestChair(bank)
    local closestChair, closestDistance = nil, math.huge
    for _, chair in pairs(workspace.RuntimeItems:GetDescendants()) do
        if chair.Name == "Chair" and chair:FindFirstChild("Seat") then
            local dist = (bank.PrimaryPart.Position - chair.Seat.Position).Magnitude
            if dist < closestDistance then
                closestChair, closestDistance = chair, dist
            end
        end
    end
    return closestChair
end

-- Function to move to the next bank and force a larger tween distance
local function moveToNextBank()
    local lastZ = rootPart.Position.Z -- Track the last Z position
    for z = lastZ - 3000, -49032.99, -2000 do -- Ensure minimum 3000-block movement
        print("Tweening to Z:", z) -- Debugging message
        local tween = TweenService:Create(rootPart, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {CFrame = CFrame.new(57, 3, z)})
        tween:Play()
        tween.Completed:Wait() -- Wait for the tween to complete before searching

        for _, template in pairs({"MediumTownTemplate", "SmallTownTemplate", "LargeTownTemplate"}) do
            local town = workspace.Towns:FindFirstChild(template)
            local bank = town and town:FindFirstChild("Buildings") and town.Buildings:FindFirstChild("Bank")
            if bank and bank.PrimaryPart and not visitedBanks[bank] then
                visitedBanks[bank] = true

                -- Find the closest chair near the bank
                local chair = findClosestChair(bank)
                if chair then
                    print("Found chair near bank:", bank.Name)
                    rootPart.CFrame = chair:GetPivot()
                    chair.Seat:Sit(character:WaitForChild("Humanoid"))
                    return -- Stop after successfully finding and sitting on a chair
                else
                    print("No chairs found near bank:", bank.Name)
                end
            end
        end
    end
    warn("No more banks or chairs to visit.")
end

-- Execute the function to move to the next bank and chair
moveToNextBank()
