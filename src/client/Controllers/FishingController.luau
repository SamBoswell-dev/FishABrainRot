local Networker = require(game:GetService("ReplicatedStorage").Shared.Networker)
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnimationController = require(script.Parent.PlayerAnimationController)
local ClientPlayer: Player = game.Players.LocalPlayer
local ClientCharacter = ClientPlayer.Character or ClientPlayer.CharacterAdded:Wait()
local ClientHumanoid: Humanoid = ClientCharacter:FindFirstChildOfClass("Humanoid")
local FishingController = {}

FishingController.fishPosAnimTrack = nil

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
		local clientFishingRod = game.Workspace.LocalParts.ClientFishingRod
		if FishingController.fishPosAnimTrack then
			FishingController.fishPosAnimTrack:Stop()
		end

		if FishingController.IsHoldingRod then
			FishingController.IsHoldingRod = false

			-- Make rod invisible
			Networker.FireServer(Networker.REMOTES.CHANGE_ROD_TRANSPARENCY, 1)
			clientFishingRod.Transparency = 1

			-- Reset animation
			AnimationController.StopAnimation(AnimationController.ANIMATIONS.FishingIdle)

			-- Unbind cast key
		else
			FishingController.IsHoldingRod = true

			-- Make rod visible
			Networker.FireServer(Networker.REMOTES.CHANGE_ROD_TRANSPARENCY, 0)
			clientFishingRod.Transparency = 0

			-- Animate to holding position
			AnimationController.PlayTwoAnimations(
				AnimationController.ANIMATIONS.FishingPosition,
				AnimationController.ANIMATIONS.FishingIdle
			)

			-- Bind cast key
		end
	end
end

function FishingController._BindToggleRod()
	ContextActionService:BindAction(ACTIONNAMES.TOGGLEROD, FishingController._OnToggleRod, false, Enum.KeyCode.F)
end

FishingController.Init()
return FishingController
