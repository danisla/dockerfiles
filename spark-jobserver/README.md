# Spark Jobserver Mesos Docker Image

Based on the [velvia/spark-jobserver](https://hub.docker.com/r/velvia/spark-jobserver/) docker image for [Spark JobServer](https://github.com/spark-jobserver)

This image builds with the supported Mesos libraries needed to run in coarse or fine mode.

The example [spark-jobserver-marathon.json](./spark-jobserver-marathon.json) can be used to run the jobserver via Marathon.

See also the Spark image that can be used in conjuction with this to run spark executors in containers: [danisla/dockerfiles/spark](https://github.com/danisla/dockerfiles/spark)
