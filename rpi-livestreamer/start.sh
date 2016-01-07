#!/usr/bin/env bash

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
        echo "** Trapped CTRL-C"
	exit
}

URL=${URL:-$1}
QUALITY=${QUALITY:-$2}

[[ -z $URL || -z $QUALITY ]] && echo "USAGE: $0 <url or env URL> <quality or env QUALITY>" && exit 1

while true; do
    echo "`date`: Streaming $URL $QUALITY"
    livestreamer --player omxplayer --fifo --player-args "\-o both \-b \-g '{filename}'" --yes-run-as-root --default-stream="$QUALITY" "$URL"
    [[ -e omxplayer.log ]] && cat omxplayer.log
    sleep 1
done
