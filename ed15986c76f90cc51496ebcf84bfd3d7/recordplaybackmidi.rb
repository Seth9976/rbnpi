#program to record realtime midi input,and then replay it.
#records midi input from say a keyboard, saving data into array tlist
#this can then be replayed. Records, note pitch, time started,
#velocity of key and note duration.
#coded by Robin Newman April 2020 EDITED April 2022 for updated midi message handling

uncomment do #comment to record, uncomment to replay
  tlist=get(:tlist)
  puts tlist.length
  puts tlist
  puts tlist[0]
  
  st=[];nt=[];dr=[];na=[] #save start time, note and duration
  tlist.length.times do |i| #extract data to three lists
    st[i]=tlist[i][3]
    nt[i]=tlist[i],[0]
    dr[i]=tlist[i],[1]
    na[i]=tlist[i],[2]
  end
  use_synth :tri
  at st, tlist do |t,d| #use at list to play notes
    puts t, d[0],d[1],d[2]
    play d[0],sustain: d[1],amp: d[2],release: 0.05
    
  end
  
  stop
end#comment

offset=0
plist=[] #list to contains references to notes to be killed
ns=[] #array to store note playing references
nv=[0]*128 #array to store state of note for a particlar pitch 1=on, 0 = 0ff
nt=[0]*128
na=[0]*128
tlist=[]
128.times do |i|
  ns[i]=("n"+i.to_s).to_sym #set up array of symbols :n0 ...:n127
end
#puts ns #for testing

define :sv do |sym| #extract numeric value associated with symbol eg :n64 => 64
  return sym.to_s[1..-1].to_i
end
#puts sv(ns[64]) #for testing


define :geton do |address|
  v= get_event(address).to_s.split(",")[6]#[address.length+1..-2].to_i
  return v.include?"note_on"
end
define :parse_midi_sync_address do |address|
  v= get_event(address).to_s.split(",")[6]
  if v != nil
    p1=v[3..-2].split("/")
    return p1[0].split(":")+p1[1..-1]
  else
    return ["error"]
  end
end

live_loop :midi_piano_on do #this loop starts 5 second notes for spcified pitches and stores reference
  use_real_time
  note, vol = sync "/midi*/note_*" #change to match your controller
  res= parse_midi_sync_address "/midi*/*"
  puts res
  puts res[3] #edited to reflect updated midi message handling use res[3] not res[4]
  if res[3]=="note_on" and vol>0 #edited to reflect updated midi message handling use res[3] not [4]
    puts note,nv[note]
    if nv[note]==0 #check if new start for the note
      nv[note]=1 #mark note as started for this pitch
      nt[note]=vt-offset
      na[note]=vol/127.0
      use_synth :tri
      #max duration of note set to 5 on next line. Can increase if you wish.
      x = play note, amp: vol/127.0,sustain: 50 #play note
      set ns[note],x #store reference in ns array
    end
  else
    if nv[note]==1 #check if this pitch is on
      
      nv[note]=0 #set this pitch off
      tlist << [note,vt-nt[note]-offset,na[note],nt[note]]
      plist << get(ns[note])
      puts tlist
    end
  end
end

live_loop :notekill,auto_cue: false,delay: 0.25 do
  use_real_time
  if plist.length > 0 #check if notes to be killed
    k=plist.pop
    control k,amp: 0,amp_slide: 0.02 #fade note out in 0.02 seconds
    sleep 0.02
    kill k #kill the note referred to in ns array
  end
  sleep 0.01
end
#controlling midi-cc inputs
#23 resets recorded list to nil
#24 resets start time to zero
#25 saves recorded list to :tlist
live_loop :newAndSaveTune do
  use_real_time
  n,v=sync "/midi*/control_change"
  if n==23 and v==127
    tlist=[]
  end
  if n==24 and v==127
    offset=vt
  end
  if n==25 and v==127
    set :tlist,tlist
    puts get(:tlist)
  end
end
