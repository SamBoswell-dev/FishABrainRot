local StarterPlayer = game:GetService("StarterPlayer")
local KeyBindManager = require(StarterPlayer.StarterPlayerScripts.Client.Modules.KeyBindManager)
local FishingGameUI: Frame = game.Players.LocalPlayer.PlayerGui.PlayerUI.FishingGame
local GreenArea: ImageButton = game.Players.LocalPlayer.PlayerGui.PlayerUI.FishingGame.GreenArea
local PlayerIcon: ImageLabel = game.Players.LocalPlayer.PlayerGui.PlayerUI.FishingGame.PlayerIcon
local FishingGame = {}

FishingGame.isPlaying = false
FishingGame.greenDirection = nil -- -1 or 1

local TICK_SPEED = 0.02
local SWITCH_DIR_CHANCE = 10 -- max 200

local GAME_FORGIVE_VALUE = 5

local PLAYER_MOVE_SPEED = 0.008

function FishingGame.StartGame(fish)
	FishingGameUI.Visible = true
	FishingGame.isPlaying = true

	-- Make the Green area match with the fish's value
	GreenArea.Size = FishingGame._GetGreenAreaSize(fish) -- max .33 min .12
	FishingGame.greenDirection = 1

	-- Turn on fishing controls
	KeyBindManager.BindFishingMiniGame(FishingGame._OnRightPressed, FishingGame._OnLeftPressed)

	while FishingGame.isPlaying do
		-- Move the green area
		GreenArea.Position = FishingGame._GetNewGreenAreaPos(fish)

		-- Check if the Player is in the green area
		if FishingGame._IsFishInGreen() then
			print("In green")
		end

		task.wait(TICK_SPEED)
	end
end

function FishingGame.EndGame() end

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
				print("moving right")
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
				print("moving left")
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
	else
		GreenArea.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	end

	return false
end

function FishingGame._GetGreenAreaSize(fish): UDim2
	local result = 0.12 + (fish.greenAreaWidth - 1) * (0.21 / 99)

	return UDim2.fromScale(result, GreenArea.Size.Y.Scale)
end

function FishingGame._GetNewGreenAreaPos(fish): UDim2
	local amount = 0.005 + (fish.greenAreaSpeed - 1) * (0.002 / 9)
	local newPos =
		UDim2.fromScale(GreenArea.Position.X.Scale + amount * FishingGame.greenDirection, GreenArea.Position.Y.Scale)

	-- Determine if we are at the edge
	if newPos.X.Scale <= 0 or newPos.X.Scale >= 1 then
		FishingGame.greenDirection = FishingGame.greenDirection * -1
		newPos = UDim2.fromScale(
			GreenArea.Position.X.Scale + amount * FishingGame.greenDirection,
			GreenArea.Position.Y.Scale
		)
	else
		local randNum = math.random(1, 200)
		-- print(randNum)
		if randNum < SWITCH_DIR_CHANCE then
			FishingGame.greenDirection = FishingGame.greenDirection * -1
			-- print(FishingGame.greenDirection)
		end

		newPos = UDim2.fromScale(
			GreenArea.Position.X.Scale + amount * FishingGame.greenDirection,
			GreenArea.Position.Y.Scale
		)
	end

	-- TODO: Bug with speed. Green area seems to speed up as time passes. Try to check the greenDirection variable
	print(amount)
	return newPos
end

print("FishingGameUI Required")
return FishingGame
