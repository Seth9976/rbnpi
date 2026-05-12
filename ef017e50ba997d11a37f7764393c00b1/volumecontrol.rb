#volume control using ramps and rings by Robin Newman May 2017



####following lines illustrate use of * splat operator if uncommented
##| puts range(0, 1.01, 0.01)
##| puts *range(0, 1.01, 0.01)
##| puts (ramp *range(0,1.01,0.01))
v = (ramp *range(0, 1.01, 0.01)) #extended range to 1.01 to include value 1.0
use_bpm 120
puts v


with_fx :gverb,room: 25, mix: 0.6 do
  live_loop :pl1 do
    use_synth :saw
    play scale(:c3,:major).choose,amp: v.tick - v.look(:down),release: 1 #use two ramps and subtract second to reduce volume
    tick(:down) if look >200 #second tick starts after 200 ticks
    if look > 400 #after 400 ticks reset both tick counters and start again
      tick_reset;tick_reset(:down)
    end
    sleep 0.1
  end
  
  sleep 5
  
  live_loop :pl2 do #similar to loop pl1 but different limits for tick counters
    use_synth :tri
    play scale(:g4,:major).choose,amp: v.tick - v.look(:down),release: 1
    tick(:down) if look >100
    if look > 200
      tick_reset;tick_reset(:down)
    end
    sleep 0.1
  end
  
  sleep 10
  
  live_loop :pl3 do #a third version with differnt limits again
    use_synth :tb303
    play scale(:c3,:major).choose,amp: v.tick - v.look(:down),release: 1
    tick(:down) if look >100
    if look > 300
      tick_reset;tick_reset(:down)
    end
    sleep 0.1
  end
end


#######following plays continuously with rising and falling volume when uncommented  using ring rather than ramps
##| vr=range(0,1.01,0.01)
##| vrdown=range(0.99,0,-0.01)
##| vr=vr+vrdown
##| puts vr
##| live_loop :pl4 do
##|   use_synth :tri
##|   play scale(:c4,:major).choose,amp: vr.tick
##|   sleep 0.1
##| end


