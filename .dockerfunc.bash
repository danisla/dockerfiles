docker-cleanup(){
  docker rm $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
  docker rmi $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null
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
