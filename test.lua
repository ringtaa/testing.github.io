bond = true

-- Code for bond collection
spawn(function()
    while true do
        if bond then
            local sssss = game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("RemotePromise"):WaitForChild("Remotes"):WaitForChild("C_ActivateObject")
            local runtimeItems = game:GetService("Workspace"):WaitForChild("RuntimeItems")

            for _, v in pairs(runtimeItems:GetChildren()) do
                if v.Name == "Bond" or v.Name == "Bonds" then
                    sssss:FireServer(v) -- Attempt to collect the bond
                end
            end
        end
        task.wait(0.1) -- Add slight delay for performance
    end
end)

-- Code for bond movement
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local function GetAllBondsWithinRange(maxDistance)
    local bonds = {}
    for _, bond in pairs(Workspace.RuntimeItems:GetChildren()) do
        if bond:IsA("Model") and (bond.Name == "Bond" or bond.Name == "Bonds") then
            local distance = (humanoidRootPart.Position - bond:GetModelCFrame().Position).Magnitude
            if distance <= maxDistance then
                table.insert(bonds, bond) -- Add bond to the list if within range
            end
        end
    end
    return bonds
end

local function MoveToBond(bond)
    humanoid:MoveTo(bond:GetModelCFrame().Position) -- Move to the bond's position
    while true do
        local distance = (humanoidRootPart.Position - bond:GetModelCFrame().Position).Magnitude
        if distance <= 2 then -- Consider the bond "reached" within a 2-block tolerance
            print("Reached bond:", bond.Name)
            break
        end
        task.wait(0.1) -- Keep checking until bond is reached
    end
end

RunService.Heartbeat:Connect(function()
    local bonds = GetAllBondsWithinRange(500) -- Get all bonds within 500 blocks
    if #bonds > 0 then
        for _, bond in ipairs(bonds) do
            print("Moving to bond:", bond.Name)
            MoveToBond(bond) -- Walk to each bond in the list
        end
    else
        print("No bonds within range.") -- Debugging when no bonds are found
    end
end)
