local module = {}

-- get spwanlocation by team color
local function getSpawnLocation(teamColor)
    local children = game.Workspace:GetChildren()
    for _, child:Instance in children do
        if not child:IsA("SpawnLocation") then
            continue
        end
        if child.TeamColor == teamColor then
            return child
        end
    end
    return nil
end

-- get a random child of game.ServerStorage.CrashCars.Cars
local function getRandomChild()
    local cars = game.ServerStorage.CrashCars.Cars:GetChildren()
    local randomIndex = math.random(1, #cars)
    return cars[randomIndex]
end

function module.placeNewCar(player:Player)
	local teamColor = player.TeamColor
    local spawnLocation = getSpawnLocation(teamColor)
    if not spawnLocation then
        return
    end
    local orignalCar:Model = getRandomChild()::Model
    local car = orignalCar:Clone()

    local size = car:GetExtentsSize()
    
-- place the car next to the spawnLocation
    car:PivotTo()
    car.Position = spawnLocation.Position + Vector3.new(size.X, 0, 0)
    car.Parent = game.Workspace
end

return module
