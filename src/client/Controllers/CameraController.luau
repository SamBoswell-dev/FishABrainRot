local CameraController = {}

local initialized = false

function CameraController.Init()
	if initialized then
		return
	end
	initialized = true

	local player = game.Players.LocalPlayer
	local char = player.Character or player.CharacterAdded:wait()

	local OFFSETDIST = -50

	-- Allow the player to see their body parts
	for _, v in pairs(char:GetChildren()) do
		CameraController._FixPartTrans(v) -- adds all parts
	end

	-- Clone the legs and link their position to the real legs.
	-- Position the legs backwards
end

function CameraController._FixPartTrans(part)
	if
		part
		and part:IsA("BasePart")
		and (
			part.Name == "LeftUpperLeg"
			or part.Name == "LeftLowerLeg"
			or part.Name == "LeftFoot"
			or part.Name == "RightUpperLeg"
			or part.Name == "RightLowerLeg"
			or part.Name == "RightFoot"
		)
	then
		part.LocalTransparencyModifier = part.Transparency
		print(typeof(part))
		part.Changed:connect(function(property)
			if property == "LocalTransparencyModifier" then
				part.LocalTransparencyModifier = part.Transparency --Changes the local modifyer(client side only)
			end
		end)
	end
end

CameraController.Init()

return CameraController
