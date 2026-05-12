#playing with chord progressions and their syntax by Robin Newman, November 2015 (rev 3)
#recently I've been reading up on chord progressions, and representing them with a Roman notation.
#This code is the result!
#revision 2. (Removed some extranous development stuff)
#revison 3. (reallocated synths for arpeglinear, typo correction, changed amp: setting for arpeg random)

#first set up hashes of symbols, giving offsets for their base note
DU= {:I=> 0,:II=> 2,:III=> 4,:IV=> 5,:V=> 7,:VI=> 9,:VII=> 11} #capitals for Major chords
DU7= {:I7=> 0,:II7=> 2,:III7=> 4,:IV7=> 5,:V7=> 7,:VI7=> 9,:VII7=> 11} # 7th Major
DUA= {:Ia=> 0,:IIa=> 2,:IIIa=> 4,:IVa=> 5,:Va=> 7,:VIa=> 9,:VIIa=> 11} #Major augmented
DUF= {:bI=> -1,:bII=> 1,:bIII=> 3,:bIV=> 4,:bV=> 6,:bVI=> 8,:bVII=> 10}#flattened Major
DL= {:i=> 0,:ii=> 2,:iii=> 4,:iv=> 5,:v=> 7,:vi=> 9,:vii=> 11} #lower case minor chords
DL7= {:i7=> 0,:ii7=> 2,:iii7=> 4,:iv7=> 5,:v7=> 7,:vi7=> 9,:vii7=> 11} #minor 7th chords
DLO= {:io=>0,:iio=>2,:iiio=>4,:ivo=>5,:vo=>7,:vio=>9,:viio=>11} #diminished minor chords
#merge a list of all symbols
all=DU.merge(DU7).merge(DUF).merge(DUA).merge(DL).merge(DL7).merge(DLO)

#define gettype to select chord type according to symbol type
define :gettype do |n|
  type='7' if DU7.include?(n)
  type=:m7 if DL7.include?(n)
  type=:dim if DLO.include?(n)
  type=:major if DU.include?(n)
  type=:major if DUF.include?(n) #same type as for DU, but note is flattened by DUF value
  type=:aug if DUA.include?(n)
  type=:minor if DL.include?(n)
  return type
end

#define function to play chord sequence as single chords once each
define :symchords do |progression,dur,tonic|
  progression.each do |n|
    type=gettype(n)
    #puts chord(tonic+all[n],type)
    play chord(tonic+all[n],type),sustain: 0.9*dur, release: 0.1*dur
    sleep dur
  end
end

#define function to play chord progession with single up-down aprpeggio for each one
#top note is played once only and a rest is added at the end
#range specifies number of octaves, and lasttime=:final will play a final chord
#dur is duration of each note
define :arpeglinear do |progression,tonic,dur,range,lasttime=""|
  progression.each do |n|
    type=gettype(n)
    chord(tonic+all[n],type,num_octaves: range).each do |v|
      play v,sustain: 0.9*dur,release: 0.1*dur
      sleep dur
    end
    chord(tonic+all[n],type,num_octaves: range).reverse[1..-1].each do |v|
      play v,attack: 0.05*dur,sustain: 0.85*dur,release: 0.1*dur,pan: 0.3
      sleep dur
    end
    sleep dur
  end
  playend(tonic+all[progression[0]],gettype(progression[0]),dur) if lasttime == :final
end

#define function to play notes chosen at random from each chord.
#number of notes played per chord equals number in the chord*2 -1
#single rest played at the end. Range is number of octaves, dur note duration
#lasttime=:final will play a final chord
define :arpegrandom do |progression,tonic,dur,range,lasttime=""|
  progression.each do |n|
    type=gettype(n)
    ((2*chord(tonic+all[n],type,num_octaves: range).length)-1).times do
      play chord(tonic+all[n],type,num_octaves: range).choose,attack: 0.05*dur,sustain: 0.85*dur,release: 0.1*dur,pan: -0.3
      sleep dur
    end
    sleep dur
  end
  playend(tonic+all[progression[0]],gettype(progression[0]),dur) if lasttime == :final
end

#playend will play a single chord generated from tonic and type and lasting 16*dur
define :playend do |tonic,type,dur|
  play note_range(tonic,tonic+35,pitches: chord(tonic,type)),sustain: 12*dur,release: 4*dur
end

#define function to play an arpeglinear and arpegrandom seqeunce together giving some harmony
#if lasttime=:final it will finish with a chord. dur is the note duration for the sequence
#prog is a list of the chords to play in Roman notation
#baselin and baserandom are the tonic notes for each sequence
#select chooses single chords if set to :single
define :playpair do |prog,t,baselin,baserandom,select="",lasttime=""|
  puts prog
  use_synth [:tri,:saw,:blade].choose
  if select==:single then
    symchords(prog,t*2,baselin+24)
    sleep t*2
  else
    in_thread do #start the arpeglinear in a thread
      arpeglinear(prog,baselin,t,2,lasttime)
    end
    use_synth [:fm,:tri,:saw,:blade].choose
    with_synth_defaults amp: 0.6 do #balance :amp here if necessary
      arpegrandom(prog,baserandom,t,2,lasttime)#play the arpegrandom at the same time
    end
  end
end
############# now set up sequence and play ################
t=0.175 #note duration
flag= :singlex #set flag=:single for single chord progressions

#define some sequences in Roman notation. lowercase minor, uppercase major
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

with_fx :reverb,room: 0.5 do
  puts "Key of C"
  perform1.each do |prog| #perform first4 sequences in :c
    playpair(prog,t,:c2,:c4,flag)
  end
  puts "Key of F"
  perform2.each do |prog| #perform next four sequences in :f
    playpair(prog,t,:f2,:f4,flag)
  end
  puts "Key of G"
  perform3.each do |prog| #perform next four sequences in :g
    playpair(prog,t,:g2,:g4,flag)
  end
  puts "Key of C"
  playpair(prog1,t,:c2,:c4,flag,:final) #perform last sequence and final chord in :c
end
puts "The End"