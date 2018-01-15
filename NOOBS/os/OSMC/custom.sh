#!/bin/bash

### customize osmc install

# for source in: ./OSMC/partition_setup.sh, ./RuneAudio/custom/usr/local/bin/osmcreset
# fstab boot partition, omit others
# config ssh login for root
# fix ssh algorithm negotiation failed
# copt custom files
# remove forcetrigger

echo -e "$bar Disable SD card automount ..."
#################################################################################
if [[ -n $part2 ]]; then
	rootnum=${part2/\/dev\/mmcblk0p}
else
	rootnum=$( mount | grep 'on / ' | cut -d' ' -f1 | cut -d'p' -f2  )
fi
bootnum=$(( rootnum - 1 ))

mountlist+="/dev/mmcblk0p$bootnum  /boot      vfat  defaults,noatime,noauto,x-systemd.automount    0   0
/dev/mmcblk0p1  /media/p1  vfat  noauto,noatime
/dev/mmcblk0p5  /media/p5  ext4  noauto,noatime
"
umount /dev/mmcblk0p$bootnum 2> /dev/null
umount -l /dev/mmcblk0p1 2> /dev/null
umount -l /dev/mmcblk0p5 2> /dev/null

partlist=$( 
	fdisk -l /dev/mmcblk0 | 
	grep mmcblk0p | 
	awk -F' ' '{print $1}' | 
	sed "/p1$\|p2$\|p5$\|p$bootnum$\|p$rootnum$/ d" | 
	sed 's/\/dev\/mmcblk0p//' 
)
partarray=( $( echo $partlist ) )
ilength=${#partarray[*]}
for (( i=0; i < ilength; i++ )); do
  (( $(( i % 2 )) == 0 )) && parttype=vfat || parttype=ext4
  p=${partarray[i]}
  mountlist+="/dev/mmcblk0p$p  /media/p$p  $parttype  noauto,noatime\n"
  umount -l /dev/mmcblk0p$p 2> /dev/null
done

echo -e "$mountlist" > $mntroot/etc/fstab

# customize files
sed -i 's|root:.*|root:\$6\$X6cgc9tb\$wTTiWttk/tRwPrM8pLZCZpYpHE8zEar2mkSSQ7brQvflqhA5K1dgcyU8nzX/.tAImkMbRMR0ex51LjPsIk8gm0:17000:0:99999:7:::|
' $mntroot/etc/shadow
sed -i -e 's/PermitRootLogin .*/PermitRootLogin yes/
' -e '/^KexAlgorithms/ s/^/#/
' -e '/^Ciphers/ s/^/#/
' -e '/^MACs/ s/^/#/
' $mntroot/etc/ssh/sshd_config

cp -r $mntrecovery/os/OSMC/custom/. $mntroot # copy recursive include hidden ('.' not '*')
#chmod 644 $mntroot/etc/udev/rules.d/999-usbsound.rules
chmod 755 $mntroot/home/osmc/{*.py,*.sh}
chmod 755 $mntroot/usr/local/bin/hardreset
chown -R 1000:1000 $mntroot/home/osmc # no user 'osmc' within noobs - use uid instead
