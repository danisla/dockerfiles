#!/usr/bin/env bash

URL=$1

[[ -z $URL ]] && echo "USAGE: $0 <url>" && exit 1

while true; do
    echo "`date`: Streaming $URL"
    omxplayer -p -b "$URL"
    sleep 1
done
