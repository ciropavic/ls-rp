
fx_version 'cerulean'
games {'gta5'}

author 'KyeongHoon'
description 'Gang Faction Manager for KOR LS Server'
version '1.0'

client_scripts {
	'@es_extended/locale.lua',
	'client/*.lua',
	'locales/*.lua'
}

server_scripts {
	'@es_extended/locale.lua',
  '@mysql-async/lib/MySQL.lua',
  'server/Modules/Functions.lua',
	'server/main.lua',
	'locales/*.lua'
}

shared_scripts {
  'Shared/Config.lua'
}

ui_page 'UI/index.html'

files {
    'UI/index.html',
    'UI/script.js',
    'UI/style.css',
}