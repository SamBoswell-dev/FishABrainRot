local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networker = require(ReplicatedStorage.Shared.scripts.Networker)
local Test = {}

function Test.OnLoad()
	Networker.FireServer(Networker.REMOTES.SAY_HELLO)
end

return Test
