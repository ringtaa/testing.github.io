local plr = game:GetService("Players").LocalPlayer
local chr = plr.Character or plr.CharacterAdded:Wait()
local root = chr:WaitForChild("HumanoidRootPart")
local runtimeItems = game.Workspace:WaitForChild("RuntimeItems")

-- Continuously teleport to Bond every 0.5 seconds
task.spawn(function()
    while true do
        local bond = runtimeItems:FindFirstChild("Bond")
        if bond then
            if bond:IsA("Model") and bond.PrimaryPart then
                root.CFrame = bond.PrimaryPart.CFrame
            elseif bond:IsA("BasePart") then
                root.CFrame = bond.CFrame
            end
        end
        task.wait(0.5) -- teleport every 0.5 seconds
    end
end)
