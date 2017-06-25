#!/usr/bin/python

import os

os.system('sudo /home/osmc/rebootrune.sh')

# current raspbian has no /sys/module/bcm2709/parameters/reboot_part > use noobd.conf instead
#os.system('sudo echo 8 > /sys/module/bcm2709/parameters/reboot_part; /var/www/command/rune_shutdown; reboot')
