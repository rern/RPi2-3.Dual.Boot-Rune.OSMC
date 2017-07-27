#!/bin/bash

mkdir -p /tmp/mount

mount $part1 /tmp/mount
sed -i "s|root=/dev/[^ ]*|root=$part2|" /tmp/mount/cmdline.txt
# remove force reinstall if any
sed -i "s| forcetrigger||" /tmp/mount/recovery.cmdline
umount /tmp/mount

mount $part2 /tmp/mount
echo"# filesystem	dir	             type   options                                 dump pass
#----------------------------------------------------------------------------------------
$part1  /boot               vfat   defaults                                0    0
logs         /var/log            tmpfs  nodev,nosuid,noatime,mode=1777,size=5M  0    0
rune-logs    /var/log/runeaudio  tmpfs  nodev,nosuid,noatime,mode=1777,size=5M  0    0
" > /tmp/mount/etc/fstab
cp -r /mnt/os/RuneAudio/custom/. /tmp/mount # customize files

umount /tmp/mount
