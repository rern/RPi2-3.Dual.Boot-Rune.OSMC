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
dev='/dev/sda'
lsblk

size=$( lsblk | sed -n "/^${dev: -3}/p" | awk '{print $4}' )
gb=${size//[^0-9.]/}
mb=$( python -c "print( int($gb * 1000) )" )
if (( $mb < 3400 )); then
    titleend "USB drive too small."
    exit
fi
if (( $mb < 4000 )); then
    p1=2.4
    p2=$( python -c "print($gb - $p1)" )
else
    p1=2.4
    p2=1.2
    p3=$( python -c "print($gb - $p1 - $p2)" )
fi

title "$info Delete all USB partitions and create new ones:"
echo 'Drive capacity:' $gb'GB'
echo -e 'Existing partiton: \e[0;31mdelete all\e[m'
echo 'New partiton #1:' $p1'GB'
echo 'New partiton #2:' $p2'GB'
(( $mb > 4000 )) && echo 'New partiton #3:' $p3'GB'
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

umount $dev*
title "Delete partitions ..."
dd if=/dev/zero of=$dev bs=512 count=1 conv=notrunc

title "Create new partitions ..."
if (( $mb < 4000 )); then
	echo -e ','$p1'G\n,' | sfdisk $dev
else
	echo -e ','$p1'G\n,'$p2'G\n,' | sfdisk $dev
fi

title "Format partitions ..."
partx -u $dev
yes | mkfs.ext4 $dev'1'
e2label $dev'1' root
yes | mkfs.ext4 $dev'2'
e2label $dev'2' root-rbp2
if [ $mb -gt 4000 ]; then
	yes | mkfs.ext4 $dev'3'
	e2label $dev'3' data
fi

title "USB drive partitioned and formatted successfully."
