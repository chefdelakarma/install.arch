#!/bin/bash
# AUTHOR:			BJ Veurink
# NAME: 			wgetfiles.sh
# LICENSE:		GNU GPLv2
file=${file:-getfiles}
cat $file | sed '/^$/d; /^#/d' | while read -r from to; do
	wget $from
	filename=$(basename $from)
	[[ -d $to ]] || sudo mkdir -pv $to
	sudo cp $filename $to
done
