#!/usr/bin/env bash

KEYS_DIR=${KEYS_DIR:-/etc/ssh/keys}

cat ${KEYS_DIR}/* 2>/dev/null

exit 0
