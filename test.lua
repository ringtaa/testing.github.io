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
        humanoid.MoveToFinished:Wait() -- Wait until the movement is completed
    else
        print("No bonds within range.") -- Debugging message for when no bonds are found
    end
    task.wait(0.1) -- Add a small delay before checking again
end
