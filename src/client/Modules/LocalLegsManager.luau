local LegsManager = {}

function LegsManager.Init(offset: number)
	local player = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
	local RunService = game:GetService("RunService")

	local bodyParts = {}
	bodyParts.LeftUpperLeg = player:FindFirstChild("LeftUpperLeg")
	bodyParts.LeftLowerLeg = player:FindFirstChild("LeftLowerLeg")
	bodyParts.LeftFoot = player:FindFirstChild("LeftFoot")
	bodyParts.RightUpperLeg = player:FindFirstChild("RightUpperLeg")
	bodyParts.RightLowerLeg = player:FindFirstChild("RightLowerLeg")
	bodyParts.RightFoot = player:FindFirstChild("RightFoot")
	bodyParts.RightUpperArm = player:FindFirstChild("RightUpperArm")
	bodyParts.RightLowerArm = player:FindFirstChild("RightLowerArm")
	bodyParts.RightHand = player:FindFirstChild("RightHand")
	bodyParts.LeftUpperArm = player:FindFirstChild("LeftUpperArm")
	bodyParts.LeftLowerArm = player:FindFirstChild("LeftLowerArm")
	bodyParts.LeftArm = player:FindFirstChild("LeftArm")
	bodyParts.FishingRod = player:FindFirstChild("FishingRod")

	local bodyPartRefs = {}
	bodyPartRefs.LeftUpperLeg = game:GetService("ReplicatedStorage").Meshs.BodyParts.ClientLeftUpperLeg
	bodyPartRefs.LeftLowerLeg = game:GetService("ReplicatedStorage").Meshs.BodyParts.ClientLeftLowerLeg
	bodyPartRefs.LeftFoot = game:GetService("ReplicatedStorage").Meshs.BodyParts.ClientLeftFoot
	bodyPartRefs.RightUpperLeg = game:GetService("ReplicatedStorage").Meshs.BodyParts.ClientRightUpperLeg
	bodyPartRefs.RightLowerLeg = game:GetService("ReplicatedStorage").Meshs.BodyParts.ClientRightLowerLeg
	bodyPartRefs.RightFoot = game:GetService("ReplicatedStorage").Meshs.BodyParts.ClientRightFoot
	bodyPartRefs.RightUpperArm = game:GetService("ReplicatedStorage").Meshs.BodyParts.ClientRightUpperArm
	bodyPartRefs.RightLowerArm = game:GetService("ReplicatedStorage").Meshs.BodyParts.ClientRightLowerArm
	bodyPartRefs.RightHand = game:GetService("ReplicatedStorage").Meshs.BodyParts.ClientRightHand
	bodyPartRefs.LeftUpperArm = game:GetService("ReplicatedStorage").Meshs.BodyParts.ClientLeftUpperArm
	bodyPartRefs.LeftLowerArm = game:GetService("ReplicatedStorage").Meshs.BodyParts.ClientLeftLowerArm
	bodyPartRefs.LeftArm = game:GetService("ReplicatedStorage").Meshs.BodyParts.ClientLeftHand
	bodyPartRefs.FishingRod = game:GetService("ReplicatedStorage").Meshs.FishingRods.ClientFishingRod

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
			local newPos = original.Position + rootForward * offset
			local newCFrame = CFrame.new(newPos)
				* CFrame.fromMatrix(Vector3.zero, original.CFrame.RightVector, original.CFrame.UpVector)
			clone.CFrame = newCFrame
		end
	end)

	-- local armParts = {}
	-- armParts.RightUpperArm = player:FindFirstChild("RightUpperArm")
	-- armParts.RightLowerArm = player:FindFirstChild("RightLowerArm")
	-- armParts.RightHand = player:FindFirstChild("RightHand")
	-- armParts.LeftUpperArm = player:FindFirstChild("LeftUpperArm")
	-- armParts.LeftLowerArm = player:FindFirstChild("LeftLowerArm")
	-- armParts.LeftArm = player:FindFirstChild("LeftArm")

	-- local armPartRefs = {}
	-- armPartRefs.RightUpperArm = game:GetService("ReplicatedStorage").Meshs.BodyParts.ClientRightUpperArm
	-- armPartRefs.RightLowerArm = game:GetService("ReplicatedStorage").Meshs.BodyParts.ClientRightLowerArm
	-- armPartRefs.RightHand = game:GetService("ReplicatedStorage").Meshs.BodyParts.ClientRightHand
	-- armPartRefs.LeftUpperArm = game:GetService("ReplicatedStorage").Meshs.BodyParts.ClientLeftUpperArm
	-- armPartRefs.LeftLowerArm = game:GetService("ReplicatedStorage").Meshs.BodyParts.ClientLeftLowerArm
	-- armPartRefs.LeftArm = game:GetService("ReplicatedStorage").Meshs.BodyParts.ClientLeftArm

	-- local armClones = {}

	-- for key, part in pairs(armParts) do
	-- 	local clone = legPartRefs[key]:Clone()
	-- 	if not workspace:FindFirstChild("LocalParts") then
	-- 		local folder = Instance.new("Folder")
	-- 		folder.Name = "LocalParts"
	-- 		folder.Parent = workspace
	-- 	end
	-- 	clone.Parent = workspace.LocalParts
	-- 	clone.CFrame = part.CFrame
	-- 	armClones[part] = clone
	-- end

	-- RunService.RenderStepped:Connect(function()
	-- 	for key, value in pairs(armParts) do
	-- 		value.LocalTransparencyModifier = 0
	-- 	end
	-- end)
end

return LegsManager
