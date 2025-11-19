local Networker = {}
Networker.__index = Networker

-- Register remotes here
Networker.REMOTES = {
	SAY_HELLO = "SayHello",
	SAY_GOODBYE = "SayGoodbye",
	CHANGE_ROD_TRANSPARENCY = "ChangeRodTransparency",
	ON_FISH_GAME = "OnFishGame",
	CAST_BOBBER = "CastBobber",
}

Networker.RPCFolder = nil
Networker._events = {}

local initialized = false

function Networker.Init()
	if initialized then
		return
	end
	initialized = true

	local RunService = game:GetService("RunService")

	if RunService:IsServer() then
		local ReplicatedStorage = game:GetService("ReplicatedStorage")

		Networker.RPCFolder = ReplicatedStorage:FindFirstChild("RemoteEvents") or Instance.new("Folder")
		Networker.RPCFolder.Name = "RemoteEvents"
		Networker.RPCFolder.Parent = game:GetService("ReplicatedStorage")

		for _, eventName in pairs(Networker.REMOTES) do
			local RPC: RemoteEvent = Instance.new("RemoteEvent")
			RPC.Name = eventName
			RPC.Parent = Networker.RPCFolder
			Networker._events[eventName] = RPC
		end
	else
		local RPCs = game:GetService("ReplicatedStorage").RemoteEvents:GetChildren()
		for _i, RPC in ipairs(RPCs) do
			Networker._events[RPC.Name] = RPC
		end
	end
	print("Networker Init")
end

function Networker.FireServer(eventName: string, ...: any)
	local event: RemoteEvent = Networker._events[eventName]

	if not event then
		error(`{eventName} is not a registered event.`)
		return
	end

	event:FireServer(...)
end

function Networker.FireClient(eventName: string, player: Player, ...: any)
	local event: RemoteEvent = Networker._events[eventName]

	if not event then
		error(`{eventName} is not a registered event.`)
		return
	end

	event:FireClient(player, ...)
end

function Networker.OnClientEvent(eventName: string, callback: (...any) -> ()): RBXScriptConnection
	local event: RemoteEvent = Networker._events[eventName]

	if not event then
		error(`{eventName} is not a registered event.`)
	end

	return event.OnClientEvent:Connect(callback)
end

function Networker.OnServerEvent(eventName: string, callback: (Player, ...any) -> ()): RBXScriptConnection
	local event: RemoteEvent = Networker._events[eventName]

	if not event then
		error(`{eventName} is not a registered event.`)
	end

	return event.OnServerEvent:Connect(callback)
end

Networker.Init()

return Networker
