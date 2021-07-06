#!/bin/sh
#
# Alter NFS mount unit states in response to current WiFi network

network="Pequod"

home_network_is_connected() {
  iwctl station wlan0 show | grep --quiet "Connected network.*$network"
}

check_network_after_delay() {
  sleep 5
  if home_network_is_connected; then
    systemctl --no-block start mnt-mother-data.automount
  else
    systemctl --no-block stop mnt-mother-data.automount
    systemctl --no-block stop mnt-mother-data.mount
  fi
}

# Entrypoint logic when the script runs:
#
# Immediately after the device is added, it's probably not already connected.
# And AFAICT there isn't another udev event we can listen to that would trigger
# after the network is connected, so the only practical approach I can see is to
# wait a few seconds before checking the network. However, just `sleep`-ing in a
# udev script is bad practice from what I've seen, since udev triggers run in
# series, i.e. they block.
#
# So the solution is that when the script runs without any arguments, all it
# does is nohup itself with a flag to tell it to "really" run the script logic.
# When it "really" runs in a forked shell, it sleeps for a few seconds. This way
# we can wait for a while without blocking other udev triggers.
if [ "$1" = "-r" ]; then
  check_network_after_delay
else
  nohup "$0" -r
fi
