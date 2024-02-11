#!/bin/bash
# AUTHOR:			BJ Veurink
# NAME: 			install.arch stage3
# LICENSE:		GNU GPLv2

IFS=$'\t'
installscriptsdir=/install
tmp=/home/admin/tmpinstall
mkdir -pv $tmp
rexex="#Server = http://ftp.snt.utwente.nl/pub/os/linux/archlinux/\$repo/os/\$arch"
newserver="Server = http://ftp.snt.utwente.nl/pub/os/linux/archlinux/\$repo/os/\$arch"
sudo sed -i "s+$regex+$newserver+" /etc/pacman.d/mirrorlist
exitcode=1
while [[ $exitcode > 0]]; do
	sudo echo "Sudo works"
	exitcode=$?
done

sudo pacman -Sy < packages

mkdir -pv git
pushd git
for i in $(cat aurpackages | grep -v ^#); do
	git clone https://aur.archlinux.org/$i.git
	pushd $i
		makepkg -si
	popd
done
popd

cat services | sed sed '/^$/d; /^#/d' | while read -r service
	sudo systemctl enable $service
done && "OK enable systemctl units/services"

pushd $tmp
	wget https://raw.githubusercontent.com/cjbassi/config/master/.config/waybar/config && echo "OK get waybar config"
	wget https://raw.githubusercontent.com/cjbassi/config/master/.config/waybar/style.css && echo "OK get waybar style.css"
	sudo cp config /etc/skel/.config/waybar/
	sudo cp style.css /etc/skel/.config/waybar/
	sudo cp --no-preserve=all /install/etc/* /etc/
popd

cat sedlist | sed '/^$/d; /^#/d' | while read -r file var value; do
	regex="^[ \t]*#?[ \t]*$var=.*$"
	sub=$var=$value
	sudo sed -i -E "/$regex/!{q100}; {s/$regex/$sub/}" $file || sudo bash -c "echo $sub >> $file"
done

cat appendlist | sed '/^$/d; /^#/d' | while read -r file append; do
	[[ $file =~ ^# ]] && continue
	regex="^[ \t]*#$append$"
	sed -i -E "/$regex/!{q100}; {s/$regex/$append/}" $file || sudo bash -c "echo $append >> $file"
done

echo "Enter username?"
read -r username
sudo useradd -m $username
sudo passwd $username
