fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'wokn'
description 'wokn-slashtire | Slash tires with sharp weapons'
version '1.0.0'
shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}
client_scripts {
    'client/client.lua',
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua',
}
dependencies {
    'ox_lib',
    'ox_target',
    'ox_inventory',
    'es_extended',
}
