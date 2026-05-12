#Sonic Pi HiHats by Robin Newman May 2023
#demo of new hi-hat samples in action
#program prints sample names, then fades in
#and runs for about 1 minute before fading out and stopping
use_debug false
sample_names(:hat).each do |name|
  puts name
end
set :kill,false
at 65 do
  set :kill,true
end

with_fx :level,amp: 0 do |v|
  set :v,v
  at [0.2,60.2],[1,0] do |l|
    control get(:v),amp: l,amp_slide: 4
  end
  with_fx :reverb, room: 0.6,mix: 0.7 do
    live_loop :x do
      stop if get(:kill)
      density [1,1,2,2,2].choose do
        density dice(2) do
          sample sample_names(:hat).choose,pan: [-1,1].tick,amp: rrand(0.4,1)
        end
        sleep 0.25
      end
    end
  end
end