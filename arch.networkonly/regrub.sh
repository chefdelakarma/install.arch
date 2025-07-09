#!/bin/bash

root=${1:-"/dev/nvme0n1p4"}
mnt=${mnt:-"/mnt"}

mount ${root} ${mnt}
for i in /dev /dev/pts /proc /sys /run
do mount --bind $i ${mnt}$i
done

chroot ${mnt} /bin/bash << 'EOF'
	mount -av
	sleep 30
	mount -v -t efivarfs efivarfs /sys/firmware/efi/efivars
	sleep 30
	grub-install -v --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
	grub-mkconfig -o /boot/grub/grub.cfg
	umount -v /sys/firmware/efi/efivars
EOF

for i in /dev/pts /dev /proc /sys /run
do umount -v ${mnt}$i
done

