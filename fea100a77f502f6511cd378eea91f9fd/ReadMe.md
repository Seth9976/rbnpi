These 5 files can be used to play Pachabel's Canon in D on either one or four computer sunning Sonic PI 3.1 or greater.
For a single computer use the file PachabelCanon-RF.rb, which must be run from a sonic pi buffer using the code: 
run_file "/path/to/file/PachabelCanon-RF.rb

Alternatively the files PachabelCaonon-part1.rb to PachabelCaonon-part4.rb can be loaded into separate buffers 
on the SAME computer. In this case select the buffers for part1 to part4 in turn and run them. When part4 is run 
it will send an OSC code which will be picked up by the other three buffers and they will all start playing. The osc_send 
commands in part4 which contain ip addresses will be ignored in this case.

To play on FOUR separate computers load each of the files part1 to part4 onto a separate computer's Sonic Pi. Adjust the IP 
addresses in part4 to suit the IP addresses of the computers you are using for parts 1 to 3. Then start the Sonic Pi programs 
on the machines with parts 1 to 3 running. Finally run the program for the machine with part4 and this will start the 
machines playing together. You can get the IP addresses by looking at the Preferences IO tab. Also make sure that the boxes 
for Enable OSC server and Send/Receive remote OSC on the IO preferences tab are all ticked on all four machines.

If you decide to try the four files on a single Sonic Pi, then you may like to add pan settings to the four parts, as in the PachabelCanon-RF.rb file. It will give better separation of the parts. When they are played on separate computers, their speaker  placing can have the same effect.