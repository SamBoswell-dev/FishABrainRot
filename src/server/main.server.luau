local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local FishingGame = require(ServerScriptService.Server.Systems.FishingGame)
local Networker = require(ReplicatedStorage.Shared.Networker)

Networker.OnServerEvent(Networker.REMOTES.CHANGE_ROD_TRANSPARENCY, function(player, newValue)
	local character = player.Character

	character.FishingRod.Transparency = newValue
end)

FishingGame.InitBobber()
