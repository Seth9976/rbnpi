#pentatechno by Roboin Newman, March 2016
#exploring the use of ring chain functions
#works on SP2.9

use_debug false
s=scale(:c4,:minor_pentatonic).reflect.repeat(4)
s2=scale(:c4,:minor_pentatonic).reverse.reflect.repeat(4)
kill=0

with_fx :level do |vol|
  control vol,amp: 0
  sleep 0.1 #to stop click
  live_loop :audio do
    tick
    control vol,amp: look.to_f/20 if look <= 20
    control vol,amp: 1 - (look-70).to_f/20 if look >= 70
    if look==90
      kill=1
      stop
    end
    sleep 1
  end
  
  with_fx :reverb,room: 0.6 do
    live_loop :y do
      stop if kill==1
      tick
      use_synth :tb303
      play s.look,release: 0.1,cutoff: 110,amp: 0.5 if spread(7,13).look
      use_synth :dpulse
      play s2.look,release: 0.1,amp: 1 if !spread(9,17).look
      cue :b if look%11==0 and look > 0
      sleep 0.1
      
    end
    
    live_loop :extra, auto_cue: false do
      stop if kill==1
      sync :b
      use_synth :tb303
      with_fx :ixi_techno do
        k=rrand_i(2,10)
        x=(s.reverse.take(k)+s.take_last(k)).shuffle.stretch(3)
        play_pattern_timed x,[0.08]*x.length,release: 0.08,cutoff: 110,pan: ring(-1,-1,1,1).tick
      end
      
    end
    
    live_loop :drums do
      stop if kill==1
      sync :y
      density(ring(1,2,1,1,1,1,2,1,1,1,1,1,2).tick) do
        sample :drum_tom_mid_hard
        sleep 0.2
      end
      sample :sn_dolf,amp: 0.4
      sleep 0.2
      
    end
  end
end