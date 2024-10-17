#!/bin/sh
# passwordless sudo for wheel group
set -e

setup_base_dir=$(dirname $0)
. "${setup_base_dir}/shared.sh"

echo "==== set up sudoers group"
printf "%%wheel\tALL=(ALL) NOPASSWD: ALL\n" | sudo dd of=/etc/sudoers.d/wheel
