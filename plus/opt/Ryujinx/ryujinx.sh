##
## Batocera.PLUS
##
## Código escrito por: Sérgio de Carvalho Júnior
## Colaborador: Alexandre Freire dos Santos
##
## https://discord.com/channels/410208534861447168/790357964749406249/855828176215080960
## https://unix.stackexchange.com/questions/57658/how-to-utilize-xdg-directories-and-paths-in-bash
## https://darthsternie.net/switch-firmwares/
## https://github.com/Ryujinx/Ryujinx/wiki/Ryujinx-Setup-&-Configuration-Guide
## https://emulation.gametechwiki.com/index.php/Shader_caches

################################################################################

### DIRECTORIES, FILES AND PARAMETERS

ROM="${1}"
P1GUID="${2}"
RENDER="${3}"

RYUJINX_EMU=/opt/Ryujinx/publish/Ryujinx
RYUJINX_DIR=/opt/Ryujinx
SAVE_DIR=/userdata/saves/switch
BIOS_DIR="${HOME}/../bios/yuzu/keys"

export XDG_CONFIG_HOME="${SAVE_DIR}"
export LD_LIBRARY_PATH=/opt/Ryujinx/lib:$LD_LIBRARY_PATH
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
export GSETTINGS_SCHEMA_DIR=/opt/Ryujinx/gschemas
export QT_PLUGIN_PATH=/opt/Ryujinx/plugins

################################################################################

### CREATE DIRS AND LINKS

function createDirs()
{
    if ! [ -d "${SAVE_DIR}/Ryujinx" ]; then
        # make save and log dirs
        mkdir -p "${SAVE_DIR}/Ryujinx"

        # create bios dir for ryujinx
        ln -s "${BIOS_DIR}" "${SAVE_DIR}/Ryujinx/system"
        cp -f "${RYUJINX_DIR}/default_config/Config.json" "${SAVE_DIR}/Ryujinx"
    fi

    if ! [ -d "${HOME}/logs/ryujinx" ]; then
        mkdir -p "${HOME}/logs/ryujinx"
    fi
}

################################################################################

### Firmware check

function TextLocalization()
{
   LANG="$(batocera-settings -command load -key system.language)"
   case $LANG in
      pt_BR) MSG[1]='\n NENHUM FIRMWARE FOI INSTALADO, INSTALE ANTES DE EXECUTAR O JOGO. \n' ;;
      es_ES) MSG[1]='\n NO SE HA INSTALADO FIRMWARE, INSTALAR ANTES DE EJECUTAR UN JUEGO. \n' ;;
      *)     MSG[1]='\n NO FIRMWARE HAS BEEN INSTALLED, INSTALL BEFORE RUN A GAME. \n'
   esac
}

function FirmwareWarning()
{
   yad --form \
   --title='WARNING' \
   --window-icon='/usr/share/icons/batocera/ryujinx.png' \
   --text=''"${MSG[1]}"'' \
   --undecorated \
   --text-align=center \
   --on-top \
   --fixed \
   --center \
   --no-escape \
   --timeout=3 \
   --no-buttons &
   exit 0
}

if [ -z "$(ls -A "${SAVE_DIR}/Ryujinx/bis/system/Contents/registered" 2> /dev/null)" ] && [ -e "${ROM}" ]; then
    TextLocalization
    FirmwareWarning
fi

if [ "${RENDER}" == 'vulkan' ]; then
    sed -i 's/"graphics_backend":.*/"graphics_backend": "Vulkan",/' "${SAVE_DIR}/Ryujinx/Config.json"
else
    sed -i 's/"graphics_backend":.*/"graphics_backend": "OpenGl",/' "${SAVE_DIR}/Ryujinx/Config.json"
fi

################################################################################

### Fix some settings

sed -i 's/"check_updates_on_start":.*/"check_updates_on_start": false,/'          "${SAVE_DIR}/Ryujinx/Config.json"
sed -i 's/"enable_discord_integration":.*/"enable_discord_integration": false,/'  "${SAVE_DIR}/Ryujinx/Config.json"
sed -i 's/"show_confirm_exit":.*/"show_confirm_exit": false,/'                    "${SAVE_DIR}/Ryujinx/Config.json"
sed -i 's/"audio_backend":.*/"audio_backend": "OpenAl",/'                         "${SAVE_DIR}/Ryujinx/Config.json"

################################################################################

### EXECUTION

createDirs

if [ -e "${ROM}" ]; then
   $MANGOHUD_CMD $RYUJINX_EMU --fullscreen "${ROM}"
else
   $RYUJINX_EMU
fi

################################################################################

exit 0
