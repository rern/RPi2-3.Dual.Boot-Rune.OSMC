HowTo: Build Offline Custom NOOBS - Dual Boot: Rune | OSMC
---
(on Linux PC)  
  
- Get custom compiled NOOBS
- Prepare os directory  
- Download
- Make image files

![partitions](https://github.com/rern/Assets/blob/master/RPi2-3.Dual.Boot-Rune.OSMC/NOOBS_partitions.PNG)  

Get custom compiled NOOBS
---
- Download [**custom compiled NOOBS**](https://drive.google.com/open?id=0B9KEjMAuGbejdDU4Zy02bDJILWM)
- Decompress in **home** directory

Prepare os directory
---

**~/os/RuneAudio/** 

>./slides_vga/  
>	os.json  
>	partition_setup.sh  
>	partition.json  
>	RuneAudio.png  
>	boot.tar.xz  
>	root.tar.xz  

		
**~/os/OSMC/**  

>./slides_vga/  
>	os.json  
>	partition_setup.sh  
>	partition.json  
>	OSMC.png  
>	boot-rbp2.tar.xz  
>	filesystem.tar.xz  

#
**Rune | OSMC**

>**./slides_vga/**  
>	one or several 400x300 px images: A.png, B.png, C.png, ... for a slideshow during installation
	
>**os.json**  
>	edit "name", "version", "release_date", "kernel"

>**partition.json**  
>	"label" must be the same as 'boot' and 'root' compressed filename  
>	"uncompressed_tarball_size" must be checked and roundup to next MB  
> `xz -l root.tar.xz` / `xz -l filesystem.tar.xz`

>**partition_setup.sh**  
>	add customizing commands to run after installation finished  
>	**warning** verify that every lines end with **LF** not **CRLF**
	
>**[icon].png**  
>	40 x 40 pixel  
>	filename must be the same as `"name":` in `os.json` for display in NOOBS menu

Download
---
**Rune**  
- Get [**RuneAudio image**](http://www.runeaudio.com/download/) image file  
- Decompress and move the image file(file.img) to current user **home** directory  

**boot.tar.xz**  
>
```
cd
sudo su
kpartx -av RuneAudio_xxx.img
mount /dev/mapper/loop0p1 /mnt
tar -cvpf boot.tar -C /mnt .
umount /mnt
xz -9ekv boot.tar
```
>
>Copy **boot.tar.xz** to **~/os/RuneAudio/**  

**root.tar.xz**  
>
```
mount /dev/mapper/loop0p2 /mnt
tar -cvpf root.tar -C /mnt . --exclude=proc/* --exclude=sys/* --exclude=dev/pts/* --exclude=boot/*
umount /mnt
xz -9ekv root.tar
kpartx -dv RuneAudio_xxx.img
```
>
>Copy **root.tar.xz** to **~/os/RuneAudio/**  
 	
#
**OSMC**  

**boot-rbp2.tar.xz**  
>Get [boot-rbp2.tar.xz](http://ftp.fau.de/osmc/osmc/download/installers/noobs/)  
>Copy **boot-rbp2.tar.xz** to **~/os/OSMC/**  

or  

>Install OSMC with SD card  
>Create **boot-rbp2.tar.xz** from SD card root, all directories and files except `cmdline.txt` and `install.log`  

**filesystem.tar.xz**  
(filename must be the same as `"label":` in `partitions.json` )  
>Get [OSMC image](http://ftp.fau.de/osmc/osmc/download/installers/diskimages/)    
>Decompress and extract image file (file.img)  
>Copy **filesystem.tar.xz** to **~/os/OSMC/**	

**Done !**  
  
  
**Set boot partition**  
( '6' - OSMC, '8' - Rune )
- #1 - skip boot menu
```
echo 6 > /sys/module/bcm2709/parameters/reboot_part
```
- #2 - skip boot menu (remove the file to get back default boot)
```
echo boot_partition=6 > /boot/autoboot.txt
```
- #3 - show boot menu
```
mkdir -p /tmp/p5
mount /dev/mmcblk0p5 /tmp/p5
sed -i "s/default_partition_to_boot=./default_partition_to_boot=6/" /tmp/p5/noobs.conf
```
