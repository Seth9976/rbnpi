#spRecordPlayer.rb
#Sonic Pi Record / Player control using TouchOSC written by Robin Newman, March 2018
#handles recording and playback, real time or double speed, key changes, metronome,
#10 synth choices, optional percussion. It is possible to loop recordings, and play them
#seamlessly if recorded using the inbuilt metronome. Adjustment can be made
#to the time between repeats.
#uses Ableton push2 style layoutPi as it taxes Sonic Pi quite heavily and requires
#low latency audio output.
#release version 1.3
#changes all statements containing /osc/ have this changed to /osc*/ to work with sp > 3
#also some typos in comments corrcted

use_osc "192.168.1.85",9000 #adjust for the address of your TouchOSC device
#next line path to folder in which recored json files are saved
JSONfilePath="/Users/rbn/Documents/SPfromXML/recordplayer/" #adjust path for your system

use_osc_logging false
use_debug false
use_cue_logging false
use_bpm 60
st=Time.now
#intialise various flags
set :playing,false
set :recflag,false
set :recenable,false
set :leds,true
set :key,1
set :majmin,0
set :metroflag,false
set :ms,60
set :pb,60
set :synptr,1
set :vol,0.5
set :dur,0.4
set :mod,0
set :repeat,1
set :rtime,1
set :restx2,1
set :restHalf,1
set :slot,01;set :bank,0;set :saveFlag,0;set :helpLeds,1;set :minFileSize,60
set :loadFlag,0
delta= 0.03 #experimental time tuning "tuning"

#extract wild card matches from osc addresses
define :parse_sync_address do |address|
  v= get_event(address).to_s.split(",")[6]
  if v != nil
    return v[3..-2].split("/")
  else
    return ["error"]
  end
end

#turn on blue dogts on note input matrix
define :blueledsOn do
  10.times do |x|
    osc "/rp/m"+(x+1).to_s,1
    sleep 0.01
  end
end

#belt and braces make sure all note indicators are off
define :noteIndictorsOff do
  8.times do |x|
    8.times do |y|
      osc "/rp/multipush1/"+(x+1).to_s+"/"+(y+1).to_s,0
    end
  end
end  


define :init do #intialise TouchOSC screens
  osc "/rp/record",0
  osc "/rp/playback",0
  osc "/rp/key/1/1",1
  osc "/rp/majmin",0
  osc "/rp/majminLabel","major"
  osc "/rp/mt1",1
  osc "/rp/mt2",0
  osc "/rp/pb1",1
  osc "/rp/pb2",0
  osc "/rp/pb3",0
  osc "/rp/synth/1/1",1
  osc "/rp/metronome",0
  osc "/rp/ledplayback",1
  osc "/rp/helperLeds",1
  osc "/rp/volume",0.8
  osc "/rp/duration",0.2
  osc "/rp/ledRec",0
  osc "/rp/repeat/1/1",1
  osc "/rp/drums",0
  blueledsOn
  noteIndictorsOff
  osc "/sav/slot/1/1",1
  osc "/sav/slotbank/1/1",1
  osc "/sav/ledSave",0
  osc "/sav/missing"," "
  osc "/sav/bank1","<== 1-10"
  osc "/sav/bank2"," "
  osc "/sav/path",JSONfilePath
end

init # run the screen init

#control helper leds on note matrix
define :doExtraToggles do |c,r,state|
  osc "/rp/multipush1/"+(c.to_i-3).to_s+"/"+(r.to_i-1).to_s,state if c.to_i-3>0 and r.to_i-1 > 0
  osc "/rp/multipush1/"+(c.to_i-6).to_s+"/"+(r.to_i-2).to_s,state if c.to_i-6>0 and r.to_i-2 > 0
  osc "/rp/multipush1/"+(c.to_i+3).to_s+"/"+(r.to_i+1).to_s,state if c.to_i+3<9 and r.to_i+1 < 9
  osc "/rp/multipush1/"+(c.to_i+6).to_s+"/"+(r.to_i+2).to_s,state if c.to_i+6<9 and r.to_i+2 < 9
end

#change note +/- a semitone
define :modchange do |n|
  v =0
  v=1 if n == -1
  v=2 if n == 1
  return v
end

#clear data stored in arrays
define :clearData do
  recn=[].clear;timn=[].clear
  set :recn,recn;set :timn,timn
  sleep 0.2
end

#set flag to turn metronome on or off
live_loop :setmetronome do
  use_real_time
  b = sync "/osc*/rp/metronome "
  if b[0]==1
    set :metroflag,true
  else
    set :metroflag,false
  end
end

#select metronome bpm, and adjust indicators
live_loop :adjustMetro do
  use_real_time
  b = sync "/osc*/rp/mt*"
  res = parse_sync_address "/osc*/rp/mt*"
  if b[0]==1
    if res[2][-1]=="1"
      osc "/rp/mt2",0
      osc "/rp/mt3",0
      set :ms,60
    elsif res[2][-1]=="2"
      osc "/rp/mt1",0
      osc "/rp/mt3",0
      set :ms,90
    elsif res[2][-1]=="3"
      osc "/rp/mt1",0
      osc "/rp/mt2",0
      set :ms,120
    end
  end
end

#generate the metronome
live_loop :metro do
  use_real_time
  use_bpm get(:ms)
  play :c5,release:0.05 if get(:metroflag)
  sleep 1
end

#select playback tempo, and adjust indicators
live_loop :adjustPBtempo do
  use_real_time
  b = sync "/osc*/rp/pb*"
  res = parse_sync_address "/osc*/rp/pb*"
  if b[0]==1
    if res[2][-1]=="1"
      osc "/rp/pb2",0
      osc "/rp/pb3",0
      set :pb,60
    elsif res[2][-1]=="2"
      osc "/rp/pb1",0
      osc "/rp/pb3",0
      set :pb,90
    elsif res[2][-1]=="3"
      osc "/rp/pb1",0
      osc "/rp/pb2",0
      set :pb,120
    end
  end
end

#flash note and modifier pushed and update vol slider, decay slider and synth indicators
define :flashPush do |c,r,m,v,d,s,k,mm|
  osc "/rp/multipush1/"+c.to_s+"/"+r.to_s,1
  osc "/rp/modifier/"+m.to_s+"/1",1
  osc "/rp/key/"+k.to_s+"/1",1
  osc "/rp/majmin/",mm
  osc "/rp/majminLabel","major" if mm==1
  osc "/rp/majminLabel","minor" if mm==0
  
  osc "/rp/volume",v
  osc "/rp/duration",d
  osc"/rp/synth/"+s.to_s+"/1",1
  sleep 0.17
  osc "/rp/multipush1/"+c.to_s+"/"+r.to_s,0
  osc "/rp/modifier/"+m.to_s+"/1",0
end

#play a note using supplied parameters and update leds/sliders if selected
define :playNote do |c,r,synptr,majmin,key,dur,vol,m|
  use_synth [:piano,:pluck,:tri,:tb303,:blade,:chiplead,:prophet,:tech_saws,:sine,:fm][synptr.to_i-1]
  sc=["c","d","e","f","g","a","b"][key.to_i-1]
  type = [:major,:minor][majmin.to_i]
  use_transpose m #for flat or sharp or neither  -1 or 1 or 0
  cue :rhythm
  with_fx :reverb,room: 0.8,mix: 0.6 do
    play scale(sc+"2",type,num_octaves: 4)[(c.to_i-1)+3*(8-r.to_i)],release: dur,amp: vol
  end
  if get(:leds)
    in_thread do
      flashPush c,r,modchange(m),vol,durchange(dur),synptr,key,majmin
    end
  end
end

#deal with button on note input matrix being pushed. Play note and Record data if enabled
#also deals with helper leds on note display when note is pressed if enabled 
live_loop :noteKeyPushed do
  use_real_time
  b= sync "/osc*/rp/multipush1/*/*"
  res = parse_sync_address "/osc*/rp/multipush1/*/*"
  if b[0]==1
    doExtraToggles(res[3],res[4],1) if get(:helpLeds)==1
    if get(:recflag)
      recn=get(:recn);timn=get(:timn)
      rn=recn + [[res[3],res[4],get(:synptr),get(:majmin),get(:key),get(:dur),get(:vol),get(:mod)]]
      tn=timn + [Time.now-st]
      set :recn,rn
      set :timn,tn
      puts "tn #{tn}"
    end
    playNote res[3],res[4],get(:synptr),get(:majmin),get(:key),get(:dur),get(:vol),get(:mod)
  else
    doExtraToggles(res[3],res[4],0) if get(:helpLeds)==1
  end
end

#plays back recorded sequence. Handles repeat and rest input, cues percussion if enabled
#kills playback at end of notes, or if playbutton turned off
define :playRecordedNotes do
  use_real_time
  use_bpm get(:pb)
  recn= get(:recn)
  timn = get(:timn)
  puts recn
  puts timn
  puts get(:rtime)
  sleep 0.2
  if recn != nil
    get(:repeat).times do
      recn.length.times do |x|
        if x==0
          #puts "delay: #{get(:rtime)*get(:restx2)}" #for debugging
          sleep 0
        else
          kk= timn[x]-timn[x-1]+delta
          #puts "kk #{kk}" #for debugging
          sleep kk
        end
        cue :first
        playNote(recn[x][0],recn[x][1],recn[x][2],recn[x][3],recn[x][4],recn[x][5],recn[x][6],recn[x][7])
        break if get(:kill)
      end
      sleep get(:rtime) * get(:restx2) * get(:restHalf) -delta
      break if get(:kill)
    end
  end
  puts "finished notes playback"
  set :notesfinish,true
end

#deals with Major/Minor switch. Stores result in :majmin and updates switch display
live_loop :getMajminChanges do
  use_real_time
  b = sync "/osc*/rp/majmin"
  set :majmin,b[0]
  if b[0]==1
    osc "/rp/majminLabel","minor"
  else
    osc "/rp/majminLabel","major"
  end
end

#deals with key changes, saving current key number
live_loop :keySwitchChanged do
  use_real_time
  b= sync "/osc*/rp/key/*/*"
  res = parse_sync_address "/osc*/rp/key/*/1"
  if b[0]==1
    set :key,res[3]
  end
end

#gets input from synth selector buttons and updates pointer stored in :synptr
live_loop :chooseSynth do
  use_real_time
  b = sync "/osc*/rp/synth/*/1"
  if b[0]==1
    v = parse_sync_address "/osc*/rp/synth/*/1"
    set :synptr,v[3]
  end
end

#reads rest x 2 button and sets :rest2x flag. Used to adjust delay between repeat
live_loop :getRestx2 do
  use_real_time
  b = sync "/osc*/rp/restx2"
  set :restx2,b[0]
end

#reads rest x 0.5 button and sets :restHalf flag. Used to adjust delay between repeat
live_loop :getRestHalf do
  use_real_time
  b = sync "/osc*/rp/restHalf"
  set :restHalf,b[0]
end

#reverts scaled reading from the decay slider back to range 0->1 for updating the slider
define :durchange do |d|
  return (d-0.1)/1.9
end

#deals with safety enable record button. Sets :recenable flag and updates indicator led
live_loop :enablerecord do
  use_real_time
  b = sync "/osc*/rp/enableRecord"
  if b[0]==1
    if get(:recenable)==false
      osc "/rp/ledRec",1
      set :recenable,true
    else
      osc "/rp/ledRec",0
      set :recenable,false
    end
  end
end

#deals with record button being pressed. Checks if enabled. Clears existing data
#sets rest time for repeats :rtime appropriate for current metronome bpm
#records start time st from which to work out durations of notes
#sets :recflag to prevent playback. Updates record led. If logic says not to record
#resets record button and enable  button
live_loop :recording do
  use_real_time
  b = sync "/osc*/rp/record"
  if b[0]==1
    if  get(:playing)==false and get(:recenable)==true
      clearData #initialise for recording
      set :rtime,60.0/get(:ms) * get(:restx2) * get(:restHalf)
      sleep 0.1
      st=Time.now
      set :recflag,true
      puts "recording"
    else
      osc "/rp/record",0
      osc "/rp/ledRec",0
      set :recenable,false
    end
  else
    set :recflag,false
    set :recenable,false
    osc "/rp/ledRec",0
    puts "stopped recording"
  end
end


#loop check if playing should be disabled because all notes played, or recording enabled
#and switches button off if necessary
live_loop :checkNotPlaying do
  use_real_time
  if get(:notesfinish)==true
    set :playing,false
    osc "/rp/playback",0
  end
  if get(:rec)==true
    osc "/rp/playback",0
  end
  sleep 0.75
end

#handles play button pushed. checks logic to see if allowed, sets notesfinished to false
#sets kill (used for stop interrupt) to false, playing to true and starts
#playback in a thread. If released, sets kill flag to stop any playback.
live_loop :handlePlayButtonOn do
  use_real_time
  b = sync "/osc*/rp/playback"
  if b[0]==1
    if get(:recflag)==false and get(:playing)==false
      set :notesfinish,false
      set :kill,false
      sleep 0.2
      set :playing, true
      puts "starting playback"
      in_thread do
        playRecordedNotes
      end
    end
  else
    osc "/rp/playback",0
    set :kill,true
    set :playing,false
    puts "kill set"
  end
end

#enables or disables using leds on note matrix during playback. Sets :leds flag
live_loop :getledplayback do
  use_real_time
  b = sync "/osc*/rp/ledplayback"
  if b[0]==1
    set :leds,true
  else
    set :leds,false
  end
end

#gets reading from volume slider (range 0->1 Stored in :vol)
live_loop :getvol do
  use_real_time
  b = sync "/osc*/rp/volume"
  set :vol,b[0]
end

#gets reading from Decay slider (range 0->1 is modified to 0.1->2 and stored in :dur)
live_loop :getduration do
  use_real_time
b = sync "/osc*/rp/duration"
  set :dur,b[0]*1.9+0.1
end

#gets input from multi (2) push switches used for flat and sharp
#transforms input to set :mod as 0 (neither pushed,0 flat -1, sharp +1)
#if both pushed last one registered wins!
live_loop :getmodifiers do
  use_real_time
  b = sync "/osc*/rp/modifier/*/1"
  if b[0]==1
    res = parse_sync_address "/osc*/rp/modifier/*/1"
    set :mod,[-1,1][res[3].to_i-1]
  else
    set :mod,0
  end
end

#reads the 4 way repeat toggle and sets :repeat to 1,2,3 or 500 (continous!)
live_loop :getRepeats do
  use_real_time
  b = sync "/osc*/rp/repeat/*/1"
  if b[0]==1
    res = parse_sync_address "/osc*/rp/repeat/*/1"
    set :repeat,[0,1,2,3,500][res[3].to_i]
  end
end

#reads switch to turn on/off helper leds indicating buttons with the same note
#sored in :helpLeds (only for pushed notes, not for playback notes)
live_loop :getHelperLeds do
  use_real_time
  b = sync "/osc*/rp/helperLeds"
  set :helpLeds,b[0]
end


#experimental siple percussion loop which can be activated and started by playback
#it is also synced to a note being played at the start of each loop
#This allows for some discrepancy of the manually entered timings
#the rate of the loop is set by the currently selected metronome bpm, whether the
#metronome is playing or not.
#it is advisable to disable the  synced drums button before stopping playback
#or a spurious burst of durms may result next time playback starts
live_loop :perc do
  use_real_time
  b = sync "/osc*/rp/drums"
  if b[0]==1
    puts "arming drums"
    set :kDrums,false
    #add some reverb
    with_fx :reverb,room: 0.8,mix: 0.6 do
      live_loop :amen,sync: :first do
        sync :rhythm
        use_bpm get(:ms)
        sample :bd_haus
        sleep 0.5
        sample :drum_cymbal_closed
        sleep 0.25
        sample :drum_cymbal_closed
        sleep 0.25
        stop if get(:kDrums)
      end
    end
  else
    set :kDrums,true
  end
end

################################### Following code deals with second screem

#function checks if file in the given slot n exists, and its size
#if size > minFileSize it illuminates a led to indicate the file has recorded notes in it.
#ie it is not an empty file with some structure but no data saved
define :setFileIndicator do |n|
  if File.exists?(JSONfilePath+(n).to_s+".json")
    if File.size(JSONfilePath+(n).to_s+".json") > get(:minFileSize)
      osc "/sav/d"+n.to_s,1
    else
      osc "/sav/d"+n.to_s,0
    end
  end
end

#initial setup of all file indicator leds, parsing the existing json files for content
20.times do |n|
  setFileIndicator n+1
end

#clears all the leds showing the last file accessed
define :clearLastAccess do
  20.times do |n|
    osc "/sav/a"+(n+1).to_s,0
  end
end

#clears all the last access leds, then illuminates the led for the input parameter n 
define :setLastAccess do |n| 
  clearLastAccess
  sleep 0.02
  osc "/sav/a"+n.to_s,1
end

#initial clearing of all last access leds when program is started
clearLastAccess

#gets the data read from a file to hash :restore and allocates it
#to :recn,:timn: and :rtime for use by the "playing" part of the program
define :restoreHash do
  restore=get(:restore)
  puts restore
  set :timn, restore["Vtimn"]
  set :recn, restore["Vrecn"]
  set :rtime, restore["Vrtime"]
end

#deals with the select slot 10 way switch, updating :slot with 1-> 10
#bank is applied separately to get overall final slot 1 -> 20
live_loop :setSlot do
  use_real_time
  b = sync "/osc*/sav/slot/1/*"
  if b[0]==1
    res=parse_sync_address "/osc*/sav/slot/1/*"
    slot=res[4].to_i
    set :slot,slot
    puts "slot is #{slot}"
  end
end

#stores the data from the arrays :recn,:timn and the value of :rtime in a Hash vals
#then writes the hash to the relevant json file specified by the input parameter n
#updates the File Indicator led appropriately (off if an empty file otherwise on)
define :writeJson do |n|
  vals=Hash.new
  vals[:Vtimn]=get(:timn)
  vals[:Vrecn]=get(:recn)
  vals[:Vrtime]=get(:rtime)*get(:restx2)*get(:restHalf)  #possible update undo first comment in this line. Updates rterm on EVERY save not just first.
  File.open(JSONfilePath+(n).to_s+".json", 'w') do |f|
    f.write(MultiJson.dump(vals, pretty: true))
    f.close
    sleep 0.2
    setFileIndicator n
  end
end

#checks if the file in slot n exists, and gives error info if not. Otherwise loads file
#and uses restoreHash function to extract data to playing part of the program
define :readJson do |n|
  if File.exist?(JSONfilePath+n.to_s+".json")==false
    sample :misc_crow
    osc "/sav/missing",n.to_s+".json file missing"
    sleep 0.4 #time to read message
  else
    osc "/sav/missing",n.to_s+".json file found"
    content =File.read(JSONfilePath+n.to_s+".json")
    set :restore,MultiJson.load(content)
    sleep 0.4
    restoreHash
  end
end

#deals with the two way slotbank selector switch, setting :bank to 0 or 1
#updates the display to show current bank range
live_loop :slotbank do
  use_real_time
  b = sync "/osc*/sav/slotbank/*/1"
  if b[0]==1
    res = parse_sync_address "/osc*/sav/slotbank/*/1"
    bank= res[3].to_i - 1
    set :bank,bank
    if bank==0
      puts "bank selected is 1-10"
      osc "/sav/bank1","<== 1-10"
      osc "/sav/bank2"," "
    else
      puts "bank selected is 11-20"
      osc "/sav/bank2","11-20 ==>"
      osc "/sav/bank1"," "      
    end
  end
end

#deals with Enable Save switch. When pushed sets saveLed on for 1.5 seconds, and
#enables toe :saveflag for the same length of time
live_loop :enableSave do
  use_real_time
  b = sync "/osc*/sav/enableSave"
  if b[0]==1
    osc "/sav/ledSave",1
    set :saveFlag,1
    sleep  rt(1.5)
    osc "/sav/ledSave",0
    set :saveFlag,0
  end
end

#deals wtih Save File button. checks if save flag set, and gives error if not, exiting
#Otherwise calculates the final slot value (slot + 10*bank), calls writeJson
#for this number, then updates the lastAccess led for this number. Puts message
#on TouchOSC screen.
live_loop :writeData do
  use_real_time
  b = sync "/osc*/sav/write"
  if get(:saveFlag)==0
    puts "Save not enabled"
    osc "/sav/missing","Enable Save First!"
    sample :misc_crow
  else
    if b[0]==1
      slot=get(:slot)+10*get(:bank)
      writeJson(slot)
      setLastAccess slot
      puts "data written to slot #{slot}"
      osc "/sav/missing","File #{slot}.json saved"
    end
  end
end

#deals with enableLoad button. Enables loadFlag for 1.5 seconds, displaying a led
#for the same period
live_loop :enableLoad do
  use_real_time
  b = sync "/osc*/sav/enableLoad"
  if b[0]==1
    osc "/sav/ledLoad",1
    set :loadFlag,1
    sleep  rt(1.5)
    osc "/sav/ledLoad",0
    set :loadFlag,0
  end
end


#deals with Load File button. Checks in loadFlag is 1,and gives error if not,exiting.
#Otherwise calculates the final slot value (slot + bank*10)< calls readJson
#for this number, then sets the lastAccess led for this number. Info messages are displayed
#on the touchOSC screen
live_loop :readData do
  use_real_time
  b = sync "/osc*/sav/read"
  if get(:loadFlag)==0
    puts "Load not enabled"
    osc "/sav/missing","Enable Load First!"
    sample :misc_crow
  else
    if b[0]==1
      slot=get(:slot)+10*get(:bank)
      readJson(slot)
      setLastAccess(slot)
      puts "data read from slot #{slot}"
      osc "/sav/missing","File #{slot}.json loaded"
    end
  end
end  
