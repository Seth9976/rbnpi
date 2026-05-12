
#Elfen Lied Lillium music box tune by Dan Tramte
#Arranged to drive Visor graphics by Robin Newman, April 2019
use_debug false
use_midi_logging false
use_midi_defaults port: "iac_driver_sonicpi",channel: 1
notes =(ring 78, 85,
        [80, 65], 73, 77, 81, [81, 66], :r, 78, 85,
        [80, 65], 73, 77, 81, [83, 66] ,81,
        [78, 62], 69, 74, 69, 71, 80, 76, 74,
        [76, 61], 68, 73, 68, 70, 78, 74, 73,
        [74, 59], 76, 78, 71, 60, [80, 63], [81, 66], 83,
        [81, 61], 66, 73, 66, [80, 61], :r, 78, 85,
        [80, 65], 73, 77, 81, [81, 66], :r, 78, 85,
        [80, 65], 73, 77, 81, [83, 66], 81,
        [78, 62], 69, 74, 69, 71, 80, 76, 74,
        [76, 61], 68, 73, 68, 70, 78, 74, 73,
        [74, 59], 83, [81, 60], 80, [78, 61], 77, [75, 73], 77,
        [78, 66], [82, 78], [83, 80], [85, 82],
        [86, 59, 71], 81, [80, 52, 64], 86, [85, 57, 69], 88, [81, 50, 62], 85,
        [83, 67], 81, [80, 61], 77, 74, [73, 66], [82, 78], [83, 80], [85, 82],
        [86, 59, 71], 81, [80, 52, 64], 86, [85, 57, 69], 88, [81, 50, 62], 85,
        [84, 63], 81, 80, 78, [81, 61], 73, 66, 83,
        [80, 65, 73], :r,:r,:r,:r,:r)
#puts notes.length;stop

##commented code prints out note data in the log from where it can be copied
##| notes.each_with_index do |n,i|
##|   if n.class == Array then
##|     puts "#{i} #{(note_info n[0]).to_s[17..-2].to_sym}"
##|     puts "#{i} #{(note_info n[1]).to_s[17..-2].to_sym}"
##|     puts "#{i} #{(note_info n[2]).to_s[17..-2].to_sym}"if n[2] != nil
##|     else
##|       if n !=:r
##|         puts "#{i} #{(note_info n).to_s[17..-2].to_sym}"
##|       else
##|         puts "#{i} rest"
##|       end
##|     end
##|   end
##|   stop

#barline notes
bl=[2,6,10,14,17,20,24,28,32,36,40,44,48,52,56,60,63,66,70,74,78,82,86,90,94,98,103,107,111,115,119,123,127].map {|x| [x,true]}.to_h
#start of melody change
mel=[2,10,48,56,90,107,123].map {|x| [x,true]}.to_h
#prominent bass notes
bass=[3,6,10,14,16,24,32,40,44,48,52,56,60,62,70,78,80,82,84,86,90,92,94,96,98,103,107,109,111,113,115,119,123].map {|x| [x,true]}.to_h

define :midiRes do #reset all midi_cc, and stored values
  8.times do |i|
    midi_cc 13+i,0
    set ("m"+i.to_s).to_sym,0
    sleep 0.05
  end
end

midiRes
sleep 0.5 #make sure completed
set :bpm,60
set :kill,false #flag used to stop loops at end of piece
set :mpass,3 #number of tune passes
k=(line 60,180,steps: 129) #generate bpm value list k
k=k+k[0..-1].reverse
#puts k
sleep 0.5 #make sure setup completed

live_loop :speed do #loop sweeps speed up and down 60 - 180 in 129 steps twice
  use_bpm get(:bpm)
  set :bpm, k.tick #store current bpm
  sleep 0.25
  stop if get(:kill)# stop loop at end
end

use_synth :pretty_bell
with_fx :reverb, room: 1, mix: 0.6 do
  live_loop :music_box do #main tune play loop
    use_bpm get(:bpm)
    tick
    if notes.look.class == Array then #split off harmony notes
      play notes.look[0],pan: 0.5
      #puts "#{look}: #{note_info notes.look[0]}" if notes.look[0] !=:r
      with_synth :pretty_bell do #can try different synth for these
        play notes.look[1],pan: -0.5
        play notes.look[2],pan: -0.5
      end
    else
      #puts "#{look}: #{note_info notes.look}" if notes.look !=:r
      play notes.look,pan: 1 #play single notes here
    end
    #puts look%notes.length
    sleep !(100..102).cover?(look%notes.length)? 0.5 : 1/3.0 #use cover? and look to alter time for triplet
    if look ==128*get(:mpass)-2 #on last pass play end chord
      mPulse 15,0 #switch of central star
      sleep rt(1)
      play :fs4,pan: 0.5
      play :a4,pan: -0.5
      play :cs5,pan: -0.5
      play :fs5,pan: 0.5
      sleep 2
      set :kill,true #flag end of piece
      stop
    end
  end
end


define :mPulse do |n,state| #send one midi_cc value
  midi_cc n,state
  set ("m"+n.to_s).to_sym,state #store value sent
end
define :mSwap do |n| #toggle or swap one midi_cc value and update store
  state = get(("m"+n.to_s).to_sym)
  if state==0
    state=127
  else
    state=0
  end
  midi_cc n,state
  set ("m"+n.to_s).to_sym,state
end

#Midi control allocations
#13=spin centre
#14=centre colour
#15=centre on/off
#16=background
#17=scale star field
#18=spin star filed
#19=colour star field
#20=starfield on/off

live_loop :timing do
  use_real_time
  use_bpm get(:bpm)
  if get(:kill) #close down at the end
    midiRes
    stop
  end
  tick #reset every time tune completes
  tick(:gl) #global tick. Doesn't reset each pass
  if look(:gl)<128 #in first pass through tune
    mSwap 20 if mel.has_key? look #control starfield using mel notes
    mPulse 15,127 if look ==0 #switch on central star at start of tune
  else #on 2nd or subsequent pass through tune
    mSwap 15 if mel.has_key? look and look(:gl) < 128*get(:mpass)#toggle central star with mel notes (not at last pass)
    mPulse 20,127 if look ==0 #switch on star field
  end
  if look(:gl) > 128*2 #on third pass of tune
    mSwap 19 if (bl.has_key? look) and one_in(3) #switch star field colour on a thord of beats at random
    mSwap 17 if bass.has_key? look #switch starfield scale using bass notes
  end
  mSwap 14 if (bl.has_key? look) and one_in(3) #switch central star colour on a third of all barlines
  mSwap 16 if bass.has_key? look #switch background colour on all bass notes
  mPulse 18,127 if look==86 #switch star field rotate on for second half of tune
  mPulse 18,0 if look==127 #switch starfield rotate off at start of tune
  mSwap 13 if bl.has_key? look #switch cental star spin on each barline.
  sleep 0.5
  tick_reset if look==127 #reset all controls at end of each tune
end
