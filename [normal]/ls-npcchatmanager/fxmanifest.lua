ui_page "html/index.html"
fx_version 'cerulean'
games {'gta5'}

author 'KyeongHoon'
description 'NPC Chatting Manager script for KOR LS Server'
version '1.0'

files {
-- 	"nui/index.html",
--   'nui/Listner.js',
--   'nui/style.css'
"html/index.html",
"html/index.css",
"html/index.js"
}


client_scripts {
	'@es_extended/locale.lua',

	'config.lua',
	'client/*.lua'
}

server_scripts {
	'@es_extended/locale.lua',

	'config.lua',
	'server/*.lua'
}
