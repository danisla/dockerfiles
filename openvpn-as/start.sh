#!/bin/bash

# Update the openvpn user password
[[ -n "${AS_ADMIN_PASS_DATA}" ]] && echo -n "openvpn:$(echo -n ${AS_ADMIN_PASS_DATA} | base64 -d)" | chpasswd

# Load the server config
[[ -n "${CONFIG_JSON_DATA}" ]] && echo -n "${CONFIG_JSON_DATA}" | base64 -d > /usr/local/openvpn_as/etc/config.json

CLOUD_IP=""
if [[ "${USE_AWS_PUBLIC_IP}" == "true" || "${USE_CLOUD_PUBLIC_IP}" == "true" ]]; then
    CLOUD_IP=`curl -sf http://169.254.169.254/latest/meta-data/public-ipv4`
    [[ $? -ne 0 ]] && echo "ERROR: Could not get public-ipv4 adress from cloud metadata" && exit 1
elif [[ "${USE_AWS_LOCAL_IP}" == "true" || "${USE_CLOUD_LOCAL_IP}" == "true" ]]; then
    CLOUD_IP=`curl -sf http://169.254.169.254/latest/meta-data/local-ipv4`
    [[ $? -ne 0 ]] && echo "ERROR: Could not get local-ipv4 adress from cloud metadata" && exit 1
fi

if [[ -n "$CLOUD_IP" ]]; then
    echo "INFO: Setting host.name to cloud ipv4: ${CLOUD_IP}"
    jq '.Default["host.name"] = "'${CLOUD_IP}'"' /usr/local/openvpn_as/etc/config.json > /usr/local/openvpn_as/etc/config.json2
    mv /usr/local/openvpn_as/etc/config.json2 /usr/local/openvpn_as/etc/config.json
fi

# Load the server config
/usr/local/openvpn_as/scripts/confdba -lf /usr/local/openvpn_as/etc/config.json

# Load the users data
[[ -n "${USER_JSON_DATA}" ]] && echo -n "${USER_JSON_DATA}" | base64 -d > /usr/local/openvpn_as/etc/users.json && \
    /usr/local/openvpn_as/scripts/confdba -ulf /usr/local/openvpn_as/etc/users.json

/usr/local/openvpn_as/scripts/openvpnas -n
