#Bach Gigue in G Minor from English Suite 3 (part 1). Coded by Robin Newman December 2014
#sample based version in two parts synced together. Start part 2 then part 1
set_sched_ahead_time! 3

#use_sample_pack '/Users/rbn/Desktop/samples/GrandPiano/' #select and adjust as necessary
use_sample_pack '/home/pi/samples/GrandPiano'
#select loud (f) or soft (p) piano samples
ps="piano_f_"
#ps="piano_p_"
rt=2**(1.0/12)  #12th root of 2
irt=1.0/rt #inverse of above

define :sname do |sn,n| #generates sample name for selected pack
  return (sn+n).intern
end
#array holding sample info for each note: [note, sample name, rate to play]
sam = [[:c1,sname(ps,"c1"),1],[:cs1,sname(ps,"c1"),rt]]
sam.concat [[:d1,sname(ps,"ds1"),irt],[:ds1,sname(ps,"ds1"),1],[:e1,sname(ps,"ds1"),rt]]
sam.concat [[:f1,sname(ps,"fs1"),irt],[:fs1,sname(ps,"fs1"),1],[:g1,sname(ps,"fs1"),rt]]
sam.concat [[:gs1,sname(ps,"a1"),irt],[:a1,sname(ps,"a1"),1],[:as1,sname(ps,"a1"),rt]]
sam.concat [[:b1,sname(ps,"c2"),irt],[:c2,sname(ps,"c2"),1],[:cs2,sname(ps,"c2"),rt]]
sam.concat [[:d2,sname(ps,"ds2"),irt],[:ds2,sname(ps,"ds2"),1],[:e2,sname(ps,"ds2"),rt]]
sam.concat [[:f2,sname(ps,"fs2"),irt],[:fs2,sname(ps,"fs2"),1],[:g2,sname(ps,"fs2"),rt]]
sam.concat [[:gs2,sname(ps,"a2"),irt],[:a2,sname(ps,"a2"),1],[:as2,sname(ps,"a2"),rt]]
sam.concat [[:b2,sname(ps,"c3"),irt],[:c3,sname(ps,"c3"),1],[:cs3,sname(ps,"c3"),rt]]
sam.concat [[:d3,sname(ps,"ds3"),irt],[:ds3,sname(ps,"ds3"),1],[:e3,sname(ps,"ds3"),rt]]
sam.concat [[:f3,sname(ps,"fs3"),irt],[:fs3,sname(ps,"fs3"),1],[:g3,sname(ps,"fs3"),rt]]
sam.concat [[:gs3,sname(ps,"a3"),irt],[:a3,sname(ps,"a3"),1],[:as3,sname(ps,"a3"),rt]]
sam.concat [[:b3,sname(ps,"c4"),irt],[:c4,sname(ps,"c4"),1],[:cs4,sname(ps,"c4"),rt]]
sam.concat [[:d4,sname(ps,"ds4"),irt],[:ds4,sname(ps,"ds4"),1],[:e4,sname(ps,"ds4"),rt]]
sam.concat [[:f4,sname(ps,"fs4"),irt],[:fs4,sname(ps,"fs4"),1],[:g4,sname(ps,"fs4"),rt]]
sam.concat [[:gs4,sname(ps,"a4"),irt],[:a4,sname(ps,"a4"),1],[:as4,sname(ps,"a4"),rt]]
sam.concat [[:b4,sname(ps,"c5"),irt],[:c5,sname(ps,"c5"),1],[:cs5,sname(ps,"c5"),rt]]
sam.concat [[:d5,sname(ps,"ds5"),irt],[:ds5,sname(ps,"ds5"),1],[:e5,sname(ps,"ds5"),rt]]
sam.concat [[:f5,sname(ps,"fs5"),irt],[:fs5,sname(ps,"fs5"),1],[:g5,sname(ps,"fs5"),rt]]
sam.concat [[:gs5,sname(ps,"a5"),irt],[:a5,sname(ps,"a5"),1],[:as5,sname(ps,"a5"),rt]]
sam.concat [[:b5,sname(ps,"c6"),irt],[:c6,sname(ps,"c6"),1],[:cs6,sname(ps,"c6"),rt]]
sam.concat [[:d6,sname(ps,"ds6"),irt],[:ds6,sname(ps,"ds6"),1],[:e6,sname(ps,"ds6"),rt]]
sam.concat [[:f6,sname(ps,"fs6"),irt],[:fs6,sname(ps,"fs6"),1],[:g6,sname(ps,"fs6"),rt]]
sam.concat [[:gs6,sname(ps,"a6"),irt],[:a6,sname(ps,"a6"),1],[:as6,sname(ps,"a6"),rt]]
sam.concat [[:b6,sname(ps,"c7"),irt],[:c7,sname(ps,"c7"),1],[:cs7,sname(ps,"c7"),rt]]
sam.concat [[:d7,sname(ps,"ds7"),irt],[:ds7,sname(ps,"ds7"),1],[:e7,sname(ps,"ds7"),rt]]
sam.concat [[:f7,sname(ps,"fs7"),irt],[:fs7,sname(ps,"fs7"),1],[:g7,sname(ps,"fs7"),rt]]
sam.concat [[:gs7,sname(ps,"a7"),irt],[:a7,sname(ps,"a7"),1],[:as7,sname(ps,"a7"),rt]]
sam.concat [[:b7,sname(ps,"c8"),irt],[:c8,sname(ps,"c8"),1]]
#puts sam

#note aliases to allow flats
flat=[:db1,:eb1,:fb1,:gb1,:ab1,:bb1,:cb2,:db2,:eb2,:fb2,:gb2,:ab2,:bb2,:cb3,:db3,:eb3,:fb3,:gb3,:ab3,:bb3,:cb3,:db4,:eb4,:fb4,:gb4,:ab4,:bb4,:cb4,:db5,:eb5,:fb5,:gb5,:ab5,:bb5,:cb5,:db6,:eb6,:fb6,:gb6,:ab6,:bb6,:cb7,:db7,:eb7,:fb7,:gb7,:ab7,:bb7,:cb8]
sharp=[:cs1,:ds1,:e1,:fs1,:gs1,:as1,:b1,:cs2,:ds2,:e2,:fs2,:gs2,:as2,:b2,:cs3,:ds3,:e3,:fs3,:gs3,:as3,:b3,:cs4,:ds4,:e4,:fs4,:gs4,:as4,:b4,:cs5,:ds5,:e5,:fs5,:gs5,:as5,:b5,:cs6,:ds6,:e6,:fs6,:gs6,:as6,:b6,:cs7,:ds7,:e7,:fs7,:gs7,:as7,:b7]

#add es and bs with aliases
flat.concat [:es1,:es2,:es3,:es4,:es5,:es6,:es7,:bs1,:bs2,:bs3,:bs4,:bs5,:bs6,:bs7]
sharp.concat [:f1,:f2,:f3,:f4,:f5,:f6,:f7,:c2,:c3,:c4,:c5,:c6,:c7,:c8]
extra=[]
flat.zip(sharp).each do |f,s|
  extra.concat [[f,(sam.assoc(s)[1]),(sam.assoc(s)[2])]]
end
sam = sam + extra #add in flat definitions

#definition to play a sample "note" specify note, duration,pan,volume,release type as parameters
define :pl do |n,d=0.2,pan=0,v=0.8,nodamp=0|
  if nodamp == 0
    rt=d #gives reasonable result: experiment with value
  else
    rt = sample_duration(sam.assoc(n)[1]) #release is sample duration time
  end
  sample (sam.assoc(n)[1]),rate: (sam.assoc(n)[2]),attack: 0,sustain: d*0.95,release: rt,amp: v,pan: pan
end

define :ntosym do |n| #this returns the equivalent note symbol to an input integer e.g. 59 => :b4
  @note=n % 12
  @octave = n / 12 - 1
  #puts @octave #for debugging
  #puts @note
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
  return (lookup_notes[@note].to_s + @octave.to_s).to_sym #return the required note symbol
end

define :tr do |nv,shift| #this enables transposition of the note. Shift is number of semitones to move
  if shift ==0 then
    return nv
  else
    return ntosym(note(nv)+shift)
  end
end

define :plarray do |nt,dur,shift=0,vol=0.6,pan=0| #This plays associated arrays of notes and durations, transposing if set, and handling rests
  nt.zip(dur).each do |n,d|
    if n != :r then
      #puts n
      pl(tr(n,shift),d,pan)
    end
    sleep d
  end
end

cue :part2