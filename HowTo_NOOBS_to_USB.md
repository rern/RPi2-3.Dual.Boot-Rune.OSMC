NOOBS to USB
---
 
**Prepare USB drive**  
Insert only 1 usb drive with at least 4GB size.
```sh
wget -q --show-progress -O formatusb.sh "https://github.com/rern/RPi2-3.Dual.Boot-Rune.OSMC/blob/master/formatusb.sh?raw=1"; chmod +x formatusb.sh; ./formatusb.sh
```

**transfer filesystem**  

**from RPi**  
_not from current root partition which dynamically changed_  
	
**Rune** on OSMC
```sh
#!/bin/bash

mkdir /mnt/root
mkdir /media/root
mount /dev/mmcblk0p9 /mnt/root
mount /dev/sda1 /media/root

apt-get install rsync
rsync -arv --exclude 'boot/*' /mnt/root/ /media/root/ 

umount /mnt/root
umount /media/root
rmdir /mnt/root
rmdir /media/root

mkdir /mnt/boot
mount /dev/mmcblk0p8 /mnt/boot

id=$(blkid /dev/sda1 | cut -d '"' -f6)
sed -i "s|/dev/mmcblk0p8|/dev/PARTUUID=$id|" /mnt/boot/cmdline.txt

umount /mnt/boot
rmdir /mnt/boot
```
(if not work: /dev/sda1)  

**OSMC** on Rune  
_boot to OSMC at least once to finish setup_  
```sh
#!/bin/bash

mkdir /mnt/root
mkdir /mnt/usb
mount /dev/mmcblk0p7 /mnt/root
mount /dev/sda2 /mnt/usb

pacman -Sy
pacman -Sy rsync
rsync -arv --exclude 'boot/*' /mnt/root/ /mnt/usb/

umount /mnt/root
umount /mnt/usb
rmdir /mnt/root
rmdir /mnt/usb

mkdir /mnt/boot
mount /dev/mmcblk0p6 /mnt/root

id=$(blkid /dev/sda2 | cut -d '"' -f2)
sed -i "s|/dev/mmcblk0p8|/dev/UUID=$id|" /mnt/boot/cmdline.txt

umount /mnt/boot
rmdir /mnt/boot
```	
(if not work: /dev/sda2)  

**or from PC**  
_VirtualBox Ubuntu has trouble manage multiple USB drives_
```sh
cd /source
tar -cvpf /destination/file.tar .
cd /destination
tar -xvpf /source/file.tar
```

NOOBS - Move to 1GB SD card
---
Finish nornal NOOBS installation.  

**GParted:**  
	(not needed: LBA, lowercase label)  
	1 - Primary > 750MB | fat32 | RECOVERY  
	2 - Extend > all the rest  
	3 - Logical > 40MB | ext4 | SETTINGS  
	4 - Logical > 40MB | fat32 | bootosmc  
	5 - Logical > 5MB | ext4  
	6 - Logical > 40M | fat32 | bootrune  

```sh
dosfsck -w -r -l -a -v /dev/sdb1
dosfsck -w -r -l -a -v /dev/sdb6
dosfsck -w -r -l -a -v /dev/sdb8
mount /device/sdb1 /mnt
```

**Files:**
```sh
gksu nautilus

cp /home/x/NOOBS_SD/RECOVERY/ /media/x/mnt
cp /home/x/NOOBS_SD/SETTINGS/ /media/x/SETTINGS
cp /home/x/NOOBS_SD/BOOT-RBP2/ /media/x/bootosmc
cp /home/x/NOOBS_SD/BOOT/ /media/x/bootrune

umount /mnt
```
