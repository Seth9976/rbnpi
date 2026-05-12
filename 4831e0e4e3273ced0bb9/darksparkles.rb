#dark sparkles by Robin Newman, January 2016
#inspired by testing the new octs function in SP2.10dev
#it is written so this is NOT necessary, and it will work on sp2.6 onwards
l=ring(0.1,0.2,0.3,0.4,0.3,0.2,0.1) #note durations
c=ring(36,48,60,72,84,96) # from sp2.10dev use octs(:c2,6)
d=ring(5,0,-7) #chooses offsets

numcycles=8 #each synth voice gives a cycle. 8 cycles uses 4 synths twice

use_debug false
with_fx :reverb,room: 0.8 do
  with_fx :level do |v| # used to fade vol in at start and out at the end
    control v,amp: 0 #set start volume
    live_loop :darksparkles do
      tick
      tick_set :p,(look/36 %3) #used to change offset
      tick_set :q,(look/72 %4) #used to change synth
      #next two lines control fade in and face out of sound level
      control v, amp: (look.to_f)/36 if look <= 36
      control v, amp: (72*numcycles-look).to_f/72 if look >= 72*(numcycles-1)
      use_synth ring(:tri,:mod_saw,:tb303,:mod_tri).look(:q)
      offset=d.look(:p)
      #next two lines play the notes
      play (c.look)+offset,pan: rrand_i(-1,1) if spread(5,8).look
      play (c.reverse.look)-7+offset,pan: rrand_i(-1,1) if !spread(5,8).look
      #now add a bass drone fading in and out
      with_synth :dsaw do #bass synth
        play c[0]+offset,detune: -12,attack: 0.75,decay: 0.75 if look%36 == 0
      end
      sleep l.look
      #stop after required number of cycles (-1 as look starts at 0)
      stop if look == 72*numcycles - 1
    end
  end
end
