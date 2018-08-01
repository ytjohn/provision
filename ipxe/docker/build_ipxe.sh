#!/bin/sh
set -e
set -x
mkdir -p /src/ipxe/bin
cd /src/ipxe/src
git clean -f -x -d
rm config/local/* || :
case $1 in
    "lkrn")
        cp /src/lkrn/*.h config/local/
        make -s -j8 bin/ipxe.lkrn
        cp bin/ipxe.lkrn ../bin/ipxe.lkrn;;
    "undionly")
        cp /src/undionly/*.h config/local/
        make -s -j8 bin/undionly.kpxe
        cp bin/undionly.kpxe ../bin/ipxe.pxe;;
    "snponly_x86_64")
        cp /src/snponly_x86_64/*.h config/local/
        make -s -j8 bin-x86_64-efi/snponly.efi
        cp bin-x86_64-efi/snponly.efi ../bin/ipxe-x86_64.efi;;
    "snponly_arm64")
        cp /src/snponly_arm64/*.h config/local/
        make util/elf2efi64
        make CROSS_COMPILE=aarch64-linux-gnu- -s -j8 bin-arm64-efi/snponly.efi
        cp bin-arm64-efi/snponly.efi ../bin/ipxe-arm64.efi;;
    *)
        echo "Cannot compile ipxe for $1"
        exit 1;;
esac
git clean -f -x -d .
