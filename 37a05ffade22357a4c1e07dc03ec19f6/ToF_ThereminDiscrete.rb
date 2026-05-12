#Sonic Pi theremin using time of flight sensor VL531X
#Discrete note version (c: major {changeable})
#by Robin Newman, August 2018 updated August 2020
with_fx :reverb,room: 0.8,mix: 0.7 do
  use_synth :tri
  #start long note at zero volume: will be controlled later by k
  k = play octs(0,2),sustain: 10000,amp: 0
  set :k,k #store k in time-state reference :k
  live_loop :theremin do
    use_real_time
    b = sync "/osc*/range" #get osc message from sensor script. Syntax updated
    v= (b[0]/12.0).to_i #scale reading and convert result to integer
    puts v #print on screen
    # puts scale(:g3,:major,num_octaves: 5).length #for debugging puts total no notes
    if v < 36
      #change the scale if you wish. (may need to change note range too)
      nv=scale(:g3,:major,num_octaves: 5)[v] #get note pitch from c scale
      #control the note and set the pitch and volume
      control get(:k),note: nv,amp: 1,amp_slide: 0.04
    else
      #if v is too high then set volume to zero
      control get(:k),amp: 0,amp_slide: 0.04
    end
  end

end #fx reverb