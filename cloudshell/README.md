# Cloud Shell

Docker shell with tools for remote administration.

## Running

```
docker run -it --rm \
    -p 9000:9000 \
    -p 8080:8080 \
    -p 8081:8081 \
    -p 8082:8082 \
    danisla/cloudshell:latest
```

with TLS and basic auth:

```
docker run -it --rm \
    -p 9000:9000 \
    -p 8080:8080 \
    -p 8081:8081 \
    -p 8082:8082 \
    -v ${HOME}/.gotty.crt:/etc/gotty.crt \
    -v ${HOME}/.gotty.key:/etc/gotty.key \
    danisla/cloudshell:latest \
    /gotty -p 9000 -w -c user:pass -t --tls-crt /etc/gotty.crt --tls-key /etc/gotty.key tmux new -A -s bash
```