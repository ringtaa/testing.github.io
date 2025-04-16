local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Remotes = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Weapon"):WaitForChild("Shoot")

local function getNearestNPCHead()
    local nearestDistance = math.huge
    local nearestHead = nil

    -- Loop through RuntimeEntities for Werewolves and Vampires
    for _, npc in pairs(workspace.RuntimeEntities:GetChildren()) do
        if npc:IsA("Model") and npc ~= Character and (npc.Name == "Werewolf" or npc.Name == "Vampire") then
            local head = npc:FindFirstChild("Head")
            if head and head:IsA("BasePart") then
                local distance = (head.Position - Character.HumanoidRootPart.Position).Magnitude
                if distance < nearestDistance then
                    nearestDistance = distance
                    nearestHead = head
                end
            end
        end
    end
    return nearestHead
end

-- Continuous targeting loop
while true do
    local targetHead = getNearestNPCHead()
    if targetHead then
        local args = {
            [1] = 1743276954.200528, -- Replace with the appropriate identifier
            [2] = Character:FindFirstChild("Revolver"),
            [3] = CFrame.new(targetHead.Position),
            [4] = {}
        }

        Remotes:FireServer(unpack(args)) -- Fire at the target
        print("Shot fired at", targetHead.Parent.Name) -- Debugging output
    else
        print("No werewolves or vampires nearby.") -- Debugging output
    end
    task.wait(0.1) -- Short delay to avoid spamming
end
