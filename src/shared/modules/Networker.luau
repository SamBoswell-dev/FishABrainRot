--!strict
local Networker = {}
Networker.__index = Networker

-- Register remotes here
Networker.REMOTES = {
	SAY_HELLO = "SayHello",
	SAY_GOODBYE = "SayGoodbye",
}

Networker.RPCFolder = nil
Networker._events = {}

function Networker:Init()
	local RunService = game:GetService("RunService")

	if RunService:IsServer() then
		local ReplicatedStorage = game:GetService("ReplicatedStorage")

		self.RPCFolder = ReplicatedStorage:FindFirstChild("RemoteEvents") or Instance.new("Folder")
		self.RPCFolder.Name = "RemoteEvents"
		self.RPCFolder.Parent = game:GetService("ReplicatedStorage")

		for _, eventName in pairs(Networker.REMOTES) do
			local RPC: RemoteEvent = Instance.new("RemoteEvent")
			RPC.Name = eventName
			RPC.Parent = self.RPCFolder
			self._events[eventName] = RPC
		end
	else
		local RPCs = game:GetService("ReplicatedStorage").RemoteEvents:GetChildren()
		for _i, RPC in ipairs(RPCs) do
			self._events[RPC.Name] = RPC
		end
	end
	print("Networker Init")
end

function Networker:FireServer(eventName: string, ...: any)
	local event: RemoteEvent = self._events[eventName]

	if not event then
		error(`{eventName} is not a registered event.`)
		return
	end

	event:FireServer(...)
end

function Networker:FireClient(eventName: string, player: Player, ...: any)
	local event: RemoteEvent = self._events[eventName]

	if not event then
		error(`{eventName} is not a registered event.`)
		return
	end

	event:FireClient(player, ...)
end

function Networker:OnClientEvent(eventName: string, callback: (...any) -> ()): RBXScriptConnection
	local event: RemoteEvent = self._events[eventName]

	if not event then
		error(`{eventName} is not a registered event.`)
	end

	return event.OnClientEvent:Connect(callback)
end

function Networker:OnServerEvent(eventName: string, callback: (Player, ...any) -> ()): RBXScriptConnection
	local event: RemoteEvent = self._events[eventName]

	if not event then
		error(`{eventName} is not a registered event.`)
	end

	return event.OnServerEvent:Connect(callback)
end

return Networker
