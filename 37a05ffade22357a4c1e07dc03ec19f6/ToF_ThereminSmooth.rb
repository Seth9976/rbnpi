#Sonic Pi theremin using time of flight sensor
#smooth continuous note pitch version
#by Robin Newman, August 2018 updated August 2020
#works on Mac or Pi3
with_fx :reverb,room: 0.8,mix: 0.7 do
  use_synth :dpulse
  #start long note at zero vol. It will be controlled by k later
  k = play 0,sustain: 10000,amp: 0
  set :k,k #store k pointer in time-state as :k
  live_loop :theremin do
    use_real_time
    b = sync "/osc*/range" #syntax updated
    v= (b[0].to_f/10) #scale and convert range data to a float
    puts v #put value on screen
    if v<=48.2
      #control the note retrieving :k pointer and adjusting pitch and amp
      control get(:k),note: v+47.9,amp: 0.7,amp_slide: 0.04,note_slide: 0.04
    else
      #if range too high set vol to 0
      control get(:k),amp: 0,amp_slide: 0.04
    end
  end
  
end #fx reverb