local Networker = require(game:GetService("ReplicatedStorage").Shared.Networker)
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local KeyBindManager = require(StarterPlayer.StarterPlayerScripts.Client.Modules.KeyBindManager)
local AnimationController = require(script.Parent.PlayerAnimationController)
local ClientPlayer: Player = game.Players.LocalPlayer
local ClientCharacter = ClientPlayer.Character or ClientPlayer.CharacterAdded:Wait()
local ClientHumanoid: Humanoid = ClientCharacter:FindFirstChildOfClass("Humanoid")
local Bobber: Part = ClientCharacter:WaitForChild("FishingRod").Bobber

local FishingController = {}

FishingController.fishPosAnimTrack = nil

FishingController.IsHoldingRod = false

local initialized = false
function FishingController.Init()
	if initialized then
		return
	end
	initialized = true

	KeyBindManager.BindRod(FishingController._OnToggleRod)
end

-- Action Events ----------------------

function FishingController._OnClickPressed(actionName, inputState, inputObject)
	if inputState ~= Enum.UserInputState.Begin then
		return
	end

	-- TODO: Play animation

	Networker.FireServer(Networker.REMOTES.CAST_BOBBER, Bobber)
end

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
			KeyBindManager.UnBindCast()
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
			KeyBindManager.BindCast(FishingController._OnClickPressed)
		end
	end
end

function FishingController.EnableToggleRod()
	KeyBindManager.BindRod(FishingController._OnToggleRod)
end

FishingController.Init()
print("FishingController Required")
return FishingController
