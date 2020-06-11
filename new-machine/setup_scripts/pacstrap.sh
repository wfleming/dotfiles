#!/bin/sh
set -e

setup_base_dir=$(dirname $0)
. "${setup_base_dir}/shared.sh"

echo "== Running pacstrap"

echo "==== configuring mirrorlist"
curl "https:/www.archlinux.org/mirrorlist/?country=CA&country=US&protocol=https&ip_version=4&use_mirror_status=on" \
  | sed 's/#Server/Server/' > /etc/pacman.d/mirrorlist

echo "==== running pacstrap to install base packages"

pacstrap_pkgs="base base-devel linux linux-firmware" # the most basic basics
pacstrap_pkgs="${pacstrap_pkgs} lvm2" # for encrypted root fs
pacstrap_pkgs="${pacstrap_pkgs} btrfs-progs" # btrfs utils
pacstrap_pkgs="${pacstrap_pkgs} intel-ucode xf86-video-intel" # I'm presuming an intel CPU & GPU
pacstrap_pkgs="${pacstrap_pkgs} man-db man-pages" # knowing how things work is handy
pacstrap_pkgs="${pacstrap_pkgs} netctl dialog wpa_supplicant dhcpcd iw" # networking
pacstrap_pkgs="${pacstrap_pkgs} netcat" # needed after restart for setup script
pacstrap_pkgs="${pacstrap_pkgs} acpid" # power management
pacstrap_pkgs="${pacstrap_pkgs} zsh zsh-completions tmux alacritty" # my preferred shell & terminal
pacstrap_pkgs="${pacstrap_pkgs} thunar" # simple gui file manager for times when that's useful
pacstrap_pkgs="${pacstrap_pkgs} ttf-hack ttf-droid noto-fonts-emoji" # fonts
pacstrap_pkgs="${pacstrap_pkgs} xorg-server xorg-xbacklight xautolock slock xclip scrot dmenu" # for desktop env
pacstrap_pkgs="${pacstrap_pkgs} bluez bluez-utils" # bluetooth
pacstrap_pkgs="${pacstrap_pkgs} dunst" # notifications
pacstrap_pkgs="${pacstrap_pkgs} ntp" # accurate time, please
pacstrap_pkgs="${pacstrap_pkgs} alsa-utils pulseaudio pulseaudio-bluetooth pulseeffects pavucontrol" # audio
pacstrap_pkgs="${pacstrap_pkgs} pass pass-otp browserpass browserpass-firefox" # password management
pacstrap_pkgs="${pacstrap_pkgs} neomutt elinks isync offlineimap msmtp" # mail
pacstrap_pkgs="${pacstrap_pkgs} rustup yarn" # language package managers
pacstrap_pkgs="${pacstrap_pkgs} docker docker-compose" # containers
pacstrap_pkgs="${pacstrap_pkgs} chromium" # I use FF and will install it via AUR later, but need chrome for browser testing sometimes
pacstrap_pkgs="${pacstrap_pkgs} neovim fzf ctags the_silver_searcher feh git hub jq bzip2 unzip" # etc
pacstrap_pkgs="${pacstrap_pkgs} intellij-idea-community-edition aws-cli" # etc

pacstrap /mnt ${pacstrap_pkgs}