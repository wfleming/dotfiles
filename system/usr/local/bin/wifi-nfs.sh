#!/bin/sh
#
# Alter NFS mount unit states in response to current WiFi network

if iwconfig 2> /dev/null | grep --quiet "SSID.*Pequod"; then
  systemctl --no-block start mnt-mother-data.automount
else
  systemctl --no-block stop mnt-mother-data.automount
  systemctl --no-block stop mnt-mother-data.mount
fi
