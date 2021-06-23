#!/bin/sh
#
# Alter NFS mount unit states in response to current WiFi network

network="Pequod"

home_network_is_connected() {
  iwctl station wlan0 show | grep --quiet "Connected network.*$network"
}

if home_network_is_connected; then
  systemctl --no-block start mnt-mother-data.automount
else
  systemctl --no-block stop mnt-mother-data.automount
  systemctl --no-block stop mnt-mother-data.mount
fi
