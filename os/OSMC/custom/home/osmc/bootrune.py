#!/usr/bin/python

import os
os.system('sudo /home/osmc/off.py')
os.system('sudo su -c "echo 8 > /sys/module/bcm2709/parameters/reboot_part; reboot"')
