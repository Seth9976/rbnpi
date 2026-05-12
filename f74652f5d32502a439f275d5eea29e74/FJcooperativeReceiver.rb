#frereJaques cooperation Receiver
#adjust IP address of computer to send to in following line
use_osc "192.168.1.150",4560 #send OSC commands to Sonic Pi port 4560
use_osc_logging false
use_cue_logging false

define :decodeSYML do |nl| #list of symbols in a string
  nl[1..-2].split(",").map {|str| str.strip[1..-1].to_sym}
end
define :decodeFNL do |dl| #list of floating point numbers in a string
  (dl[1..-2].split(",")).map {|str| str.to_f}
end
define :decodeSYM do |symr| #single symbol
  symr.strip[1..-1].to_sym
end

define :pl do |nl,dl,syn=":beep"|
  dd=decodeFNL(dl) #extract data from sent string "[d,d,d,d]"
  nn=decodeSYML(nl) #extract notes from sent string "[:a1,:a2,:a3,:a4]"
  syn2=decodeSYM(syn)
  use_synth syn2
  nn.zip(dd) do |n,d| #play data
    play n,release: d if n!=:r
    sleep d
  end
end

live_loop :pl1 do
  use_real_time
  nt,dr,bpm,syn=sync  "/osc*/play1" #receive data to play
  use_bpm bpm
  puts "rx1"
  pl nt,dr,syn #play it
  osc "/cont1",nt,dr,bpm,syn #send data back to be played
end

live_loop :pl2 do
  use_real_time
  nt,dr,bpm,syn=sync  "/osc*/play2" #receive data to play
  use_bpm bpm
  puts "rx2"
  pl nt,dr,syn #play it
  osc "/cont2",nt,dr,bpm,syn #send data back to be played
end

live_loop :pl3 do
  use_real_time
  nt,dr,bpm,syn=sync  "/osc*/play3" #receive data to play
  use_bpm bpm
  puts "rx3"
  pl nt,dr,syn #play it
  osc "/cont3",nt,dr,bpm,syn #send data back to be played
end

live_loop :pl4 do
  use_real_time
  nt,dr,bpm,syn=sync  "/osc*/play4" #receive data to play
  use_bpm bpm
  puts "rx4"
  pl nt,dr,syn #play it
  osc "/cont4",nt,dr,bpm,syn #send data back to be played
end