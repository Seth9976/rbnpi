#polyphonic midi input program with sustained notes
#experimental program by Robin Newman, November 2017
#pitchbend can be applied to note AS IT STARTS

#This version for controllers with separate note_on and note_off midi signals
#rather than using note_on with velocity 0 for midi_off signal

set :pb,0 #pitchbend value
plist=[] #list to contains references to notes to be killed
ns=[] #array to store note playing references
nv=[0]*128 #array to store state of note for a particlar pitch 1=on, 0 = 0ff

128.times do |i|
  ns[i]=("n"+i.to_s).to_sym #set up array of symbols :n0 ...:n127
end
#puts ns #for testing

define :sv do |sym| #extract numeric value associated with symbol eg :n64 => 64
  return sym.to_s[1..-1].to_i
end
#puts sv(ns[64]) #for testing

live_loop :pb do #get current pitchbend value adjusted in range -12 to +12 (octave)
  b = sync "/midi/*/*/*/pitch_bend"
  set :pb,(b[0]-8192).to_f/8192*12
  puts get(:pb)
end

define :geton do |address|
  v= get_event(address).to_s.split(",")[6]#[address.length+1..-2].to_i
  return v.include?"note_on"
end
define :parse_sync_address do |address|
  v= get_event(address).to_s.split(",")[6]#[address.length+1..-2].to_i
  if v != nil
    return v[3..-2].split("/")
  else
    return ["error"]
  end
end

live_loop :midi_piano_on do #this loop starts 5 second notes for spcified pitches and stores reference
  use_real_time
  note, vol = sync "/midi/*/*/*/note_*"
  res= parse_sync_address "/midi/*/*/*/*"
  puts res[4]
  if res[4]=="note_on"
    puts note,nv[note]
    if nv[note]==0 #check if new start for the note
      nv[note]=1 #mark note as started for this pitch
      use_synth :tri
      #max duration of note set to 5 on next line. Can increase if you wish.
      x = play note+get(:pb), amp: vol/127.0,sustain: 50 #play note
      set ns[note],x #store reference in ns array
    end
  else
    if nv[note]==1 #check if this pitch is on
      nv[note]=0 #set this pitch off
      plist << get(ns[note])
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