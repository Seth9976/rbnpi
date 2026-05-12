Sonic Pi Record / Player

The three other files enable a TouchOSC interface to be used with Sonic Pi 3 and above to allow notes to be played
on Sonic Pi, and also recorded in real time for subsequent replay. Recordings can also be stored in files on your computer.
NB spRecordPlayer.rb changed to release 1.0.1
line 144 updated "piano,"pluck" changed to :piano,:pluck

The two Sonic Pi programs should be loaded into separate buffers, where they are both run. At any time you can re-run either file.
If you ever press the stop button you must re-run both.

The TouchOSC template is the file index.xml This should be downloaded and then compressed or zipped
with the resulting file renamed as spRecordPlayer.touchosc  This file should then be loaded into your TouchOSC editor
and from there synced to your iPad/iPhone/Android device which is running TouchOSC

You should adjust the IP addresse in the two  Sonic Pi programs to point to our TouchOSC device, and also adjust
the OSC settings of that device to point back to your computer running Sonic Pi.
The Host address should be set equal to the IP address of your Sonic Pi computer, and the outgoing port set to 4559
with the incoming port set to 9000. The Sonic Pi programs should point to the host address of your TouchOSC device.

Full details about the program and how to use it are in an article at https://rbnrpi.wordpress.com/project-list/sonic-pi-3-player-recorder-using-touchosc/