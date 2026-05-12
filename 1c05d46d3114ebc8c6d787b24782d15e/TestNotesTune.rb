# Test all notes for Sonic Pi glockenspiel by Robin Newman June 2018
use_osc "localhost",8000

define :notenum do |n|
  nl=(scale :c6,:major,num_octaves: 2).to_a[0..9]+[note(:fs6)]
  #puts nl
  return nl.index note(n)
end

live_loop :testnotes,delay: 0.5 do
  tune = (ring :c6,:e6,:g6,:c7,:e7,:c7,:b6,:a6,:g6,:f6,:e6,:d6,:c6,:fs6,:d7)
  osc "/note",notenum(tune.tick)
  sleep 0.2
end