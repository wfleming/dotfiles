#!/bin/sh
set -e

# the font awesome character for the network
network_icon="\uf0ec"

is_connected() {
  nordvpn status | fgrep --quiet "Status: Connected"
}

echo_status() {
  if is_connected; then
    css_class="connected"
    tooltip="VPN is connected"
  else
    css_class="disconnected"
    tooltip="VPN is disconnected"
  fi

  printf '{ "text": "%s", "class": "%s", "tooltip": "%s" }' "$network_icon" "$css_class" "$tooltip"
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
