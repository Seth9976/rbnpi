#Sonic Pi theremin using time of flight sensor
#tb303 frenzy version!
#by Robin Newman, August 2018 updated August 2020
#experiment changing octs(v+25.8,2) to octs(v+47.9,1) line22

#may want to increase sample default amp to 3 on a Mac
#and decrease tb303 vol from 1.4 to 0.5 on a Mac

use_sample_defaults amp: 2 #for percussion samples
with_fx :reverb,room: 0.8,mix: 0.7 do #can try gverb as well
  use_synth :tb303
  #start long continous note at zero volume: controlled later on by k
  k = play 0,sustain: 10000,amp: 0
  set :k,k #save k pointer in time state as :k
  live_loop :theremin do #start thermin loop
    use_real_time
    b = sync "/osc*/range" #wait for input from python script
    v= (b[0]/8.0)#scale the received data as a float
    puts v #print value on screen
    if v<=48.2 #set limit for high note
        cue :drums #send cue to :dr live loop ty sync percussion
        control get(:k),note: octs(v+25.8,2).tick,amp: 1.4,amp_slide: 0.04,note_slide: 0.04,cutoff: 1.5*v+57,pan: 0.8*(-1)**look 
        else #if outside range then set note volume to zero
          control get(:k),amp: 0,amp_slide: 0.04
        end
        end

        live_loop :dr do
          use_real_time
          sync :drums #only run when theremin playing a note
          tick
          #use three samples with spread to give some funky rhythm
          sample :bd_haus if spread(2,5).look
          sample :elec_twip if !spread(5,8).look
          sample :drum_cymbal_closed if spread(5,8).look
          sleep 0.2 #wait then go back for next cue
        end

        end #fx reverb