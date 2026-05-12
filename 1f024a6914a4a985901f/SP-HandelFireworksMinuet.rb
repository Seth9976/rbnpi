# Handel's Firework Music Minuet coded by Robin Newman, April 2015

#requires version 2.5dev or later
#used to accompany SP/Minecraft Fireworks program (in a different workspace)
#from which it is cuded to start.

use_debug false
use_sample_pack_as '/home/pi/samples/Fireworks',:fireworks #adjust location as necessary

#first deal with selecting and setting up the samples
inst0=:fireworks__trumpet_cs5
samplepitch0=:cs5
inst1=:fireworks__tenor_trombone_as3
samplepitch1=:as3
inst2=:fireworks__bass_trombone_as2
samplepitch2=:as2


#preload all the samples

load_flag=0
if sample_loaded? inst0  then #check if sample already loaded
  load_flag=1
end
load_samples [inst0,inst1,inst2]
if load_flag==0 then #samples not loaded so allow time
  sleep 3
end

#put the sample names and pitches into an array i
i=[[inst0,samplepitch0],[inst1,samplepitch1],[inst2,samplepitch2]]

#define variables that need to be used globally
s=0 #note duration scale factor


#this function plays the sample at the relevant pitch for the note desired
#the note duration is used to set up the envelope parameters
define :pl do |inst,samplepitch,nv,dv,vol=1,st=0|
  shift=note(nv)-note(samplepitch)
  #start: param used with very small value to give more immediate attack for some samples
  sample inst,rate: (pitch_ratio shift),sustain: 0.8*dv,release: 0.2*dv,amp: vol,start: st
end

#this function plays an array of notes and associated array of durations
#also uses sample name (inst), sample normal pitch,sample start and shift (transpose) parameters
define :plarray do |inst,samplepitch,narray,darray,shift=0,vol=1,st=0|
  narray.zip(darray) do |nv,dv|
    if nv != :r
      pl(inst,samplepitch,note(nv)+shift,dv*s,vol)
    end
    sleep dv*s
  end
end

#set_bpm sets bpm required adjusting note duration variables accordingly
define :set_bpm do |n|
  s=1.0/8*60/n.to_f
end
#set relative note duration variables
dsq = 1.0 #must be float as divided later
sq = 2
sqd = 3
q = 4
qt = 2.0/3*q
qd = 6
qdd = 7
c = 8
cd = 12
cdd = 14
m = 16
md = 24
mdd = 28
b = 32
bd = 48
#set up the part lists
n1=[:bb4,:f4,:d4,:bb3,:f4,:bb4,:bb4,:d5,:bb4,:bb4,:bb4,:c5,:bb4,:c5,:c5,:d5,:c5,:d5,:eb5,:d5,:c5]
d1=[m,c,c,c,c,c,c,c,md,c,q,q,c,c,q,q,c,c,c,c,md]

n2=[:f4,:r,:f3,:r,:f4,:d4,:f4,:f4,:d4,:f4,:d4,:f4,:d4,:f4,:f4,:f4,:f4,:f4,:f4,:f4]
d2=[m,c,m,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,md]

n3=[:d5,:r,:bb4,:f4,:d5,:bb4,:bb4,:d5,:bb4,:bb4,:d5,:bb4,:bb4,:a4,:a4,:bb4,:a4,:bb4,:c5,:bb4,:a4,:c5,:a4]
d3=[m,c,m,c,c,c,c,c,c,c,c,c,c,c,q,q,c,c,c,c,c,c,c]

n4=[:bb2,:r,:bb3,:f3,:d3,:bb2,:d3,:bb2,:f3,:f3,:f3,:bb3,:a3,:bb3,:f3,:a3,:f3]
d4=[m,c+2*md,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c]

n1b=[:d5,:eb5,:f5,:f5,:g5,:f5,:eb5,:d5,:c5,:d5,:eb5,:eb5,:f5,:eb5,:d5,:c5,:bb4,:c5,:bb4,:bb4,:eb5,:c5,:d5,:d5,:eb5,:c5,:bb4]
n1fb=[:bb4]
d1b=[q,q,c,c,q,q,c,c,q,q,c,c,q,q,c,c,q,q,c,c,c,c,c,q,q,cd,q]
d1fb=[md]
n2b=[:f4,:bb4,:bb4,:bb4,:g4,:g4,:a4,:g4,:a4,:f4,:f4,:f4,:g4,:g4,:g4,:f4,:f4,:f4,:f4,:eb4]
n2fb=[:d4]
d2b=[c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c]
d2fb=[md]
n3b=[:bb4,:c5,:d5,:d5,:eb5,:eb5,:eb5,:c5,:c5,:c5,:bb4,:bb4,:a4,:g4,:a4,:bb4,:bb4,:a4,:a4,:bb4,:bb4,:c5,:a4,:a4]
n3fb=[:bb4]
d3b=[q,q,c,c,c,c,c,c,c,c,c,c,c,q,q,c,c,c,c,c,q,q,c,c]
d3fb=[md]
n4b=[:bb2,:bb3,:bb2,:eb3,:eb3,:eb3,:f3,:eb3,:f3,:d3,:bb2,:c3,:eb3,:eb3,:d3,:c3,:f3,:bb3,:bb2,:f3,:f3]
n4fb=[:bb2,:f3,:eb3,:d3,:c3]
d4b=[c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c]
d4fb=[c,q,q,q,q]
n1sb=[:bb4]
n1c=[:bb4,:f4,:d4,:c4,:bb3,:f4,:bb4,:bb4,:c5,:d5,:bb4,:bb4,:bb4,:c5,:bb4,:c5,:c5,:d5,:c5,:d5,:eb5,:d5,:d5,:eb5,:c5,:bb4,:bb4]
d1sb=[md]
d1c=[m,c,c,q,q,c,c,q,q,c,md,c,q,q,c,c,q,q,c,c,c,c,q,q,cd,q,md]
n2sb=[:d4]
n2c=[:f4,:r,:f3,:r,:f4,:f4,:f4,:d4,:d4,:f4,:f4,:f4,:f4,:f4,:f4,:f4,:f4,:f4,:f4,:f4,:f4,:c4,:d4]
d2sb=[md]
d2c=[m,c,m,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,md]
n3sb=[:f4]
n3c=[:d5,:r,:bb4,:f4,:d5,:bb4,:bb4,:bb4,:bb4,:c5,:bb4,:d5,:bb4,:d5,:a4,:a4,:bb4,:a4,:bb4,:a4,:bb4,:bb4,:c5,:a4,:a4,:bb4]
d3sb=[md]
d3c=[m,c,m,c,c,c,c,c,q,q,c,c,c,c,c,q,q,c,c,c,c,q,q,c,c,md]
n4sb=[:bb2]
n4c=[:bb2,:r,:bb2,:f3,:bb2,:bb3,:f3,:d3,:bb2,:d3,:bb2,:f3,:eb3,:d3,:c3,:bb2,:bb2,:eb3,:f3,:bb2]
d4sb=[md]
d4c=[m,c+md,c,c,c,c,c,c,c,c,c,m,c,c,c,c,c,c,c,md]
lar=[n1,d1,n2,d2,n3,d3,n4,d4,n1b,d1b,n2b,d2b,n3b,d3b,n4b,d4b,n1fb,d1fb,n2fb,d2fb,n3fb,d3fb,n4fb,d4fb]
lar.concat [n1sb,d1sb,n2sb,d2sb,n3sb,d3sb,n4sb,d4sb,n1c,d1c,n2c,d2c,n3c,d3c,n4c,d4c]



define :part do |x|
  in_thread do
    plarray(i[0][0],i[0][1],lar[x],lar[(x+1)],0,0.7) #trumpet I
  end
  in_thread do
    plarray(i[0][0],i[0][1],lar[x+2],lar[x+3],0,0.6) #trumpet II
  end
  in_thread do
    plarray(i[1][0],i[1][1],lar[x+4],lar[x+5],-12,0.6) #trombone I
  end
  plarray(i[2][0],i[2][1],lar[x+6],lar[x+7],0,0.4) #trombone II
end

set_bpm(110) #set tempo 40 crotchets or 80 quavers per minute
sync :fireworks
with_fx :reverb,room: 0.8,mix: 0.6 do #add some reverb
#  with_fx :level,amp: 1.1 do #boost levels
part(0)
part(8)
part(16)
part(8)
part(24)
part(32)
part(0)
part(8)
part(24)
 # end
end
cue :finish