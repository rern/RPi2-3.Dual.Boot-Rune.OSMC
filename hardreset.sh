#!/bin/bash

### reset rune root partition to virgin state

# format partition
# extract root partition
# fstab for boot partition
# copy custom files

rm $0

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

mntsettings=/tmp/SETTINGS
mkdir -p $mntsettings
mount /dev/mmcblk0p5 $mntsettings 2> /dev/null
installedlist=$( grep 'name\|mmc' $mntsettings/installed_os.json )
# omit current os
currentroot=$( mount | grep 'on / ' | cut -d' ' -f1 | cut -d'/' -f3 )
currentline=$( echo "$installedlist" | sed -n "/$currentroot/=" )
osarray=( $( 
	echo "$installedlist" |
	sed "$(( currentline - 2 )), $currentline d" |
	sed -n '/name/,/mmcblk/ p' |
	sed '/part/ d; s/\s//g; s/"//g; s/,//; s/name://; s/\/dev\/mmcblk0p//' 
) )
ilength=${#osarray[*]}

echo -e "\n\e[30m\e[43m ? \e[0m Hardreset OS:"
echo -e '  \e[36m0\e[m Cancel'
namearray=(0)
bootarray=(0)
for (( i=0; i < ilength; i+=2 )); do
	iname=${osarray[i]}
	echo -e "  \e[36m$j\e[m $iname"
	namearray+=($iname)
	bootarray+=(${osarray[i + 1]})
done

echo -e "  \e[36m$j\e[m NOOBS"
namearray+=(NOOBS)
bootarray+=(0)
echo
echo -e "\e[36m0\e[m / n ? "
read -n 1 ans
echo
[[ -z $ans || $ans != [0-9] || $ans == 0 || $ans -gt $(( ilength / 2 )) ]] && return

bootnum=${bootarray[$ans]}
rootnum=$(( bootnum + 1 ))
devreset=/dev/mmcblk0p$rootnum
namereset=${namearray[$ans]}
name=$( echo -e "\e[36m$namereset\e[m" )

li=$( printf "\e[36m%*s\e[0m\n" "${COLUMNS:-$(tput cols)}" '' | tr ' ' "=" )
bar='\e[36m\e[46m . \e[0m'

yesno "Hardreset ${name}?"
[[ $answer != 1 ]] && exit

if [[ $rootnum == 0 ]]; then
	### reset all partitions to virgin installed noobs
	yesno "Hardreset $name will \e[31mdelete ALL OSes and data\e[m in SD card. Continue?"
	[[ $answer != 1 ]] && exit

	echo -n " forcetrigger" >> /tmp/p1/recovery.cmdline

	[[ -d /home/osmc ]] && reboot $bootnum

	/var/www/command/rune_shutdown
	reboot
fi

yesno "Reboot to $name after hardreset:" ansre

time0=$( date +%s )

echo $li
echo -e "$bar $name hardreset ..."
echo $li

echo -e "$bar Format partition ..."
mntrecovery=/tmp/RECOVERY
mkdir -p $mntrecovery
mount /dev/mmcblk0p1 $mntrecovery 2> /dev/null

mntroot=/tmp/root
mkdir -p $mntroot

umount -l $devreset 2> /dev/null

partfile=$mntrecovery/os/$namereset/partitions.json
mkfsoption=$( sed -n '/ext4/,/mkfs/ p' $partfile | grep 'mkfs' | cut -d'"' -f4 )
echo y | mkfs.ext4 $mkfsoption $devreset &> /dev/null

echo -e "$bar Extract files ..."
mount $devreset $mntroot
rootfile=$( grep 'root' $partfile | cut -d'"' -f4 ).tar.xz
bsdtar -xpvf $mntrecovery/os/$namereset/$rootfile -C $mntroot

echo -e "$bar Customize ..."
. $mntrecovery/os/$namereset/custom.sh

time1=$( date +%s )
timediff=$(( time1 - time0 ))
timemin=$(( timediff / 60 ))
timesec=$(( timediff % 60 ))
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
