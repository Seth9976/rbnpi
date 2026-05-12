#sonic pi code by Robin Newman, Dec 31 2022
#drives sketch on hydra.ojack.xyz running on Chrome browser
#requires Sonic Pi audio output looped back to Chrome browser
use_midi_defaults channel: 1,port: "iac_driver_bus"
set :kill,false
midi_cc 4,1
comment do #uncomment to stop Bass note will take time to die away
  midi_cc 4,0
  set :kill,true
end
use_midi_logging false
use_debug false
sf=2

live_loop :mid0 do
  stop if get(:kill)
  midi_cc 0, [3,6,9,5,10,15].tick # sends to control 0 a random integer between 3 and 6
  sleep 0.125*sf
end
live_loop :mid1 do
  stop if get(:kill)
  midi_cc 1,[0,1].tick
  sleep 0.125*sf #rates of change of r,g,b cc all different
end
live_loop :mid2 do
  stop if get(:kill)
  midi_cc 2,[0,1,].tick
  sleep 0.25*sf
end
live_loop :mid3 do
  stop if get(:kill)
  midi_cc 3,[1,0,0,0,1,1,1,1].tick #mask out possibility of r,g,b cc all 0
  sleep 0.5*sf
end

with_fx :reverb,room: 0.7,mix: 0.7 do
  live_loop :aud do
    stop if get(:kill)
    if tick%64 == 0
      use_transpose [0,5,7,-5].tick(:tr)
      if look(:tr)==4
        set :kill,true
        midi_cc 4,0
      end
      synth :fm,note: (octs :e2,3),sustain: 10*0.125*sf,release: 64*0.125*sf,amp: 2
    end
    
    density dice(2) do
      use_synth :tb303
      k=play scale(:e2,:minor_pentatonic,num_octaves: 2).choose,release: 0.125*sf*2,cutoff: rrand_i(70,110)
      control k,cutoff: 100,cut_off_slide: 0.125*sf*2
    end
    sleep [0.125*sf,0.25*sf].choose
  end
end

