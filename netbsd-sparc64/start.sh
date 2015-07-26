#!/usr/bin/env bash

# Create snapshot of the base image that we'll run within the container.
if [[ "${USE_SNAPSHOT}" == "true" ]]; then
  ROOT_DISK="/opt/app/snapshot-$(date +%s).img"
  qemu-img create -f qcow2 -b ${SPARC_QEMU_DISK} ${ROOT_DISK}
else
  ROOT_DISK=${SPARC_QEMU_DISK}
fi

qemu-system-sparc64 \
  -m 512M \
  -nographic \
  -serial mon:telnet::2023,server,wait \
  -monitor telnet::4440,server,nowait \
  -netdev user,id=mynet0,net=192.168.76.0/24,dhcpstart=192.168.76.9,hostfwd=tcp::22-:22 \
  -device ne2k_pci,netdev=mynet0 \
  -drive file=${ROOT_DISK},index=0
