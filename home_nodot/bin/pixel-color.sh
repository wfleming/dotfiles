#!/bin/sh
set -e

pixel=$(grim -g "$(slurp -p)" -t ppm - | convert - -format '%[pixel:p{0,0}]' txt:-)

printf "%s" "$pixel" | wl-copy
notify-send "pixel info (copied to clipboard):  $pixel"
