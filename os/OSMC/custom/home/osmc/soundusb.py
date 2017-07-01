#!/usr/bin/python
import sys
import xml.dom.minidom as minidom
import os
import requests

if len(sys.argv) > 1: # usb 'remove'
	os.system('/usr/bin/xbmc-send -a "Notification(AUDIO OUTPUT,Switched to HDMI)"')
	exit()

xml = minidom.parse('/home/osmc/.kodi/userdata/guisettings.xml')
element = xml.getElementsByTagName('webserverport')
port = element[0].firstChild.nodeValue

stdout = os.popen("/sbin/udevadm info -n /dev/snd/controlC1 -q path").read() # read() => 'stdout'\n'result' > 'stdout'\n
path = '/sys'+ stdout.replace('controlC1\n', 'id') # path of id file
id = os.popen('cat '+ path).read().replace('\n', '')

# "ALSA:@:CARD='+ id +',DEV=0" must be exactly, no spaces, as in /home/osmc/.kodi/userdata/guisettings.xml
payload = '{"jsonrpc":"2.0", "method":"Settings.SetSettingValue", "params":{"setting":"audiooutput.audiodevice", "value":"ALSA:@:CARD='+ id +',DEV=0"}, "id":1}'
# request.post(url, data = {'key':'value'}, headers = {'key':'value'})
requests.post('http://localhost:'+ port +'/jsonrpc', data=payload, headers={'content-type': 'application/json'})

os.system('/usr/bin/xbmc-send -a "Notification(AUDIO OUTPUT,Switched to USB DAC)" &')
