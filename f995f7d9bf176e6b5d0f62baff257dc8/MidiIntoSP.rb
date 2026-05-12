#experimental program to try out midi in with Sonic-Pi 2.12.0-midi-alpha3 by Robin Newman March 2017
#An Oxygen8 v2 keyboards is connected to my Mac.
#This sends midi signals to the m2o module of osmid which translates the midi to OSC and
#feeds the signals to the osc_cues_port in Sonic Pi
#the midi messages can therefore be detected by judicious use of the sync command
#look at the osmid_m2o and osc_cues logs to figure out the message(s) to intercept
#further useful info in osmid readme files at The osmid distribution is at https://github.com/llloret/osmid
#in my case the keyboard was connected to port 2, and I used the first midi channel (0)
set_sched_ahead_time! 0.1 #reduced this to reduce latency

k=[] #define array to hold received midi data
k[1]=k[6]=k[32]=k[74]=k[52]=0.48;k[71]=k[83]=0 #initialise the controls I used on the Oxygen8 keyboard
#k[1] Modulation Wheel (pitch), k[6] Pan Value,k[32] cutoff, k[71] synth selection,k[83] volume
#k[74] sustain,k[52] release. Your keyboard may use/have different control numbers.
define :norm do |n| #scale 0->127 to 0->1
  return n.to_f/127
end

sn= :tb303 #synth for zoom1 loop
sl=[:tb303,:beep,:prophet,:piano,:zawa,:mod_saw] #synth choice for keyboard
define :synthchoose do |v| #scale 0->1 to 0,1,2,3,4,5`
  return (10*v+0.1).to_i/2
end


live_loop :cc do #loop to extract control change data
  
  c=sync '/midi/2/0/control_change' #wait for cc signal check for port/channel values in log
  
  k[c[2]]=norm(c[3]) #store scaled cc value in appropriate k array position
  
  if c[2]==71 #print out selected synth name, or control + value for other controls
    puts sl[synthchoose(k[71])]
  else
    puts "control",c[2],"value",c[3] ,norm(c[3])#print controller number and value
  end
  #sleep 0.01 #poll every 0.01  Sam Aaron suggested removing this sleep
end


live_loop :zoom1 do #play long note and control pitch,cutoff and volume using three controllers
  use_synth sn
  r=play 100*k[1],sustain: 1000,amp: 0
  10000.times do
    control r,note: 100*k[1],note_slide: 0.1,cutoff: 20+80*k[32],cutoff_slide: 0.1,amp: k[83],amp_slide: 0.1,pan: 2*k[6]-1,pan_slide: 0.1
    sleep 0.1 #poll every 0.1
  end
end


with_fx :gverb,room: 25,mix: 0.4 do #add gverb to kybd loop
  live_loop :kybd do
    s=sync '/midi/2/0/note_on' #wait for note_on
    
    puts s #for testing
    
    #choose synth with cc 71
    
    n= s[2]
    v= norm(s[3]) #velocity value 0 when note goes to off
    synth sl[synthchoose(k[71])],note: n,amp: v,sustain: k[74]*2,release: k[52]*2
    #sleep 0.005  #Sam Aaaron suggested removing this sleep Now plays chords fine!!!!
  end
end

live_loop :bong do #percussion using 6 transport keys on Oxygen8
  #controls 20,21,22,23,24 and 25
  b=sync '/midi/2/0/control_change'
  
  sample :elec_bong, amp: 1.5 if b[2]==20 and b[3]==127
  sample :perc_snap, amp: 0.8 if b[2]==21 and b[3]==127
  sample :bd_haus, amp: 2 if b[2]==22 and b[3]==127
  sample :drum_cymbal_closed, amp: 2 if b[2]==23 and b[3]==127
  sample :loop_amen_full,amp: 2 if b[2]==24 and b[3]==127
  sample :loop_mika,amp: 4 if b[2]==25 and b[3]==127
  sleep 0.1
end
