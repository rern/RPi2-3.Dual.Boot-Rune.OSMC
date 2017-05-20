#!/bin/bash

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
# We really don't want automated fscking
tune2fs -c 0 $part2
# Temporary mounting directory
mkdir -p /tmp/mount
# Fix the cmdline.txt
mount $part1 /tmp/mount
echo "root=$part2 osmcdev=$dev rootfstype=ext4 rootwait quiet" > /tmp/mount/cmdline.txt
echo "
hdmi_group=1
hdmi_mode=32
max_usb_current=1  
" >> /tmp/mount/config.txt
umount /tmp/mount
# Wait
sync
# Fix the fstab
mount $part2 /tmp/mount
echo "$part1          /boot              vfat     defaults,noatime  0   0
$part2          /                  ext4     defaults,noatime  0   0
/dev/mmcblk0p1  /media/RECOVERY    vfat     noauto,noatime    0   0
/dev/mmcblk0p5  /media/SETTINGS    ext4     noauto,noatime    0   0
/dev/mmcblk0p8  /media/boot        vfat     noauto,noatime    0   0
/dev/mmcblk0p9  /media/root        ext4     noauto,noatime    0   0
" > /tmp/mount/etc/fstab

# customize files
sed -i "s/root:.*/root:\$6\$X6cgc9tb\$wTTiWttk\/tRwPrM8pLZCZpYpHE8zEar2mkSSQ7brQvflqhA5K1dgcyU8nzX\/.tAImkMbRMR0ex51LjPsIk8gm0:17000:0:99999:7:::/" /tmp/mount/etc/shadow
sed -i "s/PermitRootLogin without-password/PermitRootLogin yes/" /tmp/mount/etc/ssh/sshd_config

# modify shutdown menu
line=$( sed -n '/Quit()/{=}' $file )
line=$(( $line - 2 ))
sed -i -e 's|<label>13012</label>|<label>Restart Kodi</label>|
' -e 's|<label>13013</label>|<label>Reboot to NOOBS</label>|
' -e ''"$line"' i\
\t\t\t\t\t<item>\
\t\t\t\t\t\t<label>Reboot to RuneAudio</label>\
\t\t\t\t\t\t<onclick>RunScript(/home/osmc/rebootrune.py)</onclick>\
\t\t\t\t\t\t<visible>System.CanReboot</visible>\
\t\t\t\t\t</item>\
\t\t\t\t\t<item>\
\t\t\t\t\t\t<label>Reboot to OSMC</label>\
\t\t\t\t\t\t<onclick>RunScript(/home/osmc/rebootosmc.py)</onclick>\
\t\t\t\t\t\t<visible>System.CanReboot</visible>\
\t\t\t\t\t</item>\
\t\t\t\t\t<item>\
\t\t\t\t\t\t<label>Skin Reload</label>\
\t\t\t\t\t\t<onclick>ReloadSkin()</onclick>\
\t\t\t\t\t\t<visible>System.CanReboot</visible>\
\t\t\t\t\t</item>
' /tmp/mount/usr/share/kodi/addons/skin.osmc/16x9/DialogButtonMenu.xml

cp -r /mnt/os/OSMC/custom/. /tmp/mount # copy recursive include hidden ('.' not '*')
chmod 644 /etc/udev/rules.d/usbsound.rules
chmod 755 /tmp/mount/home/osmc/*.py
chown -R 1000:1000 /tmp/mount/home/osmc # 'osmc' dir copied as root before os create - chown needed

umount /tmp/mount
# Wait
sync

