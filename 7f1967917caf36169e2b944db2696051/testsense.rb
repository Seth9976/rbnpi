#experimental control of SenseHat by OSC
#By Robin Newman
#either sudo python3 sensetestserver.py on client
#or sudo python3 sensetestserverface.py on client
use_osc_logging false
SPoschander_server = "localhost"
use_osc SPoschander_server,8000

##| osc"/led/control",0,0 #uncomment these two lines to stop all leds
##| stop

live_loop :test do
  use_real_time
  x,y=sync "/osc/set/xy"
  tick
  if look%2==0
    puts "x=#{x} y=#{y}"
    synth :tri,note: 48+(x-7)+y*8,release: 0.1
  end
end
live_loop :sendit do
  tick
  if look%2==0
    osc "/led/control",0,1
    play chord(:c4,:major),release: 1
  else
    osc "/led/control",1,0
    play chord(:c4,:minor),release: 1
  end
  
  sleep 1
  osc "/led/control",0,0
  sleep 0.1
end
