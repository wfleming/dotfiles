#!/bin/sh
set -e

active_color="#1a4"
inactive_color="#999"
failed_color="#a00"

systemctl_flags=""
unit=""
icon=""

parsed_args=$(getopt --options '' --longoptions 'user,unit:,icon:' -- "$@")
eval set -- "$parsed_args"
while :; do
  case "$1" in
    --user)
      systemctl_flags="$systemctl_flags --user"
      shift
      ;;
    --unit)
      unit="$2"
      shift 2
      ;;
    --icon)
      icon="$2"
      shift 2
      ;;
    --)
      shift; break
      ;;
    *)
      echo "Unexpected option $1"
      exit 64
      ;;
  esac
done

if [ -z "$unit" -o -z "$icon" ]; then
  echo "--unit and --icon are required"
  exit 64
fi

color="$inactive_color"
if systemctl $systemctl_flags is-active "$unit" | grep --quiet inactive; then
  color="$inactive_color"
elif systemctl $systemctl_flags is-active "$unit" | grep --quiet activ; then
  color="$active_color"
elif systemctl $systemctl_flags is-failed "$unit" | grep --quiet failed; then
  color="$failed_color"
fi

printf "%%{F%s}%s%%{F-}\n" "$color" "$icon"
