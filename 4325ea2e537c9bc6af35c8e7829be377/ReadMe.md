There are three ways to use these files.
OdeToJoy-RF.rb can be played in a single computer running Sonic Pi using the command.

run_file "path/to/location/of/odeToJoy-RF.rb"

Secondly files OdeToJoyBASS.rb OdeToJoyBASSOON.rb and OdeToJoyVIOLIN.rb can be loaded into three separate buffers 
on the same instance of Sonic Pi. Start the 2nd and third files running, then switch to the buffer containing 
OdeToJoyBASS.rb and run that to sync the whole sequence starting together.

Thirdly use three computers running Sonic Pi on the same local network preferrably hard wired and load the files 
OdeToJoyBASSOON.rb and OdeToJoyVIOLIN.rb into two of them, starting the programs running. Load the alternative file 
OdeToJoyBASSv2.rb into the third computer, and adjust the two IP addresses in lines 6 and 7 to point to the other two computers. 
Then run that file to start the whole sequence running.