#nc (Note Continuous) program for Sonic Pi 3 controlled by TouchOSC
#written by Robin Newman, August 2017  (ver 1.1)
#Three separate note inputs are controlled.
#For each one, synth,volume,pitch,sustain nd transpose are controlled
#One uses a virtual 2 octave+ 1 note keyboard, which can be octave shifted
#One uses an xy input to control Pitch and Release
#One generates a continous note with xy control of pitch and cutoff.
#This note can be muted/unmuted, or restarted with a differnt synth setting
#TouchOSC controls everything, by sending a variety of OSC messages to Sonic Pi 3
#It also receives feed back (via OSC messages) which set up the initial controller positions
#and controls two leds which indicate settings for the "long note"
#It features the use of set and get commands to send and receive information between the multiple
#live loops in the program.
#It uses two undocumented features of Sonic Pi 3 (which therefore may change in the future)
#1: use of n.kill to kill a synth node n
#2: use of the get_event function to retrieve address information for OSC messages
#this enables one live loop to control ALL the keyboard button inputs, and enables
#the address decoding of the multi-toggle buttons used for synth/transpose and kbd octave

TouchOSC_IP="192.168.1.50" #adjust for IP of TouchOSC
use_osc TouchOSC_IP,9000 #TouchOSC set to receive on port 9000

use_debug false
use_cue_logging false
#initialise set values. These are used to communicate with the various live_loops
set :volLN2,0 #used to hold "long Note" volume level
set :volLeft,0.5 #vol for left hand XY pad
set :volKbd,0.5 #vol for keyboard
set :kbdRelease,0.5 #keyboard release time
set :kbdOctave,1 #keyboard octave shift
set :ncontrol,36 #used to hold controlled note value for "long note"
set :kill,1 #used to kill "long note"
set :mutevol,1 #used to mute/unmute "long note"
set :cutoff_val,80 #cutoff value for "long note"
set :leftpitch,60 #left note starting pitch
set :synleft,:tri #current synth name for buttons and "left note"
set :synright,:tri #current synth name for "long note"
set :kbdsyn,:tri #current synth name for keyboard
set :kbdsynptr,1 #points to left (1) or right(2) synth list
set :trsetting,0 #transpose setting in semitomes


define :setLed do |name,col,intensity| #sets LED colour and intensity
  osc "/nc/"+name+"/color",col
  osc "/nc/"+name,intensity
end

define :init do #OSC messages to set up TouchOSC controls
  osc "/nc/vfade1",0.5
  osc "/nc/vfade2",0
  osc "/nc/synthleft/1/1",1
  osc "/nc/synthright/1/1",1
  osc "/nc/fadersrelease",0.5
  osc "/nc/kbdoctave/1/2",1
  osc "/nc/volKbd",0.5
  osc "/nc/kbdsynth/1/1",1
  osc "/nc/transpose/1/8",1 # equiv 0 transpose
  osc "/nc/faderReverb",0.5
  setLed("ledsk","red",1)
  setLed("ledmu","green",1)
end

init #intialise TouchOSC

define :pdec2 do |n| #for nice printing to 2 decimal places
  return (n.to_f*100).round.to_f/100
end

########## CONTROL SECTION ADJUSTS VOL SYNTHS, MUTE ETC ####
define :getsyn do |address| #decode synth multi-toggle address
  return get_event(address).to_s.split(",")[6][address.length-1].to_i
end
live_loop :get_synthR do #Right synth selector
  use_real_time
  b= sync "/osc/nc/synthright/?/1"
  if b[0]>0
    slist=[:tri,:saw,:prophet,:tb303,:fm,:mod_saw]
    p= getsyn("/osc/nc/synthright/?/1") - 1 #to get offset from 0
    set(:synright,slist[p])
    set(:kbdsyn,get(:synright)) if get(:kbdsynptr) == 2
    puts "synRight is",get(:synright)
  end
end


live_loop :get_synthL do #left synth selector
  use_real_time
  b= sync "/osc/nc/synthleft/?/1"
  if b[0]>0
    slist=[:tri,:saw,:prophet,:tb303,:fm,:mod_saw]
    p= getsyn("/osc/nc/synthleft/?/1") - 1 #to get offset from 0
    set(:synleft,slist[p])
    set(:kbdsyn,get(:synleft)) if get(:kbdsynptr)==1
    puts "synLeft is",get(:synleft)
  end
end

live_loop :volLN2 do #long note vol select
  use_real_time
  b = sync "/osc/nc/vfade2"
  set :volLN2,b[0]*2
  puts "Vol long note is",pdec2(get(:volLN2))
end

live_loop :volLeft do #left xy pad Vol
  use_real_time
  b = sync "/osc/nc/vfade1"
  set :volLeft,b[0]*2
  puts "Vol left note is",pdec2(get(:volLeft))
end

define :getTranspose do |address| #decode Transpose button
  return get_event(address).to_s.split(",")[6][address.length+1..-2].to_i
end
live_loop :setTranspose do #set Transpose
  use_real_time
  b= sync "/osc/nc/transpose/1/*"
  if b[0]==1
    tr= getTranspose("/osc/nc/transpose/1/*")-1
    puts "tr is",tr
    set(:trsetting,[-12,-10,-8,-7,-5,-3,-1,0,2,4,5,7,9,11,12][tr])
    puts "Transpose (semitones)",get(:trsetting)
  end
end

live_loop :volKbd do #set kbd volume
  use_real_time
  b = sync "/osc/nc/vfadekeys"
  set :volKbd,b[0]*2
  puts "Vol keyboard note is",pdec2(get(:volKbd))
end

live_loop :releaseKbd do #set kbd release time
  use_real_time
  b = sync "/osc/nc/fadersrelease"
  set :kbdRelease,b[0]
end

define :getkbdOctave do |address| #decode Octave multi-toggle selected
  return get_event(address).to_s.split(",")[6][address.length+1].to_i
end
live_loop :selectKbdOctave do #select kbd offset
  use_real_time
  b = sync "/osc/nc/kbdoctave/1/*"
  if b[0]==1
    octave=getkbdOctave("/osc/nc/kbdoctave/1/*")-1 #num from 0
    puts("Kbd octave offset ",octave)
    set :kbdOctave,octave
  end
end

define :getkbdsynth do |address| #decode kbd synth select multi-toggle address
  return get_event(address).to_s.split(",")[6][address.length+1].to_i
end
live_loop :selectkbdsynth do #select kbd synth from appropriate list
  use_real_time
  b = sync "/osc/nc/kbdsynth/1/*"
  if b[0]==1
    s=getkbdsynth("/osc/nc/kbdsynth/1/*")
    puts"s is",s
    set :kbdsynptr,s
    set :kbdsyn,get(:synleft) if s==1
    set :kbdsyn,get(:synright) if s==2
    puts "kbd synth is",get(:kbdsyn)
  end
end

live_loop :durationLeftNote do #left XY duration setting
  use_real_time
  b = sync "/osc/nc/xy1/1"
  set :dur,b[1]*0.98+0.02
  puts "Left note pitch",pdec2(get(:leftpitch)),"duration",pdec2(get(:dur))
end

live_loop :kill2 do #set kill flag for "long" note
  b=sync "/osc/nc/kill2"
  set :kill,1 if b[0]>0 #only on push, not release
end

live_loop :long_pitch do #change pitch of "long" note
  use_real_time
  b= sync "/osc/nc/xy2/1"
  set :ncontrol,b[0]*12+36
  set :cutoff_val,b[1]*40+80
  #print current data for Long Note
  puts "Long Note pitch:",pdec2(get(:ncontrol)+get(:trsetting)),"Cutoff:",pdec2(get(:cutoff_val))
end

live_loop :muteln2 do #temp mute "long note"
  use_real_time
  b=sync "/osc/nc/mute2"
  setLed("ledmu","red",1)
  set :mutevol,0
end

live_loop :unmuteln2 do #used to unmute "long note"
  use_real_time
  b=sync "/osc/nc/unmute2"
  setLed("ledmu","green",1)
  set :mutevol,1
end


###### PLAYING SECTION BELOW #####

with_fx :reverb,room: 0.8,mix: 0.5 do |rv| #playing section inside fx reverb
  in_thread do #thread to alter reverb value
    loop do #loop to react to reverb slider
      b=sync  "/osc/nc/faderReverb"
      control rv,mix: b[0],mix_slide: 0.1 #adjust reverb according to slider
      puts"Reverb mix is",pdec2(b[0])
    end
  end
  
  live_loop :continuous_note do #setup up "long note" and control it
    use_real_time
    b= sync "/osc/nc/enable2" #start the "long" note
    if b[0]>0 and get(:kill)==1 #don't restart running note
      set :kill,0
      setLed("ledsk","green",1)
      use_synth get(:synright)
      puts"long note started with synth",get(:synright)
      n= play get(:ncontrol)+get(:trsetting),sustain: 1000,cutoff: get(:cutoff_val),amp: 0  #start "long note" with zero volume for 1000 seconds
      10000.times do
        control n,note: get(:ncontrol)+get(:trsetting),note_slide: 0.1,amp: get(:mutevol)*get(:volLN2),amp_slide: 0.1,cutoff: get(:cutoff_val),cutoff_slide: 0.1
        sleep 0.1
        break if get(:kill)==1 #if kill==1 abort loop
      end
      setLed("ledsk","red",1)
      control n, amp: 0,amp_slide: 0.1 #fade out and stop
      sleep 0.1
      n.kill
    end
  end
  
  live_loop :leftNote do #adjust pitch from left xy pad
    use_real_time
    f = sync "/osc/nc/xy1/1"
    set :leftpitch,f[0]*24+60+get(:trsetting)
    synth get(:synleft),note: get(:leftpitch),attack: 0.15,release: get(:dur),amp: get(:volLeft) #or use synth get(:syn)
    sleep get(:dur)*0.05+0.01
  end
  
  define :getkey do |address| #decode key num from OSC address
    return get_event(address).to_s.split(",")[6][address.length..-2].to_i
  end
  
  live_loop :kybd do #play note pushed
    use_real_time
    b= sync "/osc/nc/k[!i]**" #match k0...k24 (exclude kill1 match)
    n= getkey("/osc/nc/k**")+48
    kn=n+get(:kbdOctave)*12+get(:trsetting) #calc pitch
    puts "keybd note",kn
    synth get(:kbdsyn),note: kn,attack: 0.1,release: get(:kbdRelease),amp: get(:volKbd)   if b[0]==1
  end
  
end #fx