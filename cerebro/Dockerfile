FROM java:jre-alpine

ENV CEREBRO_URL=https://github.com/lmenezes/cerebro/releases/download/v0.1.0/cerebro-0.0.1.tgz

RUN \
  apk update && apk add curl bash && \
  mkdir -p /opt && cd /opt && curl -L ${CEREBRO_URL} | tar zxvf -  && \
  rm -rf /var/cache/apk/*

ENTRYPOINT ["/opt/cerebro-0.0.1/bin/cerebro"]
