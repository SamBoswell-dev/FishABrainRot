--https://scriptinghelpers.org/questions/16846/arm-visible-in-first-person
--Modified by SpiralGaia for universal rigs
-- local self, player = script.Parent, game.Players.LocalPlayer
-- local char = player.Character or player.CharacterAdded:wait()
-- local humanoid = char:WaitForChild("Humanoid") -- waits for the humanoid in the character

-- local OFFSETDIST = -50

-- function antiTrans(part)
-- 	local camera = workspace.CurrentCamera

-- 	if
-- 		part
-- 		and part:IsA("BasePart")
-- 		and (
-- 			part.Name == "LeftUpperLeg"
-- 			or part.Name == "LeftLowerLeg"
-- 			or part.Name == "LeftFoot"
-- 			or part.Name == "RightUpperLeg"
-- 			or part.Name == "RightLowerLeg"
-- 			or part.Name == "RightFoot"
-- 		)
-- 	then -- checks if a part and is a arm
-- 		part.LocalTransparencyModifier = part.Transparency
-- 		print(typeof(part))
-- 		part.Changed:connect(function(property)
-- 			if property == "LocalTransparencyModifier" then
-- 				part.LocalTransparencyModifier = part.Transparency --Changes the local modifyer(client side only)
-- 			end
-- 		end)
-- 	end
-- end

-- char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, 0, OFFSETDIST)

-- for _, v in pairs(char:GetChildren()) do
-- 	antiTrans(v) -- adds all parts
-- end

local Loader = require(game:GetService("ReplicatedStorage").Shared.Loader)
Loader.LoadAll()
