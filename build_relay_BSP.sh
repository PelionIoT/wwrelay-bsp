#!/bin/bash

if [ $HOME/dev-tools/bin/commons.source ]; then
    . $HOME/dev-tools/bin/commons.source
else 
    echo "Missing $HOME/dev-tools/bin/commons.source in your home directory. Need to fix this."
fi

# http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"



if [ ! -e "$DIR/sunxi-bsp/WIGWAG.md" ]; then 
    eval $COLOR_RED
    echo "Looks like a bad checkout - where is the sunxi-BSP?"
    eval $COLOR_NORMAL
    exit 1
fi

if [ "$1" == "configkernel" ]; then
    pushd $DIR/sunxi-bsp
    cp -a WIGWAG_RELAY-defconfig-linux ./build/sun4i_defconfig-linux
    cp ./WIGWAG_RELAY_kernel.config linux-sunxi/.config
    make linux-wwconfig
    eval $COLOR_BOLD
    echo "If you want to use the new config permanently copy $DIR/sunxi-bsp/build/sun4i_defconfig-linux/.config to $DIR/sunxi-bsp/WIGWAG_RELAY_kernel.config"
    echo ""
    echo "Otherwise: cd sunxi-bsp; make ww-controller"
    eval $COLOR_NORMAL
    exit 0
fi

if [ ! -e "$DIR/expanded-prereqs/bin/arm-linux-gnueabihf-gcc" ]; then
    eval $COLOR_YELLOW
    echo "Can't find cross compiler in expanded-prereqs - trying to download."
    eval $COLOR_NORMAL
    pushd $DIR
    ./update-prereqs.sh
    ./expanded-prereqs.sh
    popd   
fi

if [ ! -e "$DIR/expanded-prereqs/bin/arm-linux-gnueabihf-gcc" ]; then
    eval $COLOR_RED
    echo "Failed to install cross compiler."
    eval $COLOR_NORMAL
    exit 1
fi

eval $COLOR_BOLD
echo "Building OS"
eval $COLOR_NORMAL

pushd $DIR
. source-pre-build.sh
pushd sunxi-bsp
eval $COLOR_BOLD
echo "Cleaning old build."
eval $COLOR_NORMAL
make clean
pushd linux-sunxi
make mrproper
popd
./configure wigwag_controller

mkdir -p build
# make a build directory just as if "make linux-config" was ran in sunxi-bsp
cp -a WIGWAG_RELAY-defconfig-linux ./build/sun4i_defconfig-linux
cp ./WIGWAG_RELAY_kernel.config ./build/sun4i_defconfig-linux/.config

if [ ! -e "./build/sun4i_defconfig-linux/.config" ]; then
    eval $COLOR_RED
    echo "sunxi BSP config template missing or otherwise..."
    eval $COLOR_NORMAL
    exit 1
else 
    eval $COLOR_BOLD
    echo "cd sunxi-bsp; make ww-controller"
    eval $COLOR_NORMAL
fi

popd
popd



