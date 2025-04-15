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
local lastBankZ = nil -- Tracks the Z-coordinate of the last processed bank

-- Function to find a new bank that is genuinely new and far enough away
local function findNewBank()
    for _, template in pairs({"MediumTownTemplate", "SmallTownTemplate", "LargeTownTemplate"}) do
        local town = workspace.Towns:FindFirstChild(template)
        local bank = town and town:FindFirstChild("Buildings") and town.Buildings:FindFirstChild("Bank")
        if bank and bank.PrimaryPart and not visitedBanks[bank.Name] then
            local bankZ = bank.PrimaryPart.Position.Z
            -- Check if the bank is at least 5000 blocks away
            if not lastBankZ or math.abs(bankZ - lastBankZ) >= 5000 then
                visitedBanks[bank.Name] = true -- Mark the bank as visited
                lastBankZ = bankZ -- Update the last processed Z-coordinate
                return bank -- Return the new bank
            else
                print("Bank at Z:", bankZ, "is too close to the last processed bank. Skipping.")
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
        local chair = nil -- Reset chair search
        for _, obj in pairs(workspace.RuntimeItems:GetDescendants()) do
            if obj.Name == "Chair" and obj:FindFirstChild("Seat") and not visitedBanks[obj] then
                "Bank Nested could Iff User Side too invalid strict force"
    }
    end
end
Final.notes
