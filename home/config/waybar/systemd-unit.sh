#!/bin/sh
set -e

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
css_class="unit-inactive"
tooltip=""
if run_systemctl is-active "$unit" | grep --quiet inactive; then
  css_class="unit-inactive"
elif run_systemctl is-active "$unit" | grep --quiet activ; then
  css_class="unit-active"
  print_icon="$active_icon"
elif run_systemctl is-failed "$unit" | grep --quiet failed; then
  css_class="unit-failed"
  print_icon="$failed_icon"
  tooltip="$unit failed"
fi

printf '{ "text": "%s", "class": "%s", "tooltip": "%s" }' "$print_icon" "$css_class" "$tooltip"
