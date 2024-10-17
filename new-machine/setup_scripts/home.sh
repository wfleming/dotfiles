#!/bin/sh
set -e

# default shells. use sudo to set mine just to avoid needing to enter the password
sudo chsh -s /usr/bin/zsh will
sudo chsh -s /usr/bin/zsh

echo "==== setting up dotfiles"
./install.sh
sudo ./system/install.sh

echo "==== Install vim plugins"
(
  cd ~/.config/nvim
  ./plugins.sh
)

# https://wiki.archlinux.org/index.php/Dropbox#Prevent_automatic_updates
# dropbox is installed via flatpak now, i don' think this is necessary anymore
# echo "==== Making ~/.dropbox-dist readonly"
# install -dm0 ~/.dropbox-dist
