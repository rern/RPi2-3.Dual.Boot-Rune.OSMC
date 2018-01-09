#!/bin/bash

bsdtar -xvf /tmp/p1/os/$namereset/root.tar.xz -C $mntroot \

# from partition_setup.sh
echo -e "$bar Partition setup ..."
sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' $mntroot/etc/ssh/sshd_config
file=/etc/shadow
sed -i '/^root.*/ d' $file
sed -i '1 i\
root:$6$e42lyTYv$RdGZNDfvFh0li8Vx.xEefjB1GSmnRRCqvzUPmCtRqLyp.8W5hlHddDrXw085J8SeLpZSXeYMCJeR2wHUULQtm0:17539::::::
' $file
