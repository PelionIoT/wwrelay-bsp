sunxi-bsp 
===========

Sunxi-BSP from Allwinner's dev team

Original at: https://github.com/linux-sunxi/sunxi-bsp

**WigWag specifics**

Original from Zhu concerning build BSP (already done)

**Toolchains**

Linaro: https://releases.linaro.org/13.06/components/toolchain/binaries


> 1. git clone --recursive git://github.com/linux-sunxi/sunxi-bsp.git
>
> 2. copy attached Wigwag_controller.fex to sunxi-bsp/sunxi-boards/sys_config/a10
>
> 3. add a config line(as below) in Boards.cfg in sunxi-bsp/u-boot-sunxi, after the cubieboard config line.
>  "wigwag_controller			 arm         armv7       wigwag_controller   allwinner      sunxi       sun4i:SPL"
>
> 4. Make 2 changes in Makefile in sunxi-bsp/
> a: change "CROSS_COMPILE=arm-linux-gnueabihf-" to "CROSS_COMPILE=arm-linux-gnueabi-"
> b: comment this line: "$(Q)[ -s $(SD_CARD) ] || "Define SD_CARD variable""
>
> 5. in sunxi-media-create.sh that in /sunxi-bsp/scripts/:
> find this line: "cp -a "$ROOTFSDIR"/rootfs/* "$MNTROOT" || die "Failed to copy rootfs partition data to SD Card""
> comment the line after it, and lines before it up to "for x in '' \"
> 
> That's it, goto to sunxi-bsp/
> 
> to list all currently supported boards: ./configure 
> to configure it to our board: ./configure Wigwag_controller

> to config linux: Make linux-config
> 
> to make a full build and burn the built image into your micro sd card(say it's /dev/sdX, you have to plug it in first, and refuse to open it in file manager, and get rootfs.tar.gz ready, be careful on dev/sdX): 
> hwpack-install SD_CARD=/dev/sdX ROOTFS=../rootfs.tar.gz

> some times the burn would fail, to burn it again without any build: 
> sudo scripts/sunxi-media-create.sh /dev/sdX ???/sunxi-bsp/output/wigwag_controller_hwpack.tar.xz ../rootfs.tar.gz
> you have to change ??? to your sunxi-bsp location first, of course
