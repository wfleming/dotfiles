#!/bin/sh
set -e

setup_base_dir=$(dirname $0)
. "${setup_base_dir}/shared.sh"

echo "==== Setting up btrfs docker subvolume"
# to ensure docker storage doesn't get out of hand
btrfs subvolume create /var/lib/docker
btrfs quota enable /var/lib/docker
# seeing "rescan failed: Operation now in progress" errors? I don't think I
# really need to rescan - this won't be used until after a reboot
# btrfs quota rescan /var/lib/docker
btrfs qgroup limit 200G /var/lib/docker
