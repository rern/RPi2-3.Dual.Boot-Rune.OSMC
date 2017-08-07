xbindkeys
---
[xbindkeys](http://www.nongnu.org/xbindkeys/) - launch shell commands with your keyboard or your mouse under X Window  

**configuration**  
`/root/.xbindkeysrc`

**restart**
```sh
killall xbindkeys

export DISPLAY=":0"
xbindkeys &
```
