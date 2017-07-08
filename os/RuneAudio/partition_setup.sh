#!/bin/bash

mkdir -p /tmp/mount

mount $part1 /tmp/mount
sed -i "s|root=/dev/[^ ]*|root=$part2|" /tmp/mount/cmdline.txt
# remove force reinstall if any
sed -i "s| forcetrigger||" /tmp/mount/recovery.cmdline
umount /tmp/mount

mount $part2 /tmp/mount
sed -i "s|^.* /boot |$part1  /boot |" /tmp/mount/etc/fstab
cp -r /mnt/os/RuneAudio/custom/. /tmp/mount # customize files

umount /tmp/mount
