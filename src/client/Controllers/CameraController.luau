local StarterPlayer = game:GetService("StarterPlayer")
local LocalLegsManager = require(StarterPlayer.StarterPlayerScripts.Client.Modules.LocalLegsManager)

local CameraController = {}

local initialized = false

function CameraController.Init()
	if initialized then
		return
	end
	initialized = true

	-- Offset Legs
	LocalLegsManager.Init(-2)
end

function CameraController._CreateFPLegs() end

CameraController.Init()

return CameraController
