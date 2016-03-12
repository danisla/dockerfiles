# Tags and Dockerfiles
- `2.0.24`, `latest` ([Dockerfile](https://github.com/danisla/dockerfiles/blob/openvpn-as-2.0.24/openvpn-as/Dockerfile))

# OpenVPN Access Server

## Running

Exporting config to ENV vars:

```
export USE_CLOUD_PUBLIC_IP="true"
export USER_JSON_DATA=$(cat users.json | base64)
export CONFIG_JSON_DATA=$(cat config.json | base64)
export AS_ADMIN_PASS_DATA=$(read -s -p "Password: " MYPASS ; echo -n ${MYPASS} | base64)
```

Start the container:

```
docker-compose up -d
```

Access the admin ui at `https://<docker machine ip>:943/admin`

## Persistent Data

Data saved to the `/usr/local/openvpn_as/etc/db/*.db` files is persisted on the docker machine host under: `/var/lib/docker/volumes/openvpnas_openvpn-as-1-data/_data`

If the `CONFIG_JSON_DATA` and `USER_JSON_DATA` env vars are provided, the `start.sh` entrypoint script will re-load the settings and users them on startup. Follow steps below to export the config and users so that a fresh start will load them. Omitting these vars will load the config and users from the existing persisted data in the docker volume.

Exporting config to json file:

```
docker exec -it openvpnas_server_1 /usr/local/openvpn_as/scripts/confdba -a > config.json
```

Exporting users to json file:

```
docker exec -it openvpnas_server_1 /usr/local/openvpn_as/scripts/confdba -us > users.json
```
