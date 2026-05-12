#!/usr/bin/ruby
`/usr/local/bin/sonic_pi stop`
`/usr/local/bin/sonic_pi "run_file '/Users/rbn/Documents/SPfromXML/BWV588Midi.rb'"`

#This file stops SP and then runs the BWV588Midi.rb file again using a run_file command
#it utilises the sonic-pi-cli gem
#adjust path for BWV588Midi.rb to suit your installtion
#install sonic-pi-cli for system ruby in /usr/bin/ruby
#use sudo gem install sonic-pi-cli
#This should give binary  /usr/local/bin/sonic_pi
#If you use rvm, you can install the gem for your current ruby, but you need to use a wrapper to run it
#using the system ruby supplied by apple is easier here