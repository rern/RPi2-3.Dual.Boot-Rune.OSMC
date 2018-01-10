#!/bin/bash

# from partition_setup.sh
echo -e "$bar Partition setup ..."
. /tmp/p1/os/$namereset/custom/usr/local/bin/custom.sh

wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/cmd.sh -P $mntroot/etc/profile.d
