local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networker = require(ReplicatedStorage.Shared.Networker)
local FishingGame = {}

local CAST_SPEED: number = 1

function FishingGame.InitBobber()
	local detectors = CollectionService:GetTagged("BobberDetector")

	for _, detector in ipairs(detectors) do
		detector.Touched:Connect(FishingGame.OnBobber)
	end
end

function FishingGame.OnBobber(otherPart)
	if otherPart:HasTag("Bobber") then
		local player: Player = Players:GetPlayerFromCharacter(otherPart.Parent.Parent)
		print(`Touched by: {player.DisplayName}`)

		-- Make bobber stop sinking

		-- Make fishing line straight

		FishingGame.SpawnFish(player)
	end
end

function FishingGame.SpawnFish(player: Player)
	-- Randomly select fish from fish table
	-- TEMP FISH
	local fish = {
		fishName = "SnootieFish",
		minWaitTime = 2,
		maxWaitTime = 5,
		pointsToWin = 10,
		initalPointValue = 5,
		pointDecreaseRate = 1, -- Per second
		greenAreaWidth = 50, -- 1 - 100
		greenAreaSpeed = 1, -- 1 - 10
	}

	-- Randomly select wait time and wait
	local waitTime: number = math.random(fish.minWaitTime, fish.maxWaitTime)
	task.wait(waitTime)

	-- Send data to client
	Networker.FireClient(Networker.REMOTES.ON_FISH_GAME, player, fish)
end

Networker.OnServerEvent(Networker.REMOTES.CAST_BOBBER, function(plr, bobber)
	bobber.Anchored = false
	local weld = bobber:FindFirstChild("WeldConstraint")
	weld.Enabled = false

	local throwVector: Vector3 = plr.Character.HumanoidRootPart.CFrame.LookVector
	local rotateVector = CFrame.fromAxisAngle(plr.Character.HumanoidRootPart.CFrame.RightVector, math.rad(45))
	local finalVector = rotateVector:VectorToWorldSpace(throwVector)

	bobber:ApplyImpulse(finalVector * CAST_SPEED)
	bobber.CanCollide = true
end)

return FishingGame
