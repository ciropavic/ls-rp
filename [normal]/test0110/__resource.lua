fx_version 'adamant'

game 'gta5'

description 'Weapon Event By.Kyeonghoon'

version '0.0.1'

client_script{
    "client.lua",
    '@es_extended/locale.lua'
} 

server_scripts 
{
    "server.lua",
    '@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua'
}

dependencies {
    'es_extended'
}