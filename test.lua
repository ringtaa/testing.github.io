local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local function GetBondWithinRange(maxDistance)
    for _, bond in pairs(Workspace.RuntimeItems:GetChildren()) do
        if bond:IsA("Model") and bond.Name == "Bond" then
            local distance = (humanoidRootPart.Position - bond:GetModelCFrame().Position).Magnitude
            if distance <= maxDistance then
                return bond -- Return the first bond found within the range
            end
        end
    end
    return nil -- Return nil if no bond is found within the range
end

RunService.Heartbeat:Connect(function()
    local bond = GetBondWithinRange(500) -- Check for bonds within 500 blocks
    if bond then
        local targetPosition = bond:GetModelCFrame().Position
        local currentPosition = humanoidRootPart.Position
        local distance = (currentPosition - targetPosition).Magnitude

        -- If the humanoid isn't already moving or if it's interrupted, reinitiate movement
        if distance > 0.5 then -- Allow slight tolerance to prevent unnecessary re-triggers
            humanoid:MoveTo(targetPosition) -- Continuously attempt to move toward the bond
            print("Moving to bond:", bond.Name, "at distance:", math.floor(distance)) -- Debugging movement
        end
    else
        print("No bonds within range.") -- Debugging no bonds found
    end
end)
