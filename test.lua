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

while true do
    local targetHead = getNearestNPCHead()
    if targetHead then
        local args = {
            [1] = os.clock(), -- Dynamic unique value for each shot
            [2] = Character:FindFirstChild("Revolver"), -- Ensure the revolver exists
            [3] = CFrame.new(targetHead.Position), -- Target position
            [4] = {}, -- Empty or additional parameters
        }

        -- Validate weapon existence before firing
        if args[2] then
            print("Firing at:", targetHead.Parent.Name, "Position:", targetHead.Position)
            Remotes:FireServer(unpack(args)) -- Fire at the target
        else
            print("Weapon not found!")
        end
    else
        print("No werewolves or vampires nearby.") -- Debugging output
    end
    task.wait(0.1) -- Short delay to avoid spamming
end
