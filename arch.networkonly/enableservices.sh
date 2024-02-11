#!/bin/bash
# AUTHOR:			BJ Veurink
# NAME: 			install.arch stage3
# LICENSE:		GNU GPLv2

cat services | sed sed '/^$/d; /^#/d' | while read -r service
	sudo systemctl enable $service
done
