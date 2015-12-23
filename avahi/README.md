# Avahi Docker Image

I use this image for resolving boot2docker instances by name.

Run with the `--net=host` when starting.

After running `docker-machine start <name>`, run this:

```
export AVAHI_HOST=docker-default
docker run -d --name avahi --net host --restart always -e AVAHI_HOST=${AVAHI_HOST} danisla/avahi:latest
```

Then you should be able to ping `docker-default.local`
