#!/bin/bash

mkdir -p /tmp/mount

mount $part1 /tmp/mount
sed -i "s|root=/dev/[^ ]*|root=$part2|" /tmp/mount/cmdline.txt
# remove force reinstall if any
sed -i "s| forcetrigger||" /tmp/mount/recovery.cmdline
umount /tmp/mount

mount $part2 /tmp/mount
file=/tmp/mount/etc/fstab
sed -i -e "s|^.* /boot |$part1  /boot |
" -e '/^#/ d
' $file
# format column
mv $file{,.original}
column -t $file'.original' > $file
cp -r /mnt/os/RuneAudio/custom/. /tmp/mount # customize files

umount /tmp/mount
