#!/bin/sh
set -e

# https://docs.fedoraproject.org/en-US/quick-docs/fedora-repositories/
#
setup_base_dir=$(dirname $0)
. "${setup_base_dir}/shared.sh"

#
echo "==== Installing packages"
dnf check-update || true

pkgs=""
# TODO what's the default installer do around disk and encryption? Best way to change after-the-fact
# or can I do it during initial setup and missed it?
# pkgs="${pkgs} lvm2" # for encrypted root fs
# pkgs="${pkgs} iwd dhcpcd iw bind" # networking - iwd preferred, iw useful for some debugging
pkgs="${pkgs} openssh" # ssh
# pkgs="${pkgs} udisks2" # removable media in userland
pkgs="${pkgs} zsh tmux foot foot-terminfo" # my preferred shell & terminal
pkgs="${pkgs} google-droid-fonts-all noto-fonts-emoji otf-font-awesome" # fonts
pkgs="${pkgs} pipewire pipewire-alsa pipewire-pulse wireplumber pavucontrol pamixer" # audio
pkgs="${pkgs} sway swaybg swaylock swayidle waybar mako grim otf-font-awesome slurp bemenu-wlroots bemenu brightnessctl wl-clipboard xorg-xwayland" # for wayland env
pkgs="${pkgs} nemo" # simple gui file manager
pkgs="${pkgs} gammastep" # flux/redshift-esque night color temp for wayland
pkgs="${pkgs} xdg-desktop-portal xdg-desktop-portal-wlr" # for screensharing in wayland
pkgs="${pkgs} pass pass-otp browserpass browserpass-firefox" # password management
pkgs="${pkgs} neomutt elinks offlineimap msmtp" # mail
pkgs="${pkgs} rustup" # language package managers
pkgs="${pkgs} docker docker-compose" # containers
pkgs="${pkgs} chromium" # I use FF but need chrome for browser testing sometimes
pkgs="${pkgs} neovim fzf ctags ripgrep sxiv git github-cli jq bzip2 unzip" # etc
pkgs="${pkgs} calibre rawtherapee" # media management
pkgs="${pkgs} wf-recorder" # screen recorder for wayland
pkgs="${pkgs} vdirsyncer" # sync caldav contacts
pkgs="${pkgs} nfs-utils" # I use a NAS at home
pkgs="${pkgs} gtk2" # gnupg pinentry use gtk if avail, then falls back to curses. qt version exists, but is not used by default.
pkgs="${pkgs} restic" # backups

dnf install $pkgs

# TODO aur packages
aur_packages="${aur_packages} aws-cli-v2-bin" # aws cli v2 (main repos are still v1)
aur_packages="${aur_packages} mullvad-vpn-bin" # vpn
aur_packages="${aur_packages} rbenv ruby-build" # ruby language management
aur_packages="${aur_packages} slack-desktop" # the productivity abyss into which we all stare
aur_packages="${aur_packages} dropbox" # sync services https://www.dropbox.com/install-linux
aur_packages="${aur_packages} spotify" # tunes
aur_packages="${aur_packages} tfenv" # manage terraform
aur_packages="${aur_packages} ttf-mac-fonts otf-san-francisco otf-san-francisco-mono" # fonts
aur_packages="${aur_packages} urlview" # for mutt with html emails
aur_packages="${aur_packages} mates-git" # contact cli management
aur_packages="${aur_packages} ydotool-bin" # xdotool but for wayland
aur_packages="${aur_packages} zsh-pure-prompt" # a nice prompt
aur_packages="${aur_packages} qpwgraph" # pipewire utility
aur_packages="${aur_packages} otf-intel-one-mono ttf-intel-one-mono" # intel mono font
aur_packages="${aur_packages} tmux-resurrect"
