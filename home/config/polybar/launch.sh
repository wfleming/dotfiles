#!/bin/sh
set -e

killall -q polybar || true
for mon in $(polybar --list-monitors | cut -d":" -f1); do
  MONITOR="$mon" polybar top &
done
