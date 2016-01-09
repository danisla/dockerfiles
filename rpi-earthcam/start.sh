#!/usr/bin/env bash

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
        echo "** Trapped CTRL-C"
        exit
}

URL=$1

[[ -z $URL ]] && echo "USAGE: $0 <url>" && exit 1

while true; do
    echo "`date`: Streaming $URL"
    omxplayer -p -b "$URL"
    sleep 1
done
