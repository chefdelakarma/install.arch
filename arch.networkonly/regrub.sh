#!/bin/bash
#re-install grub

root=${1:-"/dev/nvme0n1p4"}
mnt=${mnt:-"/mnt"}
[[ -d ${mnt} ]] || mkdir -pv ${mnt}

mount ${root} ${mnt}
for i in /dev /dev/pts /proc /sys /run
do mount -v --bind $i ${mnt}$i
done

mount -v -t efivarfs efivarfs ${mnt}/sys/firmware/efi/efivars

chroot ${mnt} /bin/bash << 'EOF'
	mount -av
	sleep 5
	grub-install -v --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
	grub-mkconfig -v -o /boot/grub/grub.cfg
EOF

for i in /sys/firmware/efi/efivars /dev/pts /dev /proc /sys /run
do umount -v ${mnt}$i
done
for i in $(awk '!/^#/ && NF {print $2}' ${mnt}/etc/fstab | sort -r); do
	if [[ $i != "none" ]]; then
		umount -v ${mnt}$i
	fi
done

