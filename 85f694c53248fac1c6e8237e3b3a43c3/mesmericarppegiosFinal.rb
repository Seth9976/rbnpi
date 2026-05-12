#mesmericappegios by Robin Newman August 2019
#a collaboration between Sonic Pi and Arturia's MatrixBrute
#load mesmericarpeggios.mbprojz into Matrix Brute via midi control center
use_real_time
use_midi_defaults port: :matrixbrute_midi_1,channel: 1
use_debug false
use_midi_logging false
use_cue_logging false
use_random_seed 6148
set :bpm,120 #set global bpm
set :kill,false #flag to stop loops at end
set :killClock,false #falg to kill midi clock loop
set :syn,:tb303

#function to set preset via code
define :presetCode do |p| #input like "A5" or "p3"
  midi_cc 0, ((p[0].upcase.ord)-65) #get row from letter "ord" value minus offset for "A"
  sleep 0.05
  midi_pc p[1..-1].to_i - 1 #using midi-pc to select column
end

#function to set preset by row and column (Not used in this piece!)
define :presetRC do |r,c|
  midi_cc 0, r-1
  sleep 0.1
  midi_pc c-1
end

define :nextSynth do
  set :syn,[:tb303,:zawa,:prophet].tick(:syn)
end

#function to play midi notes: single or chord
define :mplay do |notes,dur|
  if notes.respond_to? :each
    notes.each do |n|
      midi n, sustain: dur
    end
  else
    midi notes, sustain: dur
  end
end
sleep rt(1) #make suer everyting initialised
live_loop :mclock do#generate midi clock
  #use_real_time
  use_bpm get(:bpm)
  midi_clock_beat
  sleep 1
  stop if get(:killClock)
end

live_loop :choosepreset,sync: :mclock do
  #use_real_time
  #sync :mclock
  nextPreset= ["p1","p2","p3","p4","p5","p6","p7","p8","p9","p10"].tick
  presetCode nextPreset
  nextSynth
  puts "Current preset and synth: #{nextPreset}, #{get(:syn)}"
  sleep rt(9.5)
end

with_fx :level,amp: 0 do |v| #wrapper to control volume fades in and out
  set :v,v
  sleep 0.2
  at [1,160],[1,0] do |vol| #set times for fade in and out
    fade=8
    fade=20 if vol==0
    control get(:v),amp: vol, amp_slide: fade
    if vol==0
      sleep fade
      set :kill,true
    end
  end
  
  sleep 0.2 #allow for any audio glitches to subside at start
  #enable audio input from amtrixbrute with preamp and reverb applied
  with_fx :reverb, room: 0.7,mix: 0.7,pre_amp: 3 do
    live_audio :matrix,stereo: true #audio feed from matrixbrute
  end
  #add reverb to Pi generated audio
  with_fx :reverb, room: 0.7,mix:0.7 do
    #loop to send midi to matrixbrute
    live_loop :g,sync: :mclock do
      #use_real_time
      use_bpm  get(:bpm)
      mplay [:c3,:c4,:g4],2
      sleep 1
      mplay get(:k),2
      sleep 1
      stop if get(:kill)
    end
    #loop to play chords on the Pi
    live_loop :p,sync: :mclock do
      use_synth get(:syn)
      #use_real_time
      #sync :mclock
      use_bpm  get(:bpm)
      play [:c3,:c4,:g4],sustain: 0.1,release:0.9,cutoff: rrand(80,110),amp: 0.8
      sleep 1
      set :k, [[:c5,:e5,:g5],[:d5,:f5,:g5],[:d5,:f5,:a5],[:d5,:e5,:g5]].choose
      play get(:k),sustain: 0.1,release: 0.9,cutoff: rrand(80,110),amp: 0.8
      sleep 1
      if get(:kill)
        set :killClock,true
        stop
      end
    end
    #loop to add bass drone
    live_loop :bass,sync: :mclock do
      #use_real_time
      #sync :mclock
      use_synth :saw
      use_bpm  get(:bpm)
      play :c1,release: 4,amp:0.8
      sleep 4
      stop if get(:kill)
    end
  end
end
