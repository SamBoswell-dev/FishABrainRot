local LegsManager = {}

function LegsManager.Init()
	local playerCharacter = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
	local CollectionService = game:GetService("CollectionService")
	local RunService = game:GetService("RunService")

	local LEG_OFFSET = -2
	local ARM_OFFSET = -1.3

	local bodyParts = {}
	bodyParts.LeftUpperLeg = playerCharacter:FindFirstChild("LeftUpperLeg")
	bodyParts.LeftLowerLeg = playerCharacter:FindFirstChild("LeftLowerLeg")
	bodyParts.LeftFoot = playerCharacter:FindFirstChild("LeftFoot")
	bodyParts.RightUpperLeg = playerCharacter:FindFirstChild("RightUpperLeg")
	bodyParts.RightLowerLeg = playerCharacter:FindFirstChild("RightLowerLeg")
	bodyParts.RightFoot = playerCharacter:FindFirstChild("RightFoot")
	bodyParts.RightUpperArm = playerCharacter:FindFirstChild("RightUpperArm")
	bodyParts.RightLowerArm = playerCharacter:FindFirstChild("RightLowerArm")
	bodyParts.RightHand = playerCharacter:FindFirstChild("RightHand")
	bodyParts.LeftUpperArm = playerCharacter:FindFirstChild("LeftUpperArm")
	bodyParts.LeftLowerArm = playerCharacter:FindFirstChild("LeftLowerArm")
	bodyParts.LeftHand = playerCharacter:FindFirstChild("LeftHand")
	bodyParts.FishingRod = playerCharacter:FindFirstChild("FishingRod")
	bodyParts.Bobber = playerCharacter:FindFirstChild("Bobber", true)

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
	bodyPartRefs.LeftHand = game:GetService("ReplicatedStorage").Meshs.BodyParts.ClientLeftHand
	bodyPartRefs.FishingRod = game:GetService("ReplicatedStorage").Meshs.FishingRods.ClientFishingRod
	bodyPartRefs.Bobber = game:GetService("ReplicatedStorage").Meshs.FishingRods.ClientBobber

	local clones = {}

	local FishingRodAttachment = nil
	local BobberAttachment = nil
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
		if key == "FishingRod" then
			local inst = Instance.new("Attachment")
			inst.Parent = clone
			inst.CFrame = playerCharacter.FishingRod.Attachment.CFrame
			FishingRodAttachment = inst
		else
			if key == "Bobber" then
				local inst = Instance.new("Attachment")
				inst.Parent = clone
				inst.CFrame = playerCharacter.FishingRod.Bobber.Attachment.CFrame

				BobberAttachment = inst
			end
		end
	end

	-- Setup client beam
	local beam = Instance.new("Beam")
	beam.Parent = BobberAttachment
	beam.CurveSize0 = 3
	beam.Segments = 30
	beam.FaceCamera = true
	beam.Width0 = 0.05
	beam.Width1 = 0.05
	beam.Color = playerCharacter.FishingRod.Bobber.Beam.Color

	assert(FishingRodAttachment ~= nil, "Fishing rod has not been created yet. We can not setup the client beam")
	assert(BobberAttachment ~= nil, "Bobber has not been created yet. We can not setup the client beam")
	beam.Attachment0 = FishingRodAttachment
	beam.Attachment1 = BobberAttachment

	RunService.RenderStepped:Connect(function()
		local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		for original, clone in pairs(clones) do
			local rootForward = root.CFrame.LookVector
			local newPos = nil
			if CollectionService:HasTag(original, "LegPart") then
				newPos = original.Position + rootForward * LEG_OFFSET
			else
				newPos = original.Position + rootForward * ARM_OFFSET
			end
			local newCFrame = CFrame.new(newPos)
				* CFrame.fromMatrix(Vector3.zero, original.CFrame.RightVector, original.CFrame.UpVector)
			clone.CFrame = newCFrame
		end
	end)
end

print("LocalLegsManager Required")
return LegsManager
