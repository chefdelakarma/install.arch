#!/bin/bash
# AUTHOR:			BJ Veurink
# NAME: 			getinstall.sh stage0
# LICENSE:		GNU GPLv2
#dependencies: wget, gpg, git

ping -c 3 snt.utwente.nl || exit 1
gpg --locate-keys pierre@archlinux.org

	[[ -f archlinux-bootstrap-x86_64.tar.gz ]] || wget -r -nd --no-parent -A 'archlinux-bootstrap-x86_64.*' https://ftp.snt.utwente.nl/pub/linux/archlinux/iso/latest/
	[[ -f  sha256sums.txt ]] || wget -r -nd --no-parent -A 'sha256sums.txt' https://ftp.snt.utwente.nl/pub/linux/archlinux/iso/latest/
	gpg --verify archlinux-bootstrap-x86_64.tar.gz.sig archlinux-bootstrap-x86_64.tar.gz
	[[ -d root.x86_64 ]] || sudo tar xzf archlinux-bootstrap-x86_64.tar.gz
sudo mkdir -pv "root.x86_64/install"
sudo chmod -R 777 "root.x86_64/install"

root.x86_64/bin/arch-chroot /install/arch.networkonly/stage1.sh
