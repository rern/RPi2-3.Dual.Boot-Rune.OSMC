#!/bin/bash

bsdtar -xvf /tmp/p1/os/$namereset/root.tar.xz -C $mntroot \

# from partition_setup.sh
echo -e "$bar Partition setup ..."
sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' $mntroot/etc/ssh/sshd_config
sed -i 's|root:.*|root:\$6\$X6cgc9tb\$wTTiWttk/tRwPrM8pLZCZpYpHE8zEar2mkSSQ7brQvflqhA5K1dgcyU8nzX/.tAImkMbRMR0ex51LjPsIk8gm0:17000:0:99999:7:::|
' $mntroot/etc/shadow