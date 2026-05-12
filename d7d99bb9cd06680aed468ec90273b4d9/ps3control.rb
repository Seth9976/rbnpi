#Demo program showing Sonic Pi 3 and PS3 control
#written by Robin Newman, July 2017
#uses a python script on the Raspberry Pi to
#interface to an "AfterGlow" wireless ps3 controller
#The script sends OSC messages with the PS3 data to Sonic Pi
#Which can be running on the Pi, or on a remote machine
# inputs are from:
#osc messages from the following
#llr and lud values for left left-right and left uo-down jopystick -1->+1
#rlr and rud values for right -left-right and right up-down joystick -1->+1
#hat values from the hat control [a,b] where a is -1 or 1 and b is -1 or 1
#b0 to b12 values for the 13 buttons. (1)
#sender ignores 0 values and doesn't send them (threshold +-0.1 for joysticks)
#this cuts down a huge amount of OSC messages
#sender program polls values in a loop and sends when not 0 or > threshold
use_debug false
use_cue_logging false
#initialise set values. These are used to communicate with the various live_loops
set :vinc,1 #used to hold controlled volume level
set :ncontrol,72 #used to hold controlled note for "long note"
set :kill,0 #used to kill "long note"
set :mutevol,1 #used to mute/unmute "long note"
set :cutoff_val,80 #cutoff value for "long note"
set :opt_in, 1 #lets ps3 buttons opt in/out of controlled volume
set :syn_pointer, 0 #pints to current synth for buttons and "long note"
set :syn,:tri #current synth name for buttons and "long note"

define :pdec2 do |n| #for nice printing
  return (n.to_f*100).round.to_f/100
end
###################### CONTROL SECTION ADJUSTING VOLUME, SYNTHS, MUTING ETC ################
define :vv do |a| #function to switch control of amp setting according to "a"
  if a==1
    return get(:vinc)
  else
    return 1
  end
end

live_loop :hat do #used to adjust controlled volume level
  use_real_time
  b=sync "/osc/hat"
  val=b[1]
  set :vinc,[get(:vinc)+0.1,2].min if b[1]==1
  set :vinc,[get(:vinc)-0.11,0].max if b[1]==-1
  puts "volume set",pdec2(get(:vinc))
end

live_loop :kill do #used to kill "long" note (and set vol to 0 for remainder)
  b=sync "/osc/b12"
  set :kill,1
  sleep 1
  set :kill,0
end

live_loop :long_pitch do #used to change pitch of "long" note
  use_real_time
  b= sync "/osc/rud"
  #puts "long_pitch",pdec2((b[0]*36+72)),"cutoff"
  set :ncontrol,b[0]*36+72
  puts "Long Note pitch:",pdec2(get(:ncontrol)),"Cutoff:",pdec2(get(:cutoff_val))
end

live_loop :mute do #used to temporarily mute "long note"
  use_real_time
  b=sync "/osc/b8"
  set :mutevol,0
end

live_loop :unmute do #used to unmute "long note"
  use_real_time
  b=sync "/osc/b9"
  set :mutevol,1
end

live_loop :control_btn_vols do #osed to opt buttons in/out of controlled volume
  use_real_time
  b=sync "/osc/b10"
  set(:opt_in,get(:opt_in)*-1)
  if get(:opt_in) ==1
    puts "Button volume controlled"
  else
    puts "Button volume NOT controlled"
  end
  sleep 0.4
end

live_loop :rlr do #used to adjust "long note" cutoff
  use_real_time
  b= sync "/osc/rlr"
  set :cutoff_val,b[0]*40+80
  puts "Long Note pitch:",pdec2(get(:ncontrol)),"Cutoff:",pdec2(get(:cutoff_val))
end

live_loop :llr do #used to select synth for buttons
  use_real_time
  slist=[:sine,:tri,:saw,:prophet,:tb303,:fm,:mod_saw,:mod_fm]
  b= sync "/osc/llr"
  p=get(:syn_pointer)
  p=[p+1,slist.length-1].min if b[0] > 0.4
  p=[p-1,0].max if b[0] < -0.4
  set :syn_pointer,p
  set(:syn,slist[p])
  puts "syn is",get(:syn)
  sleep 0.4
end

############################ PLAYING SECTION BELOW ############################

with_fx :reverb,room: 0.99 do #start playing section here inside reverb
  
  live_loop :continuous_note do #setup up "long note" and control it
    use_real_time
    x= sync "/osc/b11" #start the "long" note
    use_synth get(:syn)
    n= play 72,sustain: 200,amp: 0 #start "long note" with zero volume
    control n,note: 72
    2000.times do
      control n,note: get(:ncontrol),note_slide: 0.1,amp: get(:mutevol)*get(:vinc),amp_slide: 0.1,cutoff: get(:cutoff_val),cutoff_slide: 0.1
      sleep 0.1
      break if get(:kill)==1 #if kill set abort loop and set vol of note to 0
    end
    control n, amp: 0
  end
  
  live_loop :lud do #adjust pitch of :sine synth with joystick
    use_real_time
    f = sync "/osc/lud"
    synth :sine,note: f[0]*24+60,attack: 0.15,release: 0.2,amp: get(:vinc) #or use synth get(:syn)
  end
  
  live_loop :bt0 do #play set note :c4 with chosen synth
    use_real_time
    b= sync "/osc/b0"
    synth get(:syn),note: :c4,attack: 0.1,release: 0.2,amp: vv(get(:opt_in))   if b[0]==1
  end
  
  live_loop :bt1 do #remaining buttons similar with pitch increased each button
    use_real_time
    b= sync "/osc/b1"
    synth get(:syn),note: :d4,attack: 0.1,release: 0.2,amp: vv(get(:opt_in))   if b[0]==1
  end
  live_loop :bt2 do
    use_real_time
    b= sync "/osc/b2"
    synth get(:syn),note: :e4,attack: 0.1,release: 0.2,amp: vv(get(:opt_in))   if b[0]==1
  end
  live_loop :bt3 do
    use_real_time
    b= sync "/osc/b3"
    synth get(:syn),note: :f4,attack: 0.1,release: 0.2,amp: vv(get(:opt_in))   if b[0]==1
  end
  live_loop :bt4 do
    use_real_time
    b= sync "/osc/b4"
    synth get(:syn),note: :g4,attack: 0.1,release: 0.2,amp: vv(get(:opt_in))   if b[0]==1
    
  end
  live_loop :bt5 do
    b= sync "/osc/b5"
    use_real_time
    synth get(:syn),note: :a4,attack: 0.1,release: 0.2,amp: vv(get(:opt_in))   if b[0]==1
  end
  live_loop :bt6 do
    use_real_time
    b= sync "/osc/b6"
    synth get(:syn),note: :b4,attack: 0.1,release: 0.2,amp: vv(get(:opt_in))   if b[0]==1
  end
  live_loop :bt7 do
    use_real_time
    b= sync "/osc/b7"
    synth get(:syn),note: :c5,attack: 0.1,release: 0.2,amp: vv(get(:opt_in))   if b[0]==1
  end
  
end #fx