#!/bin/bash
###
### Batocera.PLUS
### Alexandre Freire dos Santos
###

KERNEL_VERSION=$(uname -r)

if ! [ -f "/lib/modules/${KERNEL_VERSION}/extra/nvidia.ko" ]
then
    exit 0
fi

DRIVER_VERSION=$(
    modinfo /lib/modules/${KERNEL_VERSION}/extra/nvidia.ko |
        grep -E '^version: ' |
        awk '{print $2}' |
        cut -d '.' -f 1
)

case ${DRIVER_VERSION} in
    470|390|340)
        DRIVER_VERSION=v${DRIVER_VERSION}
        ;;
    *)
        DRIVER_VERSION=last
esac

DRIVER_FILES=(
    $(find "/opt/Nvidia/${DRIVER_VERSION}" ! -type d)
    /etc/modprobe.d/nvidia-driver.conf
    /usr/share/applications/nvidia-config.desktop
)


for DRIVER_FILE in ${DRIVER_FILES[@]}
do
    FILE=$(echo ${DRIVER_FILE} | sed "s|/opt/Nvidia/${DRIVER_VERSION}||")
    rm -f ${FILE}
    rm -f /overlay/overlay${FILE}
done

exit 0
