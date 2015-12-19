# Docker Raspberry Pi omxplayer

Image for running omxplayer in docker.

Exmaple run:

```
docker run -it --rm -v /opt/vc:/opt/vc --device /dev/vchiq:/dev/vchiq --device /dev/fb0:/dev/fb0 danisla/rpi-omxplayer rtmp://video1.earthcam.com:1935/earthcamtv/Stream1
```
