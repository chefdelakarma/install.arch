#!/bin/bash
# AUTHOR:			BJ Veurink
# NAME: 			install.arch stage3
# LICENSE:		GNU GPLv2
rexex="#Server = http://ftp.snt.utwente.nl/pub/os/linux/archlinux/\$repo/os/\$arch"
newserver="Server = http://ftp.snt.utwente.nl/pub/os/linux/archlinux/\$repo/os/\$arch"
sudo sed -i "s+$regex+$newserver+" /etc/pacman.d/mirrorlist
