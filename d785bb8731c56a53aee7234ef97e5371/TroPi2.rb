
#drive TroPi board using OSC messages
#by Robin Newman, October 2018
use_osc "127.0.0.1",8000
set :kill,false


use_real_time
osc "/clearAll" #clear the display
sleep 0.5
uncomment do
  
  set :pc1,false
  sleep 0.2
  live_loop :pl do
    use_synth :tb303
    puts "here"
    play scale(:e2,:minor_pentatonic,num_octaves: 2).choose,release: 0.2,cutoff: rrand(80,110),amp: 0.5
    sleep 0.2
    stop if get(:pc1)
  end
  
  
  6.times do
    osc "/gradientAll",'red','green',20,40,4 #change from red to green in 20 steps of 40ms
    sync "/osc/gradientalldone4" #cued when finished
    osc "/gradientAll",'green','blue',20,40,5 #change from green to blue
    sync "/osc/gradientalldone5"
    osc "/gradientAll",'blue','red',20,40,6 #change from bue to red
    sync "/osc*/gradientalldone6"
  end
  osc "/clearAll" #clear display
  set :pc1,true
  sleep 2
  set :pc2,false
  live_loop :p2 do
    use_synth :tri
    puts "here"
    play scale(:e3,:minor_pentatonic,num_octaves: 2).choose,release: 0.1
    sleep 0.1
    stop if get(:pc2)
  end
  
  d=1.5
  3.times do
    osc "/gradientUpDownAll",'black','red',10,50 #fade black->red->black
    sleep d
    osc "/gradientUpDownAll",'black','green',10,50 #fade black->green->black
    sleep d
    osc "/gradientUpDownAll",'black','blue',10,50 #fade black->blue->black
    sleep d
    osc "/gradientUpDownAll",'black','yellow',10,50 #fade black->yellow->black
    sleep d
    osc "/gradientUpDownAll",'black','magenta',10,50 #fade black->magenta->black
    sleep d
  end
  set :pc2,true
  sleep 2
  set :pc3,false
  live_loop :p3 do
    sample :loop_amen_full,beat_stretch: 7.7
    sleep 7.7
    stop if get(:pc3)
  end
  tt=vt
  d=0.75
  10.times do #alternately turn on 0,2,4 then 1,3 leds
    osc "/setOne",0,['red','green','blue'].choose
    osc "/setOne",2,['red','green','blue'].choose
    osc "/setOne",4,['red','green','blue'].choose
    sleep d
    osc "/setOne",0,'black'
    osc "/setOne",2,'black'
    osc "/setOne",4,'black'
    osc "/setOne",1,['cyan','yellow','magenta'].choose
    osc "/setOne",3,['cyan','yellow','magenta'].choose
    sleep d
    osc "/setOne",1,'black'
    osc "/setOne",3,'black'
    
  end
  osc "/clearAll"
  puts vt-tt
  set :pc3,true
  sleep 2
  set :pc4,false
  live_loop :p4 do
    sample :loop_garzul,beat_stretch: 8
    sleep 8
    stop if get(:pc4)
  end
  tt=vt
  osc "/gradientToFro",'red','green',100,100,0
  sync "/osc/gradienttofrodone0"
  osc "/clearAll",0
  sync "/osc/clearalldone0"
  osc "/gradientSlide",'blue','red',100,100,0
  sync "/osc/gradientslidedone0"
  osc "/gradientSlide",'red','blue',100,100,0
  sync "/osc*/gradientslidedone0"
  osc "/clearAll",0
  sync "/osc/clearalldone0"
  puts vt-tt #36.47
  set :pc4,true
  sleep 2
end #comment
uncomment do
  use_synth :tb303
  col=(ring,'navy', 'mediumblue', 'blue', 'darkgreen', 'green', 'darkcyan',   'cyan',
       'maroon', 'purple', 'darkred', 'darkmagenta',
       'yellowgreen', 'red', 'fuchsia', 'magenta', 'deeppink', 'orangered', 'tomato',
       'orange',  'lemonchiffon', 'yellow',  'white')
  live_loop :disrupter_flash do
    n=rand_i(5)
    osc "/setOne",n,col.tick
    puts(col.length,look,col[look])
    play scale(:c4,:major)[n],release: 0.3,cutoff: rrand(50,110),amp: 0.5
    sleep 0.15
    osc "/setOne",n,'black'
    stop if get(:kill)
    sleep 0.15
  end
end

8.times do
  osc "/gradientUpDown1",0,'black','green',20,10,0
  sync "/osc/gradientupdown1done0"
  
  osc "/gradientUpDown1",1,'black','blue',20,10,0
  sync "/osc*/gradientupdown1done0"
  
  osc "/gradientUpDown1",2,'black','yellow',20,10,0
  sync "/osc/gradientupdown1done0"
  
  osc "/gradientUpDown1",3,'black','cyan',20,10,0
  sync "/osc/gradientupdown1done0"
  
  osc "/gradientUpDown1",4,'black','red',20,10,0
  sync "/osc/gradientupdown1done0"
  osc "/clearAll"
end
set :kill,true
osc "/gradientAll",'red','black',50,120
sample :ambi_lunar_land,amp: 5

