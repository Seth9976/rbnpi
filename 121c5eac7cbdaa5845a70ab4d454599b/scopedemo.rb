#This program displays various soundwaves on the new scope
#put scope window on the left so you can see priinted output in log window
#written by Robin Newman May 2016
gap=2 #gap between demos
headgap=1
puts "Demonstrations showing waveforms for different situations"
sleep gap
puts "Different waveforms for different synths"
sleep headgap
sl=[:beep,:tri,:saw,:pulse,:prophet]
sl.each do |sn|
  puts sn
  use_synth sn
  play :c4,sustain: 2,release: 0
  sleep 2
end
sleep gap
use_synth :beep
puts "changing pitch of a note :c3 -> :c5 and back again"
sleep headgap
s=play :c3,sustain: 10,release: 0,note_slide: 5
puts "start at :c3 Rising towards :c5..."
control s,note: :c5
sleep 5
puts "now :c5 and dropping back to :c3..."
control s,note: :c3
sleep 5
sleep gap
puts "See and hear beats between notes 440Hz and 441Hz"
sleep headgap
use_synth :beep
play hz_to_midi(440),sustain: 8
play hz_to_midi(441),sustain: 8
sleep 8
puts "Now see and hear beats between notes 440Hz and 450Hz"
sleep headgap
play hz_to_midi(440),sustain: 8
play hz_to_midi(450),sustain: 8
sleep 8
sleep gap
puts "See the effect on frequency of changing in octaves from :C1 to C:7"
sleep headgap
in_thread do #do this in a thread so that the puts statements can be shown too
  play_pattern_timed octs(:c1,7)+octs(:c1,7).reverse,1,sustain: 1,release: 0
end
7.times do |i| #indicate notes being played
  puts ":c"+(i+1).to_s
  sleep 1
end
7.times do |i|
  puts ":c"+(7-i).to_s
  sleep 1
end
sleep gap

puts "show effect of using pan and pan_slide, moving sound left or right"
sleep headgap
puts "Start a note playing with pan: 0"
s=play :c4,sustain: 14 ,pan: 0, pan_slide: 2
sleep 2
control s,pan: -1
puts "change pan: to -1 over 2 seconds"
sleep 2
puts"wait 2 seconds then change pan: to +1 over 2 seconds"
sleep 2
control s,pan: 1
sleep 2
puts "wait 2 seconds then revert pan: to 0 over 2 seconds"
sleep 2
control s, pan: 0
sleep 2
"pan: is now 0, equal sound in both channels"
sleep 2
sleep gap
puts "look at some sound envelopes, (twice each)"
2.times do
  sleep headgap
  puts "play :c4,attack: 4,sustain: 2,release: 2"
  sleep headgap*2
  use_synth :beep
  in_thread do
    play :c4,attack: 4,sustain: 2,release: 2,pan: -1
  end
  puts "attack: 4"
  play :c7,release: 0.02,pan: 1
  sleep 4
  puts "sustain: 2"
  play :c7,release: 0.02,pan: 1
  sleep 2
  puts "release: 2"
  play :c7,release: 0.02,pan: 1
  sleep 2
  sleep gap
end
2.times do
  puts "play :c4,attack: 2,attack_level: 2,decay: 2,decay_level: 0.2,sustain: 2,sustain_level: 1,release: 3"
  sleep headgap*2
  in_thread do
    play :c4,attack: 2,attack_level: 2,decay: 2,decay_level: 0.2,sustain: 2,sustain_level: 1,release: 3,pan: -1
  end
  puts "attack: 2,attack_level: 2"
  play :c7,release: 0.02,pan: 1
  sleep 2
  puts "decay: 2,decay_level: 0.2"
  play :c7,release: 0.02,pan: 1
  sleep 2
  puts "sustain: 3,sustain_level: 1"
  play :c7,release: 0.02,pan: 1
  sleep 3
  puts "release: 3"
  play :c7,release: 0.02,pan: 1
  sleep 3
end
