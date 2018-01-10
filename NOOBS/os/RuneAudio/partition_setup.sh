#!/bin/bash

mntroot=/tmp/root
mkdir -p $mntroot
mount $part2 $mntroot

sed -i "s|root=/dev/[^ ]*|root=$part2|" $mntrecovery/cmdline.txt

# remove force reinstall if any
sed -i "s| forcetrigger||" $mntrecovery/recovery.cmdline

sed -i -e "s|^.* /boot |$part1  /boot |
" -e '/^#/ d
' -e 's/\s\+0\s\+0\s*$//
' $mntroot/etc/fstab

# customize
mntrecovery=/mnt
. $mntrecovery/os/RuneAudio/custom.sh

umount $mntroot
