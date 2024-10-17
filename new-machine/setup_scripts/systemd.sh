#!/bin/sh
set -e
# enable system/user units
sudo systemctl enable --now mullvad-daemon
  docker.socket \
  mnt-mother-data.automount

  # systemd-networkd \
  # systemd-resolved \
  # systemd-timesyncd

systemctl --user enable --now \
  ssh-agent \
  imap-sync-full.timer \
  imap-sync-quick.timer \
  contacts-sync.timer \
  backup.timer \
  geoclue-agent
mkdir -p ~/.config/systemd/user/sway-session.target.wants
ln -s /usr/lib/systemd/user/dropbox.service ~/.config/systemd/user/sway-session.target.wants/dropbox.service
ln -s /usr/lib/systemd/user/gammastep.service ~/.config/systemd/user/sway-session.target.wants/gammastep.service

