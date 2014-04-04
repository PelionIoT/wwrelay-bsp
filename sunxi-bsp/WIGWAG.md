sunxi-bsp 
===========

Sunxi-BSP from Allwinner's dev team

Original at: [https://github.com/linux-sunxi/sunxi-bsp](https://github.com/linux-sunxi/sunxi-bsp)

WigWag specifics
===========
This tree is essentially the official Allwinner BSP as of 3/18/2014 but without the annoying submodules. It also has specific changes / additions to support the WigWag Relay.

**Prerequisites**

Platform support: This is tested on Linux x86_64 only so far.

You will need to run update-prereqs.sh and expand-prereqs.sh to setup the correct cross compiler.

Ubuntu users - You will need:
<code>sudo apt-get install libusb-1.0</code>
and
<code>sudo apt-get install uboot-mkimage</code>

**Toolchains**

Linaro: https://releases.linaro.org/13.06/components/toolchain/binaries

**Building**

From the root level of the project:
    ./build_relay_BSP.sh build


If you need to modify the Linux kernel configuration, you can:
    ./build_relay_BSP.sh configkernel

and then do a <code>./build_relay_BSP.sh build</code>

Running <code>build_relay_BSP.sh</code> with no parameters will clean the tree.

If you want to keep the changes to the kernel in the source tree, you should copy the file <code>WIGWAG_RELAY_kernel.config.current</code> over <code>WIGWAG_RELAY_kernel.config</code>
We do all this to work around the sunxi default scripts which simply want to overwrite the kernel config constantly. (Note the Makefile changes from the base sunxi-bsp)


Historical...
-----------

Old email from Zhu, kept for historical reasons. old info.

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
