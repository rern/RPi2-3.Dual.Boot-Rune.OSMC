#!/bin/bash

wget -qN --no-check-certificate https://github.com/rern/RuneAudio_Addons/raw/master/install.sh -P /srv/http

chmod 755 /srv/http/install.sh || exit 1
/srv/http/install.sh
