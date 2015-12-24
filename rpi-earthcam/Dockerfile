FROM danisla/rpi-omxplayer
MAINTAINER "Dan Isla <dan.isla@gmail.com>"

ADD stream.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/stream.sh

ENV URL rtmp://video1.earthcam.com:1935/earthcamtv/Stream1

ENTRYPOINT stream.sh "$URL"
