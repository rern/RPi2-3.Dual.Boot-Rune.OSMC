#!/usr/bin/python
import os

os.system('echo 6 > /sys/module/bcm2709/parameters/reboot_part; /var/www/command/rune_shutdown; reboot')
