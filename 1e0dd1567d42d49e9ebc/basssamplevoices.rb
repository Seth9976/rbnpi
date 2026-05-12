#sample based voices for any bass_xxx_c samples over 4 octave range from :c2 to :c5 by Robin Newman December 2014
#use pl(inst,n,d=0.2,pan=0,v=0.8) to play a note where n is note symbol,d duration,v volume
#or plarray(inst,nt,dur,sh=0,vol=0.8,pan=0) to play lists of note symbols and durations
#where inst is samplename,nt and dur are note symbol and duration arrays,sh transpose shift
use_debug false
rm = 2**(1.0/12) #rate multiplier between adjacent semitones (twelth root of 2)
inst = :bass_hard_c #to define scope of inst variable set up here. Used as a parameter later
s=1.0/16 #speed multiplier give 2 crotchet/sec or 120 bpm
shift=0

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
  if shift ==0 then
    return nv
  else
    return ntosym(note(nv)+shift)
  end
end

nt = []#setup note names :c2 to :c5
note(:c2).upto(note(:c5)) do |i|
  nt << ntosym(i)
end
rt=[]#set up rate multipliers :c2 = nt[0] has rate 1
rt[0]=1
0.upto(46) do |i| #calculate rate for all higher notes
  rt[i+1]=rt[i] * rm
end

nhash=[]#build a hash of notenames and rates
0.upto(47) do |i|
  nhash << [nt[i],rt[i]]
end

#now add in aliases for flats and e and b sharp

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

#set up function to play a given sample with note symbol value n.
define :pl do |inst,n,d=0.2,pan=0,v=0.8|
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
      pl(inst,tr(n,sh),d,pan,vol)
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
define :sp do |s,r=1,vol=0.8| #used to test a particular sample and rate
  sample s,rate: r,amp: vol
  puts s
  puts (sample_duration s) / r
  sleep (sample_duration s) / r
end
#=================== The following shows something of what the voices can do ==================
slist=[:bass_hard_c,:bass_thick_c,:bass_drop_c,:bass_woodsy_c,:bass_voxy_c,:bass_voxy_hit_c] #range of samples
in_thread do
  load_samples slist #preload the samples
  cue :loaded
end
sync :loaded #continue when samples all loaded
sleep 2 #let things settle before proceeding. Helps when running on Pi
n1=[:c2,:d2,:e2,:f2,:g2,:a2,:b2,:c3] #scale to test
d1=[q]+[sq]*6+[q] #timings for the scale
with_fx :reverb, room: 0.8 do

  plarray(:bass_hard_c,n1,d1)
  plarray(:bass_woodsy_c,n1[1..-1],d1[1..-1],12) #up an octave
  plarray(:bass_voxy_c,n1[1..-1],d1[1..-1],24) #up two octaves
  plarray(:bass_voxy_c,n1[0..-2].reverse,d1[1..-1],24) #up two octaves
  plarray(:bass_woodsy_c,n1[0..-2].reverse,d1[1..-1],12) #up an octave
  plarray(:bass_hard_c,n1[0..-2].reverse,d1[1..-1])

  rangeplay(:bass_hard_c,sq) #play complete range ascending
  rangeplay(:bass_woodsy_c,sq,1)#play complete range descending
  rangeplay(:bass_voxy_c,sq) #play complete range ascending
  rangeplay(:bass_thick_c,q,1) #play complete range descending slower
  rangeplay(:bass_voxy_hit_c,sq) #play complete range ascending

  plarray(:bass_drop_c,n1,[b]*8) #play a slow scale
  sp(:bass_drop_c) #play normal sample

  100.times do #choose and play 100 notes with sample voice, pitch, duration,pan at random
    d=[sq,q,c,cd].choose
    #parameters samplename,note symbol,duration,pan
    pl(slist.choose,ntosym(rrand_i(note(:c2),note(:c5))),d,[-1,0,1].choose)
    sleep d
  end
end
