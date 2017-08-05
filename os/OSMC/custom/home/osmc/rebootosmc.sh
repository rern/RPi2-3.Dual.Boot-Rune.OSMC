#!/bin/bash

mkdir -p /tmp/p5
mount /dev/mmcblk0p5 /tmp/p5
sudo sed -i "s/default_partition_to_boot=./default_partition_to_boot=6/" /tmp/p5/noobs.conf
reboot
