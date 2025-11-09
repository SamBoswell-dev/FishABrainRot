local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local FishingGameUI = require(StarterPlayer.StarterPlayerScripts.Client.UI.FishingGameUI)
local Networker = require(ReplicatedStorage.Shared.Networker)
local UIController = {}

Networker.OnClientEvent(Networker.REMOTES.ON_FISH_GAME, function(fish)
	print(`Play fish-mini game with: {fish.fishName}`)
	FishingGameUI.StartGame(fish)
end)

print("UIController Required")
return UIController
