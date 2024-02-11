#!/bin/bash
# AUTHOR:			BJ Veurink
# NAME: 			install.arch stage2
# LICENSE:		GNU GPLv2

ping -c3 snt.utwente.nl

ln -sf /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime
hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "nl_NL.UTF-8 UTF-8" >> /etc/locale.gen  
echo "nl_NL ISO-8859-1" >> /etc/locale.gen  
echo "nl_NL@euro ISO-8859-15" >> /etc/locale.gen
locale-gen && echo "OK locale-gen"
echo "LANG=en_US.UTF-8" > /etc/locale.conf

mkdir -pv /etc/skel/.config/{sway,waybar}
cp -r /install/etc/* /etc/

useradd -m admin
exitcode=1
while [[ $exitcode > 0 ]]; do
	echo "password for admin?"
	passwd admin
	exitcode=$?
done
pacman-key --init
pacman-key --populate archlinux
pacman -Syy
pacman -Sy sudo
pacman -Sy networkmanager

regex="# %wheel ALL="
sub="%wheel ALL="
sed -i "s+$regex+$sub+" /etc/sudoers
visudo -c
#usermod -a -G wheel admin

echo enter hostname?
read -r hostname

echo "myarch-$hostname" > /etc/hostname

pacman -Sy grub
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=myarch
grub-mkconfig -o /boot/grub/grub.cfg

