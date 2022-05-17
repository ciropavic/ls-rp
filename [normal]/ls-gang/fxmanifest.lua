
fx_version 'cerulean'
games {'gta5'}

author 'KyeongHoon'
description 'Gang Faction Manager for KOR LS Server'
version '1.0'

client_scripts {
	'@es_extended/locale.lua',
  'Locale.lua',
  'Locales/*.lua',
	'client/*.lua',
  'client/Modules/warmenu.lua',
  'client/Creation.lua',
  'client/Modules/Functions.lua',
  'client/Modules/Menu.lua',
  'client/Modules/Events.lua',
  'client/Points.lua',
  'client/Modification.lua',
  'client/InteractionMenu.lua'
}

server_scripts {
  'Locale.lua',
  'Locales/*.lua',
	'@es_extended/locale.lua',
  '@mysql-async/lib/MySQL.lua',
  'server/Modules/Functions.lua',
	'server/main.lua',
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