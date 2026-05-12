#16 channel sequencer for Sonic Pi 4 by Robin Newman August 2018 v1.0 amended v 2.0 Nov 2022 for new osc parsing format
#File requires run_file "path/to/sequencer-RF.rb"
#as it is too long to run from a Sonic Pi buffer.(at least on a Mac)
use_osc "192.168.1.241",4000 #ip address and port of TouchOSC (adjust)
use_osc_logging false
use_debug false
use_cue_logging false
JSONfilePath="/Users/rbn/Documents/SPfromXML/" #path to 4 files storing patterns
set :tempo,300 #initial tempo
use_synth :tb303 #synth for all notes 
set:n,1 #initial seqeuncer step number
set :singlemode,false #turn off pause/single step mode
set :enable,false #turn off read/wrte enable
set :v1,1 #initial sample volume
set :v2,0.5 #initial note volume
set :SEflag,false
set :Sflag,false
set :Eflag,false
set :sn,0
set :en,15
set :syn, :tb303

osc "/seq/enable",0 #initialise enable button
osc "/seq/level1",1 #initlialise sample vol slider
osc "/seq/level2",0.5 #initialise note vol slider
osc "/seq/tempo",0.5 #initilaise tempo slider
osc "/seq/setStart",0 #initialise setStart button
osc "/seq/setEnd",0 #intialise setEnd button
osc "/seq/start","1" #initialise start label
osc "/seq/end","16" #initialise end label
4.times do |i| #initialise read/write buttons and leds
  osc "/seq/read"+(i+1).to_s,0
  osc "/seq/write"+(i+1).to_s,0
  osc "/seq/led"+(i+1).to_s,0
  osc "/seq/wled"+(i+1).to_s,0
  osc "/seq/s"+(i+1).to_s,0
end
sleep 0.2
osc "/seq/s1",1 #choose first synth
osc "/seq/singlemode",0 #initialise singlestep/pause mode button to off

#function parse sync address to extrat wild card values
define :parse_sync_address do |address|
  v= get_event(address).to_s.split(",")[6]
  if v != nil
    return v[3..-2].split("/")
  else
    return ["error"]
  end
end

#functions clears set buttons in row rn in the display
define :clearrow do |rn|
  16.times do |i|
    osc "/seq/r"+rn.to_s+"/"+(i+1).to_s+"/1",0
  end
end

#function clears all green buttons in sequence indicator row
define :clearGreen do
  16.times do |i|
    osc "/seq/metro/"+(i+1).to_s+"/1",0
  end
end

#function clears all rows in display AND associated array map
define :clearpatterns do
  16.times do |i|
    clearrow i+1
  end
  sleep 0.2
  16.times do |i|
    set (("l"+(i+1).to_s).to_sym),[0]*16
  end
  sleep 0.4
  4.times do |i|
    osc "/seq/led"+(i+1).to_s,0 #clear last read lead
    osc "/seq/wled"+(i+1).to_s,0 #clear last write led
  end
end
clearpatterns #intialise all row entries to 0

#live loop enables setting of start position in sequence
live_loop :setStart do
  use_real_time
  b = sync "/osc*/seq/setStart" #receive input from button setStart
  if b[0]==1 #if pushed
    set :SEflag,true #enable StartEnd flag
    set :Sflag,true #enable set Start flag
    clearGreen #clear all green buttons in sequence indicator row
  end
end

#live loop enables setting of end position in sequence
live_loop :setEnd do
  use_real_time
  b = sync "/osc*/seq/setEnd" #receive input from button setEnd
  if b[0]==1 #if pushed
    set :SEflag,true #enable StartEnd flag
    set :Eflag,true #enable set End flag
    clearGreen #clear all green buttons in sequence indicator row
  end
end

#live loop resets start end sequence to 1->16 when button pushed
live_loop :setAll do
 use_real_time
  b = sync "/osc*/seq/setAll" #recevei input from setAll button
  if b[0]==1 #if pushed
    set :sn,0 #set start position for sequence tick goes 0->15
    set :en,15 #set finish positon for sequence
    osc "/seq/start","1" #update start label
    osc "/seq/end","16" #update end label
    sleep 0.2
    osc "/seq/setAll",0 #reset setAll button indicator and turn off
  end
end

#live loop reads button selected in green "strip"
live_loop :getSE do
  use_real_time
  b = sync "/osc*/seq/metro/*/1"
  if b[0]==1 and get(:SEflag)#when one of the buttons is pushed & SEflag enabled
    #parse to find number of button which was pushed 1->16
    p= parse_sync_address("/osc*/seq/metro/*/1")[3].to_i
    #note lick values 0->15, display numbers 1->16 hence p-1
    set :sn,p-1 if get(:Sflag) #set new start number for sequence if Sflag set
    set :en,p-1 if get(:Eflag) #set new end number for sequence if Eflag set
    set :Sflag,false #reset start flag (only one of Sflag Eflag actually set)
    set :Eflag,false #reset end flag (only one of Sflag Eflag actually set)
    osc "/seq/setStart",0 #turn off setStart button (only 1 of Start End is on)
    osc "/seq/setEnd",0 #turn off setEnd button (only 1 of Start End is on) 
    osc "/seq/start",(get(:sn)+1).to_s #update start label
    osc "/seq/end",(get(:en)+1).to_s #update end label
    set :SEflag,false #disable StartEnd flag
  end
end

#live loop controls active slot number in sequence
live_loop :metro do
  use_real_time
  if get(:singlemode) #checks for pause/single step mode
    #and stops if so until cued
    sync :takesinglestep #wait for cue for next step
  end
  use_bpm get(:tempo) #set bpm using stored value
  #setSE if get(:SEflag) 
  tick #advance to next positon
  n=look #store current value in n
  #puts "look #{look} :sn #{get(:sn)}  :en #{get(:en)} n #{n}" #for debugging
  set :n,n #store current value used in live_loop :pl
  #if SEflag is false, advance display green indicator to n position
  osc "/seq/metro/"+n.to_s+"/1", 1 if get(:SEflag)==false
  tick_set get(:sn)+1 if look> get(:en) #reset tick to start pos if end reached
  #puts "look #{look} :sn #{get(:sn)}  :en #{get(:en)}" #for debugging
    sleep 1 #wait one beat
  end

#function adjusts array setting new value v in position a
#necessary as retrieved array is frozen
#this way a new array is created to replace frozen array
define :setarray do |ln,a,v|
  l=get(("l"+ln.to_s).to_sym) #get appropriate array
  case a #check the new data position in the array
  when 0 # deals with new value at the beginning
    lu = [v.to_i]+l[1..-1]
  when 1..14 #deals with new value at position 1 to 14 (index from 0)
    lu = l[0..(a-1)] + [v.to_i]+l[(a+1)..-1]
  when 15 #deals with new value at the end of the array
    lu = l[0..-2]+[v.to_i]
  end
  set (("l"+ln.to_s).to_sym),lu #save new (updated) array to time-state
end

#live loop parses for pushed button p1->p16 and resets relevant display row
#and associated array map
live_loop :zero do
  use_real_time
  b = sync "/osc*/seq/pb*"
  if b[0] == 1
    r = parse_sync_address("/osc*/seq/pb*")[2][2..-1]
    set ("l"+r).to_sym,[0]*16 #zero appropriate array 
    sleep 0.05
    clearrow(r) #clear relevant screen row
  end
end

#16 similar live loops receive changed entries as TouchOSC buttons pushed
live_loop :r1 do
  use_real_time
  b= sync "/osc*/seq/r1/*/1" #row is r1, * holds pointer to changed position 
  a=parse_sync_address("/osc*/seq/r1/*/1")[3].to_i - 1
  setarray(1,a,b[0]) #update the changed position in array and store
  sleep 0.05
end
live_loop :r2 do
  use_real_time
  b= sync "/osc*/seq/r2/*/1"
  a=parse_sync_address("/osc*/seq/r2/*/1")[3].to_i - 1
  setarray(2,a,b[0])
  sleep 0.05
end
live_loop :r3 do
  use_real_time
  b= sync "/osc*/seq/r3/*/1"
  a=parse_sync_address("/osc*/seq/r3/*/1")[3].to_i - 1
  setarray(3,a,b[0])
  sleep 0.05
end
live_loop :r4 do
  use_real_time
  b= sync "/osc*/seq/r4/*/1"
  a=parse_sync_address("/osc*/seq/r4/*/1")[3].to_i - 1
  setarray(4,a,b[0])
  sleep 0.05
end
live_loop :r5 do
  use_real_time
  b= sync "/osc*/seq/r5/*/1"
  a=parse_sync_address("/osc*/seq/r5/*/1")[3].to_i - 1
  setarray(5,a,b[0])
  sleep 0.05
end
live_loop :r6 do
  use_real_time
  b= sync "/osc*/seq/r6/*/1"
  a=parse_sync_address("/osc*/seq/r6/*/1")[3].to_i - 1
  setarray(6,a,b[0])
  sleep 0.05
end
live_loop :r7 do
  use_real_time
  b= sync "/osc*/seq/r7/*/1"
  a=parse_sync_address("/osc*/seq/r7/*/1")[3].to_i - 1
  setarray(7,a,b[0])
  sleep 0.05
end
live_loop :r8 do
  use_real_time
  b= sync "/osc*/seq/r8/*/1"
  a=parse_sync_address("/osc*/seq/r8/*/1")[3].to_i - 1
  setarray(8,a,b[0])
  sleep 0.05
end
live_loop :r9 do
  use_real_time
  b= sync "/osc*/seq/r9/*/1"
  a=parse_sync_address("/osc*/seq/r9/*/1")[3].to_i - 1
  setarray(9,a,b[0])
  sleep 0.05
end
live_loop :r10 do
  use_real_time
  b= sync "/osc*/seq/r10/*/1"
  a=parse_sync_address("/osc*/seq/r10/*/1")[3].to_i - 1
  setarray(10,a,b[0])
  sleep 0.05
end
live_loop :r11 do
  use_real_time
  b= sync "/osc*/seq/r11/*/1"
  a=parse_sync_address("/osc*/seq/r11/*/1")[3].to_i - 1
  setarray(11,a,b[0])
  sleep 0.05
end
live_loop :r12 do
  use_real_time
  b= sync "/osc*/seq/r12/*/1"
  a=parse_sync_address("/osc*/seq/r12/*/1")[3].to_i - 1
  setarray(12,a,b[0])
  sleep 0.05
end
live_loop :r13 do
  use_real_time
  b= sync "/osc*/seq/r13/*/1"
  a=parse_sync_address("/osc*/seq/r13/*/1")[3].to_i - 1
  setarray(13,a,b[0])
  sleep 0.05
end
live_loop :r14 do
  use_real_time
  b= sync "/osc*/seq/r14/*/1"
  a=parse_sync_address("/osc*/seq/r14/*/1")[3].to_i - 1
  setarray(14,a,b[0])
  sleep 0.05
end
live_loop :r15 do
  use_real_time
  b= sync "/osc*/seq/r15/*/1"
  a=parse_sync_address("/osc*/seq/r15/*/1")[3].to_i - 1
  setarray(15,a,b[0])
  sleep 0.05
end
live_loop :r16 do
  use_real_time
  b= sync "/osc*/seq/r16/*/1"
  a=parse_sync_address("/osc*/seq/r16/*/1")[3].to_i - 1
  setarray(16,a,b[0])
  sleep 0.05
end

#live loop sets :singlemode true/false as button is changed
live_loop :singlestepmode do
  use_real_time
  b = sync "/osc*/seq/singlemode"
  if b[0]==1
    set :singlemode,true
  else
    set :singlemode,false
    cue :takesinglestep #restart sequence which will be waiting for a cue
  end
end

#live loop sends a cue :takesinglestep when singlestep button is pushed
live_loop :singlestep do
  use_real_time
  b = sync "/osc*/seq/singlestep"
  if b[0]==1
    cue :takesinglestep
  end  
end

#live loop sets :enable flag true for 2 sec then reverts to false
live_loop :flagenable do
  use_real_time
  b = sync "/osc*/seq/enable"
  if b[0]==1
    set :enable,true
    sleep rt(2)
    set :enable,false
    osc "/seq/enable",0 #reset button indicator
  end
end

#live loop clears all grid entries when button pushed if enable is true
live_loop :clearall do
  use_real_time
  b = sync "/osc*/seq/clearall"  
  clearpatterns if b[0]==1 and get(:enable)
end

#next section deals with saving and reloading data from json files

#live loop writes display arrays to json file seq1.json to seq4.json
#depending on button pushed, and provided that enable is true
live_loop :write do
  use_real_time
  b = sync "/osc*/seq/write*"
  if b[0]==1 #only active as button turns on, not off
    n=(parse_sync_address("/osc*/seq/write*")[2])[5].to_i #get button number
    if get(:enable) #if enable is set, write the file
      puts "writing file seq#{n}.json"
      writeJson(n)
      osc "/seq/wled1",0 #turn all leds off
      osc "/seq/wled2",0
      osc "/seq/wled3",0
      osc "/seq/wled4",0      
      osc "/seq/wled"+n.to_s,1 #turn on write led for selected file

    end
    sleep 1 
    osc "/seq/write"+n.to_s,0 #turn write button indicator off.
  end
end

#live loop reads data from file seq1.json to seq4.json
#depending on button pushed, and provided that enable is true
live_loop :read do
  use_real_time
  b = sync "/osc*/seq/read*"
  if b[0] == 1 #only cactive as button is pushed, not when it is turned off
    n=(parse_sync_address("/osc*/seq/read*")[2])[4].to_i #get button number
    if get(:enable)
      puts "reading seq#{n}.json"
      readJson(n) #read file
      osc "/seq/led1",0 #turn all leds off
      osc "/seq/led2",0
      osc "/seq/led3",0
      osc "/seq/led4",0      
      osc "/seq/led"+n.to_s,1 #turn on led for selected file
    end
    sleep 0.5
    osc "/seq/read"+n.to_s,0 #turn read button indicator off
  end
end

#function to prepare and write the json file
define :writeJson do |n|
  vals=Hash.new #vals will hold the 16 arrays to be stored
  16.times do |i|
  #typical line is vals[:l3]=get(:l3)
    vals[("l"+(i+1).to_s).to_sym] = get(("l"+(i+1).to_s).to_sym)
  end 
  #open file for writing (replaces any file there)
  File.open(JSONfilePath+"seq"+n.to_s+".json", 'w') do |f|
  #write the vals data in "pretty" format
    f.write(MultiJson.dump(vals, pretty: true))
    f.close #file closed
    sleep 0.2
  end
end

#function restores data to the arrays :l1 to l16
define :restoreHash do
  restore=get(:restore) #data from file is stored in :restore
  #puts restore #for debugging
  16.times do |i|
    #typical line resolves to set :l3,restore["l3"]
    set ("l"+(i+1).to_s).to_sym,restore[("l"+(i+1).to_s)]
    #put copy of current array in ltemp
    ltemp=get(("l"+(i+1).to_s).to_sym)
    #loop sets display values for the current ltemp
    16.times do |j|
    #typical line is osc "/seq/r3/5/1",ltemp[4] when i is 2 and j is 4
      osc "/seq/r"+(i+1).to_s+"/"+(j+1).to_s+"/1",ltemp[j]
    end
  end
end

#live loop reads the specified json file and calls restoreHash
#to reset the arrays l1->l16 to the retreived values
#also updating the display 
define :readJson do |n|
  content =File.read(JSONfilePath+"seq"+n.to_s+".json") #pointer to file
  set :restore,MultiJson.load(content) #transfer the data to :restore
  sleep 0.4
  restoreHash #rest the arrays and display values
end

#next section deals with slider settings


#live loop reads changes in tempo slider and adjusts stored tempo
live_loop :settempo do
  use_real_time
  b = sync "/osc*/seq/tempo"
  tv = 100 + (400 * b[0]).to_i
  set :tempo,tv
end
 
#live loop reads sample level slider and sets :v1
live_loop :setlevel1 do
  use_real_time
  b = sync "/osc*/seq/level1"
  set :v1,b[0]
end

#live loop reads note vol slider and sets :v2
live_loop :setlevel2 do
  use_real_time
  b = sync "/osc*/seq/level2"
  set :v2,b[0]
end

#live loop sets synth selection
live_loop :getsynth do
  b = sync "/osc*/seq/s*"
  if b[0]==1
    synNum=parse_sync_address("/osc*/seq/s*")[2][1].to_i
    case synNum
      when 1
        set :syn,:tb303
        osc "/seq/s2",0
        osc "/seq/s3",0
        osc "/seq/s4",0
      when 2
        set :syn,:fm
        osc "/seq/s1",0
        osc "/seq/s3",0
        osc "/seq/s4",0
      when 3
        set :syn,:square
        osc "/seq/s1",0
        osc "/seq/s2",0
        osc "/seq/s4",0
      when 4
        set :syn,:piano
        osc "/seq/s1",0
        osc "/seq/s2",0
        osc "/seq/s3",0
    end
  end
end

#live loop sets tempo slider to fixed positions
live_loop :fixedtempo do
  use_real_time
  b = sync "/osc*/seq/t*"
  if b[0]==1
    tn=parse_sync_address("/osc*/seq/t*")[2][1..-1]
    case tn
      when "000"
        set :tempo, 100
        osc "/seq/tempo" ,0
      when "025"
        set :tempo, 100+0.25*400
        osc "/seq/tempo" ,0.25
      when "050"
        set :tempo, 100 + 0.5*400
        osc "/seq/tempo" ,0.5
      when "075"
        set :tempo, 100 + 0.75*400
        osc "/seq/tempo" ,0.75
      when "100"
        set :tempo, 100 + 400
        osc "/seq/tempo" ,1
    end
  end
end

#main live loop which reads data and activates appropriate samples and notes 
live_loop :pl do
  use_real_time
  use_bpm get(:tempo) #set tempo
  s= get(:syn)
  use_synth s
  if get(:singlemode) #check for singlestepmode and if so wait for cue
    sync :takesinglestep
  end
  n=get(:n) - 1 #adjust n as arrays index from 0, but TouchOSC list from 1
  #retrieve current array values
  l1=get(:l1)
  l2=get(:l2)
  l3=get(:l3)
  l4=get(:l4)
  l5=get(:l5)
  l6=get(:l6)
  l7=get(:l7)
  l8=get(:l8)
  l9=get(:l9)
  l10=get(:l10)
  l11=get(:l11)
  l12=get(:l12)
  l13=get(:l13)
  l14=get(:l14)
  l15=get(:l15)
  l16=get(:l16)
  use_sample_defaults amp: get(:v1) #set volume for samples
  #play samples with a "1" in the relevant step position (n) in their array
  #NOTE you can set differnt samples if you wish
  #you could also change row labels in TouchOSC template to match
  sample :bd_haus if l1[n]==1
  sample :drum_cymbal_pedal if l2[n]==1
  sample :drum_snare_hard if l3[n]==1
  sample :drum_tom_hi_hard if l4[n]==1
  sample :drum_tom_mid_hard if l5[n]==1
  sample :drum_tom_lo_hard if l6[n]==1
  sample :perc_snap if l7[n]==1
  sample :elec_chime if l8[n]==1
  

  #play notes if the relevant array has a "1" set for the current step (n)
  #NOTE you can specify differnt notes if you wish
  #you could also change the row labels in TouchOSC template to match 
  use_synth_defaults amp: get(:v2) #set volume for notes
  use_merged_synth_defaults cutoff: rrand(50,110) if s == :tb303
  case s
    when :tb303
      use_transpose 0
    when :fm
      use_transpose 24
    else
      use_transpose 12
  end

  play :c4 if l9[n]==1
  play :b3 if l10[n]==1
  play :a3 if l11[n]==1
  play :g3 if l12[n]==1
  play :f3 if l13[n]==1
  play :e3 if l14[n]==1
  play :d3 if l15[n]==1
  play :c3 if l16[n]==1

  while get(:pause) do #check if :pause is true and if so wait until it is false
    sleep 1
  end
  sleep 1
end
  