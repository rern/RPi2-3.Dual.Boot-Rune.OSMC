#!/bin/bash

# Let OSIRIS see what we are doing
set -x

# Are we Pi1 or Pi2
grep -q ARMv7 /proc/cpuinfo
if [ $? -eq 0 ]
then
    dev="rbp2"
else
   dev="rbp1"
fi
# Temporary mounting directory
mkdir -p /tmp/mount
# To UUID or not to UUID
vfat_part=$part1
ext4_part=$part2
if [ -n $id1 ]; then vfat_part=$id1; fi
if [ -n $id2 ]; then ext4_part=$id2; fi
# Fix the cmdline.txt
mount $part1 /tmp/mount
echo "root=$ext4_part osmcdev=$dev rootfstype=ext4 rootwait quiet" > /tmp/mount/cmdline.txt
umount /tmp/mount
# Wait
sync
# Fix the fstab
mount $part2 /tmp/mount

fstabcontent="
#device         mount            type  options
$vfat_part      /boot            vfat  defaults,noatime
/dev/mmcblk0p1  /media/RECOVERY  vfat  noauto,noatime
/dev/mmcblk0p5  /media/SETTINGS  ext4  noauto,noatime
/dev/mmcblk0p8  /media/boot      vfat  noauto,noatime
/dev/mmcblk0p9  /media/root      ext4  noauto,noatime
"
file=/tmp/mount/etc/fstab
echo "$fstabcontent" | column -t > $file
w=$( wc -L < $file )                 # widest line
hr=$( printf "%${w}s\n" | tr ' ' - ) # horizontal line
sed -i '1 a\#'$hr $file

# customize files
sed -i "s/root:.*/root:\$6\$X6cgc9tb\$wTTiWttk\/tRwPrM8pLZCZpYpHE8zEar2mkSSQ7brQvflqhA5K1dgcyU8nzX\/.tAImkMbRMR0ex51LjPsIk8gm0:17000:0:99999:7:::/" /tmp/mount/etc/shadow
sed -i "s/PermitRootLogin without-password/PermitRootLogin yes/" /tmp/mount/etc/ssh/sshd_config

cp -r /mnt/os/OSMC/custom/. /tmp/mount # copy recursive include hidden ('.' not '*')
chmod 644 /tmp/mount/etc/udev/rules.d/usbsound.rules
chmod 755 /tmp/mount/home/osmc/*.py
chown -R 1000:1000 /tmp/mount/home/osmc # 'osmc' dir copied as root before os create - chown needed

umount /tmp/mount
# Wait
sync
