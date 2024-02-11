#!/bin/bash
# AUTHOR:			BJ Veurink
# NAME: 			install.arch stage3
# LICENSE:		GNU GPLv2

cat packages | sed '/^$/d; /^#/d' | xargs sudo pacman -Sy
