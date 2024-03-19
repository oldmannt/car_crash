local CarPlacement = require(script.Parent.car_placement)
local PlayerJoin = {}

function PlayerJoin.handleJoin(player)
    CarPlacement.placeNewCar(player)
end

game.Players.PlayerAdded:Connect(function(player)
    print(`PlayerAdded {player.Name}`)
    --PlayerJoin.handleJoin(player)

    player.CharacterAdded:Connect(function(character)
        print(`CharacterAdded {player.Name}`)
        CarPlacement.placeNewCar(player)
    end)
end)

return PlayerJoin