#!/bin/bash

rm $0
systemctl disable noautomount
rm /etc/systemd/system/noautomount.service

### no automount other partitions
rootnum=$( mount | grep 'on / ' | cut -d' ' -f1 | cut -d'p' -f2  )
bootnum=$(( rootnum - 1 ))

fstab=/etc/fstab

part1=/dev/mmcblk0p$bootnum
part2=/dev/mmcblk0p$rootnum
echo "$part1  /boot      vfat  defaults,noatime,noauto,x-systemd.automount    0   0
/dev/mmcblk0p1  /media/p1  vfat  noauto,noatime
/dev/mmcblk0p5  /media/p5  ext4  noauto,noatime
" >> $fstab
umount /dev/mmcblk0p1 2> /dev/null
umount /dev/mmcblk0p5 2> /dev/null

# omit current os from installed_os.json
partlist=$( fdisk -l /dev/mmcblk0 | grep mmcblk0p | awk -F' ' '{print $1}' | sed "/p1$\|p2$\|p5$\|$part1\|$part2/ d; sed s/\/dev\/mmcblk0p//" )
partarray=( $( echo $partlist ) )
ilength=${#partarray[*]}
mountlist=''
for (( i=0; i < ilength; i++ )); do
  (( $(( i % 2 )) == 0 )) && parttype=vfat || parttype=ext4
  p=${partarray[i]}
  mountlist+="/dev/mmcblk0p$p  /media/p$p  $parttype  noauto,noatime\n"
  umount /dev/mmcblk0p$p 2> /dev/null
done

echo "mountlist" >> $fstab

mount -a
