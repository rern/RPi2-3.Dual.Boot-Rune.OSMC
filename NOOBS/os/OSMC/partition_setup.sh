#!/bin/ash

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

# Fix the cmdline.txt
mount $part1 /tmp/mount
echo "root=$part2 osmcdev=$dev rootfstype=ext4 rootwait quiet" > /tmp/mount/cmdline.txt

umount /tmp/mount
# Wait
sync

# customize #####################
bootnum=$( echo $part1 | cut -d'p' -f2 ) # no parameter expansion in busybox - ${part1/\/dev\/mmcblk0p/}
rootnum=$( echo $part2 | cut -d'p' -f2 )
mntroot=/tmp/mount
mount $part2 $mntroot

mntrecovery=/mnt
. $mntrecovery/os/OSMC/custom.sh

umount /tmp/mount
#################################

# Wait
sync
