#!/usr/bin/env bash

# Example crontab entry to run every 2 minutes:
# */2 * * * * /home/pi/mon_router.sh 10 3 192.168.1.2 'sudo /home/pi/reset_router.sh' >> /home/pi/mon_router.log 2>&1

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT TERM

function ctrl_c() {
	echo "Exiting"
	exit 0
}

function log {
  >&2 echo "`date`: ${1}"
}

function alive() {
	ping -q -c 1 -t 5 $1 >/dev/null 2>&1
}

function email() {
	log "Sending email to: $1"
}

function restart() {
	log "INFO: Running: $1"
	eval "$1"
}

#############################

# Check host health every N seconds, if down for more than 3 consecutive checks, restart it.

CHECK_INTERVAL=${1:-$CHECK_INTERVAL}
MAX_FAIL=${2:-$MAX_FAIL}
HOST=${3:-$MON_ADDR}
SCRIPT=${4:-$RESET_SCRIPT}

if [[ (-z "${CHECK_INTERVAL}" || -z "${MAX_FAIL}" || -z "${HOSt}" || -z ${SCRIPT}) && $# -lt 4 ]]; then
	echo "USAGE: $0 <check interval (seconds) or env CHECK_INTERVAL> <max fail count or env MAX_FAIL> <host or ip or env MON_ADDR> <script to run or env RESET_SCRIPT>"
	exit 1
fi

echo "INFO: Monitor for '$HOST' initialized."

fail_count=0
while true; do
	alive $HOST
	if [[ $? -eq 0 ]]; then
		#log "${HOST} is alive"
		exit 0
	else
		((fail_count=fail_count+1))
		log "WARN: Timeout on ${HOST} (${fail_count}/${MAX_FAIL})"
	fi

	if [[ $fail_count -ge $MAX_FAIL ]]; then
		restart "$SCRIPT"
		log "INFO: Executed router reset script"
		exit 0
	fi

	sleep $CHECK_INTERVAL
done
