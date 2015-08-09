FROM java:8-jre

RUN apt-get update
RUN apt-get install -y xz-utils sudo

EXPOSE 4040
VOLUME /mnt/music
VOLUME /opt/app/state

RUN wget "http://downloads.sourceforge.net/project/subsonic/subsonic/5.2.1/subsonic-5.2.1.deb?target%3Dsubsonic-5.2.1.deb&use_mirror=superb-dca2" -O /tmp/subsonic.deb
RUN dpkg -i /tmp/subsonic.deb
RUN rm -rf /tmp/subsonic.deb

RUN wget http://johnvansickle.com/ffmpeg/releases/ffmpeg-release-64bit-static.tar.xz -O /tmp/ffmpeg-release-64bit-static.tar.xz
RUN mkdir -p /opt/ffmpeg
RUN tar xf /tmp/ffmpeg-release-64bit-static.tar.xz -C /opt/ffmpeg --strip-components=1

WORKDIR /opt/app
ENV SUBSONIC_CONTEXT_PATH /
ENV SUBSONIC_MAX_MEMORY 512

RUN mkdir -p /opt/app

ADD startup.sh /opt/app/
RUN chmod +x /opt/app/startup.sh

ENTRYPOINT /opt/app/startup.sh 1000
