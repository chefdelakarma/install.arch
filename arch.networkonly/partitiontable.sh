#!/bin/bash

efi=${efi:-/dev/nvme0n1p1}
mnt=${mnt:-/mnt}
swap=$mnt/swapfile

cat partitiontable | sed '/^$/d; /^#/d'	| while read -r mountpoint device fs mountoptions; do
	mkfs.$fs $device
	[[ -d "$mnt$mountpoint" ]] || mkdir -pv "$mnt$mountpoint"
	mount -o $mountoptions	$device	"$mnt$mountpoint"

done
mkdir -pv $mnt/boot/efi
mount -o noatime,fmask=0077,dmask=0077,codepage=437,iocharset=iso8859-1,shortname=mixed,utf8,errors=remount-ro $efi $mnt/boot/efi

fallocate -l 1G $swap
chmod 600	$swap
mkswap $swap
swapon $swap
swapon --show
