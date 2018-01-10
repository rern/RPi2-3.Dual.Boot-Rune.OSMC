#!/bin/bash

mntroot=/tmp/mount

# root password
sed -i 's|root:.*|root:\$6\$X6cgc9tb\$wTTiWttk/tRwPrM8pLZCZpYpHE8zEar2mkSSQ7brQvflqhA5K1dgcyU8nzX/.tAImkMbRMR0ex51LjPsIk8gm0:17000:0:99999:7:::|
' $mntroot/etc/shadow

# permit root ssh
sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' $mntroot/etc/ssh/sshd_config

# custom files
[[ -e /mnt/os ]] && mntrecovery=/mnt || mntrecovery=/tmp/p1
cp -r $mntrecovery/os/OSMC/custom/. $mntroot # copy recursive include hidden ('.' not '*')
chmod 755 $mntroot/usr/local/bin/hardreset

wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/cmd.sh -P $mntroot/etc/profile.d
