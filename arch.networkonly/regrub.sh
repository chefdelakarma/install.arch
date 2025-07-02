#!/bin/bash

root=${1:-"/dev/nvme0n1p4"}
mnt={2:-"/mnt"}

mount ${root} ${mnt}
for i in /dev /dev/pts /proc /sys /run
do mount --bind $i ${mnt}$i
done

chroot ${mnt} bash -x << 'EOF'
	mount -a
	mount -t efivarfs efivarfs /sys/firmware/efi/efivars
	grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
	grub-mkconfig -o /boot/grub/grub.cfg
EOF
