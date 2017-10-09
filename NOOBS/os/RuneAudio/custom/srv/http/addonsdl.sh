#!/bin/bash

dl=$( wget -qN https://github.com/rern/RuneAudio_Addons/raw/master/install.sh -P /srv/http )
if [[ $? == 5 ]]; then # github 'certificate error' code
	systemctl stop ntpd
	ntpdate pool.ntp.org
	systemctl start ntpd
	echo "$dl" || exit 1
fi

chmod 755 /srv/http/install.sh
/srv/http/install.sh

exit 0
