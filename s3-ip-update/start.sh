#!/usr/bin/env bash

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
  echo "** Trapped CTRL-C"
  exit 0
}

###############################################################################

function info() {
  echo "`date`: INFO: ${1}"
}
function warn() {
  echo "`date`: WARN: ${1}"
}
function error() {
  echo "`date`: ERROR: ${1}"
}

function s3upload() {
  SRC_FILE=$1
  DEST_FILE=$2

  info "Uploading ${SRC_FILE} -> s3://${S3_BUCKET}/${DEST_FILE}"

  aws s3 cp $SRC_FILE s3://${S3_BUCKET}/${DEST_FILE} >/dev/null
  AWS_RET=$?
  if [[ $AWS_RET -gt 0 ]]; then
    error "aws s3 exited with status: ${AWS_RET}"
    return 1
  fi
  return 0
}

function do_check() {
  URL=$1
  TMP_FILE=$2
  info "Checking IP: ${URL}"
  curl -sf -o ${TMP_FILE} ${URL}
  RET=$?
  if [[ $RET -eq 0 ]]; then
    DEST_FILE=$(basename ${TMP_FILE})
    s3upload ${TMP_FILE} ${DEST_FILE}
  else
    error "curl failed with status: $RET, skipping S3 upload."
  fi
}

###############################################################################

if [[ -z "${AWS_ACCESS_KEY_ID}" ]]; then
  echo "ERROR: AWS_ACCESS_KEY_ID not set"
  exit 1
fi

if [[ -z "${AWS_SECRET_ACCESS_KEY}" ]]; then
  echo "ERROR: AWS_SECRET_ACCESS_KEY not set"
  exit 1
fi

if [[ -z "${S3_BUCKET}" ]]; then
  echo "ERROR: S3_BUCKET not set"
  exit 1
fi

while true; do

  do_check "http://checkip.amazonaws.com/" "/tmp/curr_ip.txt"
  CURR_IP=$(cat /tmp/curr_ip.txt)
  if [[ ! -z "${CURR_IP}" ]]; then
    geoiplookup -f /usr/share/GeoIP/GeoLiteCity.dat ${CURR_IP} > /tmp/geoip.txt
    if [[ $? -eq 0 ]]; then
      s3upload "/tmp/geoip.txt" "geoip.txt"
    else
      error "geoip lookup failed"
    fi
  fi

  # Random check between 60 and 180 seconds
  NEXT=$(( ( RANDOM % 120 )  + 60 ))
  info "Next check in ${NEXT} seconds"
  sleep $NEXT

done
