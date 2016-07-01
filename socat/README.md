# Tags and Dockerfiles
- `latest`, ([Dockerfile]())

# Docker port/socket forwarding with socat

Use this image to create socket and TCP port forwards using docker and socat.

## Examples

### Export the weave socket to local host.

```
socat unix-listen:/tmp/weave.sock,reuseaddr,fork 'EXEC:docker run -i --rm -v /var/run/weave/weave.sock\:/weave.sock danisla/socat "-c \"socat STDIO UNIX-CONNECT:/weave.sock\""',pty,raw,echo=0

DOCKER_HOST=unix:///tmp/weave.sock docker run -it --rm --name centos centos ping centos.weave.local
```

### Generic TCP port forward bash helper function

```
function docker-pf() {
  [[ $# -eq 0 ]] && echo "USAGE: docker-pf <local port> <dest host> <dest port> [<net default: bridge>]" && return 1
  local_port=$1
  dest_host=$2
  dest_port=$3
  net=${4:-bridge}
  socat TCP-LISTEN:${local_port},reuseaddr,fork 'EXEC:docker run -i --rm --net='${net}' danisla/socat "-c \"socat STDIO TCP-CONNECT:'${dest_host}'\:'${dest_port}'\""',pty,raw,echo=0
}

docker network create web
docker run -d --name nginx --net web nginx
docker-pf 8080 nginx 80 web
curl localhost:8080
```
