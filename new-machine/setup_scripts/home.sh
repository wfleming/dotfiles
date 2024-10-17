#!/bin/sh
set -e

echo "==== setting up dotfiles"
./install.sh
sudo ./system/install.sh

echo "==== Install vim plugins"
(
  cd ~/.config/nvim
  ./plugins.sh
)

# https://wiki.archlinux.org/index.php/Dropbox#Prevent_automatic_updates
echo "==== Making ~/.dropbox-dist readonly"
install -dm0 ~/.dropbox-dist
