#!/bin/sh
set -e

setup_base_dir=$(dirname $0)
. "${setup_base_dir}/shared.sh"

echo "== Running pacstrap"

echo "==== configuring mirrorlist"
curl --location "https://archlinux.org/mirrorlist/?country=CA&country=US&protocol=https&ip_version=4&use_mirror_status=on" \
  | sed 's/#Server/Server/' > /etc/pacman.d/mirrorlist

echo "==== running pacstrap to install base packages"

pacstrap_pkgs="base base-devel linux linux-firmware" # the most basic basics
pacstrap_pkgs="${pacstrap_pkgs} lvm2" # for encrypted root fs
pacstrap_pkgs="${pacstrap_pkgs} man-db man-pages" # knowing how things work is handy
pacstrap_pkgs="${pacstrap_pkgs} iwd dhcpcd iw bind" # networking - iwd preferred, iw useful for some debugging
pacstrap_pkgs="${pacstrap_pkgs} openssh sudo" # ssh & sudo
pacstrap_pkgs="${pacstrap_pkgs} netcat" # needed after restart for setup script
pacstrap_pkgs="${pacstrap_pkgs} udisks2" # removable media in userland
pacstrap_pkgs="${pacstrap_pkgs} zsh zsh-completions tmux alacritty" # my preferred shell & terminal
pacstrap_pkgs="${pacstrap_pkgs} ttf-droid noto-fonts-emoji otf-font-awesome" # fonts
pacstrap_pkgs="${pacstrap_pkgs} pipewire pipewire-alsa pipewire-pulse wireplumber pavucontrol pamixer" # audio
pacstrap_pkgs="${pacstrap_pkgs} bluez bluez-utils" # bluetooth
pacstrap_pkgs="${pacstrap_pkgs} sway swaybg swaylock swayidle waybar mako grim otf-font-awesome slurp bemenu-wlroots bemenu brightnessctl wl-clipboard xorg-xwayland" # for wayland env
pacstrap_pkgs="${pacstrap_pkgs} nemo" # simple gui file manager
pacstrap_pkgs="${pacstrap_pkgs} gammastep" # flux/redshift-esque night color temp for wayland
pacstrap_pkgs="${pacstrap_pkgs} xdg-desktop-portal xdg-desktop-portal-wlr" # for screensharing in wayland
pacstrap_pkgs="${pacstrap_pkgs} pass pass-otp browserpass browserpass-firefox" # password management
pacstrap_pkgs="${pacstrap_pkgs} neomutt elinks offlineimap msmtp" # mail
pacstrap_pkgs="${pacstrap_pkgs} rustup" # language package managers
pacstrap_pkgs="${pacstrap_pkgs} docker docker-compose" # containers
pacstrap_pkgs="${pacstrap_pkgs} chromium" # I use FF and will install it via AUR later, but need chrome for browser testing sometimes
pacstrap_pkgs="${pacstrap_pkgs} neovim fzf ctags ripgrep sxiv git github-cli jq bzip2 unzip" # etc
pacstrap_pkgs="${pacstrap_pkgs} calibre rawtherapee" # media management
pacstrap_pkgs="${pacstrap_pkgs} wf-recorder" # screen recorder for wayland
pacstrap_pkgs="${pacstrap_pkgs} vdirsyncer" # sync caldav contacts
pacstrap_pkgs="${pacstrap_pkgs} nfs-utils" # I use a NAS at home
pacstrap_pkgs="${pacstrap_pkgs} gtk2" # gnupg pinentry use gtk if avail, then falls back to curses. qt version exists, but is not used by default.
pacstrap_pkgs="${pacstrap_pkgs} restic" # backups

if lscpu | grep Model | grep Intel; then
  pacstrap_pkgs="${pacstrap_pkgs} intel-ucode intel-media-driver"
elif lscpu | grep Model | grep AMD; then
  pacstrap_pkgs="${pacstrap_pkgs} amd-ucode vulkan-radeon libva-mesa-driver libva-utils"
fi

pacstrap /mnt ${pacstrap_pkgs}
