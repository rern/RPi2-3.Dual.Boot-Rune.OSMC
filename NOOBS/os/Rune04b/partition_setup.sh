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
' -e 's/\s\+0\s\+0\s*$//
' $mnt/etc/fstab

# addons menu
sed -i -e '/runeui.css/ a\
    <link rel="stylesheet" href="<?=$this->asset('"'"'/css/addonsinfo.css'"'"')?>">
' -e '/poweroff-modal/ i\
            <li style="cursor: pointer;"><a id="addons"><i class="fa fa-cubes"></i> Addons</a></li>
' $mnt/srv/http/app/templates/header.php

sed -i '$ a\
<script src="<?=$this->asset('"'"'/js/addonsinfo.js'"'"')?>"></script>\
<script src="<?=$this->asset('"'"'/js/addonsmenu.js'"'"')?>"></script>
' $mnt/srv/http/app/templates/footer.php

echo 'http ALL=NOPASSWD: ALL' > $mnt/etc/sudoers.d/http
chmod 4755 $mnt/usr/bin/sudo

cp -r /mnt/os/RuneAudio/custom/. $mnt # customize files
chmod 755 $mnt/usr/local/bin/*reset $mnt/srv/http/addons*
chown 33:33 $mnt/srv/http/addons* $mnt/srv/http/assets/js/addons*

umount $mnt
