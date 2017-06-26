#!/bin/bash

mkdir -p /tmp/p5
mount /dev/mmcblk0p5 /tmp/p5
sed -i "s/default_partition_to_boot=./default_partition_to_boot=8/" /tmp/p5/noobs.conf
reboot
