#!/usr/bin/env bash

[[ -z "${X10_ADDR}" ]]    && echo "X10_ADDR is not set" && exit 1
[[ -z "${MOCHAD_PORT_1099_TCP_ADDR}" ]] && echo "MOCHAD_PORT_1099_TCP_ADDR is not set" && exit 1
[[ -z "${MOCHAD_PORT_1099_TCP_PORT}" ]] && echo "MOCHAD_PORT_1099_TCP_PORT is not set" && exit 1

echo "rf ${X10_ADDR} off" | nc ${MOCHAD_PORT_1099_TCP_ADDR} ${MOCHAD_PORT_1099_TCP_PORT}
sleep 5
echo "rf ${X10_ADDR} on" | nc ${MOCHAD_PORT_1099_TCP_ADDR} ${MOCHAD_PORT_1099_TCP_PORT}
