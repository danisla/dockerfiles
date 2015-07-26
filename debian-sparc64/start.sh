#!/usr/bin/env bash

# Create snapshot of the base image that we'll run within the container.
if [[ "${USE_SNAPSHOT}" == "true" ]]; then
  ROOT_DISK="/opt/app/snapshot-$(date +%s).img"
  qemu-img create -f qcow2 -b ${SPARC_QEMU_DISK} ${ROOT_DISK}
else
  ROOT_DISK=${SPARC_QEMU_DISK}
fi

qemu-system-sparc64 \
  -L pc-bios \
  -m 384 \
  -nographic \
  -serial mon:telnet::2023,server,wait \
  -monitor telnet::4440,server,nowait \
  -netdev user,id=mynet0,net=192.168.76.0/24,dhcpstart=192.168.76.9,hostfwd=tcp::22-:22 \
  -device virtio-net,netdev=mynet0 \
  -drive file=${ROOT_DISK},if=virtio,index=0 \
  -kernel ${SPARC_QEMU_KERNEL} \
  -initrd ${SPARC_QEMU_INITRD} \
  -append 'modprobe.blacklist=pata_cmd64x root=/dev/vda1'
