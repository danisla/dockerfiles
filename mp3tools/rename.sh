#!/usr/bin/env bash

go() {
  echo "y"|m4a2mp3 && MP3_FileRename_FromID3.py && rm -f *.pdf && rm -f *.url && rm -f *.m3u && rm -f *.sfv && rm -f *.jpg && rm -f *.png && rm -f *.txt && rm -f *.nfo && rm -f *.ini && rm -f *.URL && chmod g+rw . && chmod -x * && chmod go+rw * && chmod go+rw .
}


SRC_DIR=$1
DEST_DIR=$2

[[ $# -lt 2 ]] && echo "USAGE: $0 <src dir> <dest dir>" && exit 1

[[ ! -d "${SRC_DIR}" ]] && echo "ERROR: Invalid src dir: ${SRC_DIR}" && exit 1

mkdir /tmp/work

cp -R -a "${SRC_DIR}" /tmp/work/

cd /tmp/work/$(basename "${SRC_DIR}")

CURR_DIR=$(pwd)

go

mkdir -p "$(dirname "${DEST_DIR}")"

mv "${CURR_DIR}" "${DEST_DIR}"
