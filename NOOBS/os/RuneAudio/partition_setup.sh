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

sed -i -e $'/runeui.css/ a\
    <link rel="stylesheet" href="<?=$this->asset(\'/css/addonsinfo.css\')?>">
' -e $'/poweroff-modal/ i\
            <li style="cursor: pointer;"><a id="addons"><i class="fa fa-cubes"></i> Addons</a></li>
' $mnt/srv/http/app/templates/header.php

<script src="<?=$this->asset('"'"'/js/addonsinfo.js'"'"')?>"></script>
<script src="<?=$this->asset('"'"'/js/addonsmenu.js'"'"')?>"></script>
' >> $mnt/srv/http/app/templates/footer.php

echo 'http ALL=NOPASSWD: ALL' > /etc/sudoers.d/http

cp -r /mnt/os/RuneAudio/custom/. $mnt # customize files
chmod 755 /tmp/mount/usr/local/bin/*reset

umount $mnt
