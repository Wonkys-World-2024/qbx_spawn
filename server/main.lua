lib.versionCheck('Qbox-project/qbx_spawn')

lib.callback.register('qbx_spawn:server:getLastLocation', function(source)
    local player = exports.qbx_core:GetPlayer(source)
    return json.decode(MySQL.single.await('SELECT position FROM players WHERE citizenid = ?', {player.PlayerData.citizenid}).position), player.PlayerData.metadata.inside and player.PlayerData.metadata.inside.propertyId
end)

lib.callback.register('qbx_spawn:server:getProperties', function(source)
    local player = exports.qbx_core:GetPlayer(source)
    local houseData = {}

    local houses = MySQL.query.await('SELECT * FROM properties WHERE owner_citizenid = ?', {player.PlayerData.citizenid})

    if not houses then return {} end

    for i = 1, #houses do
        local house = houses[i]
            if not house.apartment then
            local door = exports['ps-housing']:getMainDoor(house.property_id, 1)
            local coords = door.objCoords or door.coords or door.doors[1] and door.doors[1].coords or door.doors[1].objCoords
            houseData[#houseData + 1] = {
                label = house.street,
                coords = coords
            }
        end
    end

    return houseData
end)