#!/bin/bash

if [[ -z $part1 ]]; then
	sed -i -e "s|^.* /boot |/dev/mmcblk0p$bootnum  /boot |
	" -e '/^#/ d
	' -e 's/\s\+0\s\+0\s*$//
	' $mntroot/etc/fstab
fi

# addons menu
sed -i -e '/runeui.css/ a\
    <link rel="stylesheet" href="<?=$this->asset('"'"'/css/addonsinfo.css'"'"')?>">
' -e '/poweroff-modal/ i\
            <li style="cursor: pointer;"><a id="addons"><i class="fa fa-cubes"></i> Addons</a></li>
' $mntroot/srv/http/app/templates/header.php

sed -i '$ a\
<script src="<?=$this->asset('"'"'/js/addonsinfo.js'"'"')?>"></script>\
<script src="<?=$this->asset('"'"'/js/addonsmenu.js'"'"')?>"></script>
' $mntroot/srv/http/app/templates/footer.php

echo 'http ALL=NOPASSWD: ALL' > $mntroot/etc/sudoers.d/http
chmod 4755 $mntroot/usr/bin/sudo

cp -r $mntrecovery/os/RuneAudio/custom/. $mntroot # customize files
chmod 755 $mntroot/usr/local/bin/hardreset $mntroot/srv/http/addons*
chown 33:33 $mntroot/srv/http/addons* $mntroot/srv/http/assets/js/addons*
