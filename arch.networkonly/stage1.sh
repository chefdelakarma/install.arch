#!/bin/bash
# AUTHOR:			BJ Veurink
# NAME: 			install.arch stage1
# LICENSE:		GNU GPLv2
script=$0

function on_exit(){
	umount $mnt/install
	umount $efi
	umount $boot
	umount $home
	umount $root 
}
trap 'on_exit' EXIT
ping -c3 snt.utwente.nl

sed -i 's+#Server = http://ftp.snt.utwente.nl/pub/os/linux/archlinux/$repo/os/$arch+Server = http://ftp.snt.utwente.nl/pub/os/linux/archlinux/$repo/os/$arch+' /etc/pacman.d/mirrorlist && echo "OK mirrorlist"
pacman-key --init
pacman-key --populate

[[ -z $boot ]] && echo "boot device file?" && read boot
[[ -z $root ]] && echo "root device file?" && read root
[[ -z $home ]] && echo "home device file?" && read home
[[ -z $efi ]] && echo "efi device file?" && read efi

echo filesystem boot?
read fsboot
echo filesystem root?
read fsroot
echo filesystem home?
read fshome

echo root=$root
echo home=$home
echo boot=$boot
echo efi=$efi

echo root fs=$fsroot
echo boot fs=$fsboot
echo home fs=$fshome
mnt=/mnt
echo "The following will be erased"
echo "$root"
echo "$boot"
echo "$home"
echo "ARE YOU SURE?"
read sure

sure=$(echo $sure | tr a-z A-Z)
[[ $sure =~ ^(Y|YES)$ ]] || exit 1
mkfs.$fsroot $root 
mkfs.$fsboot $boot 
mkfs.$fshome $home 

[[ -d $mnt ]] || mkdir -pv $mnt

mount -o noatime $root $mnt

[[ -d $mnt/boot ]] || mkdir -pv $mnt/boot
mount -o noatime,nodev,nosuid $boot $mnt/boot

[[ -d $mnt/boot/efi ]] || mkdir -pv $mnt/boot/efi
[[ -d $mnt/home ]] || mkdir -pv $mnt/home

mount -o noatime $efi $mnt/boot/efi
mount -o noatime,nodev,nosuid $home $mnt/home

pacstrap $mnt base linux-lts linux-firmware

genfstab -U $mnt >> $mnt/etc/fstab
[[ -d $mnt/install ]] || mkdir $mnt/install
mount --bind /installscripts/install.arch-v2 $mnt/install




umount $mnt/install
rmdir $mnt/install
