#!/usr/bin/env bash
DROP_DIR=$(mktemp -d)
docker run --privileged --interactive --tty --rm --volume $DROP_DIR:/drop \
    restack/001-webserver-rootfs /src/build_rootfs.sh
cp $DROP_DIR/* $PWD/

./firectl \
    --firecracker-binary=$PWD/firecracker \
    --kernel=$PWD/vmlinux.bin \
    --root-drive=$PWD/rootfs.ext4 \
    --kernel-opts="console=ttyS0 ip=172.17.100.2::172.17.100.1:255.255.255.0:webserver:eth0:off:172.17.100.1::" \
    --tap-device=tap0/AA:FC:00:00:00:01
