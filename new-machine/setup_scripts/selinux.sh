#!/bin/sh
set -e

echo "\nSELINUX=disabled" | sudo tee --append /etc/selinux/config

sudo grubby --update-kernel ALL --args selinux=0
