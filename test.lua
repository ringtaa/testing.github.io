local plr = game.Players.LocalPlayer
local chr = plr.Character or plr.CharacterAdded:Wait()

local targetPosition = Vector3.new(-424, 30, -49041) -- Target seat position
local teleportCount = 10 -- Number of teleport attempts
local delayTime = 0.1 -- Delay between teleports

-- Retry teleporting to the target position
for i = 1, teleportCount do
    chr:PivotTo(CFrame.new(targetPosition)) -- Move character to the exact coordinates
    task.wait(delayTime) -- Wait for the specified delay before the next teleport
end

local timer = tick()

repeat
    task.wait()

    -- Check if "FinalBasePlate" exists
    local baseplates = workspace:FindFirstChild("Baseplates")
    if baseplates then
        local finalBasePlate = baseplates:FindFirstChild("FinalBasePlate")
        if finalBasePlate then
            local outlawBase = finalBasePlate:FindFirstChild("OutlawBase")
            if outlawBase then
                -- Iterate through all descendants of "OutlawBase"
                for _, v in pairs(outlawBase:GetDescendants()) do
                    if v:IsA("Seat") or v:IsA("VehicleSeat") then
                        -- Ensure the seat matches the target position
                        if v.Position == targetPosition then
                            pcall(function()
                                local timedSeat = tick()
                                v.Disabled = false -- Enable the seat
                                local frame = v.CFrame

                                repeat
                                    task.wait()
                                    chr:PivotTo(frame) -- Move character to seat position
                                    chr.PrimaryPart.CFrame = frame -- Align character's CFrame with the seat

                                    if chr.Humanoid.SeatPart == nil then
                                        v:Sit(chr.Humanoid) -- Attempt to sit
                                    elseif chr.Humanoid.SeatPart ~= nil then
                                        -- Simulate jump if already seated
                                        game:GetService("VirtualInputManager"):SendKeyEvent(true, "Space", false, game)
                                        task.wait()
                                        game:GetService("VirtualInputManager"):SendKeyEvent(false, "Space", false, game)
                                    end
                                until tick() - timedSeat > 10 -- Stop attempting after 10 seconds

                                chr.Humanoid.Sit = false -- Reset sit state
                            end)
                        end
                    end
                end
            else
                warn("OutlawBase not found under FinalBasePlate!")
            end
        else
            warn("FinalBasePlate not found under Baseplates!")
        end
    else
        warn("Baseplates not found in Workspace!")
    end
until tick() - timer > 15 -- Stop script execution after 15 seconds
