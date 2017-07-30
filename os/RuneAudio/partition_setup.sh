#!/bin/bash

mnt=/tmp/mount

mkdir -p $mnt

mount $part1 $mnt

sed -i "s|root=/dev/[^ ]*|root=$part2|" $mnt/cmdline.txt

# remove force reinstall if any
sed -i "s| forcetrigger||" $mnt/recovery.cmdline
umount $mnt

mount $part2 $mnt

sed -i -e "s|^.* /boot |$part1  /boot |
" -e '/^#/ d
' -e 's/\s\+0\s\+0\s\+$//
' $mnt/etc/fstab

cp -r /mnt/os/RuneAudio/custom/. $mnt # customize files

umount $mnt
