#!/bin/bash

### reset all partitions to noobs virgin state
yesno "Hardreset ${name} will \e[31mdelete ALL OSes and data\e[m in SD card. Continue?"
[[ $answer != 1 ]] && exit
	
echo -n " forcetrigger" >> /tmp/p1/recovery.cmdline

[[ -d /home/osmc ]] && reboot $bootnum

/var/www/command/rune_shutdown
reboot
