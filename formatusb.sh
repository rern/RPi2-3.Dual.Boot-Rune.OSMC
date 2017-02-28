#!/bin/bash

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
    p1=$(awk "BEGIN {print $gb / 2}")
    p2=$p1
fi

title "$info Delete all USB partitions and create new ones:"
echo 'Drive capacity:' $size
echo 'Existing partiton: delete all'
echo 'New partiton #1:' $p1'GB'
echo 'New partiton #2:' $p2'GB'
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
sfdisk --delete /dev/sda

title "Create new partitions ..."
#echo -e "o\nn\n\n\n\n\+$p1G\nn\n\n\n\n\nw" | fdisk /dev/sda > /dev/null 2>&1
sfdisk /dev/sda << EOF
, $p1'G'
;
EOF

title "Format partitions to ext4 ..."
partx -u /dev/sda
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda2

title "USB drive partitioned and formatted successfully."
