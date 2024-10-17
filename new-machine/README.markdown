# Machine setup scripting

## 1. Base Install

Asahi Linux installation doesn't seem easily scriptable from scratch given the constraints around
setup on a Mac, so for setup I manually run through Asahi's official installer (using the "minimal"
preset since I won't be using GNOME or KDE), and setup my user account that way.

## 2. Encrypting root volume

Asahi's installer does not currently support encrypting the root volume. So I go through some steps
to encrypt it after initial setup.


https://github.com/leifliddy/asahi-fedora-usb/
https://github.com/NoisyCoil/encryptroot-asahi/

I cobbled these instruction together from docs at
https://developer.apple.com/documentation/virtualization/creating_and_running_a_linux_virtual_machine
and https://github.com/NoisyCoil/encryptroot-asahi/blob/main/docs/encryptroot.asahi.8.md.

1. Boot back into MacOS
2. Install [UTM](https://mac.getutm.app) (the downloadable version is free, App Store version costs
   money.)
3. In UTM, navigate to "Create a new virtual machine", "Downbload prebuilt from UTM Gallery", pick
   whatever distro your most comfortable with and launch that.

https://github.com/leifliddy/asahi-fedora-usb

## 3. Remaining setup

1. Boot back into Asahi, log in
2. `sudo dmesg -n 1` to suppress kernel messages appearing on TTY
3. On my install I'd lost the wifi connection used during setup, not sure if that's expected, so
   `nmcli device wifi connect <my-network> password <wifi-password>`
4. `sudo dnf install git`
4. `git clone https://github.com/wfleming/dotfiles.git`
5. run `./new-machine/setup` in this repository
