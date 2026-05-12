#Sonic Pi 3.0 Example showing midi out, live_audio in
#synchronised drum track and use of at to control volumes
#written by Robin Newman, July 2017
use_debug false
use_osc_logging false
use_midi_logging false
use_bpm 100
#st up rhythm tracks and volumes 0->9
set :bass_rhythm,ring(9, 0, 9, 0,  0, 0, 0, 0,  9, 0, 0, 3,  0, 0, 0, 0)
set :snare_rhythm,ring(0, 0, 0, 0,  9, 0, 0, 2,  0, 1, 0, 0,  9, 0, 0, 1)
set :hat_rhythm,ring(5, 0, 5, 0,  5, 0, 5, 0,  5, 0, 5, 0,  5, 0, 5, 0)

with_fx :level do |v|
  control v,amp: 0 #start at 0 volume
  sleep 0.05 #allow amp value to settle without clicks
  at [1,26],[1,0] do |n|
    control v,amp: n,amp_slide: 25 #fade in and out over 25 beats each
  end
  
  
  live_loop :drums do
    sample :drum_bass_hard, amp: 0.1*get(:bass_rhythm).tick
    sample :drum_snare_hard, amp: 0.1*get(:snare_rhythm).look
    sample :drum_cymbal_closed,amp: 0.1*get(:hat_rhythm).look
    sleep 0.2
    stop if look==249
  end
  
  #audio input section
  
  with_fx :compressor, pre_amp: 3,amp: 4 do
    #audio from helm synth fed back using loopback utility
    live_audio :helm_synth,stereo: true #audio from CM bells selected on helm synth
  end
  
end #fx_level

at 30 do  #stop audio input at the end
  live_audio :korg,:stop
end

#send out midi note to play (sent to helm synth CM bells)
live_loop :midi_out,  sync: :drums do
  tick
  n=scale(:c4,:minor_pentatonic).choose
  vel=0.7
  midi n,sustain: 0.1,vel_f: vel,port: "sonicpi_connect",channel: 1
  sleep 0.2
  stop if look==249
end