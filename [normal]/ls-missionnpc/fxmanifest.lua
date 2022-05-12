
fx_version 'cerulean'
games {'gta5'}

author 'KyeongHoon'
description 'Npcs mission script for KOR LS Server'
version '1.0'

client_scripts {
	'@es_extended/locale.lua',

	'config.lua',
	'client/*.lua',
	'locales/*.lua'
}

server_scripts {
	'@es_extended/locale.lua',

	'config.lua',
	'server/*.lua',
	'locales/*.lua'
}
