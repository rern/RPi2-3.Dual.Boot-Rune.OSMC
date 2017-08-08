#!/bin/bash

# for use in: ./OSMC/partition_setup.sh, ./RuneAudio/custom/usr/local/bin/osmcreset

mntroot=/tmp/mount
if ! grep '/boot' $mntroot/etc/fstab &> /dev/null; then
	vfat_part=$( blkid /dev/mmcblk0p6 | awk '{ print $2 }' )
	vfat_part=${vfat_part//\"/}
	boot="$vfat_part  /boot    vfat     defaults,noatime,noauto,x-systemd.automount    0   0"
fi
echo "$boot
/dev/mmcblk0p1  /media/p1  vfat  noauto,noatime
/dev/mmcblk0p5  /media/p5  ext4  noauto,noatime
/dev/mmcblk0p8  /media/p8  vfat  noauto,noatime
/dev/mmcblk0p9  /media/p9  ext4  noauto,noatime
" >> $mntroot/etc/fstab

# customize files
sed -i 's|root:.*|root:\$6\$X6cgc9tb\$wTTiWttk/tRwPrM8pLZCZpYpHE8zEar2mkSSQ7brQvflqhA5K1dgcyU8nzX/.tAImkMbRMR0ex51LjPsIk8gm0:17000:0:99999:7:::|
' $mntroot/etc/shadow
sed -i -e 's/PermitRootLogin .*/PermitRootLogin yes/
' -e '/^KexAlgorithms/ s/^/#/
' -e '/^Ciphers/ s/^/#/
' -e '/^MACs/ s/^/#/
' $mntroot/etc/ssh/sshd_config

[[ -e /mnt/os ]] && mntrecovery=/mnt || mntrecovery=/tmp/p1
cp -r $mntrecovery/os/OSMC/custom/. $mntroot # copy recursive include hidden ('.' not '*')
chmod 644 $mntroot/etc/udev/rules.d/usbsound.rules
chmod 755 $mntroot/home/osmc/*.py
chmod 755 $mntroot/usr/local/bin/*reset
chown -R 1000:1000 $mntroot/home/osmc # 'osmc' dir copied as root before os create - chown needed

# remove force reinstall if any
sed -i "s| forcetrigger||" $mntrecovery/recovery.cmdline
