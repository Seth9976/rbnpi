#Bobbie Shaftoe arranged for Sonic Pi glockenspeil by Robin Newman June 2018
use_osc "localhost",8000
use_debug false
define :notenum do |n|
  nl=(scale :c6,:major,num_octaves: 2)[0..9]+[note(:fs6)]
  return nl.index note(n)
end

use_synth :pluck
use_bpm 240

bs=[:g6,:g6,:g6,:c7,:b6,:d7,:b6,:g6,
    :d6,:d6,:d6,:g6,:fs6,:a6,:fs6,:d6,
    :g6,:g6,:g6,:c7,:b6,:d7,:b6,:g6,
    :a6,:c7,:a6,:fs6,:g6,:g6,
    :b6,:d7,:b6,:g6,:b6,:d7,:b6,
    :a6,:c7,:a6,:fs6,:a6,:c7,:a6,
    :b6,:d7,:b6,:g6,:b6,:d7,:b6,
    :a6,:c7,:a6,:fs6,:g6,:g6
    ]
bs2=[:g5]*8+[:d5]*8+[:g5]*8+[:fs5]*4+[:b4]*2+
  [:g5,:b5,:g5,:d5,:g5,:b5,:g5,
   :fs5,:a5,:fs5,:d5,:fs5,:a5,:fs5,
   :g5,:b5,:g5,:d5,:g5,:b5,:g5,
   :fs5,:a5,:fs5,:d5,:b4,:g4]
  
dur=[1,1,1,1,1,1,1,1,
     1,1,1,1,1,1,1,1,
     1,1,1,1,1,1,1,1,
     1,1,1,1,2,2,
     1,1,1,1,1,1,2,
     1,1,1,1,1,1,2,
     1,1,1,1,1,1,2,
     1,1,1,1,2,2]
2.times do #play through twice
  in_thread do
    sleep rt(0.3) #allow for Pi3 audio latency
    bs.zip(dur).each do |n,d|
      osc "/note",notenum(n)
      sleep d
    end
  end
  with_fx :reverb,room: 0.7,mix: 0.6 do
    bs2.zip(dur).each do |n,d| #accompaniment
      play n-12,release:d #transpose down an octave -12
      sleep d
    end
  end
end
