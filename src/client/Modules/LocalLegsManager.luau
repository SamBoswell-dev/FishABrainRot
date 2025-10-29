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

	local bodyPartRefs = {}
	bodyPartRefs.LeftUpperLeg = game:GetService("ReplicatedStorage").Meshs.BodyParts.ClientLeftUpperLeg
	bodyPartRefs.LeftLowerLeg = game:GetService("ReplicatedStorage").Meshs.BodyParts.ClientLeftLowerLeg
	bodyPartRefs.LeftFoot = game:GetService("ReplicatedStorage").Meshs.BodyParts.ClientLeftFoot
	bodyPartRefs.RightUpperLeg = game:GetService("ReplicatedStorage").Meshs.BodyParts.ClientRightUpperLeg
	bodyPartRefs.RightLowerLeg = game:GetService("ReplicatedStorage").Meshs.BodyParts.ClientRightLowerLeg
	bodyPartRefs.RightFoot = game:GetService("ReplicatedStorage").Meshs.BodyParts.ClientRightFoot

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
end

return LegsManager
