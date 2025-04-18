local plr = game:GetService("Players").LocalPlayer
local chr = plr.Character or plr.CharacterAdded:Wait()
local timer = tick()

local targetPosition = Vector3.new(-424, 30, -49041) -- Target seat position
local successfullySeated = false

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
                                until tick() - timedSeat > 8 -- Stop attempting after 8 seconds

                                if chr.Humanoid.SeatPart == v then
                                    successfullySeated = true -- Mark success if seated
                                end

                                chr.Humanoid.Sit = false -- Reset sit state
                            end)

                            if successfullySeated then break end -- Exit loop if seated successfully
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
until tick() - timer > 10 -- Allow the script to run for up to 10 seconds

if not successfullySeated then
    print("Failed to seat the character within the timeframe.")
end
