NOOBS custom compile
---
successfully compiled NOOBS 2.4 on `ubuntu-17.04-desktop-amd64` (`gcc-6`, `g++-6` downgrade to `gcc-5`, `g++-5` needed)  
 

**Install build environment:**  
```sh
sudo apt install build-essential rsync texinfo libncurses-dev whois unzip bc qt4-linguist-tools git

# !important: NOOBS needs gcc-5 and g++-5
sudo apt install gcc-5 g++-5
sudo rm /usr/bin/gcc
sudo rm /usr/bin/g++
sudo ln -s /usr/bin/gcc-5 /usr/bin/gcc
sudo ln -s /usr/bin/g++-5 /usr/bin/g++
```
**Clone** [**NOOBS source**](https://github.com/raspberrypi/noobs)
```
cd
git clone https://github.com/raspberrypi/noobs.git
cd noobs
```  
**Edit recovery/mainwindow.cpp**  
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
sed -i "s/\\r//; s/\\n//; s/\$/ silentinstall/" "\$FINAL_OUTPUT_DIR/recovery.cmdline"
' BUILDME.sh
```
**Compile**  
```
./BUILDME.sh
```
- Get **NOOBS** in **output/** directory  

**Clean cache for fresh compile**  
```
git clean -d -x -f
```
    
_NOOBS install sequence can be found in recovery/multiimagewritethread.cpp_
