NOOBS custom compile
---

- install build environment
- clone source
- edit custom compile  
	remove os count  
	add checked to 2nd os list  
	change installed os numbers  
	change boot partition  
	remove OK dialog box  
	
	add ' silentinstall'
- build  

_(successfully compiled NOOBS 2.4 on Ubuntu 16.04 but 17.04 needs gcc-5 and g++-5)__  

**Install build environment:**  
```sh
sudo apt install build-essential rsync texinfo libncurses-dev whois unzip bc qt4-linguist-tools git

# !important: ubuntu 16.10 - 17.04 need gcc-5, g++-5
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
