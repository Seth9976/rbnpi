#Sonic Pi Lissajous investigator by Robin Newman
#using a TouchOSC controller
use_osc "192.168.1.50",9000 #adjust to suit your ipad/iphone ip

flip=1 #flips x and y plots on each iteration
use_debug false
use_cue_logging false
use_midi_logging false
use_debug false
use_osc_logging false
use_arg_checks false
synthList=[:sine,:tri,:saw,:square,:fm,:pulse]
#intial values for variables
vBpm=60
vDelay=2
vVol=3
vAttack=1
vSustain=2
vRelease=1
synthName=:sine
midiVals=[0.2,0.333,1,0.25,0.80,0.25] #starting settings for sliders
#setup TouchOSC screen initial values
osc "/1/vBpm",vBpm
osc "/1/vDelay",vDelay
osc "/1/vVol",vVol
osc "/1/vAttack",vAttack
osc "/1/vSustain",vSustain
osc "/1/vRelease",vRelease
osc "/1/synthName",synthName
sleep 0.1
6.times do |i| #initialise sliders usinb mdi_cc commands
  midi_cc i+1,midiVals[i]*127
end
midi_cc 11,127 #select switch for :sine synth
#list of frequency pairs
a=(ring [600,600],[600,540],[600,400],[300,600],[200,600],[150,600],[100,600])
ts=(ring 0,2,4,5,7,5,4,2,0,-1,-3,-5,-3,-1) #transpose settings

live_loop :liss,auto_cue: false do #main program live_loop
  use_bpm vBpm
  use_synth synthName
  tick
  tick_set :tp, look/7
  b=a.look
  flip = -flip
  use_transpose ts.look(:tp)
  play hz_to_midi(b[0]),attack: vAttack,amp: vVol,sustain: vSustain,release: vRelease,pan: 1*flip
  play hz_to_midi(b[1]),attack: vAttack,amp: vVol,sustain: vSustain,release: vRelease,pan: -1*flip
  sleep vDelay
end

live_loop :control,auto_cue: false do #live loop to get input from TouchOSC
  use_real_time
  b= sync "/midi/*/*/*/control_change" #wait for next midi input (any device/port)
  case b[0] #process according to control source b[0] range 1-6 and 11-16
  when 1
    vBpm=30+150*b[1].to_f/127 #get and scale bpm
    osc "/1/vBpm",(vBpm*100).round.to_f/100 #update TouchOSC display
  when 2
    vDelay=1+b[1].to_f/127*3 #get and scale delay
    osc "/1/vDelay",(vDelay*100).round.to_f/100 #update TouchOSC display
  when 3
    vVol=0.5+2.5*b[1].to_f/127 #get and scale volune
    osc "/1/vVol",((vVol*100).to_f/100).round #update TouchOSC display
  when 4
    vAttack=0.5+2*b[1].to_f/127 #get and scale attack
    osc "/1/vAttack",(vAttack*100).round.to_f/100 #update TouchOSC display
  when 5
    vSustain=2.5*b[1].to_f/127 #get and scale sustain
    osc "/1/vSustain",(vSustain*100).round.to_f/100 #update TouchOSC display
  when 6
    vRelease=0.5+2*b[1].to_f/127 #get and scale release
    osc "/1/vRelease",(vRelease*100).round.to_f/100 #update TouchOSC display
  when 11,12,13,14,15,16 #deal with synths select multi toggle switch
    if b[1]!=0 #only deal with switch turning on
      synthNum=b[0]-11 #get synth offset in synthList
      synthName=synthList[synthNum]
      osc "/1/synthName",synthName #update TouchOSC displayed synth name
    end
  end
end
