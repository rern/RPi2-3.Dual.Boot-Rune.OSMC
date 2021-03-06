Dual Boot: Rune | OSMC (Pi2, Pi3)
---

`Rune 0.4beta 20170229` + `OSMC 2018.06-1` in `NOOBS lite 2.8` (with 'silentinstall' tweaks)  
_Initially started after [this post](http://www.runeaudio.com/forum/post20211.html?hilit=dual%20boot#p15341)._

[>> **Download**](https://drive.google.com/open?id=0B9KEjMAuGbejUnZaa2lOakFYYnM)  

> Best of Audio Distro - [**RuneAudio**](http://www.runeaudio.com/) (ArchLinux MPD)  
> Best of Video Distro - [**OSMC**](https://osmc.tv/) (Raspbian Kodi)  
> Best of Dual Boot - [**NOOBS**](https://www.raspberrypi.org/downloads/noobs/)

- Easy to switch with a single button from a cheap IR remote
- Install easier than normal NOOBS itself with 1 complete package (GitHub `Download Zip` not support large files, the download hosted on  Google Drive)
- Unattended offline installation
- No need for interaction, display, mouse, internet during installation  
- For normal interactive installation: Just copy the content of os folder to NOOBS Lite os folder

>[Features](#features)  
>[Remote Control](#remote-control)  
>[Installation](#installation)  

**Note:**  
- [**HowTo:** Build Offline Custom NOOBS](https://github.com/rern/RPi2-3.Dual.Boot-Rune.OSMC/blob/master/HowToBuild.md)  
- partition allocation (actual labels on RPi: `/dev/mmcblk0pn`)  
![partitions](https://github.com/rern/_assets/blob/master/RPi2-3.Dual.Boot-Rune.OSMC/NOOBS_partitions.PNG)  
Features
---

**Shutdown / Reboot**
- with normal menu
- next boot with 'Select OS to boot' (normal NOOBS)
		
**Boot Switch: OSMC <-> Boot Rune**
- with `e-mail` button from the remote
- bypass 'Select OS to boot'

**RuneAudio**  
- Addons Menu ready for various improvements and packages
- **minimalism RuneUI** plus some more features: [**RuneUI Enhancement**](https://github.com/rern/RuneUI_enhancement)  

**OSMC**
- Allow SSH as 'root' with password 'rune', the same as in Rune
- Fix slow SSH login
- Autoswitch audio output to/from USB DAC when on/off

Remote Control
---

**Rune:**  
(`Local browser` must be left enabled as of default.)  

|	Button		|	Function
|	------------|	--------------
|	`e-mail`	|	Reboot to OSMC
|	`amber`	    |	Reboot Rune
|	`left`		|	Previous
|	`enter`		|	Play / Pause
|	`right`		|	Next
|	`up`		|	Forward
|	`down`		|	Rewind
		
**OSMC:**

|	Button		    |	Function		    |	Function `in Video`
|	----------------|	--------------------|	---------------------------
|	`e-mail`	    |	Reboot to Rune		|
|	`amber`	        |	Reboot OSMC		    |
|	`tab`		    |	SystemInfo <-> Back	|	FullscreenInfo <-> Back
|	`open`		    |	MovieTitles		    |	MovieTitle <-> Fullscreen
|	`switchwindow`	|	Settings <-> Back	|	VideosSettings <-> Back
|	`blue`		    |				        |	NextSubtitle
|	`yellow`	    |				        |	AudioNextLanguage
|	`green`		    |	ReloadKeymaps		|	OSDAudioSettings


Installation
---

**Need:**

- Raspberry Pi 2 or 3
- 8GB SD card
- $4 USB PC Remote: ID 1d57:ad02 Xenta SE340D PC Remote Control
		
    ![remote](https://github.com/rern/_assets/blob/master/RPi2-3.Dual.Boot-Rune.OSMC/irremote.jpg)
    
    more detail:
    * [IR Remote - Using Cheap USB PC Remote with Rune](http://www.runeaudio.com/forum/ir-remote-using-cheap-usb-pc-remote-with-rune-t3901.html)
    * [IR Remote - Using Cheap USB PC Remote with OSMC](https://discourse.osmc.tv/t/ir-remote-using-cheap-usb-pc-remote-with-osmc/18695)

**Process:**

1. Prepare NOOBS SD card on a PC:
 * Download (Link at the top of this page)
 * Unzip and copy everything inside NOOBS_Rune-OSMC folder to a blank FAT32 SD card

2. Install on Raspberry Pi:
 * Power off
 * Insert the SD card
 * Power on
 * Installation runs automatically from start to reboot into Rune
 * (about 15 minutes with class 10 SD card)

3. Done!

**Force reinstall without rebuild SD card**  
- Reinstall OSMC: on Rune - `osmcreset`  
- Reinstall Rune: on OSMC - `runereset`  
- Reinstall both: `noobsreset`  
