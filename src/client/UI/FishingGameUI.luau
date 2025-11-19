-- POPULAR FONT: Fredoka One

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local TimerService = game:GetService("TimerService")
local TweenService = game:GetService("TweenService")
local Networker = require(ReplicatedStorage.Shared.Networker)
local FishingController = require(StarterPlayer.StarterPlayerScripts.Client.Controllers.FishingController)
local KeyBindManager = require(StarterPlayer.StarterPlayerScripts.Client.Modules.KeyBindManager)
local FishingGameUI: Frame = game.Players.LocalPlayer.PlayerGui.PlayerUI.FishingGame
local GreenArea: ImageLabel = game.Players.LocalPlayer.PlayerGui.PlayerUI.FishingGame.GreenArea
local PlayerIcon: ImageLabel = game.Players.LocalPlayer.PlayerGui.PlayerUI.FishingGame.PlayerIcon

-- TEMP
local TestText: TextBox = game.Players.LocalPlayer.PlayerGui.PlayerUI.FishingGame.TestText

local FishingGame = {}

FishingGame.isPlaying = false
FishingGame.greenDirection = nil -- -1 or 1

local TICK_SPEED = 0.02
local SWITCH_DIR_CHANCE = 8 -- max 200

local GAME_FORGIVE_VALUE = 5

local PLAYER_MOVE_SPEED = 0.008

local POINT_TIME_MAX = 0.5 -- How often the points will get calculated (lower is faster)

function FishingGame.StartGame(fish)
	if FishingGame.isPlaying then
		return
	end
	print(`Starting fish-mini game with: {fish.fishName}`)
	FishingGame.isPlaying = true

	-- Make unable to cast or toggle rod
	KeyBindManager.UnBindRod()
	KeyBindManager.UnBindCast()

	FishingGameUI.Visible = true

	-- Make the Green area match with the fish's value
	GreenArea.Size = FishingGame._GetGreenAreaSize(fish) -- max .33 min .12
	FishingGame.greenDirection = 1

	-- Turn on fishing controls
	KeyBindManager.BindFishingMiniGame(FishingGame._OnRightPressed, FishingGame._OnLeftPressed)

	local points = fish.initalPointValue
	local winLimit = fish.pointsToWin
	local timeElapsed = 0

	while FishingGame.isPlaying do
		-- Move the green area
		GreenArea.Position = FishingGame._GetNewGreenAreaPos(fish)
		FishingGame._HandleColor()

		-- Check if the Player is in the green area and give points
		if timeElapsed >= POINT_TIME_MAX then
			if FishingGame._IsFishInGreen() then
				-- Give points
				points += 1
			else
				-- Take points
				points -= 1
			end
			timeElapsed = 0
		end

		-- Check for win or loss condition
		if points > winLimit then
			print("Fish won!")
			-- Send win RPC
			-- End game
			FishingGame.isPlaying = false
		else
			if points <= 0 then
				print("Fish lost :(")
				FishingGame.isPlaying = false
			end
		end

		timeElapsed += TICK_SPEED
		TestText.Text = points
		task.wait(TICK_SPEED)
	end

	-- Clean up game for next use
	FishingGame.greenDirection = nil
	GreenArea.Position = UDim2.fromScale(0.5, GreenArea.Position.Y.Scale)

	FishingGameUI.Visible = false

	-- TODO: Retract players bobber

	-- Release key binds
	KeyBindManager.UnbindFishingMiniGame()

	-- Re-enable cast and toggle rod
	FishingController.EnableToggleRodAndClick()
end

Networker.OnClientEvent(Networker.REMOTES.TIGHTEN_LINE, function()
	local beam = workspace.LocalParts.ClientBobber.Attachment.Beam
	TweenService:Create(beam, TweenInfo.new(1), { CurveSize0 = 0 }):Play()
end)

local isRightHeld = false
function FishingGame._OnRightPressed(_actionName, inputState, _inputObject)
	if inputState == Enum.UserInputState.Begin then
		isRightHeld = true
		task.spawn(function()
			while isRightHeld do
				-- move player
				if
					PlayerIcon.AbsolutePosition.X + PlayerIcon.AbsoluteSize.X
					<= FishingGameUI.AbsolutePosition.X + FishingGameUI.AbsoluteSize.X
				then
					PlayerIcon.Position =
						UDim2.fromScale(PlayerIcon.Position.X.Scale + PLAYER_MOVE_SPEED, PlayerIcon.Position.Y.Scale)
				end
				--print("moving right")
				task.wait(TICK_SPEED)
			end
		end)
	else
		if inputState == Enum.UserInputState.End then
			isRightHeld = false
		end
	end
end

local isLeftHeld = false
function FishingGame._OnLeftPressed(_actionName, inputState, _inputObject)
	if inputState == Enum.UserInputState.Begin then
		isLeftHeld = true
		task.spawn(function()
			while isLeftHeld do
				-- move player
				if PlayerIcon.AbsolutePosition.X >= FishingGameUI.AbsolutePosition.X then
					PlayerIcon.Position =
						UDim2.fromScale(PlayerIcon.Position.X.Scale - PLAYER_MOVE_SPEED, PlayerIcon.Position.Y.Scale)
				end
				--print("moving left")
				task.wait(TICK_SPEED)
			end
		end)
	else
		if inputState == Enum.UserInputState.End then
			isLeftHeld = false
		end
	end
end

function FishingGame._IsFishInGreen(): boolean
	local greenLeftPos = GreenArea.AbsolutePosition.X
	local greenRightPos = GreenArea.AbsolutePosition.X + GreenArea.AbsoluteSize.X

	local playerLeftPos = PlayerIcon.AbsolutePosition.X
	local playerRightPos = PlayerIcon.AbsolutePosition.X + PlayerIcon.AbsoluteSize.X

	if playerLeftPos >= greenLeftPos and playerRightPos <= greenRightPos then
		GreenArea.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
		return true
	else
		GreenArea.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	end

	return false
end

function FishingGame._HandleColor()
	local greenLeftPos = GreenArea.AbsolutePosition.X
	local greenRightPos = GreenArea.AbsolutePosition.X + GreenArea.AbsoluteSize.X

	local playerLeftPos = PlayerIcon.AbsolutePosition.X
	local playerRightPos = PlayerIcon.AbsolutePosition.X + PlayerIcon.AbsoluteSize.X

	if playerLeftPos >= greenLeftPos and playerRightPos <= greenRightPos then
		GreenArea.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	else
		GreenArea.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	end
end

function FishingGame._GetGreenAreaSize(fish): UDim2
	local result = 0.12 + (fish.greenAreaWidth - 1) * (0.21 / 99)

	return UDim2.fromScale(result, GreenArea.Size.Y.Scale)
end

function FishingGame._GetNewGreenAreaPos(fish): UDim2
	local amount = 0.005 + (fish.greenAreaSpeed - 1) * (0.002 / 9)

	-- Determine if we are at the edge
	if GreenArea.AbsolutePosition.X <= FishingGameUI.AbsolutePosition.X then
		FishingGame.greenDirection = 1
	else
		if
			GreenArea.AbsolutePosition.X + GreenArea.AbsoluteSize.X
			>= FishingGameUI.AbsolutePosition.X + FishingGameUI.AbsoluteSize.X
		then
			FishingGame.greenDirection = -1
		else
			local randNum = math.random(1, 200)
			if randNum < SWITCH_DIR_CHANCE then
				FishingGame.greenDirection = FishingGame.greenDirection * -1
			end
		end
	end

	local newPos =
		UDim2.fromScale(GreenArea.Position.X.Scale + amount * FishingGame.greenDirection, GreenArea.Position.Y.Scale)

	return newPos
end

print("FishingGameUI Required")
return FishingGame
