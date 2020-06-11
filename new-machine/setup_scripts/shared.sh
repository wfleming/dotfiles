# variables
# TODO - define the installer root here?
username="will"
dotfiles_url="git@github.com:wfleming/dotfiles.git"
extra_pkgbuilds_url="git@github.com:wfleming/pkgbuilds.git"
crypt_dev=/dev/mapper/cryptroot

check_internet() {
  echo "== Connect to Internet"

  if netcat --wait=5 --zero 1.1.1.1 53; then
    echo "==== Internet already connected"
  else
    echo "==== Internet not connected"
    echo "     This script will exit so you can connect to the Internet."
    echo "     To connect to wifi, try wifi-menu, or dhcpd if ethernet is connected."
    echo "     When done, re-run ${0}"
    exit 2
  fi
}
