#!/bin/bash

mkdir -p /tmp/mount

mount $part1 /tmp/mount
sed -i "s|root=/dev/[^ ]*|root=$part2|" /tmp/mount/cmdline.txt
echo "
hdmi_group=1
hdmi_mode=32
max_usb_current=1  
" >> /tmp/mount/config.txt
umount /tmp/mount

mount $part2 /tmp/mount
sed -i "s|^.* /boot |$part1  /boot |" /tmp/mount/etc/fstab
cp -r /mnt/os/RuneAudio/custom/. /tmp/mount # customize files

sed -i -e 's/Reboot/Reboot to NOOBS/
' -e $'/id="reboot"/ i\
\t\t\t\t<button id="bootosmc" class="btn btn-primary btn-lg btn-block" data-dismiss="modal"><i class="fa fa-refresh"></i> Reboot to OSMC</button>\
\t\t\t\t<button id="bootrune" class="btn btn-primary btn-lg btn-block" data-dismiss="modal"><i class="fa fa-refresh"></i> Reboot to RuneAudio</button>
' /tmp/mount/srv/http/app/templates/footer.php

umount /tmp/mount
