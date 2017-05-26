#!/bin/bash

mkdir -p /tmp/mount

mount $part1 /tmp/mount
sed -i "s|root=/dev/[^ ]*|root=$part2|" /tmp/mount/cmdline.txt
echo "
hdmi_group=1
hdmi_mode=32
" >> /tmp/mount/config.txt
umount /tmp/mount

mount $part2 /tmp/mount
sed -i "s|^.* /boot |$part1  /boot |" /tmp/mount/etc/fstab
cp -r /mnt/os/RuneAudio/custom/. /tmp/mount # customize files

umount /tmp/mount
