#Pachebel Canon for Sonic Pi, played by Flute, Clarinet and Trombone sample based voices
#coded by Robin Newman, March 2015
#requires Pitch_Ration function (included) which will be in SP 2.5. From this version it can be commented out
#score from www.freegigmusic.com (version for flute oboe and clarinet)
#samples donwload at http://r.newman.ch/rpi/Pachabel.zip
use_debug false
use_sample_pack_as '/home/pi/samples/Pachabel',:pachabel #adjust location as necessary
#first deal with selecting and setting up the samples

inst0=:pachabel__flute_ds5
samplepitch0=:ds5
inst1=:pachabel__clarinet_gs4
samplepitch1=:gs4
inst2=:pachabel__tenor_trombone_cs4
samplepitch2=:cs4

#preload all the samples
load_flag=0
if sample_loaded? inst0 then #check if sample already loaded
  flag=1
end
load_samples [inst0,inst1,inst2]
if load_flag==0 then #samples not loaded so allow time
  sleep 3
end

#put the sample names and pitches into an array i
i=[[inst0,samplepitch0],[inst1,samplepitch1],[inst2,samplepitch2]]

define :ntosym do |n| #this returns the equivalent note symbol to an input integer e.g. 59 => :b4
  #nb no error checking on integer range included
  #only returns notes as n or n sharps.But will sound ok for flats
  note=n % 12
  octave = n / 12 - 1
  #puts octave #for debugging
  #puts note
  lookup_notes = {0 =>:c, 1 =>:cs,2 =>:d,3 =>:ds,4 =>:e,5 =>:f,6 =>:fs,7 =>:g,8 =>:gs,9 =>:a,10 =>:as,11 =>:b}
  return (lookup_notes[note].to_s + octave.to_s).to_sym #return the required note symbol
end


#define variables that need to be used globally
s=dsq=sq=sqd=q=qt=qd=qdd=c=cd=cdd=m=md=mdd=b=bd=0 #note duration variables
nf=[];df=[];nob=[];dob=[];ncl=[];dcl=[];nf2=[];df2=[];nob2=[];dob2=[];ncl2=[];dcl2=[];nf3=[];df3=[];nob3=[];dob3=[];ncl3=[];dcl3=[]

#prior to the release of version 2.5 you need the next function
#if you get an error message saying it exists then delete it or comment it out
uncomment do
  define :pitch_ratio do |n|
    return 2**(n.to_f/12)
  end
end

#this function plays the sample at the relevant pitch for the note desired
#the note duration is used to set up the envelope parameters
define :pl do |inst,samplepitch,nv,dv,vol=1,damp=1|
  shift=note(nv)-note(samplepitch)
  if damp==1 then
    sample inst,rate: (pitch_ratio shift),sustain: 0.8*dv,release: 0.2*dv,amp: vol
  else
    sample inst,rate: (pitch_ratio shift),sustain: 0.8*dv,release: dv,amp: vol #no damping
  end
end

#this function plays an array of notes and associated array of durations
#also uses sample name (inst), sample normal pitch, and shift (transpose) parameters
define :plarray do |inst,samplepitch,narray,darray,vol=1,shift=0|
  narray.zip(darray) do |nv,dv|
    if nv != :r
      pl(inst,samplepitch,note(nv)+shift,dv,vol)
    end
    sleep dv
  end
end

#set_bpm sets bpm required adjusting note duration variables accordingly
define :set_bpm do |n|
  s=1.0/8*60/n.to_f
  dsq = 1 * s #demisemiquaver
  sq = 2 * s #semiquaver
  sqd = 3 * s #semi quaver dotted
  q = 4 * s
  qt = 2.0/3*q
  qd = 6 * s
  qdd = 7 * s
  c = 8 * s
  cd = 12 * s
  cdd = 14 * s
  m = 16 * s
  md = 24 * s
  mdd = 28 * s
  b = 32 * s
  bd = 48 * s
end

define :trn do |n,num,offset=2| #works out notes for a trill
  @n = note_info(n).midi_note
  return [ntosym(@n+offset),n]*(num / 2)
end

define :trd do |d,num| #works out durations for a trill
  return [d/num]*num
end

#this section sets the bpm then defines the note and duration arrays

define :setupparts do |bpmvalue|
  set_bpm(bpmvalue) #define notes and durations in terms of currrent bpm value
  nf=       [:r,:a4,:c5,:f5,:r,:g4,:c5,:e5,:r,:f4,:a4,:d5,:r,:e4,:a4,:c5,   :r,:d4,:f4,:bb4,:r,:f4,:a4,:c5,:r,:f4,:bb4,:d5,:r,:g4,:c5,:e5]
  nf.concat [:r,:a4,:c5,:f5,:r,:g4,:c5,:e5,:r,:f4,:a4,:d5,:r,:e4,:a4,:c5,   :r,:d4,:f4,:bb4,:r,:f4,:a4,:c5,:r,:f4,:bb4,:d5,:r,:g4,:c5,:e5]
  nf.concat [:r,:a4,:c5,:f5,:r,:g4,:c5,:e5,:r,:f4,:a4,:d5,:r,:e4,:a4,:c5,   :r,:d4,:f4,:bb4,:r,:f4,:a4,:c5,:r,:f4,:bb4,:d5,:r,:g4,:c5,:e5]
  nf.concat [:r,:a4,:c5,:f5,:r,:g4,:c5,:e5,:r,:f4,:a4,:d5,:r,:e4,:a4,:c5,   :r,:d4,:f4,:bb4,:r,:f4,:a4,:c5,:r,:f4,:bb4,:d5,:r,:g4,:c5,:e5]
  nf.concat [:r,:a4,:c5,:f5,:r,:g4,:c5,:e5,:r,:f4,:e4,:d5,:r,:e4,:a4,:c5,   :r,:d4,:f4,:bb4,:r,:f4,:a4,:c5,:r,:f4,:bb4,:d5,:c5,:g4,:e4,:r]
  df=[sq,sq,sq,sq]*4*10

  nob=[:r,:a5,:g5,:f5,:e5,:d5,:c5,:d5,:e5,:f5,:e5,:d5,:c5,:bb4,:a4,:bb4,:g4]
  nob.concat [:f4,:a4,:c5,:bb4,:a4,:f4,:a4,:g4,:f4,:d4,:f4,:c5,:bb4,:d5,:c5,:bb4,:a4,:f4,:g4,:e5,:f5,:a5,:c6,:c5,:d5,:bb4,:c5,:a4,:f4,:f5]+trn(:f5,6)+[:e5]
  dob=[b*2,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q]+trd(qd,6)+[sq]

  ncl=[:f4,:c4,:d4,:a3,:bb3,:f3,:bb3,:c4]*5
  dcl=[c,c,c,c]*10
  #second section
  nf2=[:f4,:a4,:c5,:bb4,:a4,:f4,:a4,:g4,:f4,:d4,:f4,:c5,:bb4,:d5,:c5,:bb4,:a4,:f4,:g4,:e5,:f5,:a5,:c6,:c5]
  nf2.concat [:d5,:bb4,:c5,:a4,:f4,:f5]+trn(:f5,6)+[:e5,:f5,:e5,:f5,:f4,:e4,:c5,:g4,:a4,:f4,:f5,:e5,:d5,:e5,:a5,:c6,:d6]
  df2=[q]*30+trd(qd,6)+[sq]*17
  #b16
  nf2.concat [:bb5,:a5,:g5,:bb5,:a5,:g5,:f5,:e5,:d5,:c5,:bb4,:a4,:g4,:bb4,:a4,:g4,:f4,:g4,:a4,:bb4,:c5,:g4,:c5,:bb4,:a4,:d5,:c5,:bb4,:c5,:bb4,:a4,:g4]
  #b18
  nf2.concat [:f4,:d4,:d5,:e5,:f5,:e5,:d5,:c5,:bb4,:a4,:g4,:d5,:c5,:d5,:c5,:c5,:c6,:a5,:bb5,:c6,:a5,:bb5,:c6,:c5,:d5,:e5,:f5,:g5,:a5,:bb5,:a5,:f5,:g5,:a5,:a4,:bb4,:c5,:d5,:c5,:bb4,:c5,:a4,:bb4,:c5]
  df2.concat [sq]*16*3+[sq,dsq,dsq,sq]+[dsq]*10+[sq,dsq,dsq,sq]+[dsq]*10
  #b20
  nf2.concat [:bb4,:d5,:c5,:bb4,:a4,:g4,:a4,:g4,:f4,:g4,:a4,:bb4,:c5,:d5,:bb4,:d5,:c5,:d5,:e5,:f5,:c5,:d5,:e5,:f5,:g5,:a5,:bb5,:c6]
  nf2.concat [:c6,:a5,:bb5,:c6,:a5,:bb5,:c6,:c5,:d5,:e5,:f5,:g5,:a5,:bb5,:a5,:f5,:g5,:a5,:a4,:b4,:c5,:d5,:c5,:bb4,:c5,:a4,:bb4,:c5]
  nf2.concat [:bb4,:d5,:c5,:bb4,:a4,:g4,:a4,:g4,:f4,:g4,:a4,:bb4,:c5,:d5,:bb4,:d5,:c5,:d5,:e5,:f5,:c5,:d5,:e5,:f5,:g5,:a5,:bb5,:c6]
  df2.concat ([sq,dsq,dsq,sq]+[dsq]*10)*6
  #b23
  nf2.concat [:a5,:f5,:g5,:a5,:g5,:f5,:g5,:e5,:f5,:g5,:a5,:g5,:f5,:e5,:f5,:d5,:e5,:f5,:f4,:g4,:a4,:bb4,:a4,:g4,:a4,:f5,:e5,:f5]
  nf2.concat [:d5,:f5,:e5,:d5,:c5,:bb4,:c5,:bb4,:a4,:bb4,:c5,:d5,:e5,:f5,:d5,:f5,:e5,:f5,:e5,:d5,:e5,:f5,:g5,:f5,:e5,:f5,:d5,:e5]
  nf2.concat [:f5,:f4,:g4,:a4,:f4,:e4,:e5,:f5,:g5,:e5,:d5,:d4,:e4,:f4,:d4,:e4,:c5,:bb4,:a4,:g4]
  nf2.concat [:f4,:bb4,:a4,:g4,:bb4,:a4,:f4,:g4,:a4,:c5,:bb4,:d5,:c5,:bb4,:a4,:g4,:c5,:bb4,:a4,:g4]
  nf2.concat [:a4,:f5,:e5,:f5,:a4,:c5,:c5,:d5,:e5,:c5,:a4,:f5,:g5,:a5,:f5,:a5,:a5,:g5,:f5,:e5]
  nf2.concat [:d5,:d5,:c5,:d5,:e5,:f5,:a5,:g5,:f5,:a5,:bb5,:f5,:e5,:d5,:d5,:c5,:g4,:c5,:c5]
  df2.concat ([sq,dsq,dsq,sq]+[dsq]*10)*4 +[sq,dsq,dsq,sq,sq]*15+[sq]*4
  #end b28

  #b11
  nob2=[:f5,:e5,:f5,:f4,:e4,:c5,:g4,:a4,:f4,:f5,:e5,:d5,:e5,:a5,:c6,:d6,:bb5,:a5,:g5,:bb5,:a5,:g5,:f5,:e5,:d5,:c5,:bb4,:a4,:g4,:bb4,:a4,:g4]
  nob2.concat [:f4,:g4,:a4,:bb4,:c5,:g4,:c5,:bb4,:a4,:d5,:c5,:bb4,:c5,:bb4,:a4,:g4,:f4,:d4,:d5,:e5,:f5,:e5,:d5,:c5,:bb4,:a4,:g4,:d5,:c5,:d5,:c5,:c5]
  #b15
  nob2.concat [:f4,:a4,:c5,:bb4,:a4,:f4,:a4,:g4,:f4,:d4,:f4,:c5,:bb4,:d5,:c5,:bb4,:a4,:f4,:g4,:e5,:f5,:a5,:c6,:c5,:d5,:bb4,:c5,:a4,:f4,:f5]+trn(:f5,6)+[:e5]
  dob2.concat [sq]*16*4+[q]*4*7+[q,q]+trd(qd,6)+[sq]
  #19
  nob2.concat [:f5,:e5,:f5,:f4,:e4,:c5,:g4,:a4,:f4,:f5,:e5,:d5,:e5,:a5,:c6,:d6,:bb5,:a5,:g5,:bb5,:a5,:g5,:f5,:e5,:d5,:c5,:bb4,:a4,:g4,:bb4,:a4,:g4]
  nob2.concat [:f4,:g4,:a4,:bb4,:c5,:g4,:c5,:bb4,:a4,:d5,:c5,:bb4,:c5,:bb4,:a4,:g4,:f4,:d4,:d5,:e5,:f5,:e5,:d5,:c5,:bb4,:a4,:g4,:d5,:c5,:d5,:c5,:c5]
  nob2.concat [:f4,:g4,:a4,:bb4,:c5,:g4,:c5,:bb4,:a4,:d5,:c5,:bb4,:c5,:bb4,:a4,:g4,:f4,:d4,:d5,:e5,:f5,:e5,:d5,:c5,:bb4,:a4,:g4,:d5,:c5,:d5,:c5,:c5]
  dob2.concat [sq]*16*6
  #b25
  nob2.concat [:f4,:a4,:c5,:bb4,:a4,:f4,:a4,:g4,:f4,:d4,:f4,:c5,:bb4,:d5,:c5,:bb4]
  nob2.concat [:a4,:f4,:g4,:a4,:f4,:e4,:e5,:f5,:g5,:e5,:d5,:d4,:e4,:f4,:d4,:e4,:c5,:bb4,:a4,:g4,:f4,:bb4,:a4,:g4,:bb4,:a4,:f4,:g4,:a4,:c5,:bb4,:d5,:c5,:bb4,:a4,:g4,:c5,:bb4,:a4,:g4]
  dob2.concat [q]*16+[sq,dsq,dsq,sq,sq]*8

  #b11
  ncl2=[:f4,:c4,:d4,:a3,:bb3,:f3,:bb3,:c4]*9
  dcl2=[c,c,c,c]*18

  #third section
  #b29
  nf3=[:f5,:e5,:d5,:c5,:bb4,:a4,:bb4,:g4,:r,:a4,:c5,:f5,:r,:g4,:c5,:e5,:r,:f4,:a4,:d5,:r,:e4,:a4,:c5,:r,:d4,:f4,:bb4,:r,:f4,:a4,:c5,:r,:f4,:bb4,:d5,:c5,:g4,:e4,:c4]
  df3=[c,c,c,c,c,c,c,c]+[sq]*7*4+[sq,1.1*sq,1.2*sq,1.3*sq,1.4*sq]#rit
  #b29
  nob3=[:r,:a4,:c5,:f5,:r,:g4,:c5,:e5,:r,:f4,:a4,:d5,:r,:e4,:a4,:c5,:r,:d4,:f4,:bb4,:r,:f4,:a4,:c5,:r,:f4,:bb4,:d5,:r,:g4,:c5,:e5]
  nob3.concat [:f5,:e5,:d5,:c5,:bb4,:a4,:bb4,:g4,]
  dob3=[sq]*4*8+[c,c,c,c,c,c,c,c+sq]#rit
  #b29
  ncl3=[:f4,:c4,:d4,:a3,:bb3,:f3,:bb3,:c4]*2
  dcl3=[c,c,c,c]*3+[c,c,c,c+sq] #rit
end
setupparts(68)#create note arrays with correct tempo settings

#now play the piece
with_fx :reverb,room: 0.6,mix: 0.3 do
  #first section
  in_thread {plarray(i[2][0],i[2][1],ncl,dcl,0.3)}
  in_thread {plarray(i[1][0],i[1][1],nob,dob,0.5)}
  plarray(i[0][0],i[0][1],nf,df)
  #repeated second section
  2.times do
    in_thread {plarray(i[2][0],i[2][1],ncl2,dcl2,0.3)}
    in_thread {plarray(i[1][0],i[1][1],nob2,dob2,0.5)}
    plarray(i[0][0],i[0][1],nf2,df2)
  end
  #third section
  in_thread {plarray(i[2][0],i[2][1],ncl3,dcl3,0.3)}
  in_thread {plarray(i[1][0],i[1][1],nob3,dob3,0.5)}
  plarray(i[0][0],i[0][1],nf3,df3)
  #final note no dampening
  #|inst,samplepitch,nv,dv,vol=1,damp=1|
  pl(i[0][0],i[0][1],:f4,c*1.5,1,0)
  pl(i[1][0],i[1][1],:f4,c*1.5,0.5,0)
  pl(i[2][0],i[2][1],:f4,c*1.5,0.3,0)
  sleep md*1.2
end