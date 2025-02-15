fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'VotreNom' -- Remplacez par votre nom
description 'CZP GoFast Script'
version '1.0.0'

-- Scripts côté client
client_scripts {
    'client/Mission1.lua',
}

-- Scripts côté serveur
server_scripts {
    'server/server.lua'
}

shared_script '@es_extended/imports.lua'
-- Fichiers HTML (UI)
ui_page 'html/index.html'

-- Fichiers à inclure pour l'interface utilisateur
files {
    'html/index.html',
    'html/css/styles.css',
    'html/js/app.js',
    'html/image/mapN.png',
    'html/image/mapN1.png',
    'html/image/mapN2.png',
    'html/image/mapN3.png'
}
