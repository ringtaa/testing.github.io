bond = true
--- code for ringta || idk why

spawn(function()
    while true do
        if bond then
            local sssss = game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("RemotePromise"):WaitForChild("Remotes"):WaitForChild("C_ActivateObject")
            local runtimeItems = game:GetService("Workspace"):WaitForChild("RuntimeItems")

            for _, v in pairs(runtimeItems:GetChildren()) do
                if v.Name == "Bond" or v.Name == "Bonds" then
                    sssss:FireServer(v)
                end
            end
        end
        task.wait()
    end
end)
