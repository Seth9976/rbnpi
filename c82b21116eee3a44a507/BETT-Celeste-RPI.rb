# Sonic Pi celeste voice, programmed by Robin Newman October 2014
#THis version Paspberry Pi or Windows only. Separate version for Mac OS
#the program uses celeste samples from the Sonic Symphoic Orchstra
#also uses samples for pizz strings#clarinet and bass clarinet played with :pulse synth
#the prgoram is long, so split between two workpaces and uses cue and sync between them
set_sched_ahead_time! 2
s=0 #set s here with dummy value so that its scope is global
r=2**(1.0/12) #semitone rate multiplier
ir=1.0/r #inverse to go down semitone
#puts r
#puts ir
define :setbpm do |n| #set bpm equivalent
  s = (1.0 / 8) *(60.0/n.to_f)
end
setbpm(57)
shift = 0 #set transpose if required
use_sample_pack "/home/pi/samples/CEL" #all samples placed in here

define :ntosym do |n|
  @note=n % 12
  @octave = n / 12 - 1
  lookup_notes = {
    0  => :c,
    1  => :cs,
    2  => :d,
    3  => :ds,
    4  => :e,
    5  => :f,
    6  => :fs,
    7  => :g,
    8  => :gs,
    9  => :a,
    10 => :as,
  11 => :b}
  return (lookup_notes[@note].to_s + @octave.to_s).to_sym
end
#tr uses ntosym to work out transposed note symbol
define :tr do |nv,sh|
  if sh ==0 then
    return nv
  else
    return ntosym(note(nv)+sh)
  end
end
#setup array of midi-numbers for samples, and load the samples
flag=0
sl = []
sl=[:c3,:e3,:gs3,:c4,:e4,:gs4,:c5,:e5,:gs5,:c6,:e6,:gs6]
sl.each do |i|
  load_sample ("celeste__"+i.to_s+"_hard").intern
end
#name remaining samples used for strings
vas3=:violins_piz_as3
vcs4=:violins_piz_cs4
ve4 = :violins_piz_e4
vg4 = :violins_piz_g4
vcs5=:violins_piz_cs5
bds3= :basses_piz_ds3
bfs2= :basses_piz_fs2
bc3 = :basses_piz_c3
ba2 = :basses_piz_a2
vle4= :violin_e4
vle5= :violin_e5
if sample_loaded? vle5 then
flag=1
end

load_samples vas3,vcs4,ve4,vg4,vcs5,bds3,bfs2,bc3,ba2,vle4,vle5
if flag == 0 then
puts "loading..."
sleep 8
end

#set up array of notes and associated rate value for celeste
sam =      [[:as2,:celeste__c3_hard,ir*ir],[:b2,:celeste__c3_hard,ir],[:c3,:celeste__c3_hard,1]]
sam.concat [[:cs3,:celeste__c3_hard,r],[:d3,:celeste__e3_hard,ir*ir],[:ds3,:celeste__e3_hard,ir]]
sam.concat [[:e3,:celeste__e3_hard,1],[:f3,:celeste__e3_hard,r],[:fs3,:celeste__gs3_hard,ir*ir]]
sam.concat [[:g3,:celeste__gs3_hard,ir],[:gs3,:celeste__gs3_hard,1],[:a3,:celeste__gs3_hard,r]]
sam.concat [[:as3,:celeste__c4_hard,ir*ir],[:b3,:celeste__c4_hard,ir],[:c4,:celeste__c4_hard,1]]
sam.concat [[:cs4,:celeste__c4_hard,r],[:d4,:celeste__e4_hard,ir*ir],[:ds4,:celeste__e4_hard,ir]]
sam.concat [[:e4,:celeste__e4_hard,1],[:f4,:celeste__e4_hard,r],[:fs4,:celeste__gs4_hard,ir*ir]]
sam.concat [[:g4,:celeste__gs4_hard,ir],[:gs4,:celeste__gs4_hard,1],[:a4,:celeste__gs4_hard,r]]
sam.concat [[:as4,:celeste__c5_hard,ir*ir],[:b4,:celeste__c5_hard,ir],[:c5,:celeste__c5_hard,1]]
sam.concat [[:cs5,:celeste__c5_hard,r],[:d5,:celeste__e5_hard,ir*ir],[:ds5,:celeste__e5_hard,ir]]
sam.concat [[:e5,:celeste__e5_hard,1],[:f5,:celeste__e5_hard,r],[:fs5,:celeste__gs5_hard,ir*ir]]
sam.concat [[:g5,:celeste__gs5_hard,ir],[:gs5,:celeste__gs5_hard,1],[:a5,:celeste__gs5_hard,r]]
sam.concat [[:a5,:celeste__gs5_hard,r],[:as5,:celeste__c6_hard,ir*ir],[:b5,:celeste__c6_hard,ir]]
sam.concat [[:c6,:celeste__c6_hard,1],[:cs6,:celeste__c6_hard,r],[:d6,:celeste__e6_hard,ir*ir]]
sam.concat [[:ds6,:celeste__e6_hard,ir],[:e6,:celeste__e6_hard,1],[:f6,:celeste__e6_hard,r]]
sam.concat [[:fs6,:celeste__gs6_hard,ir*ir],[:g6,:celeste__gs6_hard,ir],[:gs6,:celeste__gs6_hard,1]]
sam.concat [[:a6,:celeste__gs6_hard,r],[:as6,:celeste__gs6_hard,r*r],[:b6,:celeste__gs6_hard,r*r*r]]
#puts sam
#set up lists of flats and the associated sharp with which they will be played
flat=[:bb2,:cb3,:db3,:eb3,:fb3,:gb3,:ab3,:bb3,:cb4,:db4,:eb4,:fb4,:gb4,:ab4,:bb4,:cb5,:db5,:eb5,:fb5,:gb5,:ab5,:bb5,:cb6,:db6,:eb6,:fb6,:gb6,:ab6,:bb6,:cb7]
sharp=[:as2,:b2,:cs3,:ds3,:e3,:fs3,:gs3,:as3,:b3,:cs4,:ds4,:e4,:fs4,:gs4,:as4,:b4,:cs5,:ds5,:e5,:fs5,:gs5,:as5,:b5,:cs6,:ds6,:e6,:fs6,:gs6,:as6,:b6]
#add es and bs with aliases
flat.concat [:es3,:es4,:es5,:es6,:bs2,:bs3,:bs4,:bs5]
sharp.concat [:f3,:f4,:f5,:f6,:c3,:c4,:c5,:c6]
#initialise array for extra values
extra=[]

flat.zip(sharp).each do |f,s|
  #adds element with flat name and rate factor looked up from associated sharp entry
  extra.concat [[f,(sam.assoc(s)[1]),(sam.assoc(s)[2])]]
end
sam = sam + extra #add extras in

#some of these samples below vas3,vcs3,ve4,vg4,vcs5 seem to be 1 semitone sharp so compensate
#vas3,vcs4,ve4,vg4,vcs5,bds3,bfs2,bc3,ba2,vle4,vle5
pizsam=       [[:e2,bfs2,ir*ir],[:fs2,bfs2,1],[:g2,bfs2,r],[:a2,ba2,1],[:as2,ba2,r],[:b2,ba2,r*r],[:c3,bc3,1],[:e3,bds3,r],[:fs3,bds3,r*r*r]]
pizsam.concat [[:b3,vas3,1],[:g3,vas3,ir*ir*ir],[:as3,vas3,ir],[:c4,vcs4,ir*ir],[:cs4,vcs4,ir],[:d4,vcs4,1],[:ds4,ve4,ir*ir]]
pizsam.concat [[:e4,ve4,ir],[:fs4,vg4,ir*ir],[:g4,vg4,ir],[:gs4,vg4,1],[:as4,vg4,r*r],[:b4,vg4,r*r*r],[:c5,vcs5,ir*ir],[:ld4,vle4,ir*ir]]
pizsam.concat [[:ld5,vle5,ir*ir],[:lds4,vle4,ir],[:lds5,vle5,ir],[:le4,vle4,1],[:le5,vle5,1],[:lfs4,vle4,r*r],[:lfs5,vle5,r*r]]

#set up function to play a given sample note.
define :pl do |n,d=0.2,pan=0,v=0.8|
  sample (sam.assoc(n)[1]),rate: (sam.assoc(n)[2]),attack: 0,sustain: d*0.9,release: d*0.1,amp: v,pan: pan
end

define :plpiz do |n,d=0.2,pan=0,v=0.8| #to play from strings samples
#puts n
  sample (pizsam.assoc(n)[1]),rate: (pizsam.assoc(n)[2]),attack: 0,sustain: d*0.9,release: d*0.1,amp: v,pan: pan #set low volume
end

#define note relative durations. Factor s sets the speed
dsq = 1 * s
sq = 2 * s
sqd = 3 * s
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

#function plays an array of note and duration values (nt and dur), with parameters for transposition, volume and pan
define :plarray do |nt,dur,sh=0,vol=0.4,pan=0|
  nt.zip(dur).each do |n,d|
    if n != :r then
      pl(tr(n,sh),d,pan,vol)
    end
    sleep d
  end
end

define :plarraypiz do |nt,dur,sh=0,vol=0.4,pan=0| #correspnding function to play from strings samples
  nt.zip(dur).each do |n,d|
    if n != :r then
      plpiz(tr(n,sh),d,pan,vol)
    end
    sleep d
  end
end

define :pln do |n,d| #play array for normal synth notes
  n.zip(d).each do |n,d|
    play n,sustain: d*0.9,release: d*0.1,amp: 0.07
    sleep d
  end
end

comment do #uncomment to play note range
  #low notes don't play very convincingly
  define :test do
    puts note(:as2)
    puts note(:b6)
    note(:as2).upto(note(:b6)) do |i|
      pl(ntosym(i),0.1,0,0.6)
      puts ntosym(i)
      sleep 0.2
    end
  end
  test
  sleep 1000 #press stop here
end

#now define note and duration arrays
#first for Celeste part
n1=[:g6,:e6,:g6,:fs6,:ds6,:e6,:d6,:d6,:d6,:cs6,:cs6,:cs6,:c6,:c6,:c6,:b5,:e6,:c6,:e6,:b5,:r]
d1=[sq,sq,q,q,q,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,sq,sq,q,c]
n2=[:b5,:e6,:b5,:a5,:fs5,:g5,:gs5,:gs5,:gs5,:g5,:g5,:g5,:fs5,:fs5,:fs5,:b5,:g5,:c6,:fs5,:b5,:r]
d2=[sq,sq,q,q,q,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,sq,sq,q,c]
n3=[:e5,:g5,:e5,:e5,:c5,:cs5,:f5,:f5,:f5,:e5,:e5,:e5,:ds5,:ds5,:ds5,:e5,:b4,:e5,:c5,:e5,:r]
d3=[sq,sq,q,q,q,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,sq,sq,q,c]
n4=[:e5,:b4,:e5,:c5,:a4,:as4,:b4,:b4,:b4,:as4,:as4,:as4,:a4,:a4,:a4,:g4,:b4,:b4,:c5,:g4,:r]
d4=[sq,sq,q,q,q,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,sq,sq,q,c]

n1.concat [:g5,:e5,:g5,:fs5,:c6,:b5,:g6,:g6,:g6,:f6,:f6,:f6,:e6,:e6,:e6,:ds6,:fs6,:e6,:fs6,:ds6,:r]
d1.concat [sq,sq,q,q,q,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,sq,sq,q,c]
n2.concat [:c5,:e5,:c5,:c5,:fs5,:g5,:cs6,:cs6,:cs6,:d6,:d6,:d6,:as5,:as5,:as5,:b5,:fs6,:as5,:fs6,:b5,:r]
d2.concat [sq,sq,q,q,q,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,sq,sq,q,c]
n3.concat [:r,:ds5,:e5,:as5,:as5,:as5,:gs5,:gs5,:gs5,:fs5,:fs5,:fs5,:fs5,:r,:r,:r,:fs5,:r]
d3.concat [cd,q,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,sq,sq,q,c]
n4.concat [:e4,:g4,:e4,:ds4,:a4,:g4,:e5,:e5,:e5,:d5,:d5,:d5,:cs5,:cs5,:cs5,:b4,:ds5,:fs5,:fs4,:b4,:r]
d4.concat [sq,sq,q,q,q,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,sq,sq,q,c]
n2b=[:r,:fs5,:fs5,:fs5]
d2b=[cd+5*m,sq,sq,q]
n3b=[:r,:d5,:d5,:d5]
d3b=[cd+5*m,sq,sq,q]

n1.concat [:g6,:e6,:g6,:fs6,:ds6,:e6,:d6,:d6,:d6,:cs6,:cs6,:cs6,:c6,:c6,:c6,:b5,:e6,:c6,:e6,:b5,:r]
d1.concat [sq,sq,q,q,q,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,sq,sq,q,c]
n2.concat [:b5,:e6,:b5,:a5,:fs5,:g5,:gs5,:gs5,:gs5,:g5,:g5,:g5,:fs5,:fs5,:fs5,:b5,:g5,:c6,:fs5,:b5,:r]
d2.concat [sq,sq,q,q,q,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,sq,sq,q,c]
n3.concat [:e5,:g5,:e5,:e5,:c5,:cs5,:f5,:f5,:f5,:e5,:e5,:e5,:ds5,:ds5,:ds5,:e5,:b4,:e5,:c5,:e5,:r]
d3.concat [sq,sq,q,q,q,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,sq,sq,q,c]
n4.concat [:e5,:b4,:e5,:c5,:a4,:as4,:b4,:b4,:b4,:as4,:as4,:as4,:a4,:a4,:a4,:g4,:b4,:b4,:c5,:g4,:r]
d4.concat [sq,sq,q,q,q,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,sq,sq,q,c]

n1.concat [:e6,:cs6,:e6,:ds6,:r,:d6,:b5,:d6,:cs6,:r,:c6,:a5,:c6,:b5,:r,:b5,:ds6,:fs6,:b6,:e6,:r]
d1.concat [sq,sq,q,q,q,sq,sq,q,q,q,sq,sq,q,q,q,dsq,dsq,dsq,dsq,q,q]
n2.concat [:as5,:fs5,:as5,:b5,:r,:gs5,:e5,:gs5,:a5,:r,:fs5,:d5,:fs5,:g5,:r,:b5,:r]
d2.concat [sq,sq,q,q,q,sq,sq,q,q,q,sq,sq,q,q,c,q,q]
n3.concat [:cs5,:e5,:cs5,:fs5,:r,:b4,:d5,:b4,:e5,:r,:a4,:c5,:a4,:d5,:r,:a5,:fs5,:ds5,:b4,:g5,:r]
d3.concat [sq,sq,q,q,q,sq,sq,q,q,q,sq,sq,q,q,q,dsq,dsq,dsq,dsq,q,q]
n4.concat [:fs4,:as4,:fs4,:b4,:r,:e4,:gs4,:e4,:a4,:r,:d4,:fs4,:d4,:g4,:r,:e5,:r]
d4.concat [sq,sq,q,q,q,sq,sq,q,q,q,sq,sq,q,q,c,q,q]
#now for strings parts
nv1 = [:r,:e4,:r,:fs4,:r,:g4,:r,:ds4,:r,:e4,:r,:fs4,:r,:g4,:r,:ds4,:r,:e4,:r,:fs4,:r,:g4,:r,:gs4,:r,:as4,:r,:c5,:b4,:c5,:b4,:r]
dv1=[q]*4*8
nv2=[:r,:b3,:r,:c4,:r,:cs4,:r,:c4,:r,:b3,:r,:c4,:r,:cs4,:r,:c4,:r,:b3,:r,:c4,:r,:cs4,:r,:d4,:r,:e4,:r,:fs4,:g4,:fs4,:g4,:r]
dv2=[q]*4*8
nb1= [:e3,:r,:e3,:r,:e3,:r,:e3,:r,:e3,:r,:e3,:r,:e3,:r,:e3,:r,:e3,:r,:e3,:r,:e3,:r,:e3,:r,:e3,:r,:e3,:r,:e4,:e4,:e4,:r]
db1= [q]*4*8
nv1.concat [:r,:c4,:r,:ds4,:r,:e4,:r,:e4,:r,:d4,:r,:e4,:ds4,:e4,:ds4,:r,:r,:e4,:r,:fs4,:r,:g4,:r,:gs4,:r,:as4,:r,:c5,:b4,:c5,:b4,:r]
dv1.concat [q]*4*8
nv2.concat [:r,:g3,:r,:c4,:r,:b3,:r,:as3,:r,:fs4,:r,:fs4,:fs4,:fs4,:fs4,:r,:r,:b3,:r,:c4,:r,:cs4,:r,:d4,:r,:e4,:r,:fs4,:g4,:fs4,:g4,:r]
dv2.concat [q]*4*8
nb1.concat [:as2,:r,:a2,:r,:g2,:r,:fs2,:r,:fs3,:r,:fs2,:r,:b2,:c3,:b2,:r,:e3,:r,:e3,:r,:e3,:r,:e3,:r,:e3,:r,:e3,:r,:e4,:e4,:e4,:r,:e2]
db1.concat [q]*31+[q+3*m+cd,q]
#arco strings parts: use extra l in note symbols to differentiate them in the strings samples array
nlv1=[:r,:lfs4,:lfs5,:lfs4,:r,:le4,:le5,:le4,:r,:ld4,:ld5,:ld4,:lds5,:lds4,:le5,:r]
dlv1=[16*m+q]+[q]*15

#===================== now start playing ==========================
uncomment do #for testing. Normally leavee uncommented
  #play bass clarinet and clarinet parts with pulse synth
  with_synth :pulse do
    in_thread do #bass clarinet
      sleep 7*m+cd
      pln([:e3,:d3,:c3,:b2,:as2,:a2,:g2,:fs2],[dsq,dsq,dsq,dsq,c,c,c,cd]) #bass cl 1
      sleep 3*c
      pln([:b2,:a2,:g2,:fs2,:e2],[dsq,dsq,dsq,dsq,3*m+cd]) #bass cl 2
      #clarinet 1 part follows straight on
      pln([:g5,:fs5,:e5,:d5,:cs5,:ds5],[dsq,dsq,dsq,dsq,cd,sq]) #cl 1 a
      sleep sq+cd
      pln([:e5,:d5,:cs5,:b4,:a4,:g4,:r,:a5,:g5,:r],[dsq,dsq,dsq,dsq,cd,sq,sq+q,q,q,q]) #cl 1 b
    end

    in_thread do #second clarinet part
      sleep 16*m+cd #from start
      pln([:fs5,:e5,:ds5,:cs5,:b4,:c5,:r],[dsq,dsq,dsq,dsq,cd,sq,sq+cd]) #cl 2 a
      pln([:d5,:c5,:b4,:a4,:g4,:r,:a4,:g4,:r],[dsq,dsq,dsq,dsq,sq,sq,q,q,q]) #cl 2 b
    end
  end
end

#play pizzicato string parts
in_thread do
  plarraypiz(nv1,dv1)
end
in_thread do
  plarraypiz(nv2,dv2)
end
in_thread do
  plarraypiz(nb1,db1)
end
#play arco string part
in_thread do
  plarraypiz(nlv1,dlv1)
end

uncomment do #for testing purposes. Normally leave uncommented
  #play celeste parts
  sleep 4*m+q
  in_thread do
    plarray(n1,d1)
  end
  in_thread do
    plarray(n2,d2)
  end
  in_thread do
    plarray(n3,d3)
  end
  in_thread do
    plarray(n2b,d2b)
  end
  in_thread do
    plarray(n3b,d3b)
  end
  plarray(n4,d4)
end