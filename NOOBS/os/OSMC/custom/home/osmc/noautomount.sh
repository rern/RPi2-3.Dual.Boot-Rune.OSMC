#!/bin/bash

rm $0

### no automount other partitions
mkdir /tmp/SETTINGS
mount /dev/mmcblk0p5 /tmp/SETTINGS

fstab=/etc/fstab
echo "
/dev/mmcblk0p1  /media/p1  vfat  noauto,noatime
/dev/mmcblk0p5  /media/p5  ext4  noauto,noatime
" >> $fstab
	
part1=/dev/mmcblk0p$bootnum
part2=/dev/mmcblk0p$rootnum
echo "$part1  /boot      vfat  defaults,noatime,noauto,x-systemd.automount    0   0" > $fstab

# omit current os from installed_os.json
partlist=$( fdisk -l /dev/mmcblk0 | grep mmcblk0p | awk -F' ' '{print $1}' | sed "/p1$\|p2$\|p5$\|$part1\|$part2/ d; sed s/\/dev\/mmcblk0p//" )
partarray=( $( echo $partlist ) )
ilength=${#partarray[*]}
for (( i=0; i < ilength; i++ )); do
  (( $(( i % 2 )) == 0 )) && parttype=vfat || parttype=ext4
  p=${partarray[i]}
  echo "/dev/mmcblk0p$p  /media/p$p  $parttype  noauto,noatime" >> $fstab
done
