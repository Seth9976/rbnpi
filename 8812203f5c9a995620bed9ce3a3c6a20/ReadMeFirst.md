This hack is a temporary fix to get Sonic Pi 3.2.2 working with the new pulse-audio environment in the latest Raspberry Pi O
released on 2020-12-02. Do not install it on earlier versions of the OS (unless you have done a apt upgrade)

You also need to install one other package
`sudo apt install pulseaudio-module-jack` for it to work

The file scsynthexternal.rb is a drop in replacement for the file of the same name installed by the sonic-pi_3.2.2_f_armhf.deb
file downloaded from sonic-pi-net The location of the installed file is /opt/sonic-pi/app/server/ruby/lib/scsynthexternal.rb

Download the replacement file into the Downloads folder of your Raspberry Pi. then execute the following commands make a backup
of the original and install the replacement.
```
cd ~/Downloads
sudo mv /opt/sonic-pi/app/server/ruby/lib/sonicpi/scsynthexternal.rb /opt/sonic-pi/app/server/ruby/lib/sonicpi/scsynthexternal.rb.bak
sudo cp scsynthexternal.rb /opt/sonic-pi/app/server/ruby/lib/sonicpi/scsynthexternal.rb
```
to restore the original you can type:
```
sudo mv /opt/sonic-pi/app/server/ruby/lib/sonicpi/scsynthexternal.rb.bak /opt/sonic-pi/app/server/ruby/lib/sonicpi/scsynthexternal.rb
```
I would appreciate feedback on your experience in using this at robin dot newman at gmail dot com
The ideas for this solution came from a post here https://github.com/SebiderSushi/sonic-pi-via-pulseaudio/blob/main/sonic-pi-via-pulseaudio I have merely incorporated them into Sonic Pi.