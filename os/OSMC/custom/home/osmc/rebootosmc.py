#!/usr/bin/python
import os

os.system('/usr/bin/sudo /home/osmc/rebootosmc.sh')

# current raspbian has no /sys/module/bcm2709/parameters/reboot_part > use noobd.conf instead
#os.system('/usr/bin/sudo echo 6 > /sys/module/bcm2709/parameters/reboot_part; /var/www/command/rune_shutdown; reboot')
