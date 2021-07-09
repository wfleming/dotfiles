#!/bin/sh
set -e

setup_base_dir=$(dirname $0)
. "${setup_base_dir}/shared.sh"

echo "== Locale, hostname, boot setup, etc."

echo "==== Enter machine hostname"
read hostname

echo "==== Set locale"
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc
sed -e 's/^#\(en_US.UTF-8.*\)/\1/' /etc/locale.gen > /etc/locale.gen.new \
  && mv /etc/locale.gen{.new,}
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "==== Set hostname"
printf "%s\n" "${hostname}" > /etc/hostname
printf "127.0.1.1\t${hostname}.localdomain ${hostname}" >> /etc/hosts
