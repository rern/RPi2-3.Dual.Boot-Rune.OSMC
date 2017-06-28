How To Add Translation 
---
(This example as of Thai - **th** language)  

**add**  
- `recovery/translation_th.ts` (create with `lupdate recovery.pro` or use one from GitHub)
- `recovery/icons/th.png` ( [**flags**](http://www.famfamfam.com/lab/icons/flags/famfamfam_flag_icons.zip) )
- `buildroot/output/build/recovery-1.0/translation_th.qm` (create with `lrelease recovery.pro`)
- `buildroot/package/recovery/unicode-fonts/DejaVuSansThai.ttf` (if characters not available in default)
- `buildroot/package/recovery/unicode-fonts/DejaVuSansThai-Bold.ttf`

**edit**
- `recovery/recovery.pro`
- `recovery/icons.qrc`
- `buildroot/package/recovery/recovery.mk`

**edit** `recovery/recovery.pro`  
add a line
```sh
# TRANSLATIONS += 
    translation_th.ts \
```

**generate .ts file**  
```sh
cd
cd noobs
chmod +x pre-commit-translation-update-hook.sh
cp pre-commit-translation-update-hook.sh .git/hooks/pre-commit

lupdate recovery/recovery.pro
```

**copy**  
`translation_th.ts` to `recovery/`  
`th.png` to `recovery/icons/`   


**generate .qm file**  
```sh
lrelease recovery/recovery.pro
```

**edit** `recovery/icons.qrc`  
add lines
```sh
        <file>translation_th.qm</file>
        <file>icons/th.png</file>
```

**add fonts**  
ttf font
`buildroot/package/recovery/unicode-fonts/`  

**edit** `buildroot/package/recovery/recovery.mk`  
add lines
```sh
	$(INSTALL) -m 0755 package/recovery/unicode-fonts/DejaVuSans.ttf $(TARGET_DIR)/usr/lib/fonts/DejaVuSansThai.ttf
	$(INSTALL) -m 0755 package/recovery/unicode-fonts/DejaVuSans-Bold.ttf $(TARGET_DIR)/usr/lib/fonts/DejaVuSansThai-Bold.ttf
```

**build**  
```sh
./BUILDME.sh
```
