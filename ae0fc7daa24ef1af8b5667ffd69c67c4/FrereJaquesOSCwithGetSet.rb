#Frere Jaques played on Sonic Pi 3.0 entirely using OSC messages
use_osc "localhost",4559
t=180
set :tempo,t #use set to store values that will be passed to live_loops
use_bpm t

p=0.2;m=0.5;f=1 # volume settings
#store data using set function so that it can be retrieved in live_loops
set :notes,(ring :c4,:d4,:e4,:c4,:c4,:d4,:e4,:c4,:e4,:f4,:g4,:e4,:f4,:g4,:g4,:a4,:g4,:f4,:e4,:c4,:g4,:a4,:g4,:f4,:e4,:c4,:c4,:g3,:c4,:c4,:g3,:c4)
set :durations,(ring 1,1,1,1,1,1,1,1 ,1,1,2,1,1,2, 0.5,0.5,0.5,0.5,1,1,0.5,0.5,0.5,0.5,1,1, 1,1,2,1,1,2)
set :vols,(ring p,p,m,p,p,p,m,p,p,m,f,p,m,f,m,m,m,m,f,m,m,m,m,m,f,m,f,f,f,f,f,f)
set :synths,(ring :tri,:saw,:fm,:tb303)

live_loop :playosc do # this loop plays the received osc data
  use_real_time
  n,d,v,s,tempo= sync "/osc/hello/play" #retrieve data from OSC message
  
  use_bpm tempo
  use_synth s
  play n,amp: v,sustain: d*0.9,release: d*0.1
end

live_loop :sendosc do
  #retrieve dfata from main program using get functions
  s=get(:synths).tick
  notes=get(:notes)
  durations=get(:durations)
  vols=get(:vols)
  tempo=get(:tempo)
  use_bpm tempo #set local tempo for this loop
  notes.zip(durations,vols).each do |n,d,v|
    osc "/hello/play",n,d,v,s,tempo #send OSC message with note data
    sleep d
  end
end

live_loop :sendosc2,delay: 8 do
  #retrieve dfata from main program using get functions
  s=get(:synths).tick
  notes=get(:notes)
  durations=get(:durations)
  vols=get(:vols)
  tempo=get(:tempo)
  use_bpm tempo #set local tempo for this loop
  notes.zip(durations,vols).each do |n,d,v|
    osc "/hello/play",n,d,v,s,tempo #send OSC message with note data
    sleep d
  end
end

live_loop :sendosc3,delay: 16 do
  #retrieve dfata from main program using get functions
  s=get(:synths).tick
  notes=get(:notes)
  durations=get(:durations)
  vols=get(:vols)
  tempo=get(:tempo)
  use_bpm tempo #set local tempo for this loop
  notes.zip(durations,vols).each do |n,d,v|
    osc "/hello/play",n,d,v,s,tempo #send OSC message with note data
    sleep d
  end
end
