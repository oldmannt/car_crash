local remote = {}

local isServer = game["Run Service"]:IsServer()
local remoteEvent = nil
if isServer then
	remoteEvent = Instance.new("RemoteEvent")
	remoteEvent.Parent = script
	remoteEvent.Name = 'general_remote_event'
else
	remoteEvent = script:WaitForChild("general_remote_event")
	print(`Client {script.Name} {game.Players.LocalPlayer} detected {remoteEvent.Name} RemoteEvent.`)
end

function remote.serverBoardcast(eventId, ...)
    
end

function remote.serverToClient(eventId, player:Player, ...)
    
end

function remote.clientToServer(eventId, player:Player, ...)
    
end



if isServer then
	-- Listen for client updates
	remoteEvent.OnServerEvent:Connect(function(player, key, value)
		print(`{script.Name} OnServerEvent {player} [{key} = {value}]`)
		--kills[key] = value

		remoteEvent:FireAllClients(key, value)
	end)
	print(`Server {script.Name} OnServerEvent connected.`)
else
	remoteEvent.OnClientEvent:Connect(function(key, value)
		print(`{script.Name} OnClientEvent [{key} = {value}]`)
		--kills[key] = value
	end)

	print(`Client {script.Name} {game.Players.LocalPlayer} OnClientEvent connected.`)
end

return remote