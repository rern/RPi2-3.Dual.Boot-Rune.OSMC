NOOBS custom compile
---

- add unattended install option
- install build environment
- clone source
- edit custom compile  
	remove os count  
	add checked to 2nd os list  
	change boot partition  
	remove OK dialog box  
	add ' silentinstall'
- build  

**Install build environment:**  
```sh
sudo su
apt-get install build-essential rsync texinfo libncurses-dev whois unzip bc qt4-linguist-tools git-all
```
**Clone** [**NOOBS source**](https://github.com/raspberrypi/noobs)
```sh
cd
git clone https://github.com/raspberrypi/noobs.git
```  
**Edit ~/noobs/recovery/mainwindow.cpp** ( //-- = removed lines, //+++ added lines)  
```sh
sed -i -e 's/if (_allowSilent && !QFile::exists(FAT_PARTITION_OF_IMAGE) && ui->list->count() == 1)/if (_allowSilent && !QFile::exists(FAT_PARTITION_OF_IMAGE))/
' -e 's/settings.setValue("default_partition_to_boot", "800");/settings.setValue("default_partition_to_boot", "8");/
' -e 's/tr("OS(es) Installed Successfully"), QMessageBox::Ok);/tr("OS(es) Installed Successfully"));/
' noobs/recovery/mainwindow.cpp 
```
**Edit ~/BUILDME.sh** (//+++ added lines)  
```sh
sed -i '\|cp "$IMAGES_DIR/cmdline.txt" "$FINAL_OUTPUT_DIR/recovery.cmdline"| a\
sed -i 's/\r//; s/\n//; s/$/ silentinstall/' "$FINAL_OUTPUT_DIR/recovery.cmdline"
' BUILDME.sh
```
**Build:**  
```sh
./BUILDME.sh
```
- Get **NOOBS** in **~/noobs/output** directory  
  
    
_NOOBS install sequence can be found in /recovery/multiimagewritethread.cpp_
