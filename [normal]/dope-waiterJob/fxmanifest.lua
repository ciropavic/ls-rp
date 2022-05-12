fx_version 'adamant'
game'gta5'

client_scripts {
    'clientSide/main.lua',
    'config.lua'
} 

server_scripts {
    '@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
    'serverSide/main.lua'
}
