The python server runs on the Raspberry Pi with the Xmas tree attached.
Set the treeServer.py file executable using chmod+x treeServer.py
start it running with ./treeServer.py -ip 192.168.1.34 -sp 192.168.1.129
where 192.168.1.34 is the ip address of the Raspberry Pi, and 192.168.1.129 is the address of the computer running Sonic Pi.
Set the correct IP address in line 7 of the Sonic Pi program, and use port 8000 as shown.

EDIT
You need to have installed the tree.py file for the RGBXmasTree in the same folder as the treeServer.py file. This can be found at https://github.com/ThePiHut/rgbxmastree#rgbxmastree colorzero should already be installed in the latest Raspbian Buster distribution.
If you need it use

`sudo apt update`

`sudo apt install python-colorzero python3-colorzero`
