#!/bin/sh
#
# Expected to be run as root via udev

sudo -u will \
  DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id --user will)/bus \
  notify-send --urgency=critical --wait "Battery is low" "Charge your battery."
