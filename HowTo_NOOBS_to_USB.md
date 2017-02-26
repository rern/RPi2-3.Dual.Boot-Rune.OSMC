NOOBS - Move to 1GB SD card
---
Finish nornal NOOBS installation.  

**GParted:**  
	(not needed: LBA, lowercase label)  
	1 - Primary > 750MB | fat32 | RECOVERY  
	2 - Extend > all the rest  
	3 - Logical > 40MB | ext4 | SETTINGS  
	4 - Logical > 80MB | fat32 | bootosmc  
	5 - Logical > 5MB | ext4  
	6 - Logical > 200M | fat32 | bootrune  

```sh
dosfsck -w -r -l -a -v /dev/sdb1
dosfsck -w -r -l -a -v /dev/sdb6
dosfsck -w -r -l -a -v /dev/sdb8
mount /device/sdb1 /mnt
```

**Files:**
```sh
gksu nautilus
```
```sh
		copy /home/x/NOOBS_SD/RECOVERY/ to /media/x/mnt
		copy /home/x/NOOBS_SD/SETTINGS/ to /media/x/SETTINGS
		copy /home/x/NOOBS_SD/BOOT-RBP2/ to /media/x/bootosmc
		copy /home/x/NOOBS_SD/BOOT/ to /media/x/bootrune
```
```sh
umount /mnt
```

NOOBS to USB
---
list disks and partitions
```sh
lsblk
```
**prepare partitions**
```sh
fdisk /dev/sda
```
```sh	
			: p			(list existing partitions)
				if needed only
					: d			(delete a partition)
					: <partition number>
			: n			(create new partition)
				: <enter>		(default primary)
				: <enter>		(default number)
				: <enter>		(default 1st sector)
				: +4G				(+2.4G on 4GB drive)
			: n
				: <enter>
				: <enter>
				: <enter>
				: <enter>		(default last sector)
			: w			(save changes)
```
```sh		
partx -u /dev/sda

umount /dev/sda1
umount /dev/sda2

mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda2
```

**transfer filesystem**  

**from RPi** (not from current root partition which dynamically changed)  
	
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
```sh
cd /source
tar -cvpf /destination/file.tar .
cd /destination
tar -xvpf /source/file.tar
```
