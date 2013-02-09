:: FOR FLASH COMPILE
"bin\flash\bin\LocalContentUpdater.exe" -a "bin\flash\bin\GolPlayTheGame.swf"

nme test build.nmml flash

"bin\flash\bin\LocalContentUpdater.exe" -a "bin\flash\bin\GolPlayTheGame.swf"

:: FOR FLASH DEBUG
:: nme test build.nmml flash -debug

:: FOR DEBUG
:: nme test build.nmml windows -neko -debug
:: nme test build.nmml windows -neko

:: haxe -main src/Server
:: haxe -neko src/server.n