#!/bin/sh
set -e

setup_base_dir=$(dirname $0)
. "${setup_base_dir}/shared.sh"

echo "==== mkinitcpio"
# https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#Configuring_mkinitcpio_2
mkinitcpio_rm_hook() {
  hook="$1"

  if ! fgrep --quiet "${hook}" /etc/mkinitcpio.conf; then
    sed -e "s/^HOOKS=\(.*\) ${hook} \(.*\)/HOOKS=\1 \2/" /etc/mkinitcpio.conf > /etc/mkinitcpio.conf.new
    mv /etc/mkinitcpio.conf{.new,}
  fi
}
mkinitcpio_add_hook() {
  after_hook="$1"
  add_hook="$2"

  if ! fgrep --quiet "${add_hook}" /etc/mkinitcpio.conf; then
    sed -e "s/^HOOKS=\(.*\) ${after_hook} \(.*\)/HOOKS=\1 ${after_hook} ${add_hook} \2/" /etc/mkinitcpio.conf > /etc/mkinitcpio.conf.new
    mv /etc/mkinitcpio.conf{.new,}
  fi
}
mkinitcpio_add_hook "base" "udev"
# keyboard was already there, but later - remove it before adding again
mkinitcpio_rm_hook "keyboard"
mkinitcpio_add_hook "autodetect" "keyboard keymap"
mkinitcpio_add_hook "block" "encrypt lvm2"
# set lz4 for compression
sed -e 's/^#COMPRESSION="lz4"$/COMPRESSION="lz4"/' /etc/mkinitcpio.conf > /etc/mkinitcpio.conf.new
mv /etc/mkinitcpio.conf{.new,}
mkinitcpio --allpresets

echo "==== bootloader"
# https://wiki.archlinux.org/index.php/Systemd-boot
# kernel options :
# - setup full disk encryption config and root device
kernel_opts="cryptdevice=UUID=${root_part_uuid}:cryptroot root=/dev/RootLvmVols/root"
# - net.ifnames=0 gets back network names like `wlan0`. I know there are good
#   reasons for "predictable network names", but for me I use several machines
#   that all just have a single wlan and maybe single ethernet and that's it, and
#   switching between them and needing to address different interface names is a
#   pain.
kernel_opts="$kernel_opts net.ifnames=0"
# - ThinkPads have some weird issue where the laptop screen will sporadically
#   freeze - I believe it has something to do with panel self refresh (PSR)
#   https://bbs.archlinux.org/viewtopic.php?id=246841&p=2
if fgrep --quiet LENOVO /sys/devices/virtual/dmi/id/sys_vendor; then
  kernel_opts="$kernel_opts i915.enable_psr=0"
fi

root_part_uuid=$(blkid | grep 'TYPE="crypto_LUKS"' | sed -e 's/^.* UUID="\([a-z0-9-]\+\)".*$/\1/')
mkdir -p /boot/loader/entries
cat <<EOF > /boot/loader/entries/arch.conf
title   Arch Linux
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options $kernel_opts
EOF
bootctl --esp-path=/boot/ install
