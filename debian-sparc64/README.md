# Tags and Dockerfile links

- <a href="https://github.com/danisla/dockerfiles/blob/0e03e48e997796b4292f58acffe7110fc0e5666a/debian-sparc64/Dockerfile">`qemu-3.2.0_debian-7.8.0`, `latest` (Dockerfile)</a>

# Debian 7.8.0 (wheezy) sparc64 qemu image

Built with qemu 2.3.0 from [debian:stretch](https://registry.hub.docker.com/_/debian/) base image.

The base image was built using this guide:

http://tyom.blogspot.com/2013/03/debiansparc64-wheezy-under-qemu-how-to.html

Creating the base image took about 5 hours, emulated IO is very slow. To save time, the clean install filesystem image is included in this docker image. The total docker image size is about 1.9G.

The prepared image file is not included in the git repository but it can be copied out of the docker image or downloaded [here](https://drive.google.com/file/d/0B19tauKQb2iuWUlsY1dER0VNZ1U/view?usp=sharing).

## Running

    docker run -it -p 2023:2023 danisla/debian-sparc64:latest

This starts qemu but waits for a telnet connection to boot the kernel

    telnet dockerhost 2023

All output and console interactions are done via telnet.

The image will take about 5 minutes to start.

Default credentials:

    user/pass: debian/debian
    root pass: debian

### Filesystem Notes

The default entrypoint for the container creates a snapshot of the base qcow2 image. All files within the guest Debian image that are changed while the container is running are written to this snapshot.

### Networking Notes

The qemu default network backend creates the SLIRP network on 10.0.2.15, this happens to also be the boot2docker ip range, to avoid conflicts, the entrypoint script starts qemu with the argument below to create a new network:

```
-netdev user,id=mynet0,net=192.168.76.0/24,dhcpstart=192.168.76.9,hostfwd=tcp::22-:22
```

Note that port 22 is also forwarded for SSH access into the instance.
