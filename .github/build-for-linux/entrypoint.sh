#!/bin/bash

wget https://nodejs.org/dist/v20.10.0/node-v20.10.0-linux-x64.tar.xz
tar -Jxvf ./node-v20.10.0-linux-x64.tar.xz
export PATH=$(pwd)/node-v20.10.0-linux-x64/bin:$PATH
npm install pnpm -g

rustup target add "$INPUT_TARGET"

if [ "$INPUT_TARGET" = "x86_64-unknown-linux-gnu" ]; then
    add-apt-repository universe
    apt-get update 
    apt-get install -y build-essential curl wget file libxdo-dev libssl-dev libayatana-appindicator3-dev librsvg2-dev libglib2.0-dev
    find /usr -name "glib-2.0.pc"
    pkg-config --libs --cflags glib-2.0
    export PKG_CONFIG_PATH=/usr/share/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig:$PKG_CONFIG_PATH
elif [ "$INPUT_TARGET" = "i686-unknown-linux-gnu" ]; then
    dpkg --add-architecture i386
    apt-get update
    apt-get install -y build-essential:i386 curl:i386 wget:i386 file:i386 libxdo-dev:i386 libssl-dev:i386 libayatana-appindicator3-dev:i386 librsvg2-dev:i386 libgtk-3-dev:i386
    export PKG_CONFIG_PATH=/usr/lib/i386-linux-gnu/pkgconfig/:$PKG_CONFIG_PATH
    export PKG_CONFIG_SYSROOT_DIR=/
elif [ "$INPUT_TARGET" = "aarch64-unknown-linux-gnu" ]; then
    dpkg --add-architecture arm64
    apt-get update
    apt-get install -y build-essential:arm64 curl:arm64 wget:arm64 file:arm64 libxdo-dev:arm64 libssl-dev:arm64 libayatana-appindicator3-dev:arm64 librsvg2-dev:arm64 libgtk-3-dev:arm64
    export CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER=aarch64-linux-gnu-gcc
    export CC_aarch64_unknown_linux_gnu=aarch64-linux-gnu-gcc
    export CXX_aarch64_unknown_linux_gnu=aarch64-linux-gnu-g++
    export PKG_CONFIG_PATH=/usr/lib/aarch64-linux-gnu/pkgconfig
    export PKG_CONFIG_ALLOW_CROSS=1
elif [ "$INPUT_TARGET" = "armv7-unknown-linux-gnueabihf" ]; then
    dpkg --add-architecture armhf
    apt-get update
    apt-get install -y build-essential:armhf curl:armhf wget:armhf file:armhf libxdo-dev:armhf libssl-dev:armhf libayatana-appindicator3-dev:armhf librsvg2-dev:armhf libgtk-3-dev:armhf
    export CARGO_TARGET_ARMV7_UNKNOWN_LINUX_GNUEABIHF_LINKER=arm-linux-gnueabihf-gcc
    export CC_armv7_unknown_linux_gnueabihf=arm-linux-gnueabihf-gcc
    export CXX_armv7_unknown_linux_gnueabihf=arm-linux-gnueabihf-g++
    export PKG_CONFIG_PATH=/usr/lib/arm-linux-gnueabihf/pkgconfig
    export PKG_CONFIG_ALLOW_CROSS=1
elif [ "$INPUT_TARGET" = "riscv64gc-unknown-linux-gnu" ]; then
    dpkg --add-architecture riscv64
    apt-get update
    apt-get install -y build-essential:riscv64 curl:riscv64 wget:riscv64 file:riscv64 libxdo-dev:riscv64 libssl-dev:riscv64 libayatana-appindicator3-dev:riscv64 librsvg2-dev:riscv64 libgtk-3-dev:riscv64
    export CARGO_TARGET_RISCV64_UNKNOWN_LINUX_GNU_LINKER=riscv64-linux-gnu-gcc
    export CC_riscv64_unknown_linux_gnu=riscv64-linux-gnu-gcc
    export CXX_riscv64_unknown_linux_gnu=riscv64-linux-gnu-g++
    export PKG_CONFIG_PATH=/usr/lib/riscv64-linux-gnu/pkgconfig
    export PKG_CONFIG_ALLOW_CROSS=1
else
    echo "Unknown target: $INPUT_TARGET" && exit 1
fi

bash .github/build-for-linux/build.sh