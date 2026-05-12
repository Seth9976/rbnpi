#dancing notes on a bass drone,osc driven
#by Robin Newman,April 2020
#utilises a "synth" produced from ambi_glass_rub sample
use_osc "localhost",4560
use_osc_logging false
use_cue_logging false
use_debug false
use_bpm 40

use_sample_defaults start: 0.7,attack: 0,decay: 0.1,decay_level: 0.3,sustain: 0,release: 0.25

define :pl do |n,d,pan|
  #78 is normal note for ambi_glass_rub so subtract for relative pitch
  #use +24 to transpose up 2 octaves
  sample :ambi_glass_rub,rpitch: 24+note(n)-78,pan: pan,amp: 0.5  if n !=:r
  sleep d
end

with_fx :reverb,amp: 3,room: 0.8 do
  
  live_loop :tune do #1 x rate
    use_real_time
    dir,pan=sync "/osc*/play1"
    nl=[:ds4,:b3,:fs3,:as3,:gs3,:e4,:cs4,:as3]
    nl=nl.reverse if dir==1
    n=nl.tick
    pl n,0.5,pan
    if look <(4*8-1)
      pan=-pan
      osc "/play1",dir,pan
    else
      tick_reset
      osc "/new"
    end
  end
  
  live_loop :tune2 do #2 x rate
    use_real_time
    dir,pan=sync "/osc*/play2"
    nl=[:ds4,:b3,:fs3,:as3,:gs3,:e4,:cs4,:as3]
    nl=nl.reverse if dir==1 #set direction from incoming osc
    n=nl.tick
    pl n,0.25,pan #set pan from incoming osc
    if look < (4*8-1)
      pan=-pan
      osc "/play2",dir,pan #cue tune 2
    else
      tick_reset #reset ready for next run
    end
  end
  
  live_loop :tune4 do #4 x rate
    use_real_time
    dir,pan=sync "/osc*/play4"
    nl=[:ds4,:b3,:fs3,:as3,:gs3,:e4,:cs4,:as3]
    nl.reverse if dir==1
    n=nl.tick
    pl n,0.125,pan
    if look < (4*8-1)
      pan=-pan
      osc "/play4",dir,pan
    else
      tick_reset
    end
  end
end #reverb


#control section
use_real_time
#set up for drone
with_fx :level, amp: 0 do |drvol|
  with_fx :reverb,room: 0.8 do
    #use octaver with adjusted sub and super levels
    with_fx  :octaver,sub_amp: 2,super_amp: 0.4 do
      use_synth :tri
      play :b2 ,amp: 0.1, sustain: 100
      #fadein drone
      control drvol,amp: 1,amp_slide: 1
      d=-1 #set initial direction of notes
      sleep 1 #allow time for drone start
      3.times do #play sequence three times
        osc "/play1",d,0.3 #pan +- 0.3
        sleep 4
        osc "/play2",d,0.6 #pan +- 0.6
        sleep 2
        osc "/play4",d,0.9 #pan +- 0.9
        d=-d #reverse direction
        sync "/osc*/new" #cue for next run
      end
      control drvol,amp:0,amp_slide: 1 #fade out drone
    end #octaver
  end #reverb
end #level