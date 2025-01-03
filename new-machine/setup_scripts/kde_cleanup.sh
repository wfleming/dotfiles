#!/bin/sh
set -e

sudo dnf remove -y \
  ktorrent /
  kmines /
  kmahjongg /
  kpat /
  kwalletmanager5 /
  digikam /
  gwenview /
  kolourpaint /
  okular skanpage dragon elisa-player kamoso k3b cdrdao /
  krdc /
  krfb /
  firewalld /
  mariadb
sudo dnf group remove -y LibreOffice


# vconsole.conf
# # Written by systemd-localed(8) or systemd-firstboot(1), read by systemd-localed
# # and systemd-vconsole-setup(8). Use localectl(1) to update this file.
# KEYMAP=us
# XKBLAYOUT=us
# XKBMODEL=applealu_ansi
