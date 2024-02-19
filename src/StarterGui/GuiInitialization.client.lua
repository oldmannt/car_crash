
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local Plasma = require(ReplicatedStorage.Plasma)
--local RemoteMessage = require(game.ReplicatedStorage.Events.RemoteMessage)
local Rank = require(game.ReplicatedStorage.game_play.rank)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Plasma"
screenGui.Parent = PlayerGui

local root = Plasma.new(screenGui)

RunService.Heartbeat:Connect(function()
	Plasma.start(root, function()
		Plasma.window(root, function()
			
			for _, player:Player in game.Players:GetPlayers() do
				Plasma.row({}, function()
					Plasma.label(player.Name)
					Plasma.label(`{Rank.GetKills(player.Name)}`)
				end)
				
			end

			if Plasma.button("New Car"):clicked() then
                print("New Car!")
            end
		end)
	end)
end)
