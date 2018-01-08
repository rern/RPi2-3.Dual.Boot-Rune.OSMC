HowTo: Build Offline Custom NOOBS - Dual Boot: Rune | OSMC
---
(on Linux PC)  
  
- Get custom compiled NOOBS
- Prepare os directory  
- Download
- Make image files

![partitions](https://github.com/rern/_assets/blob/master/RPi2-3.Dual.Boot-Rune.OSMC/NOOBS_partitions.PNG)  

Get custom compiled NOOBS
---
- Download [**custom compiled NOOBS**](https://github.com/rern/_assets/raw/master/RPi2-3.Dual.Boot-Rune.OSMC/noobs.zip)
- Decompress in **home** directory

Prepare os directory
---

### `~/os/<name>/`
>./slides_vga/  
>	os.json  
>	partition_setup.sh  
>	partition.json  
>	<name>.png  
>	<boot>.tar.xz  
>	<root>.tar.xz  

- `<name>`s must be consistent:
	- folder: `/os/<name>`
	- icon: `/os/<name>/<name>.png`
	- name: `/os/<name>/os.json` > `"name": <name>,`

>**./slides_vga/**  
>	one or several 400x300 px images: A.png, B.png, C.png, ... for a slideshow during installation
	
>**os.json**  
>	edit `"name":`  
>	(optional) edit `"version":`, `"release_date":`, `"kernel":`, `"username":` and `"password":` 

>**partition.json**  
>	`"label": "<boot>"`, `"label": "<root>"` must be consistent with `<boot>.tar.xz` and `<root>.tar.xz` 
>	`"partition_size_nominal":` to be allocated porportionally to other OSes
>	`"uncompressed_tarball_size":` must be checked and roundup to next MB  
>	`NOOBS` + all `"uncompressed_tarball_size":` < must be less than SD card size

>**partition_setup.sh**  
>	add customizing commands to run after installation finished  
>	**EOL**: verify that every lines end with **LF** not **CRLF** (to be run in linux environment)
	
>**[icon].png**  
>	40 x 40 pixel  

### `<boot>.tar.xz` and `<root>.tar.xz`
- OSes need to be prepared with this procedure, both `<boot>.tar.xz` and `<root>.tar.xz`. Othewise they might not be extracted properly.
 
- **Rune**:
	- Download [RuneAudio image](http://www.runeaudio.com/download/)
	- Decompress and move `<imagefile>.img` to current user **home** directory 
- **OSMC**:
	- Download ready-to-use [boot-rbp2.tar.xz, root-rbp2.tar.xz](http://ftp.fau.de/osmc/osmc/download/installers/noobs/)  
	- **or**
	- [OSMC image](http://ftp.fau.de/osmc/osmc/download/installers/diskimages/)
	- Install OSMC with SD card  
	- **boot-rbp2.tar.xz** must be created from SD card `/boot`, all directories and files **except** `cmdline.txt` and `install.log`
- **Create files**
```
cd
sudo su
kpartx -av <imagefile>.img
mount /dev/mapper/loop0p1 /mnt
tar -cvpf boot.tar -C /mnt .
umount /mnt
xz -9ekv boot.tar

mount /dev/mapper/loop0p2 /mnt
tar -cvpf root.tar -C /mnt . --exclude=proc/* --exclude=sys/* --exclude=dev/pts/* --exclude=boot/*
umount /mnt
xz -9ekv root.tar
kpartx -dv <imagefile>.img
```

- **Done !**  

---
  
**Set boot partition**  
- Method 1 - skip boot menu
```sh
# Rune
# N = partition number
echo N > /sys/module/bcm2709/parameters/reboot_part

# OSMC
reboot N
```
- Method 2 - skip boot menu (permanent - remove the file to get back default boot)
```sh
# RECOVERY partition
mkdir -p /tmp/p1
mount /dev/mmcblk0p1 /tmp/p1
echo boot_partition=6 > /tmp/p1/autoboot.txt
```
- Method 3 - show boot menu
```sh
# SETTINGS partition
mkdir -p /tmp/p5
mount /dev/mmcblk0p5 /tmp/p5
sed -i "s/default_partition_to_boot=./default_partition_to_boot=6/" /tmp/p5/noobs.conf
```
