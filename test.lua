local plr = game.Players.LocalPlayer
local chr = plr.Character or plr.CharacterAdded:Wait()

local targetPosition = Vector3.new(-424, 30, -49041) -- Target seat position

while true do
    task.wait(0.1) -- Add a slight delay for smoother repetition

    -- Teleport to the target position
    chr:PivotTo(CFrame.new(targetPosition)) -- Move character to the exact coordinates

    -- Check if the character is seated
    if chr.Humanoid.SeatPart ~= nil then
        print("Successfully seated!")
        break -- Exit the loop once seated successfully
    end

    -- Search for a seat at the target position and try to sit
    local baseplates = workspace:FindFirstChild("Baseplates")
    if baseplates then
        local finalBasePlate = baseplates:FindFirstChild("FinalBasePlate")
        if finalBasePlate then
            local outlawBase = finalBasePlate:FindFirstChild("OutlawBase")
            if outlawBase then
                for _, v in pairs(outlawBase:GetDescendants()) do
                    if v:IsA("Seat") or v:IsA("VehicleSeat") then
                        if v.Position == targetPosition then
                            pcall(function()
                                v.Disabled = false -- Enable the seat
                                v:Sit(chr.Humanoid) -- Attempt to sit
                            end)
                        end
                    end
                end
            end
        end
    end
end
