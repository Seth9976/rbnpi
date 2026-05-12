#Demo program gpiocontrol.rb to control GPIO devices from Sonic Pi
#and to receive data to play from a GPIO button being pressed
#written by Robin Newman, July 2017

SPoschandler_server = "192.168.1.234" #adjust for your own setup
use_osc SPoschandler_server,8000 #SPoschandler_Server on port 8000

define :all_off do
  osc  "/led/control",0,0
end
define :do_testprint do
  osc "/testprint","This is a test message with data",1,2,"The end"
end

##| all_off #uncomment these two lines to turn all leds off and stop
##| stop

live_loop :testprinting do
  use_real_time
  do_testprint # try out the testprint OSC message. Should print on the Pi terminal screen
  sleep 2
end

live_loop :test do
  use_real_time
  n= sync "/osc/play"
  puts n
  use_synth :tri
  play n,sustain: 0.05,release: 0.2
end

live_loop :m do
  use_real_time
  s=scale(:c4,:minor,num_octaves: 2).tick
  play s,release: 0.1
  #uncomment ONE of the next two lines to alter the response of the LEDS
  if s >note(:c4)+12
  #if look%2==0
    osc "/led/control",1,0
  else
    osc "/led/control",0,1
  end
  sleep 0.2
end
