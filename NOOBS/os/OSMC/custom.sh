#!/bin/bash

### customize osmc install

# for source in: ./OSMC/partition_setup.sh, ./RuneAudio/custom/usr/local/bin/osmcreset
# fstab boot partition, omit others
# config ssh login for root
# fix ssh algorithm negotiation failed
# copt custom files
# remove forcetrigger

# no automount other partitions
mntroot=/tmp/mount
rootnum=${mmcroot/\/dev\/mmcblk0p}
fstab=$mntroot/etc/fstab
echo "/dev/mmcblk0p$(( rootnum + 1 ))  /boot  vfat  defaults,noatime
/dev/mmcblk0p1  /media/p1  vfat  noauto,noatime
/dev/mmcblk0p5  /media/p5  ext4  noauto,noatime
" >> $fstab

mmc 5
# omit current os from installed_os.json
mmcroot=$( mount | grep 'on / ' | cut -d' ' -f1 | cut -d'/' -f3 )
mmcline=$( sed -n "/$mmcroot/=" /tmp/p5/installed_os.json )
sed "$(( mmcline - 3 )), $mmcline d" /tmp/p5/installed_os.json > /tmp/installed_os.json
# filter names and boot partitions > array
partlist=$( grep 'mmcblk' /tmp/installed_os.json | sed 's/"//g; s/,//; s/\/dev\/mmcblk0p//' )
partarray=( $( echo $partlist ) )
ilength=${#partarray[*]}
for (( i=0; i < ilength; i++ )); do
	(( $(( i % 2 )) == 0 )) && parttype=vfat || parttype=ext4
	j=${partarray[i]}
	echo "/dev/mmcblk0p$j  /media/p$j  $parttype  noauto,noatime" >> $fstab
done

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
chmod 755 $mntroot/usr/local/bin/hardreset*
chown -R 1000:1000 $mntroot/home/osmc # no user 'osmc' within noobs - use uid instead
