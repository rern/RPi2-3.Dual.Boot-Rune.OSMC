#!/bin/bash

# auto switch for single usb sound only

# get http 'port' >>> as may be changed by user
port=$(sed -n 's:.*>\(.*\)</webserverport>.*:\1:p' /home/osmc/.kodi/userdata/guisettings.xml)

# get usb 'id' >>> /dev/snd/controlC1 == /sys/devices/platform/soc/3f980000.usb/usb1/1-1/1-1.[1 to 4]/...
# (get usb path | sed path to '...card1/id' | prepend '/sys' dir to path) >>> get file content
path=$(udevadm info -n /dev/snd/controlC1 -q path | sed 's/controlC1/id/' | sed 's/^/\/sys/')
id=$(< $path)

# [{set audio output to usb 'id'}, {notify}] http 'port'
curl -H "Content-type: application/json" -X POST -d '[
	{"jsonrpc":"2.0","method":"Settings.SetSettingValue", "params":{"setting":"audiooutput.audiodevice","value":"ALSA:@:CARD='$id',DEV=0"},"id":1},
	{"jsonrpc":"2.0","method":"GUI.ShowNotification", "params":{"title":"AUDIO OUTPUT", "message":"Switched to USB Sound"}, "id":1}
]' http://localhost:$port/jsonrpc
