#!/bin/bash

# Update the openvpn user password
[[ -n "${AS_ADMIN_PASS_DATA}" ]] && echo -n "openvpn:$(echo -n ${AS_ADMIN_PASS_DATA} | base64 -d)" | chpasswd

# Load the server config
[[ -n "${CONFIG_JSON_DATA}" ]] && echo -n "${CONFIG_JSON_DATA}" | base64 -d > /usr/local/openvpn_as/etc/config.json

if [[ "${USE_AWS_PUBLIC_IP}" == "true" ]]; then
    AWS_IP=`curl -sf http://169.254.169.254/latest/meta-data/public-ipv4`
    if [[ $? -eq 0 ]]; then
        echo "INFO: Setting host.name to AWS public ipv4: ${AWS_IP}"
        jq '.Default["host.name"] = "'${AWS_IP}'"' /usr/local/openvpn_as/etc/config.json > /usr/local/openvpn_as/etc/config.json2
        mv /usr/local/openvpn_as/etc/config.json2 /usr/local/openvpn_as/etc/config.json
    else
        echo "ERROR: Could not get public-ipv4 adress from AWS metadata"
        exit 1
    fi
fi

# Load the server config
/usr/local/openvpn_as/scripts/confdba -lf /usr/local/openvpn_as/etc/config.json

# Load the users data
[[ -n "${USER_JSON_DATA}" ]] && echo -n "${USER_JSON_DATA}" | base64 -d > /usr/local/openvpn_as/etc/users.json && \
    /usr/local/openvpn_as/scripts/confdba -ulf /usr/local/openvpn_as/etc/users.json

/usr/local/openvpn_as/scripts/openvpnas -n
