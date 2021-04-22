#!/bin/sh
#
# Hacky utility to allow disabling my xautolock temporarily with a polybar icon.
# Basically it's a much simpler caffeine-ng replacement.

enabled_icon=""
disabled_icon=""

if [ -z "$XDG_RUNTIME_DIR" ]; then
  XDG_RUNTIME_DIR="/run/user/$UID"
fi
status_file="$XDG_RUNTIME_DIR/wake-status"

# AFAICT there's no way to ask an xautolock process it's current status, so we
# assume it's currently enabled if we can't determine anything else
if [ ! -e "$status_file" ]; then
  echo "enabled" > "$status_file"
fi

currently_enabled() {
  tail --lines=1 "$status_file" | grep --quiet enabled
}

tail_status() {
  tail --lines=1 --follow "$status_file" |
    while read status; do
      if [ "$status" = "enabled" ]; then
        echo "$enabled_icon"
      else
        echo "$disabled_icon"
      fi
    done
}

toggle_status() {
  if currently_enabled; then
    xautolock -disable
    echo "disabled" >> "$status_file"
  else
    xautolock -enable
    echo "enabled" >> "$status_file"
  fi
}

case "$1" in
  tail_status)
    tail_status
    ;;
  toggle)
    toggle_status
    ;;
  *)
    echo "Missing or invalid subcommand."
    exit 64
    ;;
esac
