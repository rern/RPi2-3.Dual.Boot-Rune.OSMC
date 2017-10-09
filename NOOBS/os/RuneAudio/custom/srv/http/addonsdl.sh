#!/bin/bash

dl=$( wget -qN https://github.com/rern/RuneAudio_Addons/raw/master/install.sh -P /srv/http )
if [[ $? == 5 ]]; then # github 'certificate error' code
	systemctl stop ntpd
	ntpdate pool.ntp.org
	systemctl start ntpd
	echo "$dl"
	[[ $? == 5 ]] && exit 5
fi

[[ $? != 0 ]] && exit 1

chmod 755 /srv/http/install.sh
/srv/http/install.sh

exit 0
