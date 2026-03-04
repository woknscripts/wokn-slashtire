local ESX = exports['es_extended']:getSharedObject()

local onCooldown = false

local tireBones = {
    [0] = 'wheel_lf',
    [1] = 'wheel_rf',
    [2] = 'wheel_lm',  
    [3] = 'wheel_rm',
    [4] = 'wheel_lr',
    [5] = 'wheel_rr',
}

local function PlayTirePopSound(coords)
    SendNUIMessage({ type = 'playsound' }) 
    PlaySoundFromCoord(-1, 'TYRE_POP', coords.x, coords.y, coords.z, 'VEHICLE_HANDLING_SOUNDS', true, 30.0, false)
end

local function HasSharpWeapon()
    local playerInventory = exports.ox_inventory:Items()
    if not playerInventory then return false, nil end

    for _, itemData in pairs(playerInventory) do
        for _, weapon in ipairs(Config.SharpWeapons) do
            if itemData.name == weapon and itemData.count and itemData.count > 0 then
                return true, itemData.name
            end
        end
    end
    return false, nil
end

local function GetClosestTireIndex(vehicle)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local closestIndex = 0
    local closestDist = math.huge

    for i = 0, 5 do
        local boneName = tireBones[i]
        if boneName then
            local boneIdx = GetEntityBoneIndexByName(vehicle, boneName)
            if boneIdx ~= -1 then
                local boneCoords = GetWorldPositionOfEntityBone(vehicle, boneIdx)
                local dist = #(playerCoords - boneCoords)
                if dist < closestDist then
                    closestDist = dist
                    closestIndex = i
                end
            end
        end
    end

    return closestIndex
end

local function SlashTire(vehicle)
    if onCooldown then
        lib.notify({ title = 'Slash Tire', description = 'You need to wait before slashing again.', type = 'error' })
        return
    end

    local hasWeapon, weaponName = HasSharpWeapon()
    if not hasWeapon then
        lib.notify({ title = 'Slash Tire', description = 'You need a sharp weapon to slash a tire.', type = 'error' })
        return
    end

    if GetVehicleNumberOfPassengers(vehicle) > 0 or GetPedInVehicleSeat(vehicle, -1) ~= 0 then
        lib.notify({ title = 'Slash Tire', description = 'Cannot slash tires of an occupied vehicle.', type = 'error' })
        return
    end

    local ped = PlayerPedId()
    local tireIndex = GetClosestTireIndex(vehicle)

    lib.requestAnimDict(Config.Animation.dict)

    TaskPlayAnim(ped, Config.Animation.dict, Config.Animation.anim, 2.0, -2.0, -1, Config.Animation.flags, 0, false, false, false)

    local success = lib.progressBar({
        duration = Config.ProgressDuration,
        label = 'Slashing tire...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            combat = true,
            move = true,
        },
        anim = {
            dict = Config.Animation.dict,
            clip = Config.Animation.anim,
        },
    })

    ClearPedTasks(ped)
    RemoveAnimDict(Config.Animation.dict)

    if success then
        local vehCoords = GetEntityCoords(vehicle)
        PlayTirePopSound(vehCoords)

        TriggerServerEvent('wokn-slashtire:server:slashTire', NetworkGetNetworkIdFromEntity(vehicle), tireIndex, weaponName)

        SetVehicleTyreBurst(vehicle, tireIndex, true, 1000.0)

        onCooldown = true
        SetTimeout(Config.Cooldown, function()
            onCooldown = false
        end)

        if Config.Debug then
            print('[wokn-slashtire] Slashed tire index:', tireIndex, '| Weapon:', weaponName)
        end
    else
        lib.notify({ title = 'Slash Tire', description = 'Tire slashing cancelled.', type = 'error' })
    end
end

exports.ox_target:addGlobalVehicle({
    {
        name        = 'wokn_slash_tire',
        label       = Config.TargetLabel,
        icon        = Config.TargetIcon,
        distance    = 2.5,
        onSelect    = function(data)
            SlashTire(data.entity)
        end,
        canInteract = function(entity)
            return DoesEntityExist(entity) and GetEntityType(entity) == 2
        end,
    }
})

RegisterNetEvent('wokn-slashtire:client:confirmed', function(netId, tireIndex)
    local vehicle = NetToVeh(netId)
    if DoesEntityExist(vehicle) then
        SetVehicleTyreBurst(vehicle, tireIndex, true, 1000.0)
        if Config.Debug then
            print('[wokn-slashtire] Server confirmed tire burst | netId:', netId, '| tire:', tireIndex)
        end
    end
end)
