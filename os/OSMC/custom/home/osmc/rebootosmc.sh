#!/bin/bash

mkdir -p /mnt/p5
mount /dev/mmcblk0p5 /mnt/p5
sed -i "s/default_partition_to_boot=./default_partition_to_boot=6/" /mnt/p5/noobs.conf
reboot
