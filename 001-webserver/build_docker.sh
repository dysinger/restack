#!/usr/bin/env bash
docker build --tag restack/001-webserver --target=docker $PWD

docker build --tag restack/001-webserver-rootfs --target=firecracker $PWD
