#!/bin/bash
# AUTHOR:			BJ Veurink
# NAME: 			install.arch stage3
# LICENSE:		GNU GPLv2

cat appendlist | sed '/^$/d; /^#/d' | while read -r file append; do
	regex="^[ \t]*#$append$"
	sed -i -E "/$regex/!{q100}; {s/$regex/$append/}" $file || sudo bash -c "echo $append >> $file"
done
