#!/bin/sh
set -e

# enable system/user units
sudo systemctl enable --now \
  mullvad-daemon \
  docker.socket \
  mnt-mother-data.automount \
  systemd-timesyncd

systemctl --user enable --now \
  ssh-agent \
  imap-sync-full.timer \
  imap-sync-quick.timer \
  contacts-sync.timer \
  backup.timer \
  geoclue-agent
mkdir -p ~/.config/systemd/user/sway-session.target.wants
# havne't decided how to install/manage dropbox yet
# ln -s /usr/lib/systemd/user/dropbox.service ~/.config/systemd/user/sway-session.target.wants/dropbox.service
# color management on asahi is still wonky and i don't think well supported yet, avoid gammastep for now
# ln -s /usr/lib/systemd/user/gammastep.service ~/.config/systemd/user/sway-session.target.wants/gammastep.service
