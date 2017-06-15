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

_(successfully compiled NOOBS 2.3 on Ubuntu 16.04 x64 but failed on 16.10 x64)__  

**Install build environment:**  
```
sudo apt install build-essential rsync texinfo libncurses-dev whois unzip bc qt4-linguist-tools git-all
```
**Clone** [**NOOBS source**](https://github.com/raspberrypi/noobs)
```
cd
git clone https://github.com/raspberrypi/noobs.git
cd noobs
```  
**Edit recovery/mainwindow.cpp**  
```
sed -i -e 's/if (_allowSilent && !QFile::exists(FAT_PARTITION_OF_IMAGE) && ui->list->count() == 1)/ \
	if (_allowSilent && !QFile::exists(FAT_PARTITION_OF_IMAGE))/
' -e 's/settings.setValue("default_partition_to_boot", "800");/ \
	settings.setValue("default_partition_to_boot", "8");/
' -e 's/tr("OS(es) Installed Successfully"), QMessageBox::Ok);/ \
	tr("OS(es) Installed Successfully"));/
' recovery/mainwindow.cpp 
```
**Edit BUILDME.sh**  
```
sed -i '/cp "$IMAGES_DIR\/cmdline.txt" "$FINAL_OUTPUT_DIR\/recovery.cmdline"/ a\ 
	sed -i "s/\\r//; s/\\n//; s/\$/ silentinstall/" "\$FINAL_OUTPUT_DIR/recovery.cmdline"
' BUILDME.sh
```
**Compile**  
```
./BUILDME.sh
```
- Get **NOOBS** in **output/** directory  
  
    
_NOOBS install sequence can be found in recovery/multiimagewritethread.cpp_
