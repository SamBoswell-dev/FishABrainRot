local Loader = {}

function Loader.LoadAll()
	local RunService = game:GetService("RunService")

	local clientOrServerScripts = nil

	if RunService:IsServer() then
		clientOrServerScripts = game:GetService("ServerScriptService").Server.scripts:GetChildren()
	else
		clientOrServerScripts = game:GetService("StarterPlayer").StarterPlayerScripts.Client.scripts:GetChildren()
	end

	local sharedScripts = game:GetService("ReplicatedStorage").Shared.scripts:GetChildren()

	for _, module in ipairs(clientOrServerScripts) do
		if module:IsA("ModuleScript") then
			local mod = require(module)
			if mod["OnLoad"] then
				mod.OnLoad()
			end
		end
	end

	for _, module in ipairs(sharedScripts) do
		if module:IsA("ModuleScript") then
			local mod = require(module)
			if mod["OnLoad"] then
				mod.OnLoad()
			end
		end
	end
end

return Loader
