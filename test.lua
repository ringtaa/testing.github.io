local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local function GetBond()
    for _, item in pairs(Workspace.RuntimeItems:GetChildren()) do
        if item.Name == "Bond" then
            return item -- Return the first bond found
        end
    end
    return nil -- Return nil if no bond is found
end

while true do
    local bond = GetBond()
    if bond then
        humanoid:MoveTo(bond:GetModelCFrame().Position) -- Move to the bond's position
        humanoid.MoveToFinished:Wait() -- Wait until the movement is completed
    else
        print("No bond found.")
    end
    task.wait(0.1) -- Add a small delay before checking again
end
