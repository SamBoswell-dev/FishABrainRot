local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networker = require(ReplicatedStorage.Shared.Networker)
local FishingGame = {}

local CAST_SPEED: number = 1
local BOBBER_SINK_SPEED = 2

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

Networker.OnServerEvent(Networker.REMOTES.CAST_BOBBER, function(plr, bobber, throwVector)
	bobber.Anchored = false
	local weld = bobber:FindFirstChild("WeldConstraint")
	weld.Enabled = false

	local rotateVector = CFrame.fromAxisAngle(plr.Character.HumanoidRootPart.CFrame.RightVector, math.rad(25))
	local finalVector = rotateVector:VectorToWorldSpace(throwVector)

	bobber:ApplyImpulse(finalVector * CAST_SPEED)
	bobber.CanCollide = true
	task.wait(0.2)
	bobber.Touched:Once(function(otherPart)
		if otherPart:HasTag("water") then
			print("Hit water!")
			bobber.AssemblyAngularVelocity = Vector3.zero

			local bodyForce = Instance.new("BodyForce")
			bodyForce.Force = Vector3.new(0, -BOBBER_SINK_SPEED, 0)
			bodyForce.Parent = bobber
		else
			print("Missed water")
			bobber.AssemblyAngularVelocity = Vector3.zero
			bobber.AssemblyLinearVelocity = Vector3.zero
		end
	end)
end)

Networker.OnServerEvent(Networker.REMOTES.UNCAST_BOBBER, function(plr, bobber)
	local bodyForce = bobber:FindFirstChild("BodyForce", false)

	if bodyForce then
		bodyForce:Destroy()
	end

	local weld = bobber:FindFirstChild("WeldConstraint")
	bobber.CanCollide = false
	weld.Parent.CFrame = plr.Character.FishingRod.Attachment.WorldCFrame
	weld.Enabled = true
end)

return FishingGame
