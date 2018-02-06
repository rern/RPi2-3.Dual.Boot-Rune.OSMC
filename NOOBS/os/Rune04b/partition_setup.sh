#!/bin/ash

mkdir /tmp/1
mount $part1 /tmp/1
sed -i "s|root=/dev/[^ ]*|root=$part2|" /tmp/1/cmdline.txt

mntroot=/tmp/2
mkdir -p $mntroot
mount $part2 $mntroot

sed -i -e "s|^.* /boot |$part1  /boot |
" -e '/^#/ d
' -e 's/\s\+0\s\+0\s*$//
' $mntroot/etc/fstab

# customize
mntrecovery=/mnt
. $mntrecovery/os/Rune04b/custom.sh

# remove force reinstall if any
sed -i "s| forcetrigger||" $mntrecovery/recovery.cmdline

umount /tmp/1
umount /tmp/2
