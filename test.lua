local Players = game:GetService("Players")
local chr = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
local timer = tick()

repeat
    task.wait()
    -- Check if "FinalBasePlate" exists
    if workspace.Baseplates:FindFirstChild("FinalBasePlate") then
        -- Iterate through all descendants of the target base
        for _, v in pairs(workspace.Baseplates.FinalBasePlate.OutlawBase:GetDescendants()) do
            if v:IsA("Seat") or v:IsA("VehicleSeat") then
                pcall(function()
                    local timedSeat = tick()
                    v.Disabled = false -- Enable the seat
                    local frame = v.CFrame -- Get seat's CFrame
                    
                    repeat
                        task.wait()
                        chr:PivotTo(frame) -- Move character to seat
                        chr.PrimaryPart.CFrame = frame -- Set character's CFrame to seat's CFrame
                        
                        -- Try to make the character sit
                        if chr.Humanoid.SeatPart == nil then
                            v:Sit(chr.Humanoid) -- Attempt to sit the humanoid
                        elseif chr.Humanoid.SeatPart ~= nil then
                            -- Simulate a jump if already sitting
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, "Space", false, game)
                            task.wait()
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, "Space", false, game)
                        end
                    until tick() - timedSeat > 2 -- Stop after 2 seconds of attempting
                    chr.Humanoid.Sit = false -- Reset sit state
                end)
            end
        end
    else
        -- Teleport the character if no valid seat is found
        chr:PivotTo(CFrame.new(-424.448975, 30, -49041))
    end
until tick() - timer > 10 -- Stop script execution after 10 seconds
