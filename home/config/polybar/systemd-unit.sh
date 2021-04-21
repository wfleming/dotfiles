#!/bin/sh
set -e

active_color="#1a4"
inactive_color="#999"
failed_color="#a00"

sudo_systemctl=1
unit=""
icon=""
active_icon=""
failed_icon=""

run_systemctl() {
  if [ $sudo_systemctl = 1 ]; then
    sudo systemctl $@
  else
    systemctl --user $@
  fi
}

parsed_args=$(getopt --options '' --longoptions 'user,unit:,icon:,active-icon:,failed-icon:' -- "$@")
eval set -- "$parsed_args"
while :; do
  case "$1" in
    --user)
      sudo_systemctl=0
      shift
      ;;
    --unit)
      unit="$2"
      shift 2
      ;;
    --icon)
      icon="$2"
      active_icon="$2"
      failed_icon="$2"
      shift 2
      ;;
    --active-icon)
      active_icon="$2"
      shift 2
      ;;
    --failed-icon)
      failed_icon="$2"
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

if [ -z "$unit" ]; then
  echo "--unit is required"
  exit 64
fi

if [ -z "$icon" -a -z "$failed_icon" ]; then
  echo "--unit or --failed-icon is required"
  exit 64
fi

print_icon="$icon"
color="$inactive_color"
if run_systemctl is-active "$unit" | grep --quiet inactive; then
  color="$inactive_color"
elif run_systemctl is-active "$unit" | grep --quiet activ; then
  color="$active_color"
  print_icon="$active_icon"
elif run_systemctl is-failed "$unit" | grep --quiet failed; then
  color="$failed_color"
  print_icon="$failed_icon"
fi

printf "%%{F%s}%s%%{F-}\n" "$color" "$print_icon"
