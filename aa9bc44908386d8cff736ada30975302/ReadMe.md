EXPERIMENTAL PROGRAMS TO SYNC TWO MACHINES RUNNING SONIC PI TOGETHER

These programs utilise experimental commands in Sonic Pi 2.12beta (after commit #78b2216).
The first of the experimental commands lets you send OSC messages to a specified port on your local machine
```
use_osc "localhost",8000
```
The second ```osc ``` lets you send an OSC message, which is specified in the command line.
Sonic Pi can receive external OSC messages on port 4557 (which can handle commands to run Sonic Pi code,
and is used by the sonic-pi-cli gem written by Nick Johnstone.
However recently port 4559 has been opened for the specific purpose of receiving commands
which are expected to be exernally generated sync commands, which can also incorporate additional paremeters.
These can have a simple format like
```
osc "\waitforit","c4",1.5,60
```
which works like a sync command with three parameters. These can be extracted using
```
s=osc "\waitforit,"c4",1.5,60
nvalue=s[0]
durationvalue=s[1]
tempovalue=s[2]
```
By sending a succession of such cues, it is possible to play a lisat of notes accurately synced to the originating machine,
and this is what these demonstration programs show.

At present, Sonic Pi is limited to using the use_osc command only on the local machine, and port 4557 and 4559
will also only accept input from the local machine, for security reasons. It may be later, that port 4559
will be able to accept OSC messages directly produced from external (ip) sources.
At present, the way round this is to use two processing scripts, one running on each machine to act as intermediary relays
for the osc messages. The two scripts concerned are not difficult to follow. On the orginating computer, the script
accepts OSC messages on port 8000, and then rebroadcasts them to the receiving computer (in my case on ip address 192.168.1.33)
to port 8000. On the receiving computer, the processing scripts listens on port 8000 and rebroadcasts to the local machine
on poert 4559 (the "sync" port for Sonic Pi)

There is one receiving program which runs in a buffer on teh receiving machine;s Sonic Pi. This has a live_loop which waits
for the incoming sync, matches the namein to /waitforit and then extracts the threee parameters.

(NEXT SECTION REMOVED****)

There are two alternative
routes through the rest of the loop which depend on whether single notes are being sent, or whether chord info si being
sent with two or more notes sounding together. A slightly differnt extraction mechanism is required ineach case, and is
selected according to the length of the first parameter.)

**** Sam Aaron suggested that it was unwise to have to use eval of a string in the receive program, becuase of possible mal use. Instead I have rewritten the BachSend2.rb program so that chords are preprocessed and sent as a series of single notes one after the other. Experiments show that this only introduces a delay between "concurrent" notes of 0.0008 seconds which is acceptable. He also said that the intention was for use-osc to be able to communicate with external ip addresses, so this may obviate the use of the process sketch on teh transmitting side, when it is adjusted.

In the examples, the bpm paramter is constant throughout, but it can handle pieces where there is more than one component to
the array of notes eg a1[0] and a1[1] etc.... and each can have separate bpm settings.

I hope that this brief outline will help you to understand what is going on, and how the system works.

Finally, just to emphasise that this code is experimental. The commands in Sonic Pi are NOT fixed and will more than likely change,
but it is still instructive and fun to try this out. Just make sure you have the appropriate version of SP2.12beta

If you have not used processing before then just download the app from https://processing.org/download/ Put the the two .pde files into the processing folder which will be created in your My Documents folder when you run the app. When you the select and open the script (they are called sketches) it will aotomatically create a folder of teh same name and place it in that for you. To run the script you click on the arwow head as shwon in the video
