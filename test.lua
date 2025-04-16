local plr = game:GetService("Players").LocalPlayer
local chr = plr.Character or plr.CharacterAdded:Wait()
local timer = tick()

local targetPosition = CFrame.new(-424.448975, 30, -49041) -- Target seat position

repeat
    task.wait()

    -- Check if "FinalBasePlate" exists
    if workspace.Baseplates:FindFirstChild("FinalBasePlate") then
        for _, v in pairs(workspace.Baseplates.FinalBasePlate.OutlawBase:GetDescendants()) do
            if v:IsA("Seat") or v:IsA("VehicleSeat") then
                if v.CFrame == targetPosition then -- Only target the seat at the specified position
                    pcall(function()
                        local timedSeat = tick()
                        v.Disabled = false -- Enable the seat
                        
                        repeat
                            task.wait()
                            chr:PivotTo(v.CFrame) -- Move character to seat position
                            chr.PrimaryPart.CFrame = v.CFrame -- Align character's CFrame with the seat
                            
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
        -- Teleport the character if no valid seat is found
        chr:PivotTo(targetPosition)
    end
until tick() - timer > 10 -- Stop script execution after 10 seconds
