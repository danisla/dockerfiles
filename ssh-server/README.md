# Docker Non-Interactive SSH Server

Starting:

```
docker-compose up
```

Example SSH config:

```
Host dockerhost
    IdentityFile ~/.ssh/id_rsa
    Port 2222
    User nobody
```
