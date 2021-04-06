#!/bin/sh
# References:
# - https://github.com/polybar/polybar/wiki/Module:-script
# - https://github.com/polybar/polybar/wiki/Formatting
#
# Example config:
# [module/nordvpn]
# type = custom/script
# label = VPN %output%
# exec = ~/.config/polybar/nordvpn.sh status
# click-left = ~/.config/polybar/nordvpn.sh toggle
set -e

# the font awesome character for the network
network_icon=""

# the colors
connected_color="#1a4"
disconnected_color="#999"

is_connected() {
  nordvpn status | fgrep --quiet "Status: Connected"
}

echo_status() {
  if is_connected; then
    printf "%%{F%s}%s%%{F-}\n" "$connected_color" "$network_icon"
  else
    printf "%%{F%s}%s%%{F-}\n" "$disconnected_color" "$network_icon"
  fi
}

toggle_vpn() {
  if is_connected; then
    nordvpn disconnect
  else
    nordvpn connect
  fi
}

case "$1" in
  status)
    echo_status
    ;;
  toggle)
    toggle_vpn
    ;;
  *)
    echo "invalid subcommand"
    exit 1
    ;;
esac
