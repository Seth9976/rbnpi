#This program polls the keyboard and then maps the code for detected keys to midi note values
#which are tranmsitted to the new OSC-API in Sonic Pi
#Warning THIS API IS EXTREMEMLY EXPERIMENTAL AND MAY CHANGE (current version 2.11 dev 2d13e)
#This script runs in a terminal window. Once the SP script is running, type in the terminal window to send key presses.
require 'io/wait'
require 'socket'
require 'rubygems'
require 'osc-ruby'

client ||= OSC::Client.new('localhost', 4559) #set up OSC channel to port 4559

def char_if_pressed #routine to scan for keyboard press (non-blocking)
  begin
    system("stty raw -echo") # turn raw input on
    c = nil
    if $stdin.ready?
      c = $stdin.getc
    end
    c.chr if c
  ensure
    system "stty -raw echo" # turn raw input off
  end
end

nIn=[39,59,92,93,97,100,101,102,103,104,106,107,108,111,112,115,116,117,119,121] #ascii numbers from keyboard
nOut=[77,76,79,78,60,64,63,65,67,69,71,72,74,73,75,62,66,70,61,68] #midi number mapped by hash
nV=nIn.zip(nOut).to_h

while true #main loop, runs until stopped by ctrl-c
  k=0 #0 will be transmitted if no key pressed
  c = char_if_pressed
  k= "#{c}".ord if c #work out ascii value of key
  
  if k>0 then
    note="#{nV[k]}".to_i #use the hash to get the correspending midi note (if any is mapped)
    if note > 0 then #only process mapped notes
      prepared_command = OSC::Message.new("/kyb", note) #transit the note info as an osc message to /kyb
      client.send(prepared_command)
      puts note #visual feed back in terminal
    end
  end
  sleep 0.01 #short gap
end