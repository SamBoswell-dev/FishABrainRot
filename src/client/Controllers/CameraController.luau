local CameraController = {}

local initialized = false

function CameraController.Init()
	if initialized then
		return
	end
	initialized = true

	local OFFSETDIST = -50

	-- Clone the legs and link their position to the real legs.
	CameraController._CreateFPLegs()
	-- Position the legs backwards
end

function CameraController._CreateFPLegs()
	local player = game.Players.LocalPlayer.Character

	local LeftUpperLeg = player:FindFirstChild("LeftUpperLeg")
	local LeftLowerLeg = player:FindFirstChild("LeftLowerLeg")
	local LeftFoot = player:FindFirstChild("LeftFoot")
	local RightUpperLeg = player:FindFirstChild("RightUpperLeg")
	local RightLowerLeg = player:FindFirstChild("RightLowerLeg")
	local RightFoot = player:FindFirstChild("RightFoot")

	print(LeftLowerLeg)
end

CameraController.Init()

return CameraController
