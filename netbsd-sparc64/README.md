# Tags and Dockerfile links

- `qemu-3.2.0_netbsd-6.1.5`, `latest` ([Dockerfile](https://github.com/danisla/dockerfiles/blob/885f8353659eea5ad89b86593152ada087fcd07d/netbsd-sparc64/Dockerfile))

# NetBSD 6.1.5 sparc64 qemu image

This image is very fast and uses a 4G `qcow2` disk image format with working networking. The total docker image size is about 1.2G.

On startup, you have to tell the netbsd kernel where the boot drive is, in this case, use `wd0a` and all the defaults for following questions.

To build this image, installing NetBSD with `qemu-system-sparc64` and the ISO is very easy, the ISO can boot directly using the qemu command below and entering `cd0a` when the kernel prompts for a boot device.

The prepared image file is not included in the git repository but it can be copied out of the docker image or downloaded [here](https://drive.google.com/file/d/0B19tauKQb2iuNlBYU1BNX0o0S0k/view?usp=sharing).

```
qemu-system-sparc64 \
  -m 512M \
  -nographic \
  -serial mon:telnet::2023,server,wait \
  -monitor telnet::4440,server,nowait \
  -netdev user,id=mynet0,net=192.168.76.0/24,dhcpstart=192.168.76.9,hostfwd=tcp::22-:22 \
  -device ne2k_pci,netdev=mynet0 \
  -drive file=${ROOT_DISK},index=0
```

The clean install of the filesystem is relatively small ~500M so the filesystem image was included with this docker image. Of course you can override the filesystem image by volume mounting it at container start time and setting the `SPARC_QEMU_DISK` to match the new path.

## Running

    docker run -it -p 2023:2023 danisla/netbsd-sparc64:latest

This starts qemu but waits for a telnet connection to boot the kernel

    telnet dockerhost 2023

All output and console interactions are done via telnet.

When prompted for the boot device, enter `wd0a`:

```
wd0 at atabus0 drive 0
wd0: <QEMU HARDDISK>
wd0: 4096 MB, 8322 cyl, 16 head, 63 sec, 512 bytes/sect x 8388608 sectors
atapibus0 at atabus1: 2 targets
cd0 at atapibus0 drive 0: <QEMU DVD-ROM, QM00003, 2.3.0> cdrom removable
FATAL: boot device not found, check your firmware settings!
root device: wd0a
dump device (default wd0b):
file system (default generic):
root on wd0a dumps on wd0b
root file system type: ffs
init path (default /sbin/init):
```

Solutions on how to fix this are welcome.

Default credentials:

    user/pass: netbsd/netbsd2015
    root pass: netbsd2015

### Filesystem Notes

The default entrypoint for the container creates a snapshot of the base qcow2 image. All files within the guest Debian image that are changed while the container is running are written to this snapshot.

### Networking Notes

The qemu default network backend creates the SLIRP network on 10.0.2.15, this happens to also be the boot2docker ip range, to avoid conflicts, the entrypoint script starts qemu with the argument below to create a new network:

```
-netdev user,id=mynet0,net=192.168.76.0/24,dhcpstart=192.168.76.9,hostfwd=tcp::22-:22
```

Note that port 22 is also forwarded for SSH access into the instance.

sshd is disabled by default but can be started with the command below:

    /etc/rc.d/sshd onestart
