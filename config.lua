Config = {}

-- Items from ox_inventory that count as sharp weapons
Config.SharpWeapons = {
    'WEAPON_KNIFE',
    'WEAPON_SWITCHBLADE',
    'box_cutter',
    'hunting_knife',
    'dagger',
    'combat_knife',
    'machete',
    'razor',
}

-- Progress bar duration in ms
Config.ProgressDuration = 4000

-- Cooldown between slashing tires (ms) - prevents spam
Config.Cooldown = 3000

-- Animation
Config.Animation = {
    dict = 'amb@world_human_gardener_plant@male@base',
    anim = 'base',
    flags = 1,
}

-- ox_target icon and label
Config.TargetLabel = 'Slash Tire'
Config.TargetIcon  = 'fas fa-scissors'

-- Debug mode
Config.Debug = false
