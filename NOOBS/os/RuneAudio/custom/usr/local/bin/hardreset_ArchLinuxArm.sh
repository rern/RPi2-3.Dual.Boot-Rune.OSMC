#!/bin/bash

### reset rune root partition to virgin state

# format partition
# extract root partition
# customize install

li=$( printf "\e[36m%*s\e[0m\n" "${COLUMNS:-$(tput cols)}" '' | tr ' ' "=" )
bar='\e[36m\e[46m . \e[0m'

mmc() {
	[[ $2 ]] && mntdir=/tmp/$2 || mntdir=/tmp/p$1
	if [[ ! $( mount | grep $mntdir ) ]]; then
		mkdir -p $mntdir
		mount /dev/mmcblk0p$1 $mntdir
	fi
}
yesno() { # $1: header string; $2 : optional return variable (default - answer)
	echo
	echo -e "\e[30m\e[43m ? \e[0m $1"
	echo -e '  \e[36m0\e[m No'
	echo -e '  \e[36m1\e[m Yes'
	echo
	echo -e '\e[36m0\e[m / 1 ? '
	read -n 1 answer
	echo
	[[ $2 ]] && eval $2=$answer
}


yesno "Reset OSMC:"
[[ $answer != 1 ]] && exit

yesno "Reboot to OSMC after reset:" ansre

time0=$( date +%s )

echo $li
echo -e "$bar OSMC reset"
echo $li
umount -l /dev/mmcblk0p7 &> /dev/null
# format with label to match cmdline.txt
echo -e "$bar Format partition ..."
mmc 1
mmc 6
label=$( cat /tmp/p6/cmdline.txt | awk '{print $1}' | sed 's/root=LABEL=//' )
echo y | mkfs.ext4 -L $label /dev/mmcblk0p7 &> /dev/null
# extract image files
echo -e "$bar Extract files ..."
mmc 7 mount
bsdtar -xvf /tmp/p1/os/OSMC/root-rbp2.tar.xz -C /tmp/mount \
  --exclude=./var/cache/apt \
  --exclude=./usr/include \
  --exclude=./usr/lib/{python2.7/test,python3*,libgo.*} \
  --exclude=./usr/share/{doc,gtk-doc,info,locale,man}

# from partition_setup.sh
echo -e "$bar Partition setup ..."
. /tmp/p1/os/OSMC/custom/usr/local/bin/custom.sh

time1=$( date +%s )
timediff=$(( $time1 - $time0 ))
timemin=$(( $timediff / 60 ))
timesec=$(( $timediff % 60 ))
echo -e "\nDuration: $timemin min $timesec sec"
echo $li
echo -e "$bar OSMC reset successfully."
echo $li
success=1

[[ $ansre == 1 && $# == 0 ]] && reboot 6
