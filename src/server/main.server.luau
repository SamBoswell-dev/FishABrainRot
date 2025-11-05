local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networker = require(ReplicatedStorage.Shared.Networker)

-- local FishingPositionAnim: Animation = game:GetService("ReplicatedStorage").Animations.FishingPosition
-- local fishPosAnimTrack = nil
-- Networker.OnServerEvent(Networker.REMOTES.ANIMATE_ROD_EQUIP, function(player, isHoldingRod: boolean)
-- 	if fishPosAnimTrack then
-- 		fishPosAnimTrack:Stop()
-- 	end

-- 	local ClientHumanoid = player.Character:FindFirstChildOfClass("Humanoid")

-- 	local animator: Animator? = ClientHumanoid:FindFirstChildOfClass("Animator")

-- 	if isHoldingRod then
-- 		if animator then
-- 			fishPosAnimTrack = animator:LoadAnimation(FishingPositionAnim)
-- 			fishPosAnimTrack:Play()
-- 			fishPosAnimTrack:GetMarkerReachedSignal("Finished"):Once(function()
-- 				fishPosAnimTrack:AdjustSpeed(0)
-- 			end)
-- 		else
-- 			error("animator is nil")
-- 		end
-- 	else
-- 		if animator then
-- 			print("Retracting")
-- 		else
-- 			error("animator is nil")
-- 		end
-- 	end
-- end)
