#!/bin/sh
set -e

setup_base_dir=$(dirname $0)
. "${setup_base_dir}/shared.sh"

echo "== Creating user account"
useradd "${username}" \
  --create-home \
  --home-dir /home/will \
  --shell /usr/bin/zsh \
  --user-group \
  --groups wheel,docker

echo "==== set a password for ${username}"
passwd "${username}"

su "${username}" --pty -c "${setup_base_dir}/after_create_user.sh"
