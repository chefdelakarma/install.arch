#!/bin/bash
#re-install grub

root=${1:-"/dev/nvme0n1p4"}
mnt=${mnt:-"/mnt"}
[[ -d ${mnt} ]] || mkdir -pv ${mnt}

mount ${root} ${mnt}
for i in /dev /dev/pts /proc /sys /run
do mount --bind $i ${mnt}$i
done

mount -t efivarfs efivarfs ${mnt}/sys/firmware/efi/efivars

chroot ${mnt} /bin/bash << 'EOF'
	mount -av
	sleep 5
	grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
	grub-mkconfig -o /boot/grub/grub.cfg
EOF

umount -R ${mnt}

