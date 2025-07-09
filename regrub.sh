#!/bin/bash

root=${1:-"/dev/nvme0n1p4"}
mnt=${mnt:-"/mnt"}

mount ${root} ${mnt}
for i in /dev /dev/pts /proc /sys /run
do mount --bind $i ${mnt}$i
done

mount -v -t efivarfs efivarfs ${mnt}/sys/firmware/efi/efivars

chroot ${mnt} /bin/bash << 'EOF'
	mount -av
	sleep 30
	grub-install -v --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
	grub-mkconfig -v -o /boot/grub/grub.cfg
EOF

umount -v {mnt}/sys/firmware/efi/efivars

for i in /dev/pts /dev /proc /sys /run
do umount -v ${mnt}$i
done

