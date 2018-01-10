#!/bin/bash

bsdtar -xpvf /tmp/p1/os/$namereset/root-rbp2.tar.xz -C $mntroot \
  --exclude=./var/cache/apt \
  --exclude=./usr/include \
  --exclude=./usr/lib/{python2.7/test,python3*,libgo.*} \
  --exclude=./usr/share/{doc,gtk-doc,info,locale,man}

# from partition_setup.sh
echo -e "$bar Partition setup ..."
. /tmp/p1/os/$namereset/custom/usr/local/bin/custom.sh

wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/_settings/cmd.sh -P $mntroot/etc/profile.d
