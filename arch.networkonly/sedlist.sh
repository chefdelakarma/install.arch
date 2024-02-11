#!/bin/bash
# AUTHOR:			BJ Veurink
# NAME: 			install.arch stage3
# LICENSE:		GNU GPLv2

cat sedlist | sed '/^$/d; /^#/d' | while read -r file var value; do
	regex="^[ \t]*#?[ \t]*$var=.*$"
	sub=$var=$value
	sudo sed -i -E "/$regex/!{q100}; {s/$regex/$sub/}" $file || sudo bash -c "echo $sub >> $file"
done
