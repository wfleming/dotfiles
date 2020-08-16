#!/bin/sh
set -e

setup_base_dir=$(dirname $0)
. "${setup_base_dir}/shared.sh"

echo "== Inside chroot"

# I use nvim but lots of things tend to expect vim to exist
echo "==== Symlink vim"
ln -s $(which nvim) /usr/bin/vim

# https://www.reddit.com/r/archlinux/comments/5r5ep8/make_your_arch_fonts_beautiful_easily/
echo "==== Font setup"
sudo ln -s /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d
sudo ln -s /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
sudo ln -s /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d
sed 's/^#export FREETYPE_PROPERTIES/export FREETYPE_PROPERTIES/' /etc/profile.d/freetype2.sh > /etc/profile.d/freetype2.sh.new
mv /etc/profile.d/freetype2.sh{.new,}

"${setup_base_dir}/locale_misc.sh"
"${setup_base_dir}/mkinitcpio.sh"
"${setup_base_dir}/root_passwd.sh"
"${setup_base_dir}/sudoers.sh"
"${setup_base_dir}/user_account.sh"
