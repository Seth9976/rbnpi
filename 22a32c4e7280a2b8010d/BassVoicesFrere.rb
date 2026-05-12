#bass sample voices for Sonic Pi version 2. With Frere Jaques and chords examples

#sample based voices for any bass_xxx_c samples over 4 octave range from :c2 to :c5 by Robin Newman December 2014
#use pl(inst,n,d=0.2,pan=0,v=0.8) to play a note where n is note,d duration,v volume
#or plarray(inst,nt,dur,sh=0,vol=0.8,pan=0) to play lists of notes and durations
#where inst is samplename,nt and dur are note and duration arrays,sh transpose shift
#tidied up tr, pl, plarray definitions and added plchord to play chords.
#all of them now accept symbolic or numeric note entry

use_debug false

rm = 2**(1.0/12) #rate multiplier between adjacent semitones (twelth root of 2)
inst = :bass_hard_c #to define scope of inst variable set up here. Used as a parameter later

s=1.0/16 #speed multiplier sets 2 crotchet/sec or 120 bpm.
shift=0 #set here for global scope. Altered later

define :ntosym do |n| #this returns the equivalent note symbol to an input integer e.g. 59 => :b4
  #nb no error checking on integer range included
  #only returns notes as n or n sharps.But will sound ok for flats
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
  return ntosym(note(nv)+shift) #always returns a note symbol. Input can be symbol or number
end

nt = []#setup note names :c2 to :c5
note(:c2).upto(note(:c5)) do |i|
  nt << ntosym(i) #generates note names and their sharps only
end

rt=[]#set up rate multipliers :c2 = nt[0] has rate 1
rt[0]=1
0.upto(46) do |i| #calculate rate for all the 47 higher notes
  rt[i+1]=rt[i] * rm #each note's rate is 12th root of 2 times higher than previous one
end

nhash=[]#build a hash of notenames and rates
0.upto(47) do |i| #48 notes in total
  nhash << [nt[i],rt[i]]
end

#now add in aliases for flats and e and b sharp so these symbols can be used to
#the flats are essentially set up as aliases for the sharp names
flat=[:db2,:eb2,:fb2,:gb2,:ab2,:bb2,:cb3,:db3,:eb3,:fb3,:gb3,:ab3,:bb3,:cb4,:db4,:eb4,:fb4,:gb4,:ab4,:bb4,:cb5]
sharp=[:cs2,:ds2,:e2,:fs2,:gs2,:as2,:b2,:cs3,:ds3,:e3,:fs3,:gs3,:as3,:b3,:cs4,:ds4,:e4,:fs4,:gs4,:as4,:b4]
#add es and bs with aliases
flat.concat [:es2,:es3,:es4,:bs2,:bs3,:bs4]
sharp.concat [:f2,:f3,:f4,:c3,:c4,:c5]

#initialise array for extra values
extra=[]

flat.zip(sharp).each do |f,s|
  # adds element with flat name and rate factor looked up from associated sharp entry
  extra.concat [[f,(nhash.assoc(s)[1])]]
end
nhash = nhash + extra #add extras in

#set up function to play a given sample with note n (symbol or numeric acccepted).
define :pl do |inst,n,d=0.2,pan=0,v=0.8|
  n=ntosym(note(n)) #this converts all entries to symbols (converts all to numeric then back)
  #sample inst,rate: (nhash.assoc(n)[1]),attack: d*0.1,sustain: d*0.85,release: d*0.1,amp: v,pan: pan,start: 0.04
  #use one of line above OR below
  sample inst,rate: (nhash.assoc(n)[1]),attack: d*0,sustain: d*0.9,release: d*0.1,amp: v,pan: pan,start: 0.00
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

#function plays an array of note symbols and duration values (nt and dur) using sample inst, with parameters for transposition, volume and pan
define :plarray do |inst,nt,dur,sh=0,vol=0.8,pan=0|
  nt.zip(dur).each do |n,d|
    if n != :r then
      pl(inst,tr(note(n),sh),d,pan,vol)
    end
    sleep d
  end
end

define :rangeplay do |inst,duration,direction=0|
  l=[]
  d=[]
  note(:c2).upto(note(:c5)) do |n|
    l << ntosym(n)
    d << duration
  end
  if direction==1
    l=l.reverse
  end
  plarray(inst,l,d)
end

define :plchord do |inst,trname,d=0.2,shift=0,pan=0,v=0.8|
  trname.each do |n|
    pl(inst,tr(note(n),shift),d,pan,v)
  end
end

define :inv1 do |triad| #returns first inversion of a triad
  return triad[1..-1]+[triad[0]+12]
end

define :inv2 do |triad| #returns second inversion of a triad
  return inv1(inv1(triad))
end

define :sp do |s,r=1,vol=0.8| #used to test a particular sample and rate
  sample s,rate: r,amp: vol
  puts s
  puts (sample_duration s) / r
  sleep (sample_duration s) / r
end

slist=[:bass_hard_c,:bass_thick_c,:bass_drop_c,:bass_woodsy_c,:bass_voxy_c,:bass_voxy_hit_c] #range of samples
in_thread do
  load_samples slist #preload the samples
  cue :loaded
end
sync :loaded #continue when samples all loaded
sleep 2 #let things settle

#=================== The following shows something of what the voices can do ==================
#first setup up Frere Jaques
#define notes and durations for Frere Jaques tune. Four lines 1-4
n1=[:c3,:d3,:e3,:c3]*2
d1=[c]*8
n2=[:e3,:f3,:g3]*2
d2=[c,c,m]*2
n3=[:g3,:a3,:g3,:f3,:e3,:c3]*2
d3=[q,q,q,q,c,c]*2
n4=[:c3,:g2,:c3]*2
d4=[c,c,m]*2

define :fj do |inst,shift=0,vol=1| #define function to play Frere Jaques (with transpose)
  plarray(inst,n1,d1,shift,vol*0.8,-1)
  plarray(inst,n2,d2,shift,vol*0.8,1)
  plarray(inst,n3,d3,shift,vol*0.8,-0.7)
  plarray(inst,n4,d4,shift,vol*0.8,0.7)
end

define :round do |shift=0,vol| #plays four part round with different bass sample voices
  vlist=[:bass_thick_c,:bass_voxy_c,:bass_woodsy_c,:bass_hard_c]
  0.upto(3) do |i|
    in_thread do
      fj(vlist[i],shift,vol)
    end
    sleep c*8 #duration of first line
  end
  sleep c*8*3 #allow for remainder of last round to complete
end

#================= Start playing things here ===================
shiftnum=[-5,5,0] #setup up three shifts
volnum=[0.8,0.3,1] #setup three volumes
curinst=:bass_voxy_c #default voice to use
with_fx :reverb,room: 0.6 do
  0.upto(2) do |i| #play everything 3 times with different settings
    shift=shiftnum[i]  #max range for this piece is -7 to +5
    plchord(curinst,chord(:c3,:dim),m,shift,0,volnum[i])
    sleep m
    plchord(curinst,inv1(chord(:c3,:dim)),m,shift,0,volnum[i])
    sleep m
    plchord(curinst,inv2(chord(:c3,:dim)),m,shift,0,volnum[i])
    sleep m
    plchord(curinst,chord(:c4,:major),m,shift,0,volnum[i])
    sleep m

    round(shift,volnum[i]) #plays Frere Jaques 4 part round with 4 different Bass Sample Voices

    plchord(curinst,[:c3,:e3,:g3,:c4],m,shift,0,volnum[i])
    sleep m
    plchord(curinst,[:c3,:c4],q,shift,0,volnum[i]) #two different way to play in octaves, first with chords
    sleep q
    plchord(curinst,[:g2,:g3],cdd,shift,0,volnum[i])
    sleep cdd
    in_thread do
      plarray(curinst,[:g2,:c3],[q,cdd],shift,volnum[i]) #now with a thread and list of notes
    end
    plarray(curinst,[:g3,:c4],[q,cdd],shift,volnum[i]) #here is the upper octave played at the same time

    if shift >= 0 #play last note only if no shift < 0 applied
      pl(curinst,tr(:c2,shift),b,0,volnum[i])
      sleep b
    end
  end
end
