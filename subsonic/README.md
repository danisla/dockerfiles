# Dockerfile for Subsonic

Dockerfile for Subsonic music streamer: http://www.subsonic.org/

Image is built with transcoding support via [static ffmpeg](http://johnvansickle.com/ffmpeg/) binaries. I could not find a way to re-route the path to the transcode libraries so they are stuck under the state directory where logs are generated. If you mount the state directory when running the container, these binaries will not be available so the entrypoint script [startup.sh](./startup.sh) copies them to `/opt/app/state/transcode` at runtime. If someone finds a way around this, pull requests are welcome. 

Using the entrypoint script [startup.sh](./startup.sh) to create a user with your given UID. This is done to keep UID mapping of your mounted music directory in sync with changes the subsonic process makes from within the container.

## Running

When running, you should mount a directory to save the state (index database and logs) so that all of the subsonic metadata is persisted across restarts. This directory inside the container is `/opt/app/state`.

Mount your music dir from your host to the container directory: `/mnt/music`.

The argument to the entrypoint script [startup.sh](./startup.sh) is the UID of the container's `subsonic` user. This user is created at runtime with the UID you provide to keep the writes to your music directory done within the container in sync with your host filesystem. The default UID is `1000`.

```sh
docker run -d --name subsonic \
  -p 4040:4040 \
  -e ${SUBSONIC_MAX_MEMORY:-512} \
  -e ${SUBSONIC_CONTEXT_PATH:-/} \
  -v /mnt/subsonic:/opt/app/state \
  -v /mnt/music:/mnt/music
  danisla/subsonic 1000
```
---

Runtime environment variables:

- `SUBSONIC_CONTEXT_PATH`: Set this to a context path if you are running subsonic behind a proxy and it is not the at the root path. For example, to make subsonic available at: `https://homeserver.example.com/subsonic` pass `-e SUBSONIC_CONTEXT_PATH=/subsonic`
- `SUBSONIC_MAX_MEMORY`: Set the max memory for the JVM, you will probably have to increase this if you have a large music library. Default is 512 (megabytes).
