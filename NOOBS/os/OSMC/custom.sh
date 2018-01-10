#!/bin/bash

### customize osmc install

# for source in: ./OSMC/partition_setup.sh, ./RuneAudio/custom/usr/local/bin/osmcreset
# fstab boot partition, omit others
# config ssh login for root
# fix ssh algorithm negotiation failed
# copt custom files
# remove forcetrigger

### no automount other partitions
mntsetting=/tmp/setting
mkdir -p $mntsetting
mount /dev/mmcblk0p5 $mntsetting
devboot=$( sed -n '/OSMC/,/mmcblk/ p' $mntsetting/installed_os.json | grep 'mmcblk' | sed 's/"//g; s/,//' )
devbootline=$( sed -n "/$devboot/=" $mntsetting/installed_os.json )
sed "$(( devbootline - 2 )), $(( devbootline + 1 )) d" $mntsetting/installed_os.json > /tmp/installed_os.json

fstab=$mntroot/etc/fstab
[[ ! grep $devboot $fstab ]] && echo "$devboot  /boot      vfat  defaults,noatime,noauto,x-systemd.automount    0   0" >> $fstab

# omit current os from installed_os.json
echo "
/dev/mmcblk0p1  /media/p1  vfat  noauto,noatime
/dev/mmcblk0p5  /media/p5  ext4  noauto,noatime
" >> $fstab

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

cp -r $mntrecovery/os/OSMC/custom/. $mntroot # copy recursive include hidden ('.' not '*')
chmod 644 $mntroot/etc/udev/rules.d/usbsound.rules
chmod 755 $mntroot/home/osmc/*.py
chmod 755 $mntroot/usr/local/bin/hardreset*
chown -R 1000:1000 $mntroot/home/osmc # no user 'osmc' within noobs - use uid instead
