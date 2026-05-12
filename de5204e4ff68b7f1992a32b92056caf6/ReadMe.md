Sonic Pi Record / Player version 1.3

This version is updated to work on SP 3.2 or greater. This involves a change which is detailed in teh comments at the beginning of the program. The TouchOSC template is unchanged. I have left it as a MkI TouchOSC file , but you can load it into the latest TouchOSC and it will automatically concert from a .touchosc file to the new .tosc format which will only work in the new version of TouchOSC.

The two other files enable a TouchOSC interface to be used with Sonic Pi 3 and above to allow notes to be played on Sonic Pi, and also recorded in real time for subsequent replay. Recordings can also be stored in files on your computer.

The Sonic Pi program is too long to run in a buffer, and should be run using the run_file command
eg
```
run_file "/path/to/file/recordplayercombined-RF.rb"
```
(The RF in the name reminds you to do this)

The TouchOSC template is the file index.xml This should be downloaded and then compressed or zipped with the resulting file renamed as spRecordPlayer12.touchosc This file should then be loaded into your TouchOSC editor and from there synced to your iPad/iPhone/Android device which is running TouchOSC



You should adjust the IP addresses in the Sonic Pi program to point to your TouchOSC device, and also adjust the OSC settings of that device to point back to your computer running Sonic Pi. The Host address should be set equal to the IP address of your Sonic Pi computer, and the outgoing port set to 4559 with the incoming port set to 9000. The Sonic Pi programs should point to the host address of your TouchOSC device.

This version does not run well on a Raspberry Pi burt requires a more powerful machine like a Mac.

Full details about the program and how to use it are in an article at https://rbnrpi.wordpress.com/sonic-pi-3-player-recorder-version-1-2-using-touchosc/