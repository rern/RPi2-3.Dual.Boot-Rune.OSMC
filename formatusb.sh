#!/bin/bash

# formatusb.sh
#
# verify drive capacity >3.4GB
# delete all partitions
# 4GB: create partitions 2.4GB + the rest
# >4GB: create partitions 2.4GB + 1.2GB + the rest
# format

line2='\e[0;36m=========================================================\e[m'
line='\e[0;36m---------------------------------------------------------\e[m'
bar=$( echo -e "$(tput setab 6)   $(tput setab 0)" )
info=$( echo $(tput setab 6; tput setaf 0) i $(tput setab 0; tput setaf 7) )

# functions #######################################

title2() {
        echo -e "\n$line2\n"
        echo -e "$bar $1"
        echo -e "\n$line2\n"
}
title() {
        echo -e "\n$line"
        echo $1
        echo -e "$line\n"
}
titleend() {
        echo -e "\n$1"
        echo -e "\n$line\n"
}

title "$info Storage list"
lsblk

size=$(lsblk | sed -n '/^sda/p' | awk '{print $4}')
title "$info USB drive size: $size"

gb=${size//[^0-9.]/}
mb=$(awk "BEGIN {print $gb * 1000}")
if [ $mb -lt 3400 ]; then
    titleend "USB drive too small."
    exit
fi
if [ $mb -lt 4000 ]; then
    p1=2.4
    p2=$(awk "BEGIN {print ($mb - 2400) / 1000}")
else
    p1=2.4
    p2=1.2
    p3=$(awk "BEGIN {print $size - 3.6}")
fi

title "$info Delete all USB partitions and create new ones:"
echo 'Drive capacity:' $size
echo 'Existing partiton: \e[0;31mdelete all\e[m'
echo 'New partiton #1:' $p1'GB'
echo 'New partiton #2:' $p2'GB'
[ $mb -gt 4000 ] && echo 'New partiton #3:' $p3'GB'
echo -e '  \e[0;36m0\e[m No'
echo -e '  \e[0;36m1\e[m Yes'
echo
echo -e '\e[0;36m0\e[m / 1 ? '
read -n 1 answer
case $answer in
	1 ) echo;;
	* ) echo
		titleend "USB drive partitioning cancelled."
		exit;;
esac

umount /dev/sda*
title "Delete partitions ..."
dd if=/dev/zero of=/dev/sda bs=512 count=1 conv=notrunc

title "Create new partitions ..."
if [ $mb -lt 4000 ]; then
	echo -e ','$p1'G\n,;' | sfdisk /dev/sda
else
	echo -e ','$p1'G\n,'$p2'G\n,;' | sfdisk /dev/sda
fi

title "Format partitions ..."
partx -u /dev/sda
mkfs.ext4 /dev/sda1
e2label /dev/sda1 root
mkfs.ext4 /dev/sda2
e2label /dev/sda2 root-rbp2
if [ $mb -gt 4000 ]; then
	mkfs.ext4 /dev/sda3
	e2label /dev/sda3 data
fi

title "USB drive partitioned and formatted successfully."
