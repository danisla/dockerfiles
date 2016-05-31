docker-cleanup(){
  docker rm $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
  docker rmi $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null
}

function docker-machine-default() {
  name=default
  [[ "$(docker-machine status $name)" == "Stopped" ]] && docker-machine start $name
  eval $(docker-machine env $name)
}

function docker-volume-du() {
  VOL=$1
  [[ -z $VOL ]] && echo "USAGE: docker-volume-du <volume name>" && return 1
  docker run -it --rm -v ${VOL}:/data --entrypoint=du alpine:3.3 -sh /data
}

function docker-ui() {
  docker run --name dockerui --restart always -d -p 9000:9000 --privileged -v /var/run/docker.sock:/var/run/docker.sock elegoev/dockerui:latest
}

function docker-swarm-ui() {
  docker run -d -p 9001:3000 -v /var/run/docker.sock:/var/run/docker.sock --name dockerswarm-ui --restart always mlabouardy/dockerswarm-ui:1.0.0
}

function docker-avahi() {
  AVAHI_HOST=$1
  [[ -z $AVAHI_HOST ]] && echo "USAGE: docker-avahi <host name>" && return 1
  docker run -d --name avahi-${AVAHI_HOST} --net host --restart always -e AVAHI_HOST=${AVAHI_HOST} danisla/avahi:latest
}

function docker-mac-ip() {
  pinata list | awk -F= '/docker-ipv4=/ {print $3}' | awk -F, '{printf $1}'
}

function docker-mac-tty() {
	# Login as root
	# CTRL-a + k  to exit
	screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty
}

function docker-install-completion() {
  files=(docker-machine docker-machine-wrapper docker-machine-prompt)
  for f in "${files[@]}"; do
    curl -L https://raw.githubusercontent.com/docker/machine/v$(docker-machine --version | tr -ds ',' ' ' | awk 'NR==1{print $(3)}')/contrib/completion/bash/$f.bash > `brew --prefix`/etc/bash_completion.d/$f
  done
   curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose > `brew --prefix`/etc/bash_completion.d/docker-compose
}

function gen-ssl-cert() {
  cn=$1
  [[ -z "${cn}" ]] && echo "USAGE: gen-ssl-cert <cn>" && return 1
  docker run -it --rm \
    -v "${PWD}:/certs:rw" \
    --entrypoint=openssl \
    nginx:latest \
    req -new -newkey rsa:2048 -sha1 -days 365 -nodes -x509 -keyout /certs/server.key -out /certs/server.crt \
      -subj "/C=US/ST=California/L=Pasadena/O=Megacorp/OU=IT/CN=${cn}/emailAddress=docker@example.com"
}
