local plr = game:GetService("Players").LocalPlayer
local chr = plr.Character or plr.CharacterAdded:Wait()
local timer = tick()

local targetPosition = Vector3.new(-424, 30, -49041) -- Target seat position

repeat
    task.wait()

    -- Check if "FinalBasePlate" exists
    if workspace.Baseplates:FindFirstChild("FinalBasePlate") then
        for i, v in pairs(workspace.Baseplates.FinalBasePlate.OutlawBase:GetDescendants()) do
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
                        until tick() - timedSeat > 10 -- Stop attempting after 10 seconds

                        chr.Humanoid.Sit = false -- Reset sit state
                    end)
                end
            end
        end
    else
        warn("FinalBasePlate not found under Baseplates!")
    end
until tick() - timer > 15 -- Stop script execution after 15 seconds
