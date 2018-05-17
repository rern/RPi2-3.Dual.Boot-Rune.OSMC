NOOBS custom compile
---
- For unattended `silentinstall` to SD card only
- For normal interactive installation, just copy the content in os folder to NOOBS os folder
- The following procedure has successfully compiled `NOOBS 2.8` on `ubuntu-18.04-desktop-amd64`  

**Install build environment:**  
```sh
sudo apt install build-essential rsync texinfo libncurses-dev whois unzip bc qt4-linguist-tools git
```
**Clone** [**NOOBS source**](https://github.com/raspberrypi/noobs)
```
cd
git clone https://github.com/raspberrypi/noobs.git
cd noobs
```  
**Edit `./noobs/recovery/mainwindow.cpp`**  
* remove os count  
* add checked to 2nd os list  
* change installed os numbers  
* change boot partition  
* remove OK prompt on finished 
```
sed -i -e 's/if (_allowSilent && .*)/if (_allowSilent)/
' -e '/ui->list->item(0)->setCheckState(Qt::Checked);/ a\
            ui->list->item(1)->setCheckState(Qt::Checked);
' -e 's/_numInstalledOS = 1/_numInstalledOS = 2/
' -e 's/"default_partition_to_boot", "800"/"default_partition_to_boot", "8"/
' -e 's/("OS(es) Installed Successfully"), QMessageBox::Ok)/("OS(es) Installed Successfully"))/
' recovery/mainwindow.cpp 
```
**Edit BUILDME.sh**  
* add ' silentinstall'
```
sed -i -e '/cp "$IMAGES_DIR\/cmdline.txt" "$FINAL_OUTPUT_DIR\/recovery.cmdline"/ a\
sed -i "s/\\r//; s/\\n//; s/\$/ silentinstall/" "$FINAL_OUTPUT_DIR/recovery.cmdline"
' BUILDME.sh
```
**Compile**  
- If available, restore previously downloaded packages to `./noobs/buildroot/dl/*` to avoid slow download
```sh
./BUILDME.sh
```
- Get compiled **NOOBS** in `./noobs/output/` directory
- Backup `./noobs/buildroot/dl/*` for reuse in fresh setup to avoid slow download of packages

**Clean cache for fresh compile**  
```
git clean -d -x -f
```
    
_NOOBS install sequence can be found in recovery/multiimagewritethread.cpp_
