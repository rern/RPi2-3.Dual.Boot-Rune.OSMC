#!/bin/bash

### reset rune root partition to virgin state

# format partition
# extract root partition
# fstab for boot partition
# copy custom files

yesno() { # $1 = header string; $2 = input or <enter> = ''
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
mmc() {
	[[ $2 ]] && mntdir=/tmp/$2 || mntdir=/tmp/p$1
	if [[ ! $( mount | grep $mntdir ) ]]; then
		mkdir -p $mntdir
		mount /dev/mmcblk0p$1 $mntdir
	fi
}

mmc 5
# omit current os from installed_os.json
mmcroot=$( mount | grep 'on / ' | cut -d' ' -f1 | cut -d'/' -f3 )
mmcline=$( sed -n "/$mmcroot/=" /tmp/p5/installed_os.json )
sed "$(( mmcline - 3 )), $mmcline d" /tmp/p5/installed_os.json > /tmp/installed_os.json
# filter names and boot partitions > array
oslist=$( sed -n '/name/,/mmcblk/ p' /tmp/installed_os.json | sed '/part/ d; s/\s//g; s/"//g; s/,//; s/name://; s/\/dev\/mmcblk0p//' )
osarray=( $( echo $oslist ) )

echo -e "\n\e[30m\e[43m ? \e[0m Hardreset OS:"
echo -e '  \e[36m0\e[m Cancel'
ilength=${#osarray[*]}
namearray=(0)
bootarray=(0)
for (( i=0; i < ilength; i++ )); do
	j=$(( i / 2 + 1 ))
	if (( $(( i % 2 )) == 0 )); then
		echo -e "  \e[36m$j\e[m ${osarray[i]}"
		namearray+=(${osarray[i]})
	else
		bootarray+=(${osarray[i]})
	fi
done
namearray+=(NOOBS)
j=$(( ilength / 2 + 1 ))
bootarray+=(0)
echo -e "  \e[36m$j\e[m NOOBS"
echo
echo 'Which OS? '
read -n 1 ans
echo
[[ -z $ans || $ans == 0 ]] && exit

bootnum=${bootarray[$ans]}
rootnum=$(( bootnum + 1 ))
devreset=/dev/mmcblk0p$rootnum
namereset=${namearray[$ans]}
name=$( echo -e "\e[36m$namereset\e[m" )

li=$( printf "\e[36m%*s\e[0m\n" "${COLUMNS:-$(tput cols)}" '' | tr ' ' "=" )
bar='\e[36m\e[46m . \e[0m'

yesno "Hardreset ${name}?"
[[ $answer != 1 ]] && exit

[[ $bootnum == 0 ]] && /usr/local/bin/hardreset_NOOBS.sh

yesno "Reboot to $name after hardreset:" ansre

time0=$( date +%s )

echo $li
echo -e "$bar $name hardreset ..."
echo $li

[[ $namereset == Rune04b ]] && namereset=RuneAudio
wget -qN --no-check-certificate --show-progress https://github.com/rern/RPi2-3.Dual.Boot-Rune.OSMC/raw/master/NOOBS/hardreset/hardreset_$namereset.sh
if [[ $? != 0 ]]; then
	echo -e '\e[38;5;7m\e[48;5;1m ! \e[0m custom files download failed.'
	echo 'Please try again.'
	exit
fi

umount -l $devreset &> /dev/null
echo -e "$bar Format partition ..."
echo y | mkfs.ext4 $devreset &> /dev/null

echo -e "$bar Extract files ..."
mmc 1
mmc $rootnum
mntroot=/tmp/p$rootnum

. hardreset_$namereset.sh

time1=$( date +%s )
timediff=$(( $time1 - $time0 ))
timemin=$(( $timediff / 60 ))
timesec=$(( $timediff % 60 ))
echo -e "\nDuration: $timemin min $timesec sec"
echo $li
echo -e "$bar $name hardreset successfully."
echo $li
success=1

if [[ $ansre == 1 && $# == 0 ]]; then
	[[ -d /home/osmc ]] && reboot $bootnum
	echo $bootnum > /sys/module/bcm2709/parameters/reboot_part
	/var/www/command/rune_shutdown 2> /dev/null
	reboot
fi
