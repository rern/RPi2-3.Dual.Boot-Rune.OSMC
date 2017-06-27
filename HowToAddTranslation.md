How To Add Translation
---

**edit** `recovery/recovery.pro`  
add a line
```sh
# TRANSLATIONS += 
    translation_<languagecode>.ts \
```


```sh
cd
cd noobs
chmod +x pre-commit-translation-update-hook.sh
cp pre-commit-translation-update-hook.sh .git/hooks/pre-commit

lupdate recovery/recovery.pro
```

**copy**  
`translation_<languagecode>.ts` to `recovery/`  
`<languagecode>.png` to `recovery/icons/` ( [**flags**](http://www.famfamfam.com/lab/icons/flags/famfamfam_flag_icons.zip) )  

**edit** `recovery/icons.qrc`  
add lines
```sh
        <file>translation_<languagecode>.qm</file>
        <file>icons/<languagecode>.png</file>
```
