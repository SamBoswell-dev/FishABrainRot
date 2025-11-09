local FishingGameUI: Frame = game.Players.LocalPlayer.PlayerGui.PlayerUI.FishingGame
local GreenArea: ImageButton = game.Players.LocalPlayer.PlayerGui.PlayerUI.FishingGame.GreenArea
local FishingGame = {}

FishingGame.isPlaying = false
FishingGame.greenDirection = nil -- -1 or 1

local TICK_SPEED = 0.3
local SWITCH_DIR_CHANCE = 30 -- max 100

function FishingGame.StartGame(fish)
	FishingGameUI.Visible = true
	FishingGame.isPlaying = true

	-- Make the Green area match with the fish's value
	GreenArea.Size = FishingGame._GetGreenAreaSize(fish) -- max .33 min .12
	FishingGame.greenDireciton = 1

	while FishingGame.isPlaying do
		-- Move the green area
		GreenArea.Position = FishingGame._GetNewGreenAreaPos(fish)

		task.wait(TICK_SPEED)
	end
end

function FishingGame.EndGame() end

function FishingGame._GetGreenAreaSize(fish): UDim2
	local result = 0.12 + (fish.greenAreaWidth - 1) * (0.21 / 99)

	return UDim2.fromScale(result, GreenArea.Size.Y.Scale)
end

function FishingGame._GetNewGreenAreaPos(fish): UDim2
	local amount = 0.001 + (fish.greenAreaSpeed - 1) * (0.004 / 9)
	local newPos =
		UDim2.fromScale(GreenArea.Position.X.Scale + amount * FishingGame.greenDirection, GreenArea.Position.Y.Scale)

	-- Determine if we are at the edge
	if newPos.X.Scale <= 0 or newPos.Y.Scale >= 1 then
		FishingGame.greenDirection = FishingGame.greenDirection * -1
		newPos = UDim2.fromScale(
			GreenArea.Position.X.Scale + amount * FishingGame.greenDirection,
			GreenArea.Position.Y.Scale
		)
	else
		local randNum = math.random(1, 100)
		if randNum < SWITCH_DIR_CHANCE then
			FishingGame.greenDireciton = FishingGame.greenDirection * -1
		end

		newPos = UDim2.fromScale(
			GreenArea.Position.X.Scale + amount * FishingGame.greenDirection,
			GreenArea.Position.Y.Scale
		)
	end

	return newPos
end

print("FishingGameUI Required")
return FishingGame
