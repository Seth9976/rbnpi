#spRecordPlayer.rb
#Sonic Pi Record / Player control using TouchOSC written by Robin Newman, March 2018
#handles recording and playback, real time or double speed, key changes, metronome, two synths
#uses Ableton push2 style layout
#release version 1.0.1
#few comments because of space limitations
use_osc "192.168.1.240",9000 #adjust for the address of your TouchOSC device
use_real_time
use_osc_logging false
use_bpm 60
st=Time.now
#intialise various flags
set :playing,false
set :recflag,false
set :leds,true
set :key,1
set :majmin,0
set :metroflag,false
set :ms,90
set :pb,60
set :synptr,1
delta=0.1

define :clearData do #clear all stored data
  recn=[].clear;timn=[].clear
  recp=[].clear;timp=[].clear
  recm=[].clear;timm=[].clear
  recs=[].clear;tims=[].clear
  set :recn,recn;set :timn,timn
  set :recp,recp;set :timp,timp
  set :recm,recm;set :timm,timm
  set :recs,recs;set :tims,tims
  sleep 0.2
end

define :blueledsOn do
  10.times do |x|
    osc "/sprp/m"+(x+1).to_s,1
    sleep 0.01
  end
end

define :flashPush do |c,r| #flash matrix button pushed
  osc "/sprp/multipush1/"+c.to_s+"/"+r.to_s,1
  sleep 0.2
  osc "/sprp/multipush1/"+c.to_s+"/"+r.to_s,0
end

define :parse_sync_address do |address| #get address wildcards
  v= get_event(address).to_s.split(",")[6]
  if v != nil
    return v[3..-2].split("/")
  else
    return ["error"]
  end
end

define :init do #init page 1 of the display
  osc "/sprp/record",0
  osc "/sprp/playback",0
  osc "/sprp/key/1/1",1
  osc "/sprp/majmin",0
  osc "/sprp/majminLabel","major"
  osc "/sprp/mt1",1
  osc "/sprp/mt2",0
  osc "/sprp/pb1",1
  osc "/sprp/pb2",0
  osc "/sprp/pb3",0
  osc "/sprp/synth/1/1",1
  osc "/sprp/metronome",0
  osc "/sprp/ledplayback",1
  blueledsOn
end
##next section handles metronome
live_loop :setmetronome do
  b = sync "/osc/sprp/metronome "
  if b[0]==1
    set :metroflag,true
  else
    set :metroflag,false
  end
end

live_loop :adjustMetro do
  b = sync "/osc/sprp/mt*"
  res = parse_sync_address "/osc/sprp/mt*"
  if b[0]==1
    if res[2][-1]=="1"
      osc "/sprp/mt2",0
      set :ms,90
    elsif res[2][-1]=="2"
      osc "/sprp/mt1",0
      set :ms,120
    end
  end
end

live_loop :metro do
  use_bpm get(:ms)
  play :c5,release:0.05 if get(:metroflag)
  sleep 1
end
#handle playback tempo
live_loop :adjustPBtempo do
  b = sync "/osc/sprp/pb*"
  res = parse_sync_address "/osc/sprp/pb*"
  if b[0]==1
    if res[2][-1]=="1"
      osc "/sprp/pb2",0
      osc "/sprp/pb3",0
      set :pb,60
    elsif res[2][-1]=="2"
      osc "/sprp/pb1",0
      osc "/sprp/pb3",0
      set :pb,90
    elsif res[2][-1]=="3"
      osc "/sprp/pb1",0
      osc "/sprp/pb2",0
      set :pb,120
    end
  end
end
#handle led pb on button
live_loop :getledplayback do
  b = sync "/osc/sprp/ledplayback"
  if b[0]==1
    set :leds,true
  else
    set :leds,false
  end
end

init # run the screen init

define :doExtraToggles do |c,r,state| #control extra notes display
  osc "/sprp/multipush1/"+(c.to_i-3).to_s+"/"+(r.to_i-1).to_s,state if c.to_i-3>0 and r.to_i-1 > 0
  osc "/sprp/multipush1/"+(c.to_i-6).to_s+"/"+(r.to_i-2).to_s,state if c.to_i-6>0 and r.to_i-2 > 0
  osc "/sprp/multipush1/"+(c.to_i+3).to_s+"/"+(r.to_i+1).to_s,state if c.to_i+3<9 and r.to_i+1 < 9
  osc "/sprp/multipush1/"+(c.to_i+6).to_s+"/"+(r.to_i+2).to_s,state if c.to_i+6<9 and r.to_i+2 < 9
  
end
##next section handles note input recording and playback
define :playNote do |c,r|
  use_synth [:piano,:pluck][(get(:synptr)).to_i-1]
  sc=["c","d","e","f","g","a","b"][get(:key).to_i-1]
  type = [:major,:minor][get(:majmin).to_i]
  play scale(sc+"2",type,num_octaves: 7)[(c.to_i-1)+3*(8-r.to_i)]
  if get(:leds)
    in_thread do
      flashPush c,r
    end
  end
  sleep 0.1
end

live_loop :testNoteKeyPushed do
  b= sync "/osc/sprp/multipush1/*/*"
  if b[0]==1
    res = parse_sync_address "/osc/sprp/multipush1/*/*"
    in_thread do
      doExtraToggles(res[3],res[4],1)
    end
    if get(:recflag)
      in_thread do
        recn=get(:recn);timn=get(:timn)
        rn=recn + [[res[3],res[4]]]
        tn=timn + [Time.now-st]
        set :recn,rn
        set :timn,tn
      end
    end
    playNote res[3],res[4]
  end
end

live_loop :testNoteKeyReleased do
  b= sync "/osc/sprp/multipush1/*/*"
  if b[0]==0
    res = parse_sync_address "/osc/sprp/multipush1/*/*"
    in_thread do
      doExtraToggles(res[3],res[4],0)
    end
  end
end

define :playRecordedNotes do
  use_bpm get(:pb)
  set :notesfinish,false
  recn= get(:recn)
  timn = get(:timn)
  sleep 0.2
  if recn != nil
    recn.length.times do |x|
      if x==0
        sleep timn[0]-delta
      else
        sleep timn[x]-timn[x-1]-delta
      end
      playNote(recn[x][0],recn[x][1])
      break if get(:kill)
    end
  end
  puts "finished notes playback"
  set :notesfinish,true
end
## next section handles major/minor changes
live_loop :getMajminChanges do
  b = sync "/osc/sprp/majmin"
  set :majmin,b[0]
  if b[0]==1
    osc "/sprp/majminLabel","minor"
  else
    osc "/sprp/majminLabel","major"
  end
  if get(:recflag)
    recm=get(:recm);timm=get(:timm)
    rnm=recm + [b[0]]
    tnm=timm + [Time.now-st]
    set :recm,rnm
    set :timm,tnm
  end
end

define :playbackMajmin do
  set :mmfinish,false
  use_bpm get(:pb)
  recm= get(:recm)
  timm = get(:timm)
  sleep 0.2
  if recm != nil
    recm.length.times do |x|
      if x==0
        sleep 0
      else
        sleep timm[x]-timm[x-1]-delta
      end
      set :majmin,recm[x]
      osc "/sprp/majmin",recm[x].to_i
      osc "/sprp/majminLabel",["major","minor"][recm[x].to_i]
      break if get(:kill)
    end
  end
  set :mmfinish,true
  puts "finished majmin playback"
end
###### next section handles Key changes
live_loop :keySwitchChanged do
  b= sync "/osc/sprp/key/*/*"
  res = parse_sync_address "/osc/sprp/key/*/1"
  if b[0]==1
    set :key,res[3]
    if get(:recflag)
      recp=get(:recp);timp=get(:timp)
      rnp=recp + [res[3].to_i]
      tnp=timp + [Time.now-st]
      set :recp,rnp
      set :timp,tnp
    end
  end
end

define :playbackRecordedKey do
  set :pushfinish,false
  use_bpm get(:pb)
  recp= get(:recp)
  timp = get(:timp)
  sleep 0.2
  if recp !=nil
    recp.length.times do |x|
      if x==0
        sleep 0
      else
        sleep timp[x]-timp[x-1]-delta
      end
      set :key,recp[x]
      osc "/sprp/key/"+ recp[x].to_s+"/1",1
      break if get(:kill)
    end
  end
  set :pushfinish,true
  puts "finished key playback"
end
#next section handles Synth selection
live_loop :chooseSynth do
  b = sync "/osc/sprp/synth/*/1"
  if b[0]==1
    v = parse_sync_address "/osc/sprp/synth/*/1"
    set :synptr,v[3]
    if get(:recflag)
      recs=get(:recs);tims=get(:tims)
      rns=recs + [v[3]]
      tns=tims + [Time.now-st]
      set :recs,rns
      set :tims,tns
    end
  end
end

define :playbackSynth do
  set :synfinish,false
  use_bpm get(:pb)
  recs= get(:recs)
  tims = get(:tims)
  sleep 0.2
  if recs != nil
    recs.length.times do |x|
      if x==0
        sleep 0
      else
        sleep tims[x]-tims[x-1]-delta
      end
      s=recs[x].to_i
      set :synptr,s
      
      osc "/sprp/synth/"+s.to_s+"/1",1
      break if get(:kill)
    end
  end
  set :synfinish,true
  puts "finished synth playback"
end
#next section recording/playback logic
live_loop :recording do
  b = sync "/osc/sprp/record"
  if b[0]==1
    if  get(:playing)==false
      clearData #initialise for recording
      set :recp,[get(:key)];set :timp,[0]
      set :recm,[get(:majmin)];set:timm,[0]
      set :recs,[get(:synptr)];set:tims,[0]
      st=Time.now
      set :recflag,true
      puts "recording"
    else
      osc "/sprp/record",0
    end
  else
    set :recflag,false
    #data is extracted for saving in the other program
    puts "stopped recording"
  end
end

define :playbackControl do
  set :playing,true
  in_thread do
    playbackSynth
  end
  in_thread do
    playRecordedNotes
  end
  in_thread do
    playbackRecordedKey
  end
  in_thread do
    playbackMajmin
  end
  
end

live_loop :checkNotPlaying do
  #puts "playing is",get(:playing)
  if get(:notesfinish)==true and get(:pushfinish)==true and get(:mmfinish)==true and get(:synfinish)==true
    set :playing,false
    osc "/sprp/playback",0
  end
  if get(:rec)==true
    osc "/sprp/playback",0
  end
  sleep 0.5
end

live_loop :handlePlayButton do
  b = sync "/osc/sprp/playback"
  if b[0]==1
    if get(:recflag)==false and get(:playing)==false
      set :playing, true
      puts "starting playback"
      set :kill,false
      playbackControl
    end
  else
    set :kill,true
    set :playing,false
    puts "Playback finished"
  end
end