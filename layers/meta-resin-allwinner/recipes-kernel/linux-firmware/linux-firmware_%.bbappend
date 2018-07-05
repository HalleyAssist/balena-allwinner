FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# These firmware files are fetched from  https://github.com/armbian/firmware/tree/master/brcm
# and https://github.com/RPi-Distro/firmware-nonfree
SRC_URI_append = " \
    file://brcmfmac43430-sdio.bin \
    file://brcmfmac43430-sdio.txt \
    file://brcmfmac43430a0-sdio.bin \
    file://brcmfmac43430a0-sdio.txt \
    file://config.txt \
    file://brcmfmac43362-sdio.txt \
    "

do_install_append() {
    cp ${WORKDIR}/brcmfmac43430-sdio.bin ${D}/lib/firmware/brcm/brcmfmac43430-sdio.bin
    cp ${WORKDIR}/brcmfmac43430-sdio.txt ${D}/lib/firmware/brcm/brcmfmac43430-sdio.txt
    cp ${WORKDIR}/brcmfmac43430a0-sdio.bin ${D}/lib/firmware/brcm/brcmfmac43430a0-sdio.bin
    cp ${WORKDIR}/brcmfmac43430a0-sdio.txt ${D}/lib/firmware/brcm/brcmfmac43430a0-sdio.txt
    cp ${WORKDIR}/config.txt ${D}/lib/firmware/brcm/config.txt
    cp ${S}/brcm/brcmfmac43362-sdio.bin ${D}/lib/firmware/brcm/
    cp ${WORKDIR}/brcmfmac43362-sdio.txt ${D}/lib/firmware/brcm/
}

PACKAGES =+ "${PN}-ap6212 ${PN}-brcm43362"

FILES_${PN}-ap6212 = " \
  /lib/firmware/brcm/brcmfmac43430-sdio.bin \
  /lib/firmware/brcm/brcmfmac43430-sdio.txt \
  /lib/firmware/brcm/brcmfmac43430a0-sdio.bin \
  /lib/firmware/brcm/brcmfmac43430a0-sdio.txt \
  /lib/firmware/brcm/config.txt \
"

FILES_${PN}-brcm43362 = " \
  /lib/firmware/brcm/brcmfmac43362-sdio.bin \
  /lib/firmware/brcm/brcmfmac43362-sdio.txt \
"
