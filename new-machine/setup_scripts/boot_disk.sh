#!/bin/sh
set -e

setup_base_dir=$(dirname $0)
. "${setup_base_dir}/shared.sh"

echo "== Partition boot disk"

lsblk -o "NAME,PATH,SIZE,TYPE,MOUNTPOINT"
echo "==== Enter boot device to install Linux on"
read boot_dev
if echo "$boot_dev" | grep --quiet "[0-9]$"; then
  boot_partition="${boot_dev}p1"
  root_partition="${boot_dev}p2"
else
  boot_partition="${boot_dev}1"
  root_partition="${boot_dev}2"
fi

(
  echo "g"     # clear the partition table - start new gpt partition table
  echo "n"     # new partition
  echo "1"     # partition number 1
  echo ""      # default - start at beginning of disk
  echo "+260M" # 260 MB boot parttion - min efi size suggested, more than i need
  echo "t"     # change partition type
  echo "1"     # efi partition https://wiki.archlinux.org/index.php/EFI_system_partition#Create_the_partition
  echo "n"     # new partition
  echo "2"     # partion number 2
  echo ""      # default, start immediately after preceding partition
  echo ""      # default, extend partition to end of disk
  echo "p"     # print the partition table
  echo "w"     # write the partition table
  sleep 1      # without a bit of a wait ioctl tends to error
  echo "q"     # and we're done
) | fdisk --wipe always "${boot_dev}"

# https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#LVM_on_LUKS
echo "== Setup LVM on LUKS full disk encryption"

cryptsetup luksFormat "${root_partition}"
cryptsetup open "${root_partition}" cryptroot
pvcreate "${crypt_dev}"
vgcreate RootLvmVols "${crypt_dev}"
lvcreate -L 8G RootLvmVols -n swap
lvcreate -l 100%FREE RootLvmVols -n root

echo "== Format partitions"

mkfs.fat -F32 "${boot_partition}"
mkfs.ext4 /dev/RootLvmVols/root
mkswap /dev/RootLvmVols/swap

echo "== Mount disk for installation"

mount --options "autodefrag,compress=zstd" /dev/RootLvmVols/root /mnt
mkdir /mnt/boot
mount "${boot_partition}" /mnt/boot
swapon /dev/RootLvmVols/swap
