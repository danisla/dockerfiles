# Cloud Shell

Docker shell with tools for remote administration.

## Running

as daemon:

```
docker run -t -d --restart=always \
    --name=cloudshell \
    -p 9000:9000 \
    -p 8080:8080 \
    -p 8081:8081 \
    -p 8082:8082 \
    danisla/cloudshell:latest
```

with TLS and basic auth:

```
docker run -t -d --restart=always \
    --name=cloudshell \
    -p 9000:9000 \
    -p 8080:8080 \
    -p 8081:8081 \
    -p 8082:8082 \
    -e USERID=500 \
    -e GROUPID=100 \
    -v ${HOME}/.gotty.crt:/etc/gotty.crt \
    -v ${HOME}/.gotty.key:/etc/gotty.key \
    danisla/cloudshell:latest \
    /gotty -p 9000 -w -c user:pass -t --tls-crt /etc/gotty.crt --tls-key /etc/gotty.key tmux new -A -s bash
```