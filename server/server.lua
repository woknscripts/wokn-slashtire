local ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('wokn-slashtire:server:slashTire', function(netId, tireIndex, weaponName)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if not xPlayer then return end

    local hasItem = false
    for _, weapon in ipairs(Config.SharpWeapons) do
        if weapon == weaponName then
            local item = exports.ox_inventory:GetItem(src, weaponName, nil, false)
            if item and item.count and item.count > 0 then
                hasItem = true
                break
            end
        end
    end

    if not hasItem then
        print('[wokn-slashtire] Player ' .. src .. ' tried to slash tire without valid sharp item: ' .. tostring(weaponName))
        return
    end

    local vehicle = NetworkGetEntityFromNetworkId(netId)
    if not DoesEntityExist(vehicle) then
        return
    end

    if tireIndex < 0 or tireIndex > 5 then
        return
    end

    if Config.Debug then
        print('[wokn-slashtire] Player ' .. src .. ' slashed tire ' .. tireIndex .. ' on vehicle netId ' .. netId)
    end

    TriggerClientEvent('wokn-slashtire:client:confirmed', -1, netId, tireIndex)
end)
