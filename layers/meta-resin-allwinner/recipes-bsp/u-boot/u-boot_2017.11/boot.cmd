#
# Please edit /boot/config.txt to set supported parameters
#

setenv load_addr "0x44000000"
setenv overlay_error "false"

# Default values
setenv console "serial"
setenv docker_optimizations "on"
setenv disp_mem_reserves "off"
setenv disp_mode "1920x1080p60"
setenv logo "disabled"
setenv overlay_prefix "sun8i-h3"
setenv rootfstype "ext4"
setenv verbosity "1"
setenv overlays "uart1 uart2 usbhost1 usbhost2"

# Sevice number of eMMC is 1, SD card is 0
if itest.b *0x28 == 0x00; then
	echo "U-boot loaded from SD"
	setenv ${devnum} 0
elif itest.b *0x28 == 0x02; then
	echo "U-boot loaded from eMMC"
	setenv ${devnum} 1
else
	echo "U-boot loaded from something else, good luck"
	# NMP
fi

load ${devtype} ${devnum} ${load_addr} ${prefix}config.txt
env import -t ${load_addr} ${filesize}
part uuid mmc ${devnum}:1 partuuid

# Setting RESIN_HOST_CONFIG_resinos to rootB loads uImage.rootB with rootB OS
if test "${resinos}" = "rootB"; then
	setenv kernel "uImage.rootB";
	setenv rootdev "/dev/mmcblk${devnum}p3";
else
	setenv kernel "uImage";
	setenv rootdev "/dev/mmcblk${devnum}p2";
fi

if test "${logo}" = "disabled"; then setenv logo "logo.nologo"; fi
if test "${console}" = "display" || test "${console}" = "both"; then setenv consoleargs "console=tty1"; fi
if test "${console}" = "serial" || test "${console}" = "both"; then setenv consoleargs "${consoleargs} console=ttyS0,115200"; fi

setenv bootargs "root=${rootdev} rootwait rootfstype=${rootfstype} ${consoleargs} hdmi.audio=EDID:0 disp.screen0_output_mode=${disp_mode} panic=10 consoleblank=0 loglevel=${verbosity} ubootpart=${partuuid} ubootsource=${devtype}"

if test "${disp_mem_reserves}" = "off"; then setenv bootargs "${bootargs} sunxi_ve_mem_reserve=0 sunxi_g2d_mem_reserve=0 sunxi_fb_mem_reserve=0 cma=0"; fi

if test "${docker_optimizations}" = "on"; then setenv bootargs "${bootargs} cgroup_enable=memory swapaccount=1"; fi

setenv bootargs "${bootargs} ${extraargs}"

echo "Found mainline kernel configuration"
load ${devtype} ${devnum} ${fdt_addr_r} ${prefix}dtb/${fdtfile}
fdt addr ${fdt_addr_r}
fdt resize 65536
for overlay_file in ${overlays}; do
	if load ${devtype} ${devnum} ${load_addr} ${prefix}dtb/overlay/${overlay_prefix}-${overlay_file}.dtbo; then
		echo "Applying kernel provided DT overlay ${overlay_prefix}-${overlay_file}.dtbo"
		fdt apply ${load_addr} || setenv overlay_error "true"
	fi
done
for overlay_file in ${user_overlays}; do
	if load ${devtype} ${devnum} ${load_addr} ${prefix}overlay-user/${overlay_file}.dtbo; then
		echo "Applying user provided DT overlay ${overlay_file}.dtbo"
		fdt apply ${load_addr} || setenv overlay_error "true"
	fi
done
if test "${overlay_error}" = "true"; then
	echo "Error applying DT overlays, restoring original DT"
	load ${devtype} ${devnum} ${fdt_addr_r} ${prefix}dtb/${fdtfile}
else
	if load ${devtype} ${devnum} ${load_addr} ${prefix}dtb/overlay/${overlay_prefix}-fixup.scr; then
		echo "Applying kernel provided DT fixup script (${overlay_prefix}-fixup.scr)"
		source ${load_addr}
	fi
	if test -e ${devtype} ${devnum} ${prefix}fixup.scr; then
		load ${devtype} ${devnum} ${load_addr} ${prefix}fixup.scr
		echo "Applying user provided fixup script (fixup.scr)"
		source ${load_addr}
	fi
fi

echo "Loading kernel from ${kernel} with root as ${rootdev}"
load ${devtype} ${devnum} ${kernel_addr_r} ${prefix}${kernel}
bootm ${kernel_addr_r} - ${fdt_addr_r}


setenv prefix "/"
setenv devnum "1"
setenv rootdev "/dev/mmcblk${devnum}p2";
setenv kernel "uImage";
echo load ${devtype} ${devnum} ${kernel_addr_r} ${prefix}${kernel}
