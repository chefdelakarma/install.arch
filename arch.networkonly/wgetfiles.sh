#!/bin/bash
# AUTHOR:			BJ Veurink
# NAME: 			wgetfiles.sh
# LICENSE:		GNU GPLv2
file=${file:-getfiles}
cat $file | sed '/^$/d; /^#/d' | while read -r from to; do
	[[ -d $to ]] || sudo mkdir -pv $to
	sudo wget "$from" -P "$to"
done
