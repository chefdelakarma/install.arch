#!/bin/bash
# AUTHOR:			BJ Veurink
# NAME: 			install.arch stage3
# LICENSE:		GNU GPLv2

mkdir -pv git
pushd git
for i in $(cat ../aurpackages | grep -v ^#); do
	git clone https://aur.archlinux.org/$i.git
	pushd $i
		makepkg -si
	popd
done
popd
