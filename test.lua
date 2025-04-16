local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

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

while true do
    local bond = GetBondWithinRange(500) -- Check for bonds within 500 blocks
    if bond then
        humanoid:MoveTo(bond:GetModelCFrame().Position) -- Move to the bond's position
        print("Walking to bond:", bond.Name, "at position:", bond:GetModelCFrame().Position) -- Debugging movement
    else
        print("No bonds within range.") -- Debugging no bonds found
    end
    task.wait(0.1) -- Add a small delay before checking again
end
