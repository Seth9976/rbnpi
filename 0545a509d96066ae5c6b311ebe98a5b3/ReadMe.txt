These files accompany a video at https://youtu.be/K1KQSFiHg6I which explores the use of a GUI to control a Sonic Pi program
running code to drive an external midi player. (I used Logic Pro) It currently works with SP2.12.0-midi-alpha1 on a Mac,
but may probably break on future versions. It is intended to show some concepts, particularly the use of a GUI written
in processing which can control SP by means of OSC messages. The source code of the processing sketch is included.
It also illustrates a technique to allow a Sonic Pi piece to be started at any bar, by calculating the start note for
each of the parts concerned. It can handle a tied note already playing at the start of the selected bar.
The final technique utilised is to use an external script utilising calls to the Sonic Pi cli interface gem to stop
Sonic Pi running and then to restart the program using a run_file command. In this way, Sonic Pi can respond to
a stop singal from the GUI and then restart playing when a subsequent Play cue is received via an OSC message.

There are some further bits you will ahve to sort out. EG setting up the audio midi program so that Sonic PI can
communicate with your midi player. See a picture in the video which shows this.

FILES: BWV588.rb is run in a SP buffer. BWV588auto.rb is accessed from a specified location by BWV588.rb
Processing 3 should be installed and then the StartBarSelector.txt is pasted into a new sketch, which is then run to create
the GUI. You need to speficy the address of the machine running SP in the script, (or leave if the local machine)