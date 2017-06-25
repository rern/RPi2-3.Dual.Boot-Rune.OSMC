#!/usr/bin/python

import os

os.system('sudo su -c "mkdir -p /mnt/p5; sed -i 's/default_partition_to_boot=./default_partition_to_boot=8/' /mnt/p5/noobs.conf; reboot"')
