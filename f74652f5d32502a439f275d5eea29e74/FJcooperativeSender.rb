#frereJaques cooperation Sender
#adjust IP of computer to send to in next line
use_osc "192.168.1.129",4560 #send OSC commands to Sonic Pi port 4560
use_osc_logging false
use_debug false
set :bpm,180
use_cue_logging false
define :decodeSYML do |nl| #list of symbols in  string
  nl[1..-2].split(",").map {|str| str.strip[1..-1].to_sym}
end
define :decodeFNL do |dl| #list of floating point numbers in a string
  (dl[1..-2].split(",")).map {|str| str.to_f}
end
define :decodeSYM do |symr| #decode single symbol
  symr.strip[1..-1].to_sym
end

#tune data: notes and durations for each section
f1=[:c4,:d4,:e4,:c4];f2=[:e4,:f4,:g4];f3=[:g4,:a4,:g4,:f4,:e4,:c4];f4=[:c4,:g3,:c4]
d1=[1,1,1,1];d2=[1,1,2];d3=[0.5,0.5,0.5,0.5,1,1];d4=[1,1,2]

fl=[f1,f2,f3,f4] #full tune list
dl=[d1,d2,d3,d4] #full data list
#plays list of notes/durations with synth syn (all as strings)
define :pl do |nl,dl,syn|
  nn=decodeSYML(nl) #convert incoming notes from string to list
  dd=decodeFNL(dl) #convert incoming durations from string to list
  syn2=decodeSYM(syn) #convert syn from string to symbol
  use_synth syn2
  nn.zip(dd) do |n,d| #play corresponding note/duration pairs
    play n,release: d if n != :r
    sleep d
  end
end

set :flag,0 #flag to control cue to start live_loop :tune
live_loop :tune do
  use_real_time
  sync :one if get(:flag)==1 #ignore until flag ==1
  syn=:tri
  
  puts "t1"
  4.times do |i|
    cue :two if i==1 #(start of 2nd iteration
    bpm=get(:bpm)
    osc "/play1",fl[i],dl[i],bpm,syn #send data to play
    nr,dr,bpm,syn=sync "/osc*/cont1" #receive data to play
    use_bpm bpm
    pl nr,dr,syn #play it
  end
end

live_loop :tune2 do
  use_real_time
  
  syn=:tb303
  sync :two
  puts"t2"
  4.times do |i|
    cue :three if i==1
    bpm=get(:bpm)
    osc "/play2",fl[i],dl[i],bpm,syn #send data to play
    nr,dr,bpm,syn=sync "/osc*/cont2" #receive data to play
    use_bpm bpm
    pl nr,dr,syn #play it
  end
  
end

live_loop :tune3 do
  use_real_time
  syn=:saw
  sync :three
  puts "t3"
  4.times do |i|
    cue :four if i==1
    bpm=get(:bpm)
    use_bpm bpm
    osc "/play3",fl[i],dl[i],bpm,syn #send data to play
    nr,dr,bpm,syn=sync "/osc*/cont3" #receive data to play
    pl nr,dr,syn #play it
  end
  
end
live_loop :tune4 do
  use_real_time
  set :flag,1 #enable cue to start live_loop tune
  syn=:prophet
  sync :four
  puts "t4"
  4.times do |i|
    bpm=get(:bpm)
    osc "/play4",fl[i],dl[i],bpm,syn #send data to play
    
    nr,dr,bpm,syn=sync "/osc*/cont4" #receive data to play
    use_bpm bpm
    pl nr,dr,syn #play it
  end
  set :bpm,[240,300,360,420].tick
  stop if look==4
  sleep 0.05 #bodge to make sure bpm is set
  cue :one #cue live_loop:tune  
end