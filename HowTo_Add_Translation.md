How To Add Translation 
---
(This example as of Thai - **th** language)  

**add**  
- `recovery/translation_th.ts` (create with `lupdate recovery.pro` or use one from GitHub)
- `recovery/icons/th.png` ( [**flags**](http://www.famfamfam.com/lab/icons/flags/famfamfam_flag_icons.zip) )
- `buildroot/output/build/recovery-1.0/translation_th.qm` (create with `lrelease recovery.pro`)
- `buildroot/package/recovery/unicode-fonts/DejaVuSansThai.ttf` (if characters not available in default)
- `buildroot/package/recovery/unicode-fonts/DejaVuSansThaiBold.ttf`

**edit**
- `recovery/recovery.pro`
- `recovery/icons.qrc`


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

**edit** `recovery/icons.qrc`  
add lines
```sh
        <file>translation_th.qm</file>
        <file>icons/th.png</file>
```

**generate .qm file**  
```sh
lrelease buildroot/output/build/recovery-1.0/recovery.pro
```

**add fonts**  
`buildroot/package/recovery/unicode-fonts/`  

**build**  
```sh
./BUILD.sh
```
