#terminal ruby program to get and transmit key info
#written by Robin Newman, April 2016
# use in conjunction with SP-KeyboardController.rb running in Sonic Pi
require 'io/wait'
require 'socket'

server = TCPServer.new 2016 #set up transmit tcp socket

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

while true #main loop, runs until stoped by ctrl-c
k=0 #0 will be transmitted if no key pressed
c = char_if_pressed
k= "#{c}".ord if c #work out ascii value of key
client = server.accept    # Wait for a client to connect
client.puts k #transmit the keycode
client.close #close the client terminating input
sleep 0.02 #short gap
end