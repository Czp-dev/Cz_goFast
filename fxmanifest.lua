fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Cz' 
description 'CZP GoFast Script'
version '1.0.0'


client_scripts {
    'client/cl_mission.lua',
}


server_scripts {
    'server/sv_mission.lua'
}

shared_script {
    '@es_extended/imports.lua',
    'Config.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/css/styles.css',
    'html/js/app.js',
    'html/image/mapN.png',
    'html/image/mapN1.png',
    'html/image/mapN2.png',
    'html/image/mapN3.png'
}
