#!/bin/bash
# AUTHOR:			BJ Veurink
# NAME: 			install.arch stage3
# LICENSE:		GNU GPLv2

tmp=tmpinstall
pushd $tmp
	wget https://raw.githubusercontent.com/cjbassi/config/master/.config/waybar/config
	wget https://raw.githubusercontent.com/cjbassi/config/master/.config/waybar/style.css
	sudo cp config /etc/skel/.config/waybar/
	sudo cp style.css /etc/skel/.config/waybar/
	sudo cp --no-preserve=all /install/etc/* /etc/
popd
