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
		if seat.Occupant and Players:GetPlayerFromCharacter(seat.Occupant.Parent) then
			return seat.Occupant
		end
	end
end

local function onTouchedCrash(hitPart:BasePart, beHittedPart:BasePart)

	if beHittedPart:HasTag(CrashTag) then
		return
	end
	
	local beHittedModel = beHittedPart:FindFirstAncestorOfClass("Model")
	if not beHittedModel then
		return
	end
	local model = hitPart:FindFirstAncestorOfClass("Model")
	if not model then
		return
	end
	-- don't hit self  
	if beHittedModel == model then
		return
	end

	if model:IsAncestorOf(beHittedModel) or 
		beHittedModel:IsAncestorOf(model) then
		return
	end

	--print(`hitPart {model:GetFullName()}, hit {beHittedModel:GetFullName()}`)
	local hittedPlayer = getHittedPlayer(beHittedPart, beHittedModel)

	print(`{hitPart:GetFullName()} hit {beHittedPart:GetFullName()} {hittedPlayer}` )
	beHittedPart:BreakJoints()
	-- check if the above BreakJoints kill a player
	if hittedPlayer then
		local killer:Player = getDriver(hitPart)

		if not killer then
			print(`Boom {beHittedModel.Name} crash self`) 
			--Rank.AddKills(hittedPlayer.Name, 1)
			return
		end
		
		if killer then
			print(`Boom {killer.Name} creashed {beHittedModel.Name}`)
			Rank.AddKills(killer.Name, 1)
		end
	end
end

TagUtil.ConnectTag(CrashTag, function(obj:Instance)
	if not obj:IsA("BasePart") then
		return
	end

	if not obj:FindFirstAncestorOfClass("Model") then
		return
	end

	print(`TagUtil connect {obj:GetFullName()} to the tag {CrashTag}`)
	return obj.Touched:Connect(function(part:BasePart)
		onTouchedCrash(obj, part)
	end)
end)