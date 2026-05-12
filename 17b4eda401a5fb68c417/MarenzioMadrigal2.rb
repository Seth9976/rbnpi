# Luca Marenzio Madrigal 1553-1599 "Crudele Acerba" arranged for 5 trumpets coded for by Robin Newman, April 2015
#uses sample based voice, and also has variable dynamic settings for each part and final rit.
#requires version 2.5 or later
#Sample requires can be downloaded from http://r.newman.ch/rpi/Marenzio.zip
use_debug false
path= '~/Desktop/samples/Marenzio' #path to sample folder adjust location as necessary

#first deal with selecting and setting up the sample
inst0=:trumpet_cs5
samplepitch0=:cs5
#preload the sample

load_sample path,inst0

#define variable that needs to be used globally
s=0 #note duration scale factor: redefined in use_bpm function

#this function plays the sample at the relevant pitch for the note desired
#the note duration is used to set up the envelope parameters
define :pl do |inst,samplepitch,nv,dv,vol=1,pan=0|
  shift=note(nv)-note(samplepitch)
  sample path,inst,rate: (pitch_to_ratio shift),sustain: 0.95*dv,release: 0.05*dv,amp: vol,pan: pan
end

#this function plays an array of notes and associated array of durations
#also uses sample name (inst), sample normal pitch,sample start and shift (transpose) parameters
define :plarray do |inst,samplepitch,narray,darray,shift=0,vol=1,pan=0|
  narray.zip(darray) do |nv,dv|
    if nv != :r
      pl(inst,samplepitch,note(nv)+shift,dv*s,vol,pan)
    end
    sleep dv*s
  end
end
define :ct do |ptr,lev,slid=0,timetonext=0| #controls level
  control ptr,amp: lev,amp_slide: slid
  puts "level "+lev.to_s
  sleep timetonext*s #scale for tempo
end
define :plct do |pt,am,amsl,amd| #performs level change for a part
  am.zip(amsl,amd) do |amv,amslv,amdv|
    ct(pt,amv,amslv,amdv)
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
#dynamic settings
# pp p mp mf f ff
pp=0.02
p=0.08
mp=0.2
mf=0.6
f=1.0
ff=1.6
comment do
  pp=0.01
  p=0.15
  mp=0.2
  mf=0.6
  f=1.0
  ff=1.6
end
ps=1.6 #pause factor

#set up the part lists ADD "settling rest time" of dsq at beginning of all parts for level to set
n1=[:r,:c5,:g5,:g5,:ab5,:g5,:g5,:g5,:d5,:e5,:f5,:f5,:ab5,:ab5,:g5,:f5,:db5,:eb5,:f5,:gb5,:f5,:f5,:e5,:f5]
d1=[dsq,b*2,bd,m,b,b,b,b,m,m,b,b*2,b,m,m,m,c,c,m,md,c,b,m,b]
#b20
n1.concat [:r,:f5,:g5,:ab5,:bb5,:ab5,:ab5,:g5,:ab5,:r,:eb5,:bb5,:eb5,:r,:g5,:f5,:e5,:r]
d1.concat [b,md,c,m,md,c,b,m,b,7*b,b,b,b,m,b,b,m,b]
#b40
n1.concat [:r,:c5,:d5,:eb5,:f5,:e5,:f5,:r,:f5,:c5,:c5,:c5,:bb4,:gb5,:g5,:f5,:a4,:bb4,:eb4,:f4,:ab4,:bb4,:eb4,:f4,:gb4]
d1.concat [m,m,b,m,b,m,b*2,m,m,b,b,b,b,b,b,bd,m,b*2,b,b,m,b,m,b,b]
#b63
n1.concat [:r,:eb5,:f5,:r,:bb5,:f5,:bb5,:ab5,:g5,:g5,:f5,:g5,:r,:ab5,:g5,:f5,:eb5,:db5,:c5,:r,:eb4,:f4,:g4,:ab4,:g4,:r]
d1.concat [md,c,b,md,c,c,c,q,q,m,c,m,b*2,m,m,b,m,m,b,b*2+m,m,md,c,m,m,b*2]
#b81
n1.concat [:eb5,:db5,:c5,:bb4,:ab4,:bb4,:ab5,:g5,:f5,:eb5,:db5,:c5,:r,:c5,:db5,:eb5,:f5,:e5]
d1.concat [md,c,m,c,c,b,c,c,b,c,c,m,c,c,m,m,b,b*ps]
#end

n2=[:r,:e4,:c5,:d5,:e5,:c5,:c5,:b4,:c5,:db5,:c5,:bb4,:c5,:r,:db5,:db5,:c5,:bb4,:ab4,:bb4]
d2=[dsq+b,b*2,bd,m,b,b,b,m,b,b,b,m,b,b,b,bd,m,bd,c,c]
#b20
n2.concat [:c5,:db5,:c5,:c5,:bb4,:c5,:r,:c5,:a4,:bb4,:c5,:d5,:eb5,:ab4,:bb4,:c5,:bb4,:a4,:r,:c5,:db5,:eb5,:db5,:c5,:bb4,:a4]
d2.concat [m,md,c,b,m,b,b*2,b,m,b,b,b,c,c,m,b,b,m,b,m,m,b,m,b,b,m]
#b40
n2.concat [:r,:g4,:a4,:bb4,:c5,:b4,:c5,:r,:eb4,:f4,:g4,:f4,:f4,:db5,:bb4,:db5,:c5,:c4,:d4,:eb4,:f4,:g4,:ab4,:g4,:ab4,:r,:ab4,:db5,:eb5,:db5,:c5,:bb4]
d2.concat [3*b+m,m,b,m,b,m,m,c,c,m,m,b,m,m,m,b,m,m,m,m,m,m,b,m,b,m,b,b,b,b,c,c]
#b63
n2.concat [:c5,:r,:c5,:d5,:r,:eb5,:bb4,:eb5,:db5,:c5,:r,:bb4,:f4,:bb4,:ab4,:g4,:r,:db5,:c5,:bb4,:ab4,:g4,:ab4,:eb5,:db5,:c5,:bb4,:ab4,:g4,:g4,:ab4,:g4,:f4,:e4,:r]
d2.concat [m,c,c,b,c,c,c,c,b,m,md,c,c,c,m,m,b,c,m,m,m,c,b,c,m,m,m,c,c,c,md,c,b,m,2*b]
#b81
n2.concat [:c5,:bb4,:ab4,:g4,:f4,:eb4,:f5,:eb5,:db5,:c5,:bb4,:f5,:f4,:ab4,:bb4,:c5,:bb4,:c5]
d2.concat [md,c,m,c,c,b,c,c,b,c,c,c,c,m,m,b,m,b*ps]
#end

n3=[:r,:c5,:e4,:f4,:g4,:c4,:r,:c4,:f4,:eb4,:db4,:c4,:db4,:ab3,:db4,:db4,:eb4,:f4,:bb3,:c4,:db4,:c4]
d3=[dsq+b,b*2,bd,m,b*2,b,b,m,b,m,b,b,b,m,m,m,m,b,md,c,m,m]
#b20
n3.concat [:ab4,:g4,:f4,:f4,:eb4,:eb4,:eb4,:r,:g4,:f4,:eb4,:f4,:g4,:ab4,:bb4,:c5,:c5,:eb4,:d4,:r]
d3.concat [md,c,b,b,b,b,b,b*2,bd,b,m,m,m,m,m,m,c,md,m,b*5]
#b40
n3.concat [:g4,:bb4,:bb3,:bb3,:f4,:r,:ab4,:f4,:f4,:eb4,:d4,:c4,:db4,:r,:bb4,:g4,:f4,:eb4,:f4,:eb4,:c5,:f5,:f5,:gb5,:f5,:eb5,:db5]
d3.concat [b,b,b,b,b,m,m,m,b,b,m,b,b,b*2+m,m,m,m,m,m,b,b,bd,m,bd,b,c,c]
#b63
n3.concat [:eb5,:r,:bb4,:f4,:bb4,:ab4,:g4,:r,:c5,:bb4,:g4,:bb4,:c5,:r,:c5,:bb4,:ab4,:g4,:f4,:eb4,:r,:c5,:bb4,:ab4,:g4,:f4]
d3.concat [m,md,c,c,c,m,m,b+c,c,c,c,b,b*2,b*2,m,m,b,m,m,b,bd,b,m,m,c,c]
#b81
n3.concat [:eb4,:eb4,:f4,:g4,:ab4,:g4,:r,:f4,:g4,:ab4,:f4,:c4]
d3.concat [m,m,b,b,b,b,b+c,c,m,m,m,b*ps]
#end

n4=[:r,:c4,:g4,:g4,:ab4,:g4,:f4,:f4,:f4,:g4,:ab4,:f4,:bb4,:bb4,:ab4,:g4,:r]
d4=[dsq+5*b,b*2,bd,m,bd,m,b,b,m,m,b,m,m,m,m,b,b]
#b20
n4.concat [:f4,:g4,:ab4,:ab4,:g4,:f4,:g4,:c5,:bb4,:c5,:r,:c5,:d5,:e5,:f5,:g5,:ab5,:g5,:f5,:r,:eb4,:f4,:g4,:ab4,:bb4,:c5,:bb4,:ab4,:g4,:f4]
d4.concat [md,c,m,b,c,c,m,m,b,b,m,b,b,m,b,m,b,m,b,m,m,m,m,m,m,m,b,b,b,b] #minum over
#b40+m
n4.concat [:e4,:r,:g4,:bb4,:bb4,:bb4,:c5,:r,:f4,:g4,:a4,:bb4,:a4,:bb4,:r,:bb4,:gb4,:f4,:eb4,:e4,:f4,:c5,:r,:ab4,:f4,:db4,:bb3,:eb4,:f4]
d4.concat [m,m,m,m,m,b,b,b+md,c,b,m,b,m,m,c,c,m,m,md,c,b,b,2*b+m,b,m,b,b*2,md,c]
#b63
n4.concat [:gb4,:f4,:r,:bb4,:f4,:bb4,:ab4,:g4,:r,:bb4,:f4,:e4,:f4,:e4,:r,:f4,:g4,:ab4,:bb4,:bb4,:eb4,:r,:f5,:eb5,:db5,:c5,:bb4,:c5,:eb5,:f5]
d4.concat [b,b,b+c,c,c,c,m,m,m,c,c,c,m,c,b,m,m,m,cd,q,b,c,c,b,b,b,m,b,b,b]
#b81
n4.concat [:g5,:ab5,:g5,:r,:bb4,:ab4,:g4,:f4,:g4]
d4.concat [b,b,m,bd,b,bd,m,b,b*ps]
#end

n5=[:r,:c4,:e4,:f4,:g4,:f4,:bb3,:bb3,:f4,:eb4,:db4,:db4,:db4,:db4,:g3,:f4]
d5=[dsq+4*b,b*2,bd,m,b,b,b,b,m,m,b,b,b,b,b,b]
#b20
n5.concat [:r,:f4,:eb4,:db4,:c4,:ab3,:eb4,:c4,:r,:g3,:a3,:b3,:c4,:d4,:eb4,:db4,:c4,:bb3,:ab3,:g3,:r]
d5.concat [b,md,c,b,m,m,b,b,b*2,b,b,m,m,m,b,m,b,b,bd,m,b*3]
#b40
n5.concat [:c4,:g3,:gb3,:g3,:f4,:db4,:d4,:c4,:e4,:f4,:bb3,:r,:c4,:a3,:bb3,:c4,:d4,:eb4,:ab3,:db4,:bb4,:gb3,:bb3,:eb4]
d5.concat [b,b,b,b,b,b,b,bd,m,b,b,bd,m,m,m,bd,m,b,b,bd,m,b,b,b*2] #over by b
#b63 + b
n5.concat [:bb3,:r,:eb4,:bb3,:eb4,:db4,:c4,:f4,:eb4,:db4,:c4,:bb3,:ab3,:ab3,:bb3,:c4,:db4,:c4,:ab4,:g4,:f4,:eb4,:db4]
d5.concat [b,2*b+md,c,c,c,m,b,m,m,b,m,m,b,b,b,b,b,b,m,m,m,c,c]
#b81
n5.concat [:c4,:r,:db4,:eb4,:f4,:db4,:c4]
d5.concat [b,b*2,b,b,b,b*2,b*ps]
#end

#parts dynamic data
a1=[p,mf,mp,p,mf,f,mf,mp,p,pp] #levels
as1=[0,4*b,0,3*b,b,0,3*b,m,3*b,2*b+md,b]#slide times
ad1=[20*b,12*b,7*b+m,9*b+m,15*b+md,7*b+c,3*b+m,bd,6*b,4*b,2*b] #sleep durations at level
a2=[p,mf,p,mf,mp,p,mf,f,mf,mp,p,pp]
as2=[0,4*b+m,0,5*b,0,5*b,0,0,b,3*b,2*b+m,b]
ad2=[18*b+m,4*b+m,5*b,6*b,3*b+m,12*b,14*b+md,7*b+md,5*b,6*b,2*b+m,3*b+m]
a3=[p,mf,p,mf,p,mf,f,mf,mp,p,pp]
as3=[0,5*b,0,6*b,0,0,0,b,0,2*b,b]
ad3=[19*b,8*b,b,6*b,18*b+m,10*b+md,8*b+md,5*b+m,5*b+m,3*b,b,2*b]
a4=[p,mf,p,mf,mp,p,mf,f,mf,mp,p,pp]
as4=[0,5*b,0,4*b,0,2*b,0,0,b,b,0,b]
ad4=[19*b,6*b,3*b,4*b+m,6*b,11*b+c,15*b+m,6*b+md,4*b,8*b,3*b,2*b]
a5=[p,mf,p,mf,p,mf,f,mf,mp,p,pp]
as5=[0,4*b,0,6*b,b,0,0,b,b,b,b]
ad5=[20*b,7*b,2*b,6*b,16*b+m,15*b+c,5*b+c,5*b,6*b,4*b,2*b]


define :len do |d| #for checking durations of parts
  ld=0
  d.each do |d|
    ld += d
  end
  return ld
end

define :perform do |x|
  in_thread do
    with_fx :level do |amp1| #set dynamic level
      in_thread do
        plct(amp1,a1,as1,ad1)
      end
      plarray(inst0,samplepitch0,n1,d1,-2,0.8,-0.7) #trumpet I
    end
  end
  in_thread do
    with_fx :level do |amp2|
      in_thread do
        plct(amp2,a2,as2,ad2)
      end
      plarray(inst0,samplepitch0,n2,d2,-2,0.8,0.7) #trumpet II
    end
  end
  in_thread do
    with_fx :level do |amp3|
      in_thread do
        plct(amp3,a3,as3,ad3)
      end
      plarray(inst0,samplepitch0,n3,d3,-2,0.8,-0.4) #trumpet III
    end
  end
  in_thread do
    with_fx :level do |amp4|
      in_thread do
        plct(amp4,a4,as4,ad4)
      end
      plarray(inst0,samplepitch0,n4,d4,-2,0.8,0.4) #trumpet IV
    end
  end
  with_fx :level do |amp5|
    in_thread do
      plct(amp5,a5,as5,ad5)
    end
    plarray(inst0,samplepitch0,n5,d5,-2,0.9,0) #trumpet V
  end
end
comment do #checks for debugging data input
  puts len(d1)
  puts len(d2)
  puts len(d3)
  puts len(d4)
  puts len(d5)
  puts n4.length
  puts d4.length
  puts len(ad1)
  puts len(ad2)
  puts len(ad3)
  puts len(ad4)
  puts len(ad5)
end

set_bpm(132) #set tempo

with_fx :reverb,room: 0.8,mix: 0.6 do #add some reverb
  perform(0)
end