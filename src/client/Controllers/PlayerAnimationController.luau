local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AnimationsFolder = ReplicatedStorage.Animations
local Controller = {}

local ClientPlayer: Player = game.Players.LocalPlayer
local ClientCharacter = ClientPlayer.Character or ClientPlayer.CharacterAdded:Wait()
local ClientHumanoid: Humanoid = ClientCharacter:FindFirstChildOfClass("Humanoid")
local Animator: Animator? = ClientHumanoid:FindFirstChildOfClass("Animator")

if not Animator then
	error("Animator is null")
end

Controller.ANIMATIONS = {
	FishingPosition = Animator:LoadAnimation(AnimationsFolder.FishingPosition),
	FishingIdle = Animator:LoadAnimation(AnimationsFolder.FishingIdle),
}

function Controller.PlayAnimation(animation: AnimationTrack)
	animation:Play()
end

-- Plays and waits for the first animation to finish, then plays the second
function Controller.PlayTwoAnimations(firstAnimation: AnimationTrack, secondAnimation: AnimationTrack)
	firstAnimation:Play()
	firstAnimation.Stopped:Once(function()
		secondAnimation:Play()
	end)
end

function Controller.StopAnimation(animation: AnimationTrack)
	animation:Stop()
end

print("Animation Controller Required")
return Controller
