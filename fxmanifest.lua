fx_version 'cerulean'
game 'gta5'

author 'MD Development / MathewGaming'
description 'MG HUD - Minimalist circular HUD'
version '1.0.0'

shared_script 'shared/config.lua'

ui_page 'html/index.html'

client_script 'client/client.lua'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/img/logo.png',
}

dependencies {
    'pma-voice'
}
