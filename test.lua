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
local lastProcessedZ = nil -- Stores the Z-coordinate of the last processed bank

-- Function to check for new banks
local function findNewBank()
    for _, template in pairs({"MediumTownTemplate", "SmallTownTemplate", "LargeTownTemplate"}) do
        local town = workspace:FindFirstChild("Towns") and workspace.Towns:FindFirstChild(template)
        if town then
            local bank = town:FindFirstChild("Buildings") and town.Buildings:FindFirstChild("Bank")
            if bank and bank:FindFirstChild("PrimaryPart") and not visitedBanks[bank.Name] then
                local bankZ = bank.PrimaryPart.Position.Z
                -- Ensure the bank is at least 5000 blocks away
                if not lastProcessedZ or math.abs(bankZ - lastProcessedZ) >= 5000 then
                    visitedBanks[bank.Name] = true
                    lastProcessedZ = bankZ -- Update last processed Z-coordinate
                    return bank -- Return the new bank
                end
            end
        end
    end
    return nil -- No new banks found
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
            return -- Stop further movement as the new bank is found
        end
    end
    warn("No new banks found before reaching -49k.")
end

-- Execute the function to continuously move forward and find a new bank
moveToNextBank()
