local TagUtil = require(game.ReplicatedStorage.game_play_util.tag_util)
local Rank = require(game.ReplicatedStorage.game_play.rank)
local Players = game.Players

local CrashTag = "CrashPart"

local function getHittedPlayer(hit:BasePart, model:Model)
	local humanoid:Humanoid = model:FindFirstChild("Humanoid")
	if not humanoid then return false end

	if humanoid.Health <= 0 then
		return false
	end

	if hit.Name ~= "Head" and hit.Name ~= "UpperTorso" then
		return false
	end

	return Players:GetPlayerFromCharacter(model)
end

-- part is a part of a Car model, return the Driver
local function getDriver(part:BasePart)
	local car:Model = part:FindFirstAncestorOfClass("Model")
	if not car then return nil end

	local descendants = car:GetDescendants()
	local desiredClass = "VehicleSeat"
	local instancesOfDesiredClass = {}

	for i, descendant in ipairs(descendants) do
		if descendant:IsA(desiredClass) then
			table.insert(instancesOfDesiredClass, descendant)
		end
	end

	for i, seat in ipairs(instancesOfDesiredClass) do
		if seat.Occupant and Players:GetPlayerFromCharacter(seat.Occupant) then
			return seat.Occupant
		end
	end
end

local function onTouchedCrash(hitPart:BasePart, beHittedPart:BasePart)

	-- don't hit self
	local model = beHittedPart:FindFirstAncestorOfClass("Model")
	if script.Parent.Parent == model then
		return
	end

	if beHittedPart:HasTag(CrashTag) then
		return
	end
	local hittedPlayer = getHittedPlayer(beHittedPart, model)

	print(`hit {beHittedPart:GetFullName()}`)
	beHittedPart:BreakJoints()
	-- check if the above BreakJoints kill a player
	if hittedPlayer then
		local killer:Player = getDriver(hitPart)

		if not killer then
			print(`Boom {model.Name} crash self`) 
			--Rank.AddKills(hittedPlayer, 1)
			return
		end
		
		if killer then
			print(`Boom {killer.Name} creashed {model.Name}`)
			Rank.AddKills(killer, 1)
		end
	end
end

TagUtil.ConnectTag(CrashTag, function(obj:Instance)
	if not obj:IsA("BasePart") then
		return
	end

	print(`TagUtil connect {obj:GetFullName()} to the tag {CrashTag}`)
	return obj.Touched:Connect(function(part:BasePart)
		onTouchedCrash(obj, part)
	end)
end)