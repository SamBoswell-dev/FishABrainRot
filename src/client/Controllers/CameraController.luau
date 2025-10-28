local CameraController = {}

local initialized = false

function CameraController.Init()
	if initialized then
		return
	end
	initialized = true

	local OFFSETDIST = -50

	-- Clone the legs and link their position to the real legs.
	task.wait(3)
	CameraController._CreateFPLegs()
	-- Position the legs backwards
end

function CameraController._CreateFPLegs()
	local player = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
	local RunService = game:GetService("RunService")
	local camera = workspace.CurrentCamera

	local bodyParts = {}
	bodyParts.LeftUpperLeg = player:FindFirstChild("LeftUpperLeg")
	bodyParts.LeftLowerLeg = player:FindFirstChild("LeftLowerLeg")
	bodyParts.LeftFoot = player:FindFirstChild("LeftFoot")
	bodyParts.RightUpperLeg = player:FindFirstChild("RightUpperLeg")
	bodyParts.RightLowerLeg = player:FindFirstChild("RightLowerLeg")
	bodyParts.RightFoot = player:FindFirstChild("RightFoot")

	local bodyPartRefs = {}
	bodyPartRefs.LeftUpperLeg = game:GetService("ReplicatedStorage").Meshs.ClientLeftUpperLeg
	bodyPartRefs.LeftLowerLeg = game:GetService("ReplicatedStorage").Meshs.ClientLeftLowerLeg
	bodyPartRefs.LeftFoot = game:GetService("ReplicatedStorage").Meshs.ClientLeftFoot
	bodyPartRefs.RightUpperLeg = game:GetService("ReplicatedStorage").Meshs.ClientRightUpperLeg
	bodyPartRefs.RightLowerLeg = game:GetService("ReplicatedStorage").Meshs.ClientRightLowerLeg
	bodyPartRefs.RightFoot = game:GetService("ReplicatedStorage").Meshs.ClientRightFoot

	local clones = {}

	for key, part in pairs(bodyParts) do
		local clone = bodyPartRefs[key]:Clone()
		if not workspace:FindFirstChild("LocalParts") then
			local folder = Instance.new("Folder")
			folder.Name = "LocalParts"
			folder.Parent = workspace
		end
		clone.Parent = workspace.LocalParts
		clone.CFrame = part.CFrame
		clones[part] = clone
	end

	RunService.RenderStepped:Connect(function()
		--local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		for original, clone in pairs(clones) do
			--local relative = root.CFrame:ToObjectSpace(original.CFrame)
			clone.CFrame = original.CFrame
		end
	end)
end

CameraController.Init()

return CameraController
