docker-cleanup(){
	docker ps --filter status=exited -q | xargs -I {} docker rm {} 2>/dev/null
	docker ps --filter status=created -q | xargs -I {} docker rm {} 2>/dev/null
	docker images --filter dangling=true -q | xargs -I {} docker rmi {} 2>/dev/null
}

docker-backup-cleanup(){
  docker.backup rm $(docker.backup ps --filter status=exited -q 2>/dev/null) 2>/dev/null
  docker.backup rmi $(docker.backup images --filter dangling=true -q 2>/dev/null) 2>/dev/null
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

function docker-ssh-pf() {
  [[ $# -eq 0 ]] && echo "USAGE: docker-pf <ssh_key> <user@host> <container name/id> <local port> <dest host:port>" && return 1
  ssh_key=$1
  ssh_user_host=$2
  container=$3
  local_port=$4
  dest_host_port=$5
  socat TCP-LISTEN:${local_port},reuseaddr,fork 'EXEC:ssh -t -i '${ssh_key}' -o ControlMaster=auto -o "ControlPath=/tmp/docker-pf-control-%r@%h:%p" -o ControlPersist=600 '${ssh_user_host}' sudo docker exec -i '${container}' "socat STDIO TCP-CONNECT:'${dest_host_port}'"',pty,raw,echo=0
}

function docker-pf() {
  [[ $# -eq 0 ]] && echo "USAGE: docker-pf <local port> <dest host> <dest port> [<net default: bridge>]" && return 1
  local_port=$1
  dest_host=$2
  dest_port=$3
  net=${4:-bridge}
  socat TCP-LISTEN:${local_port},reuseaddr,fork 'EXEC:docker run -i --rm --net='${net}' danisla/socat "-c \"socat STDIO TCP-CONNECT:'${dest_host}'\:'${dest_port}'\""',pty,raw,echo=0
}

function weave-env() {
  nohup socat unix-listen:/tmp/weave.sock,reuseaddr,fork 'EXEC:docker run -i --rm -v /var/run/weave/weave.sock\:/weave.sock danisla/socat "-c \"socat STDIO UNIX-CONNECT:/weave.sock\""',pty,raw,echo=0 >/tmp/weave-sock.out 2>&1 &
  echo "export DOCKER_HOST=unix:///tmp/weave.sock"
}

function weave-env-stop() {
  pkill -f ".*socat.*/tmp/weave.sock.*" >/dev/null 2>&1
  echo "unset DOCKER_HOST"
}

function docker-mac-ip() {
  docker run -it --net=host --rm debian:jessie sh -c "ip route get 8.8.8.8 | awk '{printf \$NF; exit}'"
}

function docker-hub-basic-auth() {
  cat ~/.docker/config.json | jq -r '.auths."https://index.docker.io/v1/".auth'
}

function docker-hub-list-tags() {
  REPO=$1
  if [[ -z "${REPO}" ]]; then
    echo "USAGE: docker-hub-list-tags <repo name>"
    return
  fi
  if [[ ! -e ~/.docker/config.json ]]; then
    echo "ERROR: ~/.docker/config.json not found, run: docker login"
    return
  fi
  TOKEN=$(curl -sf -H "Authorization: Basic $(docker-hub-basic-auth)" \
                  -H 'Accept: application/json' \
                  "https://auth.docker.io/token?service=registry.docker.io&scope=repository:$REPO:pull" | jq -r '.token')

  curl -s -H "Authorization: Bearer $TOKEN" -H "Accept: application/json" \
             "https://index.docker.io/v2/$REPO/tags/list" |
               jq -r '.tags | sort'
}

function gcr-list-tags() {
  REPO=${1/gcr.io\/}
  if [[ -z "${REPO}" ]]; then
    echo "USAGE: gcr-list-tags <repo name>"
    return
  fi
  curl -s -H "Accept: application/json" \
             "https://gcr.io/v2/${REPO}/tags/list" |
               jq -r '.tags[]' | sort --version-sort
}

function docker-host-root() {
	docker run -it --rm --entrypoint=sh --privileged --net=host -e sysimage=/host -v /:/host -v /dev:/dev -v /run:/run ubuntu:vivid -c 'nsenter --mount=$sysimage/proc/1/ns/mnt -- sh'
}

function docker-backup-host-root() {
	docker.backup run -it --rm --entrypoint=sh --privileged --net=host -e sysimage=/host -v /:/host -v /dev:/dev -v /run:/run ubuntu:vivid -c 'nsenter --mount=$sysimage/proc/1/ns/mnt -- sh'
}

function docker-jupyter-start() {
	docker run -d -p 8888:8888 --name jupyter -v ${PWD}:/notebooks:rw jupyter/notebook:4.2.0 && \
	sh -c 'until `curl -sf http://localhost:8888 >/dev/null`; do echo "Starting Jupyter Notebook in dir: '${PWD}'..." && sleep 5; done' && \
	open http://localhost:8888
}

function docker-jupyter-stop() {
	docker stop jupyter
	docker rm jupyter
}

function docker-elastic-stack-start() {
  ES_TAG=$1
  KIBANA_TAG=$2

  docker run -d \
    --name elasticsearch \
    -p 9200:9200 \
    -p 9300:9300 \
    elasticsearch:${ES_TAG} && \
  docker run -d \
    --name kibana \
    -p 5601:5601 \
    -e ELASTICSEARCH_URL=http://elasticsearch:9200 \
    --link elasticsearch \
    kibana:${KIBANA_TAG}
}

function docker-elastic-stack-2-start() {
  # Elasticsearch 2.x with kopf plugin

  docker-elastic-stack-start 2 4 && \
  docker exec -it elasticsearch sh -c 'bin/plugin install lmenezes/elasticsearch-kopf'

  sh -c 'until `curl -sf http://localhost:9200 >/dev/null`; do echo "Starting Elastic Stack..." && sleep 5; done' && \
  open http://localhost:5601
  open http://localhost:9200/_plugin/kopf
}

function docker-elastic-stack-5-start() {
  # Elasticsearch 5.x with cerebro app
  docker-elastic-stack-start 5 5 && \
  docker run -d \
    -p 9000:9000 \
    --name cerebro \
    --link elasticsearch \
    --entrypoint=bash \
    danisla/cerebro:v0.4.1 -c "sed -i -e 's|host = .*|host = \"http://elasticsearch:9200\"|g' /opt/cerebro-0.4.1/conf/application.conf && /opt/cerebro-0.4.1/bin/cerebro"

  sh -c 'until `curl -sf http://localhost:9200 >/dev/null`; do echo "Starting Elastic Stack..." && sleep 5; done' && \
  open http://localhost:5601
  sh -c 'until `curl -sf http://localhost:9000 >/dev/null`; do echo "Starting Cerebro..." && sleep 5; done' && \
  open http://localhost:9000
}

function docker-elastic-stack-stop() {
  docker kill cerebro
  docker rm cerebro
  docker kill kibana
  docker rm kibana
  docker kill elasticsearch
  docker rm elasticsearch
}

function docker-packer {
  docker run -it --rm -v ${HOME}:${HOME} --env-file <(env|awk '/^.+=/'|grep -v TMPDIR) -w $PWD hashicorp/packer:light $@
}

function docker-terraform {
	if [[ -e ${HOME}/.config/gcloud/credentials.json ]]; then
		GOOGLE_CREDENTIALS="$(cat ${HOME}/.config/gcloud/credentials.json | tr '\n' ' ')"
	fi
  GOOGLE_PROJECT=${DEVSHELL_PROJECT_ID:-$(gcloud config get-value project 2>/dev/null)}
  docker run -it --rm \
		-v ${HOME}:${HOME} \
		--env-file <(env|awk '/^.+=/'|grep -v TMPDIR) \
		-e GOOGLE_CREDENTIALS="${GOOGLE_CREDENTIALS}" \
		-e GOOGLE_PROJECT="${GOOGLE_PROJECT}" \
		-w $PWD \
		hashicorp/terraform:latest $@
}

function spinnaker-versions {
  docker run -it --rm --entrypoint=bash ubuntu:trusty -c '
  echo "Checking latest versions of Spinnaker components in debian repo..." && \
  apt-get -qq update && apt-get -qq -y --force-yes install curl apt-transport-https >/dev/null && \
  echo "deb https://dl.bintray.com/spinnaker/debians trusty spinnaker" > /etc/apt/sources.list.d/spinnaker.list && \
  curl -s -f "https://bintray.com/user/downloadSubjectPublicKey?username=spinnaker" | apt-key add - && \
  apt-get -qq update && \
  export SPINNAKER_COMPONENTS="spinnaker-clouddriver spinnaker-deck spinnaker-echo spinnaker-front50 spinnaker-gate spinnaker-igor spinnaker-orca spinnaker-rosco spinnaker" && \
  for c in $SPINNAKER_COMPONENTS; do echo ${c}=`apt-cache madison ${c} | head -1 | cut -d "|" -f2 | sed "s|[[:space:]]||g"`; done'
}

function docker-go-swagger {
  docker run --rm -it -v $HOME:$HOME -w $(pwd) quay.io/goswagger/swagger:0.7.4 $@
}

function docker-1.11.2 {
	# Compatible with API v1.23
  URL=https://get.docker.com/builds/Darwin/x86_64/docker-1.11.2.tgz
  DOCKER_BIN=${HOME}/bin/docker-1.11.2
  if [[ ! -f "${DOCKER_BIN}" ]]; then
		echo "Installing $(basename ${DOCKER_BIN}) binary to ${DOCKER_BIN}"
    curl -sfL "${URL}" | tar xvf -
    mv docker/docker ${DOCKER_BIN}
    rm -Rf docker
	fi
  ${DOCKER_BIN} $@
}

function docker-cadvisor {
  docker run \
    --volume=/:/rootfs:ro \
    --volume=/var/run:/var/run:rw \
    --volume=/sys:/sys:ro \
    --volume=/var/lib/docker/:/var/lib/docker:ro \
    --publish=9000:8080 \
    --detach=true \
    --name=cadvisor \
    google/cadvisor:latest
}

function dc_trace_cmd() {
  local parent=`docker inspect -f '{{ .Parent }}' $1` 2>/dev/null
  declare -i level=$2
  echo ${level}: `docker inspect -f '{{ .ContainerConfig.Cmd }}' $1 2>/dev/null`
  level=level+1
  if [ "${parent}" != "" ]; then
    echo ${level}: $parent 
    dc_trace_cmd $parent $level
  fi
}

function docker-extract-appimage() {
  local SRC_FILE=$1
  local SRC_FILE_NAME=$(basename "$SRC_FILE")
  local TS=$(date +%Y%m%d%H%M%S)
  local TMP_DIR=$(mktemp -d)

  [[ -d $PWD/appimage ]] && echo "ERROR: directory exists: ./appimage" && return 1

  cp "${SRC_FILE}" "${TMP_DIR}/" 
  cat - > "${TMP_DIR}/Dockerfile" <<EOF
FROM ubuntu:16.04 as appimage
WORKDIR /tmp
COPY ${SRC_FILE_NAME} .
RUN chmod +x ${SRC_FILE_NAME} && \
    ./${SRC_FILE_NAME} --appimage-extract && \
    find squashfs-root -type d -exec chmod ugo+rx {} \; && \
    chown -R 1000:1000 squashfs-root
EOF

  (cd $TMP_DIR && docker build -t appimage-extract:$TS .)

  ID=$(docker create appimage-extract:$TS)
  docker cp $ID:/tmp/squashfs-root ./appimage
  docker rm $ID

  rm -rf "${TMP_DIR}"
}
