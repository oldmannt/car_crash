local module = {}

local players_rank = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local isServer = game["Run Service"]:IsServer()
local remoteEvent = nil
if isServer then
	remoteEvent = Instance.new("RemoteEvent")
	remoteEvent.Parent = script
	remoteEvent.Name = 'players_rank'
else
	remoteEvent = script:WaitForChild("players_rank")
	print(`Client {script.Name} {game.Players.LocalPlayer} detected {remoteEvent.Name}.`)
end

local kills = {}

function players_rank.GetKills(key)
	if kills[key] == nil then
		kills[key] = 0
	end
	return kills[key]
end

function players_rank.SetKills(key, value)
	kills[key] = value
	
	if isServer then
		-- Synchronize the data to the client
		remoteEvent:FireAllClients(key, value)
	else
		remoteEvent:FireServer(key, value)
	end
	
end

function players_rank.AddKills(key, increase)
	local value = kills[key] or 0
	value = value + increase
	players_rank.SetKills(key, value)
end

if isServer then
	-- Listen for client updates
	remoteEvent.OnServerEvent:Connect(function(player, key, value)
		print(`{script.Name} OnServerEvent {player} [{key} = {value}]`)
		kills[key] = value

		remoteEvent:FireAllClients(key, value)
	end)
	print(`Server {script.Name} OnServerEvent connected.`)
else
	remoteEvent.OnClientEvent:Connect(function(key, value)
		print(`{script.Name} OnClientEvent [{key} = {value}]`)
		kills[key] = value
	end)

	print(`Client {script.Name} {game.Players.LocalPlayer} OnClientEvent connected.`)
end


return players_rank
