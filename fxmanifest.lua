fx_version "cerulean"
game "gta5"

shared_scripts {
  "@ox_lib/init.lua",
}

files {
  "locales/*.json",
  "shared/*.lua",
  "server/frameworks/*.lua",
  "web/dist/**/*",
  "stream/*.ycd"
}

ui_page "web/dist/index.html"
--[[ ui_page "http://localhost:3000" ]]

client_scripts {
  "client/modules/settings.lua",
  "client/modules/radio-object.lua",
  "client/modules/nui.lua",
  "client/modules/channels.lua",
  "client/main.lua"
}

server_scripts {
  "server/main.lua"
}

ox_lib {
  "locale"
}

dependencies {
  "ox_inventory",
  "pma-voice",
  "ox_lib"
}
