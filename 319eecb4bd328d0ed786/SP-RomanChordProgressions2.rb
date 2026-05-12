#playing with chord progressions and their syntax by Robin Newman, November 2015 (rev 5)
#revision 5 a major rewrite to allow both major and minor scales to be the basis of the chord progressions.

#first generate offsets for major and minor scales
s=scale(:c4,:major)
maj=s.map{|n| n-s[0]}
#puts maj
s=scale(:c4,:minor)
min=s.map{|n| n-s[0]}
#puts min
#now generate symbol lists for different chords
#D degree, U uppercase (major), L lowercase (minor),A augmented,F flattened,O diminished,NO natural diminished
DU=[:I,:II,:III,:IV,:V,:VI,:VII]
DL=[:i,:ii,:iii,:iv,:v,:vi,:vii]
DU7=[:I7,:II7,:III7,:IV7,:V7,:VI7,:VII7]
DL7=[:i7,:ii7,:iii7,:iv7,:v7,:vi7,:vii7]
DUA=[:Ia,:IIa,:IIIa,:IVa,:Va,:IVIa,:VIIa]
DUF=[:bI,:bII,:bIII,:bIV,:bV,:bVI,:bVII]
DLO=[:io,:iio,:iiio,:ivo,:vo,:vio,:viio]
DLF=[:bi,:bii,:biii,:biv,:bv,:bvi,:bvii]
DLNO=[:nio,:niio,:niiio,:nivo,:nvo,:nvio,:nviio]
#now generate hash tables for the symbol lists for both major and minor scales
majU=Hash[DU.zip maj]
minU=Hash[DU.zip min]
majL=Hash[DL.zip maj]
minL=Hash[DL.zip min]
majU7=Hash[DU7.zip maj]
minU7=Hash[DU7.zip min]
majL7=Hash[DL7.zip maj]
minL7=Hash[DL7.zip min]
majUA=Hash[DUA.zip maj]
minUA=Hash[DUA.zip min]
majUF=Hash[DUF.zip maj]
minUF=Hash[DUF.zip min]
majLO=Hash[DLO.zip maj]
minLO=Hash[DLO.zip min]
majLF=Hash[DLF.zip maj]
minLF=Hash[DLF.zip min]
majLNO=Hash[DLNO.zip maj]
minLNO=Hash[DLNO.zip maj]

#now generate hashes for major,minor and all scales
allmaj=majU.merge(majL).merge(majU7).merge(majL7).merge(majUA).merge(majUF).merge(majLO).merge(majLF).merge(majLNO)
allmin=minU.merge(minL).merge(minU7).merge(minL7).merge(minUA).merge(minUF).merge(minLO).merge(minLF).merge(minLNO)
all=[allmaj,allmin]

comment do #for debugging
  puts allmaj
  puts allmin
  puts all
end

#define gettype to select chord type according to symbol type
#types are the sme for both major and minor scales
define :gettype do |n|
  type="none found"
  type='7' if (majU7.include?(n) or minU7.include?(n))
  type=:m7 if (majL7.include?(n) or minL7.include?(n))
  type=:dim if (majLO.include?(n) or minLO.include?(n))
  type=:major if (majU.include?(n) or minU.include?(n))
  type=:major if (majUF.include?(n) or minUF.include?(n))
  type=:augmented if (majUA.include?(n) or minUA.include?(n))
  type=:minor if (majL.include?(n) or minL.include?(n))
  type=:minor if (majLF.include?(n) or minLF.include?(n))
  type=:dim if (majLNO.include?(n) or minLNO.include?(n))
  return type
end

define :keytype do |key| #convert maj amd min key values to numeric
  if key == 'maj' then
    return 0
  else
    return 1
  end
end

define :playone do |n,dur,tonic,key="maj"| #play the chord for a single symbol input
  type = gettype(n)
  play chord(tonic+all[key][n],type),sustain: 0.9*dur, release: 0.1*dur
  sleep dur
end

#playone(:VII,1,:c4,0) #test value

#define function to play chord sequence as single chords once each
define :symchords do |progression,dur,tonic,key|
  progression.each do |n|
    type=gettype(n)
    #puts chord(tonic+all[key][n],type=0)
    play chord(tonic+all[key][n],type),sustain: 0.9*dur, release: 0.1*dur
    sleep dur
  end
end
#symchords([:I,:II,:III],1,:c4,0) #test
#stop

#define function to play chord progession with single up-down aprpeggio for each entry
#top note is played once only and last note has duration doubled
#range specifies number of octaves, and lasttime=:final will play a final chord
#dur is duration of each note, key specifies "maj"or or "min"or
define :arpeglinear do |progression,tonic,dur,range,key="maj",lasttime=""|
  key=keytype(key) #convert key to number
  progression.each do |n| #process each entry in progression list
    type=gettype(n) #get chord type
    notes=chord(tonic+all[key][n],type,num_octaves: range) #save notes list
    num=notes.length #get number of notes
    notes.each do |v| #process each note in turn as rising arpeggion
      play v,sustain: 0.9*dur,release: 0.1*dur
      sleep dur
    end
    notes.reverse[1..-1].each_with_index do |v,i| #do falling arpeggio minuss first note, and last note 2x duration
      dur2=dur
      #make last note twice the duration
      dur2=2*dur if i == num-2 #index starts at 0 so compare with num-2 as one note is note played from notes.reverse
      play v,attack: 0.05*dur2,sustain: 0.85*dur2,release: 0.1*dur2,pan: 0.3
      sleep dur2
    end
  end
  #play final chord if lasttime is :final
  playend(tonic+all[key][progression[0]],gettype(progression[0]),dur) if lasttime == :final
end

#define function to play notes chosen at random from each chord.
#number of notes played per chord equals number in the chord*2 -1
# Range is number of octaves, dur note duration. Last note has twice duration
#lasttime=:final will play a final chord
define :arpegrandom do |progression,tonic,dur,range,key="maj",lasttime=""|
  key=keytype(key) #convert key to numeric
  progression.each do |n| #process each symbol in progression
    type=gettype(n) #get next chord type
    num=((2*chord(tonic+all[key][n],type,num_octaves: range).length)-1) #calc number of notes to play
    num.times do |i|
      dur2=dur
      #make last note twice the duration
      dur2=2*dur if i == (num-1) #index i starts at 0, so compare with number notes -1 to get last time
      play chord(tonic+all[key][n],type,num_octaves: range).choose,attack: 0.05*dur2,sustain: 0.85*dur2,release: 0.1*dur2,pan: -0.3
      sleep dur2
    end
  end
  #play last time chord if lasttime is :final
  playend(tonic+all[key][progression[0]],gettype(progression[0]),dur) if lasttime == :final
end

#playend will play a single chord generated from tonic and type and lasting 16*dur
define :playend do |tonic,type,dur|
  play note_range(tonic,tonic+35,pitches: chord(tonic,type)),sustain: 12*dur,release: 4*dur
end

#define function to play an arpeglinear and arpegrandom sequence together giving some harmony
#if lasttime=:final it will finish with a chord. dur is the note duration for the sequence
#prog is a list of the chords to play in Roman notation
#baselin and baserandom are the tonic notes for each sequence
#select chooses single chords if set to :single
#key is "maj" or "min" to set scale type
define :playpair do |prog,t,baselin,baserandom,key="maj",select="",lasttime=""|
  key=keytype(key) #set up keyflag string
  keyflag="major"
  keyflag="minor" if key==1
  puts "key of "+baselin.to_s[0..-2]+" "+keyflag #print key information
  puts prog #print the currrent progression
  use_synth [:tri,:saw,:blade].choose #choose synth
  if select==:single then #if single just play single chords
    symchords(prog,t*2,baselin+24,key)
    sleep t*2
  else #otherwise play arpeglinear and arpegrandom together
    in_thread do #start the arpeglinear in a thread
      arpeglinear(prog,baselin,t,2,key,lasttime)
    end
    use_synth [:fm,:tri,:saw,:blade].choose
    with_synth_defaults amp: 0.6 do #balance :amp here if necessary
      #play last time chord if lasttime set to :final
      arpegrandom(prog,baserandom,t,2,key,lasttime)#play the arpegrandom at the same time
    end
  end
end
####### now set up sequence and play ######
t=0.1
#note duration
flag= :singlex #set flag=:single for single chord progressions

#define sequences in Roman notation. lowercase minor, uppercase major
#suffix o gives diminished, leading b flattens a semitone 7 gives seventh chord
#all relative to base tonic note.
prog1=[:I,:IV,:viio,:iii,:vi,:ii,:V,:I]
prog2=[:i,:iv,:VII,:III,:VI,:iio,:V,:i]
prog3=[:I,:vi,:IV,:V,:i]
prog4=[:I,:IV,:iii,:vi]
prog5=[:vi,:V,:IV,:III]
prog6=[:I,:vi,:ii,:V7,:ii,:I]
prog7=[:I,:ii,:iii,:IV,:V,:vi,:vii,:I]
prog8=[:i,:bVII,:bVI]
prog9=[:i,:bVI,:bVII,:i]
prog10=[:I,:iii,:IV,:ii,:I]
prog11 = [:i,:iv,:V7]
prog12=[:I,:V,:vi,:iii,:IV,:I,:IV,:V,:I]
pr=[:i,:v,:v7,:vi,:ii,:IV,:V,:i]

perform1=[prog2,prog3,prog4,prog5]
perform2=[prog6,prog7,prog8,prog9]
perform3=[pr,prog10,prog11,prog12]

p1=[:I,:vi,:IV,:viio,:iii,:vi,:ii,:v,:I,:vi,:IV,:viio,:I]
p2=[:I,:i,:IV,:iv,:bIV,:iii,:II,:i]
pm=[:I,:iio,:III,:iv,:v,:VI,:VII]
phm=[:i,:iio,:IIIa,:iv,:V,:VI,:nviio]
pmm=[:i,:ii,:IIIa,:IV,:V,:nvio,:nviio,:i]
pud=pmm+phm.reverse
perform4=[p1,p2,pm,pud]
px=[:I,:ii,:viio,:iii,:vi,:IV,:V]
px2=[:I,:vi,:IV,:viio]
px3=[:I,:V,:iii,:vi,:ii,:V,:I]
px4=[:I,:iii,:vi,:ii,:V,:I]


with_fx :reverb,room: 0.5 do
  key="min"
  perform1.each do |prog| #in :c
    playpair(prog,t,:c2,:c4,key,flag)
  end
  key="maj"
  perform2.each do |prog| #pin :f
    playpair(prog,t,:f2,:f4,key,flag)
  end

  perform3.each do |prog| #in :g
    key="min"
    playpair(prog,t,:g2,:g4,key,flag)
  end
  perform4.each do |prog|
    key="min"
    playpair(prog,t,:c2,:c4,key,flag)
  end
  playpair(px,t,:d2,:d4,"maj")
  playpair(px2,t,:e2,:e4,"min")
  playpair(px3,t,:fs2,:fs4,"maj")
  playpair(px3,t,:g2,:g4,"maj")
  key="maj"
  playpair(prog1,t,:c2,:c4,key,flag,:final) #perform last sequence and final chord in :c
end
puts "The End"