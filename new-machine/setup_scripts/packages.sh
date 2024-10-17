#!/bin/sh
set -e

setup_base_dir=$(dirname $0)
. "${setup_base_dir}/shared.sh"

echo "==== Installing packages"

# Stat with packages in the standard Fedora repositories
# https://docs.fedoraproject.org/en-US/quick-docs/fedora-repositories/
# enable rpmfusion repositories https://docs.fedoraproject.org/en-US/quick-docs/rpmfusion-setup/ https://rpmfusion.org/Configuration
sudo dnf install --assumeyes \
   https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
   https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf check-update || true
sudo dnf groupinstall --assumeyes "Development Tools"
pkgs=""
pkgs="${pkgs} openssh" # ssh
pkgs="${pkgs} udisks2" # removable media in userland
pkgs="${pkgs} zsh tmux foot foot-terminfo" # my preferred shell & terminal
pkgs="${pkgs} google-droid-fonts-all google-noto-color-emoji-fonts" # some fonts
pkgs="${pkgs} libavcodec-freeworld" # media codecs
pkgs="${pkgs} intel-one-mono-fonts" # intel mono font
pkgs="${pkgs} pipewire pipewire-alsa pipewire-pulseaudio wireplumber pavucontrol pamixer" # audio
pkgs="${pkgs} sway swaybg swaylock swayidle waybar mako grim slurp bemenu brightnessctl wl-clipboard xorg-x11-server-Xwayland" # for wayland env
pkgs="${pkgs} nemo" # simple gui file manager
pkgs="${pkgs} gammastep" # flux/redshift-esque night color temp for wayland
pkgs="${pkgs} xdg-desktop-portal xdg-desktop-portal-wlr" # for screensharing in wayland
pkgs="${pkgs} pass pass-otp" # password management
pkgs="${pkgs} neomutt elinks offlineimap msmtp" # mail
pkgs="${pkgs} docker docker-compose" # containers
pkgs="${pkgs} chromium" # I use FF but need chrome for browser testing sometimes
pkgs="${pkgs} neovim fzf ctags ripgrep sxiv git jq bzip2 unzip" # etc
pkgs="${pkgs} calibre" # media management
pkgs="${pkgs} wf-recorder" # screen recorder for wayland
pkgs="${pkgs} vdirsyncer" # sync caldav contacts
pkgs="${pkgs} nfs-utils" # I use a NAS at home
pkgs="${pkgs} gtk2" # gnupg pinentry use gtk if avail, then falls back to curses. qt version exists, but is not used by default.
pkgs="${pkgs} restic" # backups
pkgs="${pkgs} awscli2" # aws cli v2
pkgs="${pkgs} urlview" # for mutt with html emails
pkgs="${pkgs} rustup" # will use later to install mates
pkgs="${pkgs} qemu-user-static qemu-system-x86" # allows flatpak to emulate apps
pkgs="${pkgs} firefox" # I'll switch to stable ff for now since getting aarch64 nightly has hit several roadblocks

sudo dnf install --assumeyes $pkgs

# Some desktop apps in flatpak not available in standard repos
# disabled for now since it seems all the apps I'm interested in only have x86 versions on flathub
# right now, which isn't very helpful.
# dnf install --assumeyes flatpak # Not a fan, but easiest way to get some desktop apps without packages in standard repos
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
# flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
# flatpak install flathub com.slack.Slack
# flatpak install flathub com.spotify.Client
# flatpak install flathub com.dropbox.Client
# flatpak install flathub-beta org.mozilla.firefox

# sudo dnf check-update || true
# this might not be useful either. https://rpmfusion.org/Architectures/ARM says they build for arch,
# but I don't see the packages I care about available on my architecture.
# exit 1

# the zsh-pure prompt
test -d ~/src/vendor/zsh-pure || (
  mkdir -p ~/src/vendor
  cd ~/src/vendor
  git clone https://github.com/sindresorhus/pure.git zsh-pure
  cd zsh-pure
  mkdir -p /usr/share/zsh/functions/Prompts
  install -Dm644 pure.zsh /usr/share/zsh/site-functions/prompt_pure_setup
  install -Dm644 async.zsh /usr/share/zsh/site-functions/async
)

# tfenv
test -d ~/src/vendor/tfenv || (
  mkdir -p ~/.local/bin/
  cd ~/src/vendor
  git clone https://github.com/tfutils/tfenv
  cd tfenv
  ln -s $PWD/bin/* ~/.local/bin/
)

# browserpass native component (hardcoded to latest release at time of writing)
test -d ~/src/vendor/browserpass-native || (
  mkdir -p ~/src/vendor/browserpass-native
  cd ~/src/vendor/browserpass-native
  RELEASE="3.1.0"
  PKG="browserpass-arm64-$RELEASE.tar.gz"
  curl -L -o "$PKG" "https://github.com/browserpass/browserpass-native/releases/download/$RELEASE/$PKG"
  tar -xzf "$PKG"
  make BIN=browserpass-arm64 configure
  sudo make BIN=browserpass-arm64 install
)

# Mullvad VPN
sudo dnf config-manager --add-repo https://repository.mullvad.net/rpm/stable/mullvad.repo
sudo dnf install --assumeyes mullvad-vpn

# GH CLI
sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
sudo dnf install --assumeyes --repo gh-cli gh

# Apple San Francisco typefaces
# based on AUR packages:
# - https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=otf-san-francisco
# - https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=otf-san-francisco-mono
sudo dnf install --assumeyes p7zip p7zip-plugins bsdtar
test -d ~/src/vendor/apple-san-francisco || (
  mkdir -p ~/src/vendor/apple-san-francisco
  cd ~/src/vendor/apple-san-francisco
  curl -L -o sf-pro.zip https://developer.apple.com/fonts/downloads/SFPro.zip
  unzip sf-pro.zip
  bsdtar -xvf "SFPro/San Francisco Pro.pkg"
  bsdtar -xvf "San Francisco Pro.pkg/Payload"

  curl -L -o sf-mono.dmg https://developer.apple.com/design/downloads/SF-Mono.dmg
  7z x sf-mono.dmg
  bsdtar -xvf "SFMonoFonts/SF Mono Fonts.pkg"
  bsdtar -xvf "SFMonoFonts.pkg/Payload"

  sudo install -d /usr/share/fonts/apple
  sudo install -m644 Library/Fonts/*.otf /usr/share/fonts/apple
)

# TODO aur packages
# aur_packages="${aur_packages} mates-git" # contact cli management
