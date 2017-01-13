#!/bin/bash

# auto swith back to hdmi by system default, notify only

# get http 'port'
port=$(sed -n 's:.*>\(.*\)</webserverport>.*:\1:p' /home/osmc/.kodi/userdata/guisettings.xml)

# notify with http 'port'
curl -H "Content-type: application/json" -X POST -d '{"jsonrpc":"2.0","method":"GUI.ShowNotification", "params":{"title":"AUDIO OUTPUT", "message":"Switched to HDMI"}, "id":1}' http://localhost:$port/jsonrpc
