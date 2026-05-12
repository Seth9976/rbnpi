These files contain software to run a solenoid operated glockenspeil controlled by Sonic Pi running on a   Raspberry Pi 3.
It is also possible to control it from a remote instance of Sonic Pi 3 running on a separate computer.
The first pice of software is a python script which controls the GPIO pins connected to the solenoid circuitry
using received OSC messages received from Sonic Pi
The remaining software consists of various scripts which can be run on Sonic Pi to play the glockenspiel.
These are constrained by the range of notes available on the glockenspiel.
Full contructional details of the glockenspiel are on my blgo https://rbnrpi.wordpress.com