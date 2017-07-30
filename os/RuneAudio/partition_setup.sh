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
' -e 's/\s\+0\s\+0\s\+$//
' $file
# format column
mv $file{,.original}
sed '1 i\#device mount type options dump pass' $file'.original' | column -t > $file
w=$( wc -L < $file )                 # widest line
hr=$( printf "%${w}s\n" | tr ' ' - ) # horizontal line
sed -i '1 a\#'$hr $file

cp -r /mnt/os/RuneAudio/custom/. /tmp/mount # customize files

umount /tmp/mount
