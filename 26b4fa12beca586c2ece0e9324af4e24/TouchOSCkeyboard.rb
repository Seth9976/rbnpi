#Simple TouchOSC keyboard player for Sonic Pi. Works on iPhone or iPad
#by Robin Newman, May 2017 (updated for SP 3.1amJam talk)
#pdated to use set and get instead of variable passing to live_loops
#use with TouchOSC and phonekeyboardOSC.touchosc
######## SETUP CONNECTIONS ##################

use_cue_logging false
use_midi_logging false
use_osc_logging true
use_osc "172.20.10.5",9000 #address to send osc messages back to touchOSC

#names used for set/get
octo="/octo"
vol="/vol"
relval="/relval"
syn="/syn"
#######INITIALISE TouchOSC selectors #########
osc "/kbd/octave/1/2","1" #set octave switch on TouchOSC
set octo,48#intial octave offset (4 octaves)
set vol,0.5 #initial volume setting
sleep 0.1 #allow OSC link time
osc "/kbd/volume","0.5" #set volume slider on TouchOSC to initial value
sleep 0.1 #allow OSC link time
osc "/kbd/synth/1/3","1" #set inital synth position on TouchOSC
set syn,:saw #initial synth
sleep 0.1
osc "/kbd/release","0.167" #range 0.1->1, slider goes 0->1 0.167-> 0.25 value
set relval,0.25
############# START CONTROL AND NOTE INPUT LIVE LOOPS ############
live_loop :get_vol do
  use_real_time
  b = sync "/osc/kbd/volume"
  set vol, b[0]
  puts "vol",get(vol)
end
define :getdata do |address| #decode synth multi-toggle address
  return get_event(address).to_s.split(",")[6][address.length+1].to_i
end
live_loop :get_synth do
  use_real_time
  b = sync "/osc/kbd/synth/1/*"
  if b[0]==1 #only respond to button going down
    set(syn, [:piano,:tb303,:saw,:fm][getdata("/osc/kbd/synth/1/*")-1]) #offset as counts from 0
    puts get(syn)
  end
end
live_loop :get_octave do
  use_real_time
  b = sync "/osc/kbd/octave/1/*"
  if b[0]==1 #only respond to button going down
    set(octo,24+getdata("/osc/kbd/octave/1/*")*12)
    puts get(octo)
  end
end
live_loop :get_release do
  use_real_time
  b = sync "/osc/kbd/release"
  set(relval,b[0]*0.9+0.1) #range 0.1->1 for release Slider goes 0->1
  puts get(relval)
end

live_loop :play_note do
  use_real_time
  b= sync "/osc/kbd/[abcdefg]**"
  if b[0]>0 #only respond to key going down
    puts "key offset",b[0]-1
    use_synth get (syn)
    play b[0]+get(octo)-1,attack: 0.05,amp: get(vol),release: get(relval) if b[0]!=0#play note, adjusted for offset, with selected amp, and release
    puts get(octo),get(syn)
  end
end

#karioke sing-along input
##| with_fx :compressor,  pre_amp: 4, amp: 2 do
#live_audio :mic,amp: 2
##| end