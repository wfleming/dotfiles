#!/bin/sh
set -e

setup_base_dir=$(dirname $0)
. "${setup_base_dir}/shared.sh"

export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_ed25519"

echo "==== copying private/local dotfiles from ${setup_base_dir}"
cd ~
sudo cp --archive $(find /installer/home -mindepth 1 -maxdepth 1) ~/
sudo cp --archive $(find /installer/usr -mindepth 1 -maxdepth 1) /usr

echo "==== Ensure ~ file ownership is correct"
sudo chown --recursive "${username}:${username}" ~

# All files embedded in the airootfs get the same permissions
chmod 0600 ~/.ssh/*

# aurto is rust, needs the toolchain configured for later
echo "==== rustup - default toolchain"
rustup default stable

echo "==== setting up dotfiles"
(
  mkdir ~/src
  cd ~/src
  git clone "${dotfiles_url}" dotfiles
  cd dotfiles
  ./install.sh
  sudo ./system/install.sh
)

echo "==== Install vim plugins"
(
  cd ~/.config/nvim
  ./plugins.sh
)

# https://wiki.archlinux.org/index.php/Dropbox#Prevent_automatic_updates
echo "==== Making ~/.dropbox-dist readonly"
install -dm0 ~/.dropbox-dist

echo "==== enabling systemd units"
sudo systemctl enable --now \
  bluetooth \
  docker.socket \
  iwd \
  mnt-mother-data.automount \
  pac-gen-mirrorlist.timer \
  systemd-networkd \
  systemd-resolved \
  systemd-timesyncd

echo "==== User account created"
echo "     You need to reboot to continue:"
echo "     After rebooting, log in as ${username} and then run /installer/setup_2"
