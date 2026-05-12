#Sonic Pi celeste voice, programmed by Robin Newman October 2014 (PART 1)
#This version for Mac OSX, but works on Raspberry Pi too
#the program uses celeste samples from the Sonatina Symphonic Orchstra under CCL1
#also uses samples for pizz strings
#clarinet and bass clarinet played with :pulse synth
#the program is long, so split between two workpaces and uses cue and sync between them
#load part2 into separate workspace, run it, then switch to this workspace and run this program

s=0 #set s here with dummy value so that its scope is global
r=2**(1.0/12) #semitone rate multiplier
ir=1.0/r #inverse to go down semitone
#puts r
#puts ir
define :setbpm do |n| #set bpm equivalent
  s = (1.0 / 8) *(60.0/n.to_f)
end
setbpm(57)
shift = 0 #set transpose: not used in this piece
use_sample_pack "/Users/rbn/Desktop/samples/CEL" #all samples placed in here

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
flag=0 #flag to check if samples loaded
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
#check if sample already loaded
if sample_loaded? vle5 then
flag=1 #set loaded flag
end

load_samples vas3,vcs4,ve4,vg4,vcs5,bds3,bfs2,bc3,ba2,vle4,vle5

if flag == 0 then #allow time for loading to finish
puts "loading time"
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
#puts n #for debugging
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

cue :second #start the second half of the program
