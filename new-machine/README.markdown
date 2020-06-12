# Machine setup scripting

Put together to automate setting up a new box, and copying over some things from
a current box that aren't easy/appropriate to keep in dotfiles

## Why not just image the current box and copy it?

Because a new machine is an opportunity to clean up and document/script
configuration, and I like to futz around.

## Testing the disk image in a VM

```
# you should already have run mkboot, so the custom boot image exists at
# arch-custom.iso
# deps
sudo pacman -S qemu libvirt
# create a 30G disk image
qemu-img create -f qcow2 disk.cow 30G
# must be run as root or I kaslr errors?
sudo qemu-system-x86_64 \
  -m 2G \
  -enable-kvm \
  -cdrom arch-custom.iso \
  -boot order=d \
  -vga std \
  -drive file=disk.cow
# aquire internet
dhcpcd
# run installer
/installer/setup
```

Followed this to get a shared vol between host & guest - faster to iterate on
installer script

https://xapax.github.io/blog/2017/05/09/sharing-files-kvm.html

```
mkdir /nmshare
mount  -t 9p -o trans=virtio /nmshare /nmshare
```
