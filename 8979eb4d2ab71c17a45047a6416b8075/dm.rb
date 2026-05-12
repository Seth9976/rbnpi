#dm.rb
#Drum pattern generator inspired by https://mynoise.net/NoiseMachines/polyrhythmBeatGenerator.php
#Control is by means of a TouchOSC screen on a tablet
#coded by Robin Newman, December 2017
#uses 10 components to a drum pattern, each playing at a different number of "hits' per cycle
#ranging from 1 to 10. Individual componetn volumes, pan positions and samples can be set
#a master volume is provided, and the tempo can be chosen from 5 values
#A start/stop sync button stops and starts the sequence at the beginning of a new cycle.
#Patterns can be saved in JSON tect files and restored, with two banks giving 20 files
#A safety enable save interloc prevents inadvertent overwriting.
#buttons provide quick resettings of all volues, pan settings and sample selections.
use_osc "192.168.1.240",9000 #address of TouchOSC tablet
use_osc_logging false
set :bpm,25 #initial bpm
set :sv,0 #start/stop value
tempo=[20,25,30,35,40] #tempo choices
define :getTempoSwitch do |address| #gets which tempo switch activated
  return get_event(address).to_s.split(",")[6][address.length-1..-4].to_i
end
live_loop :gettempo do #get tempo setting
  use_real_time
  b= sync "/osc/dm/tempo/*/1"
  if b[0]==1
    tn=5-getTempoSwitch("/osc/dm/tempo/*/1")
    set :bpm,tempo[tn]
  end
end

osc "/dm/tempo/4/1",1 #set second top position = 25 for tempo
use_bpm get(:bpm) #set tempo
t1=1 #drum intervals for each component
t2=1/2.0
t3=1/3.0
t4=1/4.0
t5=1/5.0
t6=1/6.0
t7=1/7.0
t8=1/8.0
t9=1/9.0
t10=1/10.0
v=[0]*11 #list for volume
p=[0]*11 #list for pan
sam=[0]*11 #list for sample
samName=(ring :elec_twip,:elec_plip,:elec_blup,:drum_tom_lo_hard,:drum_tom_mid_hard,:drum_tom_hi_hard)
JSONfilePath="/Users/rbn/Documents/SPfromXML/TouchData/dm" #path for JSON storage files

define :volstozero do |flag=0| #set vols to zero OR v values if flag is 1, updating sliders
  if flag==0
    11.times do |n|
      osc "/dm/vol/"+n.to_s,0
      v[n]=0
      sleep 0.02
    end
    osc "/dm/vol0",0
  else
    11.times do |n|
      osc "/dm/vol/"+n.to_s,v[n]
      sleep 0.02
    end
    osc "/dm/vol0",v[0]
  end
  #puts "vol is ",v #for debug
end

define :panstozero do |flag=0| #set pans to zero OR p values if flag is 1, updating sliders
  if flag==0
    11.times do |n|
      osc "/dm/pan/"+n.to_s,0
      p[n]=0
      sleep 0.02
    end
  else
    11.times do |n|
      osc "/dm/pan/"+(11-n).to_s,p[n] #reverse numbering
      sleep 0.01
    end
  end
  #puts "pan is now ",p #for debug
end

define :samNumto1 do |flag=0| #set sample to first value, or sam settings if flaig is 1,updating switches
  if flag==0
    11.times do |n|
      osc "/dm/sam"+n.to_s+"/1/1",1
      sam[n]=0
      sleep 0.01
    end
  else
    11.times do |n|
      osc "/dm/sam"+n.to_s+"/1/"+(sam[n]+1).to_s,1
      sleep 0.01
    end
  end
  #puts "sam is now ",sam #for debug
end

osc "/dm/sync",0 #intialise sync (start/stop button)
osc "/dm/slot/10/1",1 #initialise pattern select slot switch
slot=1 #initialise slot value (top row)
panstozero
volstozero
samNumto1 #set sam values to 0


define :pl do |s,n,t,p=0,a=0,r=0| #play component sample
  while get(:sv)==0 #wait until start/stop switch is on (1)
    sleep 0.05
  end
  use_bpm get(:bpm) #set current bpm
  n.times do #play number of samples per cycle for current element
    sample s,amp: a*v[0],pan: p#use sample, vol and pan settings
    sleep t
  end
end


define :getSlider do |address| #decode slider used in multi slider
  return get_event(address).to_s.split(",")[6][address.length+1..-2].to_i
end
define :getSamSwitch do |address| #decode sam switch used
  return get_event(address).to_s.split(",")[6][address.length-3..-6].to_i
end
define :getSlotSwitch do |address| #decode pattern select switch
  return get_event(address).to_s.split(",")[6][address.length-1..-4].to_i
end
define :getBankSwitch do |address| #decode bank seledt switch
  return get_event(address).to_s.split(",")[6][address.length+1..-2].to_i
end
define :getGlobalSampleSwitch do |address| #decode bank seledt switch
  return get_event(address).to_s.split(",")[6][address.length-1..-4].to_i
end

live_loop :getv do #get volume setting for slider changed and store in v
  use_real_time
  vol= sync "/osc/dm/vol/*"
  sn= getSlider("/osc/dm/vol/*")
  v[sn]=vol[0]
end
live_loop :mastervol do #get mastervol level and store in v[0]
  use_real_time
  b= sync "/osc/dm/vol0"
  v[0]=b[0]
end
live_loop :startsync do #get start/stop setting
  use_real_time
  b=sync "/osc/dm/sync"
  set :sv,b[0]
end
live_loop :getsam do #get sample set for component wich is changed, store in sam
  b= sync "/osc/dm/sam*/1/*"
  if b[0]==1
    ch= getSamSwitch("/osc/dm/sam*/1/*")
    samNum= getSlider("/osc/dm/sam"+ch.to_s+"/1/*")
    sam[ch]=samNum-1
    puts "Channel #{ch} set to #{samNum} synth #{samName[sam[ch]]}"
  end
end

live_loop :globalsampleset do #set all component samples to same value
  b = sync "/osc/dm/globalsample/*/1"
  if b[0]==1
    globsam= getGlobalSampleSwitch("/osc/dm/globalsample/*/1")
    #puts globsam,7-globsam #for debug
    11.times do |n|
      osc "/dm/sam"+n.to_s+"/1/"+(7-globsam).to_s,1
      sam[n]=6-globsam
      sleep 0.01
    end
  end
end

live_loop :getpan do #get pan for component which is changed and store in p
  use_real_time
  panpos= sync "/osc/dm/pan/*"
  pn= getSlider("/osc/dm/pan/*")
  #puts pn,panpos[0] #for debug
  p[11-pn]=panpos[0] #reverse numbering
end
live_loop :setzero do #zero vols when zero button pressed
  use_real_time
  b= sync "/osc/dm/zero"
  if b[0]==1
    volstozero
  end
end
live_loop :setcentre do #centre pans when centre button pressed
  use_real_time
  b= sync "/osc/dm/centre"
  if b[0]==1
    panstozero
  end
end
with_fx :reverb,room: 0.6,mix: 0.6 do #play with reverb
  live_loop :t1 do #live loops to play the compnents
    pl(samName[sam[1]],1,t1,p[1],v[1])
  end
  live_loop :t2 do
    pl(samName[sam[2]],2,t2,p[2],v[2])
  end
  live_loop :t3 do
    pl(samName[sam[3]],3,t3,p[3],v[3])
  end
  live_loop :t4 do
    pl(samName[sam[4]],4,t4,p[4],v[4])
  end
  live_loop :t5 do
    pl(samName[sam[5]],5,t5,p[5],v[5])
  end
  live_loop :t6 do
    pl(samName[sam[6]],6,t6,p[6],v[6])
  end
  live_loop :t7 do
    pl(samName[sam[7]],7,t7,p[7],v[7])
  end
  live_loop :t8 do
    pl(samName[sam[8]],8,t8,p[8],v[8])
  end
  live_loop :t9 do
    pl(samName[sam[9]],9,t9,p[9],v[9])
  end
  live_loop :t10 do
    pl(samName[sam[10]],10,t10,p[10],v[10])
  end
end


vals=Hash.new #hash to store values for json write (save) and read (restore)

osc "/dm/patternbank/1/1",1 #set bank switch to 0 position
bank=0 #initial bank
saveFlag=0 #initial saveFlag

define :loadHash do #load vals hash
  vals[:valV]=v
  vals[:valP]=p
  vals[:valSam]=sam
end

define :restoreHash do #restore v/p/sam from vals hash
  v= vals["valV"] #dRestore
  p= vals["valP"]
  sam= vals["valSam"]
end

define :writeJson do |n| #write Json file using current v/p/sam
  loadHash
  File.open(JSONfilePath+(n).to_s+".json", 'w') do |f|
    f.write(MultiJson.dump(vals, pretty: true))
    f.close
  end
end

define :readJson do |n| #read Json file and set v/p/sam accordingly
  content =File.read(JSONfilePath+n.to_s+".json")
  vals =  MultiJson.load(content) #dRestore
  sleep 0.2
  #extract the data
  restoreHash
  panstozero(1) #restore pan using parameter 1
  volstozero(1) #restore vols
  samNumto1(1) #restore samples
end

live_loop :readslot do #deal with slot (pattern select) changes
  use_real_time
  b = sync "/osc/dm/slot/*/1"
  if b[0]==1
    slot=11-getSlotSwitch("/osc/dm/slot/*/1") #reverse numbering
    puts "slot is #{slot+10*bank}"
  end
end

live_loop :writeData do #deal with Save Pattern button, using write enable
  use_real_time
  b = sync "/osc/dm/write"
  if saveFlag==0
    puts "Save not enabled"
    play 84,release: 0.2 #warining tone
  else
    if b[0]==1
      writeJson(slot+10*bank)
      puts "data written to slot #{slot+10*bank}"
    end
  end
end

live_loop :readData do #deal with Load Pattern button
  use_real_time
  b = sync "/osc/dm/read"
  if b[0]==1
    readJson(slot+10*bank)
    puts "data read from slot #{slot+10*bank}"
  end
end

live_loop :patternbank do #deal with PAttern Bank select
  b = sync "/osc/dm/patternbank/1/*"
  if b[0]==1
    bank= getBankSwitch("/osc/dm/patternbank/1/*")-1 #value will be 0 or 1
    puts "bank selected is #{bank}"
  end
  
end

live_loop :enablesave do #deal with enable save button
  use_real_time
  b = sync "/osc/dm/enablesave"
  if b[0]==1
    osc "/dm/ledSave",1
    saveFlag=1 #enalbe save
    sleep  rt(1.5) #1.5 seconds regardless of tempo
    osc "/dm/ledSave",0
    saveFlag=0 #disable save
  end
end
