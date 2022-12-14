#!/bin/bash

##
## Batocera.PLUS
##
## Cria a esturura de pastas padrão para todas as versões do wine.
## Esta estrutura é necessária para savar o jogo.
## Este script é parte integrante do script de execução do wine.
##

FOLDERS=(
    'ProgramData/Microsoft/Windows/Templates'
    'ProgramData/Microsoft/Windows/Start Menu/Programs/Administrative Tools'
    'ProgramData/Microsoft/Windows/Start Menu/Programs/StartUp'

    'users/wine/Templates'
    'users/wine/Music'
    'users/wine/Application Data/Microsoft/Windows'
    'users/wine/Application Data/Microsoft/Windows/Themes'
    'users/wine/Favorites'
    'users/wine/Pictures'
    'users/wine/Downloads'
    'users/wine/Links'
    'users/wine/Searches'
    'users/wine/AppData/LocalLow'
    'users/wine/AppData/Local/Microsoft/Windows/History'
    'users/wine/AppData/Local/Microsoft/Windows/INetCookies'
    'users/wine/AppData/Local/Microsoft/Windows/INetCache'
    'users/wine/AppData/Roaming/Microsoft/Windows/Templates'
    'users/wine/AppData/Roaming/Microsoft/Windows/Themes'
    'users/wine/AppData/Roaming/Microsoft/Windows/Printer Shortcuts'
    'users/wine/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Administrative Tools'
    'users/wine/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/StartUp'
    'users/wine/AppData/Roaming/Microsoft/Windows/Recent'
    'users/wine/AppData/Roaming/Microsoft/Windows/SendTo'
    'users/wine/AppData/Roaming/Microsoft/Windows/Network Shortcuts'
    'users/wine/Contacts'
    'users/wine/Temp'
    'users/wine/Saved Games'
    'users/wine/Documents'
    'users/wine/Desktop'
    'users/wine/Videos'

    'users/root/Templates'
    'users/root/Music'
    'users/root/Favorites'
    'users/root/Pictures'
    'users/root/Downloads'
    'users/root/Links'
    'users/root/Searches'
    'users/root/Contacts'
    'users/root/Temp'
    'users/root/Saved Games'
    'users/root/Documents'
    'users/root/Desktop'
    'users/root/Videos'
    'users/root/AppData/LocalLow'
    'users/root/Application Data/Microsoft/Windows/Themes'
    'users/root/AppData/Local/Microsoft/Windows/History'
    'users/root/AppData/Local/Microsoft/Windows/INetCookies'
    'users/root/AppData/Local/Microsoft/Windows/INetCache'
    'users/root/AppData/Roaming/Microsoft/Windows/Templates'
    'users/root/AppData/Roaming/Microsoft/Windows/Themes'
    'users/root/AppData/Roaming/Microsoft/Windows/Printer Shortcuts'
    'users/root/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Administrative Tools'
    'users/root/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/StartUp'
    'users/root/AppData/Roaming/Microsoft/Windows/Recent'
    'users/root/AppData/Roaming/Microsoft/Windows/SendTo'
    'users/root/AppData/Roaming/Microsoft/Windows/Network Shortcuts'

    'users/0/Templates'
    'users/0/Application Data/Microsoft/Windows/Themes'
    'users/0/Downloads'
    'users/0/AppData/Local/Microsoft/Windows/History'
    'users/0/AppData/Local/Microsoft/Windows/INetCookies'
    'users/0/AppData/Local/Microsoft/Windows/INetCache'
    'users/0/Temp'
    'users/0/Desktop'

    'users/Public/Music'
    'users/Public/Pictures'
    'users/Public/Documents'
    'users/Public/Desktop'
    'users/Public/Videos'
)

################################################################################

##
## Cria a extrutuda de pastas para o save.
##

PROFILE_DIR="${1}"

## Teste de sanidade.

if [ -z "${1}" ]
then
    exit 1
fi

## Cria a estrutura de pastas.

for FOLDER in "${FOLDERS[@]}"
do
    mkdir -p "${PROFILE_DIR}/${FOLDER}"
done

## Remove links simbólicos para pasta que foram criadas pelo wine.

for FILE in "${PROFILE_DIR}/users/root/"* \
            "${PROFILE_DIR}/users/0/"* \
            "${PROFILE_DIR}/users/wine/"*
do
    if [ -L "${FILE}" ]
    then
        rm "${FILE}"
    fi
done

## Ativa a compatibilidade dos saves do wine com o proton.

if ! [ -e "${PROFILE_DIR}/users/steamuser" ]
then
    ln -sf wine "${PROFILE_DIR}/users/steamuser"
fi

exit 0
