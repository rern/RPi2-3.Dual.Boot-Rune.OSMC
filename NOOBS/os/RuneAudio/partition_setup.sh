#!/bin/bash

mntboot=/tmp/mount

mkdir -p $mntboot

mount $part1 $mntboot

sed -i "s|root=/dev/[^ ]*|root=$part2|" $mntboot/cmdline.txt

# remove force reinstall if any
sed -i "s| forcetrigger||" $mntboot/recovery.cmdline

mount $part2 $mntroot

sed -i -e "s|^.* /boot |$part1  /boot |
" -e '/^#/ d
' -e 's/\s\+0\s\+0\s*$//
' $mntroot/etc/fstab

# customize
. $mntboot/os/RuneAudio/custom.sh

umount $mntboot
umount $mntroot
