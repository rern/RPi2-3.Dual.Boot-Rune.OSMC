#!/bin/bash

gitpath=https://github.com/rern/RuneAudio_Addons/raw/master

dl=$( wget -qN https://github.com/rern/RuneAudio_Addons/raw/master/install.sh -P /srv/http )
if [[ $? != 0 ]]; then
	if [[ $? == 5 ]]; then # github 'ca certificate failed' code > update time
		systemctl stop ntpd
		ntpdate pool.ntp.org
		systemctl start ntpd
		echo "$dl"
		[[ $? != 0 ]] && exit 5
	else
		exit 1
	fi
fi

chmod 755 /srv/http/install.sh
/srv/http/install.sh

exit 0
