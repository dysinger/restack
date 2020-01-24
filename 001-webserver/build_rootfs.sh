#!/usr/bin/env bash
dd if=/dev/zero of=/rootfs.ext4 bs=1M count=32
mkfs.ext4 /rootfs.ext4
mount -o loop /rootfs.ext4 /mnt
mkdir -p /mnt/lib /mnt/usr/lib/ /mnt/sbin
cp /lib/ld-musl-x86_64.so.1 /mnt/lib/
cp /usr/lib/libgmp.so.10    /mnt/usr/lib/
cp /src/_build/main.native  /mnt/sbin/init
umount /mnt
chmod 644 /*.{bin,ext4}
cp /*.{bin,ext4} /usr/local/bin/* /drop/
