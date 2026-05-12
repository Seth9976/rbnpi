# Sonic Pi Jukebox Program  (version 2)
change: path variable added for sonic-pi-cli binary sonic_pi so program can be configured to work on a Mac as well as a Pi

The jukebox.rb program, downloaded from the next file, should be run in an xterminal window in the gui, with Sonic Pi also loaded and running. Requires installation of sonic-pi-cli from https://github.com/Widdershin/sonic-pi-cli

Install this with:

cd ~

git clone https://github.com/Widdershin/sonic-pi-cli.git

followed by

sudo gem install sonic-pi-cli


You should first have some Sonic Pi files in place ready to be chose by the jukebox. You can download some sample files in the Pi home directory with wget http://r.newman.ch/rpi/telegram/jukeboxfiles.tar.gz

Untar the files with tar zxvf jukeboxfiles.tar.gz

The folder contains three further tarred files

tar zxvf jukeboxfiles/linkedSP.tar.gz

tar zxvf jukeboxfiles/samplesv2.tar.gz

tar zxvf jukeboxfiles/spfilesv2.tar.gz

Then save the file jukebox.rb from this gist to your homw directory

You may have to alter the path varaibles at the start of teh program to suit your system. e g to alter desired locations of the Sonic Pi music and samples files, or to allow for different locations of the sonic_pi cli binary file. You can find the location by typing which sonic_pi in a terminal window

Start the file with ./jukebox.rb (or with ruby jukebox.rb

Listall gives the commands