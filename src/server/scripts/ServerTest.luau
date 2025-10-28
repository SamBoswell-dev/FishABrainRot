local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networker = require(ReplicatedStorage.Shared.scripts.Networker)
local Test = {}

function Test.OnLoad()
	Networker.OnServerEvent(Networker.REMOTES.SAY_HELLO, function(_player)
		print("Hello from Client!")
	end)
	print("Loaded ServerTest")
end

return Test
