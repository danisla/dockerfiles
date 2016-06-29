# Packet debugging with Wireshark

A wireshark stack in docker used to capture packets isolated at the container level.

## Running step-by-step

To use this example do the following:

1. Edit the `docker-compose.override.yml` file and add the details for running your app. The service name must be `app` to work with the main `docker-compose.yml` file.

2. Run the VNC desktop container so you can see wireshark.

```
docker-compose up -d desktop
```

3. Open your browser to http://localhost:6080. After the desktop loads, continue to step 4.

4. Start the wireshark service (dependency is your `app` service):

```
docker-compose up -d wireshark
```

You should see the wireshark GUI in the VNC browser session.

When done, run this to tear everything down:

```
docker-compose down
```

## Running with 1-step Makefile

To run all of the steps with blocking automation (except editing the override file):

```
make
```

When you are done:

```
make clean
```
