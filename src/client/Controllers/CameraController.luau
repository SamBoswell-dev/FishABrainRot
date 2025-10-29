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
		local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		for original, clone in pairs(clones) do
			local rootForward = root.CFrame.LookVector
			local newPos = original.Position + rootForward * -2
			local newCFrame = CFrame.new(newPos)
				* CFrame.fromMatrix(Vector3.zero, original.CFrame.RightVector, original.CFrame.UpVector)
			clone.CFrame = newCFrame
		end
	end)
end

CameraController.Init()

return CameraController

-- local worldOffset = Vector3.new(0, 0, -3) -- world Z offset
-- local targetPosition = original.Position + worldOffset

-- -- Get the player's rotation around Y only
-- local _, yRotation, _ = original.CFrame:ToEulerAnglesYXZ()
-- local rotation = CFrame.Angles(0, yRotation, 0) -- only Y rotation

-- -- Set the clone CFrame
-- clone.CFrame = CFrame.new(targetPosition) * rotation
