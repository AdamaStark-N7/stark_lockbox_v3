fx_version 'cerulean'

use_experimental_fxv2_oal 'yes'

lua54 'yes'

game 'gta5'

name 'stark_lockbox_v3'

author 'Adama Stark'

version '3.0.0'

repository 'https://github.com/AdamaStark-N7/stark_lockbox_v3'

description 'A Vehicle Lockbox Script for Qbox & QBCore'

ox_lib 'locale'

shared_script {
    'config.lua',
    '@ox_lib/init.lua',
}

client_scripts {
    'bridge/client/**.lua',
    'client/*.lua',
}

server_scripts {
    'bridge/server/**.lua',
    'server/*.lua'
}

files {
    'locales/*.json',
}

dependency {
    'ox_lib'
}