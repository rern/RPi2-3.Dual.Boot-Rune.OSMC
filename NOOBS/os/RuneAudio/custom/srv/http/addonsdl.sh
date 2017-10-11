#!/bin/bash

wget -qN https://github.com/rern/RuneAudio_Addons/raw/master/install.sh -P /srv/http
if [[ $? == 5 ]]; then # 'certificate error' code
	systemctl stop ntpd
	ntpdate pool.ntp.org
	systemctl start ntpd
	wget -qN https://github.com/rern/RuneAudio_Addons/raw/master/install.sh -P /srv/http
fi

chmod 755 /srv/http/install.sh
/srv/http/install.sh
