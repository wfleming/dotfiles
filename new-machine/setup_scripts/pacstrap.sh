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
pacstrap_pkgs="${pacstrap_pkgs} intel-ucode xf86-video-intel" # I'm presuming an intel CPU & GPU
pacstrap_pkgs="${pacstrap_pkgs} man-db man-pages" # knowing how things work is handy
pacstrap_pkgs="${pacstrap_pkgs} iwd dhcpcd iw" # networking - iwd preferred, iw useful for some debugging
pacstrap_pkgs="${pacstrap_pkgs} netcat" # needed after restart for setup script
pacstrap_pkgs="${pacstrap_pkgs} acpid" # power management
pacstrap_pkgs="${pacstrap_pkgs} udisks2" # removal media in userland
pacstrap_pkgs="${pacstrap_pkgs} zsh zsh-completions tmux alacritty" # my preferred shell & terminal
pacstrap_pkgs="${pacstrap_pkgs} thunar tumbler" # simple gui file manager for times when that's useful, tumbler is for thumbnails
pacstrap_pkgs="${pacstrap_pkgs} ttf-hack ttf-droid noto-fonts-emoji otf-font-awesome" # fonts
pacstrap_pkgs="${pacstrap_pkgs} xorg-server xorg-xinit xorg-xbacklight xorg-xrandr xautolock xclip scrot rofi" # for desktop env
pacstrap_pkgs="${pacstrap_pkgs} i3-gaps i3lock" # for x11 i3 setup
#pacstrap_pkgs="${pacstrap_pkgs} sway swaybg swaylock swayidle waybar mako grim otf-font-awesome slurp bemenu-wlroots bemenu brightnessctl wl-clipboard xorg-xserver-xwayland" # for wayland env
pacstrap_pkgs="${pacstrap_pkgs} bluez bluez-utils" # bluetooth
pacstrap_pkgs="${pacstrap_pkgs} dunst" # notifications
pacstrap_pkgs="${pacstrap_pkgs} ntp" # accurate time, please
pacstrap_pkgs="${pacstrap_pkgs} alsa-utils pulseaudio pavucontrol" # audio
pacstrap_pkgs="${pacstrap_pkgs} pass pass-otp browserpass browserpass-firefox" # password management
pacstrap_pkgs="${pacstrap_pkgs} neomutt elinks offlineimap msmtp" # mail
pacstrap_pkgs="${pacstrap_pkgs} rustup yarn" # language package managers
pacstrap_pkgs="${pacstrap_pkgs} docker docker-compose" # containers
pacstrap_pkgs="${pacstrap_pkgs} chromium" # I use FF and will install it via AUR later, but need chrome for browser testing sometimes
pacstrap_pkgs="${pacstrap_pkgs} neovim fzf ctags ripgrep feh sxiv git hub jq bzip2 unzip" # etc
pacstrap_pkgs="${pacstrap_pkgs} intellij-idea-community-edition aws-cli" # etc
pacstrap_pkgs="${pacstrap_pkgs} calibre rawtherapee" # media management
pacstrap_pkgs="${pacstrap_pkgs} wf-recorder" # screen recorder for wayland
pacstrap_pkgs="${pacstrap_pkgs} vdirsyncer" # sync caldav contacts

pacstrap /mnt ${pacstrap_pkgs}
