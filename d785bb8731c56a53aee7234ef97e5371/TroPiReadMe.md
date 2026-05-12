This projects lets Sonic Pi 3 drive a piborg TroPi board pupilated with 5 rgb leds.
The python script dives the bard and also acts as an OSC server which receives
OSC messages sent from Sonic Pi which activate differnt colour sequences on the board.

You need to install python-osc on the Raspberry Pi using `sudo pip3 install python-osc`
You also need to install the colourzero libarary using `sudo apt install python3-colorzero`

Finally you need to download the software associated with the piborg board from
`https://github.com/piborg/tropi`

The piborg file tropi.py and my file rbn.py should be in the same folder.
Set the python script rbn.py executable using `chmod +x rbn.py` and run it
using `./rbn.py`
Then start Sonic Pi (usually on the same Pi3 into which the TroPi board is plugged).
and run the Sonic Pi program TroPi2.rb

As supplied, the programs are configured to be on the same computer. YOu can also run
the TroPi board and python script on a separate computger to the one running Sonic Pi
In this case you need to know the ip address of this Pi, and the ip address of the computer
running Sonic Pi. Start the pythion script using
`./rbn.py -ip <ip.address.of.tropi.computer> -sp <ip.address.of.sonicpi.computer>`
Also alter line 4 of the TroPi2.rb file from
`use_osc '127.0.0.1',8000` to `use_osc '<ip.address.of.tropi.computer>`,8000`