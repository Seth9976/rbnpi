#helmOSCsynthSelector.rb
#program written by Robin Newman, November 2019
#uses TouchOSC and Sonic Pi to allow easy remote selection of any factory preset for Helm Synth
#also has some test midi sequences that can be sent to Helm
#audio output from Helm fed back through Sonic Pi, and volume is controllable there.
#turn off most logging. Can enable for testing
use_osc_logging false
use_midi_logging false
use_debug false
#setup user specified values
use_osc "192.168.1.240",9000 #address and port of TouchOSC device
#choose midi port to suit. I used "iac_driver_sonicpi" (mac) or "midi_through_port-0" (RaspberryPi)
use_midi_defaults port: "iac_driver_sonicpi",channel: 1 #midi port and channel
#select ONE of the next two lines as appropriate
dirbase=(ENV['HOME']+"/Library/Audio/Presets/Helm/Factory Presets/") #path to helm presets (Mac)
#dirbase=("/home/pi/.helm/patches/Factory Presets/") #path to helm presets (Raspberry Pi)

define :getList do |type| #get patch names for a given type from their stored location
  files = Dir.glob(File.join(dirbase+type, '**', '*')).select{|file| File.file?(file)}.sort
  l=[]
  files.each do |f|
    #select one of the next two lines depending on OS used
    l<< f.split("/")[9][0..-6] #strip out just filename without .helm suffix (for Mac)
    #l<< f.split("/")[7][0..-6] #strip out just filename without .helm suffix (for RPi)
  end
  return l
end

define :getTypeList do #get list of patch types (these are folder names)
  tl=[]
  Dir.chdir(dirbase) do
    tl= Dir.glob('*').select { |f| File.directory? f }.sort #get sorted list of folders
  end
  return tl
end
typeList=getTypeList #store list of patch type folders


l=[] #initialise list for patch names
limits=[] #initialise list for index max limit for each patch type
typeList.each_with_index do |type,i| #fill type lists and limits list
  l[i]=getList type
  limits[i]=l[i].length - 1
end

plist=[l[0],l[1],l[2],l[3],l[4],l[5],l[6],l[7],l[8]] #plist is a list of the  9 patch type lists
sleep 1 #let things settle. (maily for RPi)
define :parse_sync_address do |address| # used to retrieve data which matched wild card in synced event
  v= get_event(address).to_s.split(",")[6]
  if v != nil
    return v[3..-2].split("/")
  else
    return ["error"]
  end
end

#initialise volume slider position
osc "/helm/volume",0.5
osc "/helm/volScale/2/1",1 #set second switch
osc "/helm/tempo/2/1",1 #set 2nd tempo
set :type,0 #set starting type, choice and volume
set :choice,0
set :vol, 0.5
set :volScale, 3
set :tempo,60

live_loop :getVol,delay: 2 do #live loop to adjust volume. Delayed start to allow live_audio setup
  use_real_time
  b = sync "/osc*/helm/volume"
  set :vol,b[0]
end
live_loop :getVolScale,delay: 2 do #live loop to get volScale setting
  use_real_time
  b = sync "/osc*/helm/volScale/*/1"
  if b[0]==1.0
    n=parse_sync_address("/osc*/helm/volScale/*/1")[3].to_i
    set :volScale,[1,3,5,7][n-1] #select vol multiplier
  end
end
live_loop :getTempo,delay: 2 do #live loop to adjust volume. Delayed start to allow live_audio setup
  use_real_time
  b = sync "/osc*/helm/tempo/*/1"
  if b[0]==1.0
    n=parse_sync_address("/osc*/helm/tempo/*/1")[3].to_i
    set :tempo,[30,60,90,120][n-1] #select tempo
  end
end

with_fx :level, amp: get(:vol)*get(:volScale) do |vl| #set volume level of incoming audio from Helm
  set :vl,vl
  live_loop :adjustV, delay: 2 do #loop checks and adjust vol every 0.5 seconds
    control get(:vl),amp: get(:vol)*get(:volScale),amp_slide: 0.2
    sleep 0.5
  end
  
  live_audio :helm,input: 1, stereo: true #audio in from Helm
end

define :patch do |bank=0,folder=0,patch=0| #midi code to adjust patch.
  midi_cc 0,bank #always 0 in this version. Could expand to cover user bank
  midi_cc 32,folder #patch folder type index
  midi_pc patch #patch name index in folder
end

define :emptyLabels do #clear all patch label names
  58.times do |x|
    v=x.to_s
    v="0"+v if x<10
    osc "/helm/L"+v,""
    sleep 0.01
  end
end

define :populateLabels do |lab| #populate patch label names for given selected type
  emptyLabels
  lab.length.times do |x|
    v=x.to_s
    v="0"+v if x<10
    osc "/helm/L"+v,lab[x]
    sleep 0.01
  end
end

define :setPled do |n| #light led for current choice, or none if n < 0
  57.times do |x|
    osc "/helm/led"+x.to_s,0
  end
  if n >=0
    osc "/helm/led"+n.to_s,1
    set :choice,n
  end
end

define :setType do |n| #light type led for current selection n, then populate labels
  9.times do |x|
    osc "/helm/T"+x.to_s,0
  end
  sleep 0.1
  osc "/helm/T"+n.to_s,1
  set :type,n
  populateLabels plist[n] if n >= 0 #ignore for negative n
  setPled -1 #turn off choice led as no longer valid for current list
end

setType 0 #init starting position (arp choices)


live_loop :getType do #get osc message to update current type
  use_real_time
  b = sync "/osc*/helm/Tp*"
  if b[0]==1.0
    puts parse_sync_address("/osc*/helm/Tp*")
    n= parse_sync_address("/osc*/helm/Tp*")[2][-1].to_i
    puts n
    setType n
  end
end
live_loop :getChoice do #get osc message to update current choice
  use_real_time
  b = sync "/osc*/helm/p*"
  if b[0]==1.0
    n = parse_sync_address("/osc*/helm/p*")[2][-2..-1].to_i
    #puts n
    setPled n  if n<= limits[get(:type)] #update led
    patch 0,get(:type),get(:choice) #send new patch selection to helm
  end
end

live_loop :chooseScale do #choose midi notes to use depending on selector switch
  use_real_time
  b = sync "/osc*/helm/selectScale/*/1"
  if b[0]==1.0
    n= parse_sync_address("/osc*/helm/selectScale/*/1")[3].to_i
    #puts "scale on #{n}"
    case n
    when 1
      set :sv,0.2
      set :snote,:c4
      doLoop 1,1 #doLoop sets up live_loop name1 to send midi notes
    when 2
      set :sv,0.2
      set :snote,:c5
      doLoop 2,2 #sets up live_loop name2
    when 3
      set :sv,1
      set :snote,:c3
      doLoop 3,1 #sets up live_loop name3
    when 4
      set :sv,0.5
      set :snote,:c3
      doLoop 4,2 #sets up live_loop name4
    when 5
      set :sv,2
      set :snote,:c4
      doLoop 5,1 #sets up live_loop name5
    end
  else #b[0]==0.0 so deal with stopping any deselected loop
    n= parse_sync_address("/osc*/helm/selectScale/*/1")[3].to_i
    #puts "scale off #{n}"
    set ("kill"+n.to_s).to_sym,true #set kill switch for the selected loop
    #puts "stopping loop"+n.to_s
  end
end

#sets up and starts live_loop named name<n>
define :doLoop do |n,ch,vol=get(:vol)| #parameters n (for name),ch for tick or choose,vol setting
  set ("kill"+n.to_s).to_sym,false #set kill flag to false
  ln=("name"+n.to_s).to_sym #create loop name
  
  live_loop  ln do #start the loop
    use_bpm get(:tempo) #set current tempo
    nv=scale(get(:snote),:minor_pentatonic).tick if ch==1 #choose note select method depending on ch
    nv=scale(get(:snote),:minor_pentatonic).choose if ch==2
    midi nv,sustain: get(:sv),vel_f: vol #send midi to helm
    sleep get(:sv)
    #puts "loop"+n.to_s,get( ("kill"+n.to_s).to_sym)
    stop if get( ("kill"+n.to_s).to_sym)==true #stop the loop if flag has changed to true
  end
end



define :stopAllScales do #set all midi loop kill flags to true
  5.times do |n|
    osc "/helm/selectScale/"+(n+1).to_s+"/1",0 #turn all button indicators off
    set ("kill"+(n+1).to_s).to_sym,true
  end
end

live_loop :oscKillScales do #detect Stop Patter button pushed and stop all midi loops
  use_real_time
  b = sync "/osc*/helm/stopAll"
  if b[0]==1.0
    stopAllScales
    midi_all_notes_off
  end
end

live_loop :clearAll do #detect Clear All pushed
  use_real_time
  b= sync "/osc*/helm/clearPanel"
  if b[0]==1.0
    emptyLabels #clear all labels
    setType -1 #clear all type leds
    stopAllScales #stop any playing midi loops
    midi_all_notes_off #stop any other midi notes currently playing
  end
end
