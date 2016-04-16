FROM alpine:3.3

RUN apk update && \
  apk add curl

ENV TRAEFIK_VERSION v1.0.0-beta.475

RUN curl -fL http://github.com/containous/traefik/releases/download/${TRAEFIK_VERSION}/traefik_linux-amd64 > traefik && \
  chmod +x traefik

WORKDIR /
ENTRYPOINT ["/traefik"]
EXPOSE 8080
EXPOSE 80
EXPOSE 443

