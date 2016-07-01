FROM alpine:3.4

RUN apk update && \
    apk add socat && \
    rm -rf /var/cache/apk/*

ENTRYPOINT ["socat"]
