Dual Boot: Rune | OSMC (Pi2, Pi3)
---

`Rune 0.3beta 20160321` + `OSMC 2017.04-1` in `NOOBS lite 2.3` (with 'silentinstall' tweaks)  

[>> **Download**](https://drive.google.com/open?id=0B9KEjMAuGbejUnZaa2lOakFYYnM)  
[>> Change Log](https://github.com/rern/RPi2-3.Dual.Boot-Rune.OSMC/blob/master/Changelog.md)

Best of Audio Distro - [**Rune**](http://www.runeaudio.com/) (ArchLinux MPD)  
Best of Video Distro - [**OSMC**](https://osmc.tv/) (Raspbian Kodi)  
Best of Dual Boot - [**NOOBS**](https://www.raspberrypi.org/downloads/noobs/)

- Easy to switch with a single button from a cheap IR remote
- Install easier than normal NOOBS itself with 1 complete package (GitHub `Download Zip` not support large files, the download hosted on  Google Drive)
- Unattended offline installation
- No need for interaction, display, mouse, internet during installation  

>[Features](#features)  
>[Remote Control](#remote-control)  
>[Installation](#installation)  

[**HowTo:** Build Offline Custom NOOBS](https://github.com/rern/RPi2-3.Dual.Boot-Rune.OSMC/blob/master/HowToBuild.md)  
For more **minimalism RuneUI** plus some more features: [**RuneUI Enhancement**](https://github.com/rern/RuneUI_enhancement) 

![partitions](https://github.com/rern/Assets/blob/master/RPi2-3.Dual.Boot-Rune.OSMC/NOOBS_partitions.PNG)  

Features
---

**Shutdown / Reboot**
- with normal menu
- next boot with 'Select OS to boot' (normal NOOBS)
		
**Boot Switch: OSMC <-> Boot Rune**
- with `e-mail` button from the remote
- bypass 'Select OS to boot'

**OSMC:**
- Allow SSH as 'root' with password 'rune', the same as in Rune
- Autoswitch audio output to/from USB DAC when on/off

Remote Control
---

**Rune:**  
(`Local browser` must be left enabled as of default.)  

	Button		|	Function
	------------|-----------------
	`e-mail`	|	Boot OSMC
	`left`		|	Previous
	`enter`		|	Play / Pause
	`right`		|	Next
	`up`		|	Forward
	`down`		|	Rewind
		
**OSMC:**

	Button		|	Function		|	Function `In Video`
	------------|-------------------|-------------------
	`e-mail`	|	Boot Rune		|
	`tab`		|	SystemInfo <-> Back	|	FullscreenInfo <-> Back
	`open`		|	MovieTitles		|	MovieTitle <-> Fullscreen
	`switchwindow`	|	Settings <-> Back	|	VideosSettings <-> Back
	`blue`		|				|	NextSubtitle
	`yellow`	|				|	AudioNextLanguage
	`green`		|	ReloadKeymaps		|	OSDAudioSettings


Installation
---

**Need:**

- Raspberry Pi 2 or 3
- 8GB SD card
- $4 USB PC Remote: ID 1d57:ad02 Xenta SE340D PC Remote Control
		
    ![remote](https://github.com/rern/Assets/blob/master/RPi2-3.Dual.Boot-Rune.OSMC/irremote.jpg)
    
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

**NOOBS force recovery**
```sh
echo " forcetrigger" >> recovery.cmdline
```

