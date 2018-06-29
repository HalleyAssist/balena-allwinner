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

S = "${WORKDIR}/linux-${PV}"

# require recipes-kernel/linux/linux-dtb.inc
#require recipes-kernel/linux/linux.inc

# Default is to use stable kernel version
# If you want to use latest git version set to "1"
DEFAULT_PREFERENCE = "-1" 

# 4.13.12
PV = "4.14.14+git${SRCPV}"
SRCREV_pn-${PN} = "v4.14.14"


SRC_URI = "git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git;protocol=git;branch=linux-4.14.y \
        "
S = "${WORKDIR}/git"
