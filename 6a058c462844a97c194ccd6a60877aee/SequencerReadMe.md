**UPDATED NOVEMBER 13th 2022**
for new format OSC message parsing introduced in Sonic Pi Feb 2020
Use the file Sequencer2.0-RF.rb for Sonic Pi >= 3.2. which uses the new format

The index.xml file will still work, but once you hav it loaded you may like to amend the top label to
Sonic Pi Sequencer 2 by Robin Newman, but this is purely cosmetic and not essential

For convenience I have added 4 specimen json files seq1.json to seq4.json which you can use. You can generate your own otherwise using the write commands in the interface. The location of these files is specified in the program. Adjust to suit your own requirements.

**orginal ReadMe text follows**
These two files comprise a 16 channel sequencer for Sonic Pi 3, controlled by a TouchOSC screen template.
To install the TouchOSC template, download the file index.xml then compress/zip it and rename the resulting file sequencer.touchosc

The resulting file can then be loaded into the TouchOSC editor (downloadable from hexler.net) and then uploaded to your tablet
using the TouchOSC>app available from the App store. There are versions available for android as well.

The Sonic Pi program sequencer-RF.rb is too long to run from a Sonic Pi buffer on the Mac, and you should use
the run_file command to exceute it. eg
```
run_file "/path/to/file/sequencer-RF.rb"
```
The easiest way to do this is to type run_file in an empty Sonic Pi buffer, then to chouse the File Open button, navigate
to the file, but DON'T OPEN IT. instead, drag it with your mouse cursor into the Sonic Pi window and it will
automatically add the path for you. Then cancel the File Open dialog.

Before running the file, adjust the ip address in line 4 to point to your tablet WiFi address. Also on the Tablet
open the TouchOSC prefs and set the OSC connection IP host to the ip of the computer running Sonic Pi. Also check
that the Port (incoming) is set to 4000 and Port (outgoing) is set to 4560. You will also see the local
IP address of your tablet, which should be the IP address set in line 4 of the seqeuncer-RF.rb program.

A full article about the program is on my Wordpress site, and there is also a video on YouTube