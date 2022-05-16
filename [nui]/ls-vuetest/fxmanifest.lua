fx_version 'cerulean'
game 'gta5'

author 'Kyeong hoon'
description 'A Vue JS Test for FiveM'
version '1.0.0'

ui_page 'html/index.html'

files {
  'html/index.html',
  'html/js/app.js',
  'html/img/*',
}

-- What to run
shared_scripts {
  'shared/sh_*.lua'
}

client_scripts {
  'client/cl_*.lua'
}

server_scripts {
  'server/sv_*.lua'
}