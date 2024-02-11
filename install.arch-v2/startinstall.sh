#!/bin/bash
# AUTHOR:			BJ Veurink
# NAME: 			startinstall.sh stage0
# LICENSE:		GNU GPLv2
#dependencies: wget, gpg, git
script=$0
echo "OK start $script"
set -e
function on_error(){
	line=$1
	echo "in script $script"
	echo "error on line $1"
	cat $script | sed "${line}q;d"
	exit
}
trap 'on_error $LINENO' ERR

ping -c 3 snt.utwente.nl || exit 1
gpg --locate-keys pierre@archlinux.org
bootstrapdir=${1:-/home/knoppix}
chrootdir=$bootstrapdir/root.x86_64
chrootcmd=/bin/arch-chroot
pushd $bootstrapdir
	[[ -f archlinux-bootstrap-x86_64.tar.gz ]] || wget -r -nd --no-parent -A 'archlinux-bootstrap-x86_64.*' https://ftp.snt.utwente.nl/pub/linux/archlinux/iso/latest/
	[[ -f  sha256sums.txt ]] || wget -r -nd --no-parent -A 'sha256sums.txt' https://ftp.snt.utwente.nl/pub/linux/archlinux/iso/latest/
	gpg --verify archlinux-bootstrap-x86_64.tar.gz.sig archlinux-bootstrap-x86_64.tar.gz
	[[ -d root.x86_64 ]] || sudo tar xzf archlinux-bootstrap-x86_64.tar.gz
popd
sudo mkdir -pv $chrootdir/installscripts
sudo chmod 777 $chrootdir/installscripts
pushd $chrootdir/installscripts
	[[ -d install.arch-v2 ]] || git clone https://gitlab.com/kingsindian85/install.arch-v2.git && echo "OK git clone install.arch.git "
	sudo chmod 777 install.arch-v2/*.sh
popd
sudo $chrootdir$chrootcmd $chrootdir /installscripts/install.arch-v2/stage1.sh

