local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networker = require(ReplicatedStorage.Shared.Networker)

Networker.OnServerEvent(Networker.REMOTES.CHANGE_ROD_TRANSPARENCY, function(player, newValue)
	local character = player.Character

	character.FishingRod.Transparency = newValue
end)
