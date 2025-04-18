local plr = game:GetService("Players").LocalPlayer
local chr = plr.Character or plr.CharacterAdded:Wait()
local timer = tick()

local targetPosition = Vector3.new(-424, 30, -49041) -- Target seat position

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
                        -- Check if the seat's position matches the target position
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
                                until tick() - timedSeat > 2 -- Stop attempting after 2 seconds

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

    -- Teleport the character if no valid seat is found
    chr:PivotTo(CFrame.new(-424, 30, -49041)) -- Ensure fallback teleport to target position
until tick() - timer > 2.7 -- Stop script execution after 2.7 seconds
