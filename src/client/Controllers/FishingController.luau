local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game.Players.LocalPlayer
local FishingController = {}

local ACTIONNAMES = {
	TOGGLEROD = "TOGGLE_ROD",
}

FishingController.IsHoldingRod = false

local initialized = false
function FishingController.Init()
	if initialized then
		return
	end
	initialized = true

	FishingController._BindToggleRod()
end

-- Action Events ----------------------

function FishingController._OnToggleRod(actionName, inputState, inputObject)
	if inputState == Enum.UserInputState.Begin then
		if FishingController.IsHoldingRod then
			FishingController.IsHoldingRod = false

			-- Make rod invisible
			Player.Character.FishingRod.Transparency = 1

			-- Reset animation

			-- Unbind cast key
		else
			FishingController.IsHoldingRod = true

			-- Make rod visible
			Player.Character.FishingRod.Transparency = 0

			-- Animate to holding position

			-- Bind cast key
		end
	end
end

function FishingController._BindToggleRod()
	ContextActionService:BindAction(ACTIONNAMES.TOGGLEROD, FishingController._OnToggleRod, false, Enum.KeyCode.F)
end

FishingController.Init()
return FishingController
