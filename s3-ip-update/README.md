# s3-ip-update

Checks public IP from http://checkip.amazonaws.com/ and GEOIP from the `geoiplookup` tool and uploads the result to S3 bucket.

Example container start:

    export AWS_ACCESS_KEY_ID=<your aws key>
    export AWS_SECRET_ACCESS_KEY=<your secret aws key>
    export S3_BUCKET=<dest s3 bucket>

    docker run -d \
      -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
      -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
      -e S3_BUCKET=${S3_BUCKET} \
      s3-ip-update:latest
