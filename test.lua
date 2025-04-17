local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local remote = ReplicatedStorage.Packages.RemotePromise.Remotes.C_ActivateObject

local collectDistance = 20
local walkDelay = 0.1

-- Creates a floating label above the bond
local function createBillboard(bond)
	if not bond:FindFirstChild("BondLabel") then
		local billboard = Instance.new("BillboardGui")
		billboard.Name = "BondLabel"
		billboard.Size = UDim2.new(0, 100, 0, 50)
		billboard.StudsOffset = Vector3.new(0, 3, 0)
		billboard.AlwaysOnTop = true
		billboard.Adornee = bond:FindFirstChildWhichIsA("BasePart")
		billboard.Parent = bond

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = "BOND"
		label.TextColor3 = Color3.fromRGB(255, 255, 0)
		label.TextStrokeTransparency = 0
		label.TextScaled = true
		label.Font = Enum.Font.GothamBold
		label.Parent = billboard
	end
end

-- Adds a highlight to the bond
local function highlightBond(bond)
	if not bond:FindFirstChild("Highlight") then
		local highlight = Instance.new("Highlight")
		highlight.Name = "Highlight"
		highlight.FillColor = Color3.fromRGB(255, 215, 0)
		highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		highlight.FillTransparency = 0.3
		highlight.OutlineTransparency = 0
		highlight.Adornee = bond
		highlight.Parent = bond
	end
end

-- Highlight & label bonds within range
local function highlightNearbyBonds()
	for _, bond in pairs(Workspace.RuntimeItems:GetChildren()) do
		if bond:IsA("Model") and bond.Name:match("Bond") then
			local distance = (humanoidRootPart.Position - bond:GetModelCFrame().Position).Magnitude
			if distance <= 150 then -- Larger detection radius for visibility
				createBillboard(bond)
				highlightBond(bond)
			else
				local label = bond:FindFirstChild("BondLabel")
				if label then label:Destroy() end

				local highlight = bond:FindFirstChild("Highlight")
				if highlight then highlight:Destroy() end
			end
		end
	end
end

local function GetNearestBond()
	local closestBond = nil
	local closestDistance = math.huge
	for _, bond in pairs(Workspace.RuntimeItems:GetChildren()) do
		if bond:IsA("Model") and bond.Name:match("Bond") then
			local distance = (humanoidRootPart.Position - bond:GetModelCFrame().Position).Magnitude
			if distance < closestDistance then
				closestBond = bond
				closestDistance = distance
			end
		end
	end
	return closestBond, closestDistance
end

RunService.Heartbeat:Connect(function()
	highlightNearbyBonds()

	local bond, distance = GetNearestBond()
	if bond and distance <= collectDistance then
		remote:FireServer(bond)
	end
	task.wait(walkDelay)
end)
