#!/usr/bin/python
import os

os.system('sudo su -c "echo 6 > /sys/module/bcm2709/parameters/reboot_part; reboot"')