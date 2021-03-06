SECTION = "kernel"
DESCRIPTION = "Mainline Linux kernel"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"
COMPATIBLE_MACHINE = "(sun4i|sun5i|sun7i|sun8i|sun50i)"

inherit kernel

# Since we're not using git, this doesn't make a difference, but we need to fill
# in something or kernel-yocto.bbclass will fail.
KBRANCH ?= "master"

# Pull in the devicetree files into the rootfs
RDEPENDS_${KERNEL_PACKAGE_NAME}-base += "kernel-devicetree"

KERNEL_EXTRA_ARGS += "LOADADDR=${UBOOT_ENTRYPOINT}"
KERNEL_VERSION = "4.19.50"
PV = "${KERNEL_VERSION}"
S = "${WORKDIR}/linux-${PV}"
SRCREV_pn-${PN} = "v${KERNEL_VERSION}"
SRC_URI[sha256sum] = "a9987423918abd20ee68d6e9b14b7225eaca8a586bf75fb56c49f6e1e47ce01e"
SRC_URI = "https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-${PV}.tar.xz \
	   file://defconfig \
"
