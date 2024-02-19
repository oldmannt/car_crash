local spwan_car = {}


local spawnLocation = game.Workspace.SpawnLocation -- Replace "SpawnLocation" with the actual name of your spawn location
local function cloneRandomCar()
    local carModels = game.ServerStorage.CarModels:GetChildren()
    local randomIndex = math.random(1, #carModels)
    local randomCar = carModels[randomIndex]

    local newCar = randomCar:Clone()

    return newCar
end

local function getBoundingBox(model)
    local min, max = model:GetBoundingBox()
    return min, max
end



local function cloneCar()

    
    local newCar = carModel:Clone()
    local carSize = newCar.Size

    -- Check if there is already a car at the spawn location
    local existingCar = spawnLocation:FindFirstChild("Car")
    if existingCar then
        -- Offset the new car by the size of the existing car
        local offset = existingCar.Size + carSize
        newCar.Position = existingCar.Position + offset
    else
        newCar.Position = spawnLocation.Position
    end

    -- Make sure the cloned car won't overlap with other objects
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {newCar}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local raycastResult = workspace:Raycast(newCar.Position, Vector3.new(0, -1, 0), raycastParams)
    if raycastResult then
        newCar.Position = raycastResult.Position + Vector3.new(0, carSize.Y / 2, 0)
    end

    -- Make sure the cloned car is always on the ground
    local raycastResult2 = workspace:Raycast(newCar.Position, Vector3.new(0, -1, 0), raycastParams)
    if raycastResult2 then
        newCar.Position = raycastResult2.Position + Vector3.new(0, carSize.Y / 2, 0)
    end

    newCar.Parent = workspace
end

return cloneCar



return spwan_car