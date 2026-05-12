# Luca Marenzio Madrigal 1553-1599 "Spring Returns" arranged for 5 trumpets coded for by Robin Newman, April 2015
#uses sample based voice, and also has variable dynamic settings for each part and final rit.
#updated for newer versions of SP > 3 May need run_file on a Mac as quite long.
#Sample requires can be downloaded from http://r.newman.ch/rpi/Marenzio.zip
use_debug false
path = '~/Desktop/samples/Marenzio' #adjust location of sampe directory as necessary

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
  sample path,inst,rate: (pitch_to_ratio shift),sustain: 0.8*dv,release: 0.2*dv,amp: vol,pan: pan
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
  #puts "level "+lev.to_s #for debugging
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
ps=1.6 #pause factor

#set up the part lists
n1=[:c5,:g5,:e5,:r,:e5,:g5,:e5,:d5,:c5,:d5,:e5,:f5,:f5,:e5,:e5,:d5,:c5,:r,:c5,:g5,:e5,:r,:g5,:e5,:g5,:g5,:g5,:r,:c5,:c5,:b4,:c5,:g4]
d1=[m,m,b,c,c,c,c,q,q,q,q,c,c,c,c,m,m,c,c,m,m,c,c,c,c,c,c,md,c,c,c,m,m]
#b12
n1.concat [:r,:c5,:b4,:c5,:g4,:g5,:g5,:a5,:b5,:g5,:g5,:e5,:e5,:f5,:g5,:e5,:e5,:g5,:g5,:f5,:e5,:g5,:g5,:r,:g5,:g5,:a5,:b5,:g5,:g5,:e5,:e5,:f5,:g5,:e5]
d1.concat [c,m,c,m,m,c,q,q,c,c,m,c,q,q,c,c,m,c,q,q,c,c,b,m,c,q,q,c,c,m,c,q,q,c,c]
#b22
n1.concat [:e5,:r,:g5,:f5,:e5,:d5,:d5,:a5,:g5,:f5,:e5,:d5,:c5,:d5,:e5,:f5,:g5,:g4,:ab4,:ab4,:r,:a4,:a4,:r,:e5,:d5,:c5,:b4,:a4,:g4,:f4]
d1.concat [m,c,c,c,c,b,m,b*2,c,c,c,c,c,c,c,c,m,m,b,b,md,c,m,c,cd,q,q,q,c,q,q]
#b35
n1.concat [:e4,:e4,:r,:e5,:d5,:c5,:b4,:a4,:g4,:f4,:e4,:e4,:r,:g5,:f5,:e5,:d5,:c5,:b4,:a4,:ab4,:ab4,:r,:e5,:c5,:a4,:e5,:d5,:c5,:a4,:e5,:c5,:a4,:e5,:d5,:c5]
d1.concat [c,c,c,cd,q,q,q,c,q,q,c,c,c,cd,q,q,q,c,q,q,m,m,c,c,c,c,q,q,c,c,c,c,c,q,q,c]
#b43
n1.concat [:a4,:e5,:c5,:b4,:c5,:b4,:c5,:r,:g5,:a5,:a5,:g5,:c5,:r,:a5,:g5,:e5,:d5,:g5,:r,:f5,:f5,:f5,:e5,:e5,:d5,:d5,:d5,:d5,:e5,:f5,:e5,:f5,:g5,:a5,:a5,:g5,:g5,:f5,:e5,:g5,:g5]
d1.concat [c,m,c,c,m,c,m,c,c,c,c,m,b,c,c,c,c,m,m,c,c,c,c,c,c,m,c,c,c,c,q,q,q,q,c,c,m,c,m,c,m,b*2]
#b58
n1.concat [:r,:g5,:g5,:f5,:f5,:e5,:d5,:c5,:e5,:f5,:g5,:d5,:r,:d5,:e5,:f5,:g5,:c5,:r,:g5,:f5,:e5,:e5,:a5,:a5,:g5,:f5,:d5,:e5,:d5,:c5,:b4,:a4]
d1.concat [2*b+m,m,m,m,b,bd,b,m,m,m,m,m,bd,m,m,m,m,m,2*b+m,c,q,q,m,c,q,q,c,c,cd,q,c,c,m]
#b78
n1.concat [:b4,:e5,:e5,:d5,:c5,:e5,:f5,:g5,:a5,:g5,:g5,:g5,:e5,:f5,:g5,:a5,:g5,:g5,:g5]
d1.concat [b,c,q,q,c,c,cd,q,c,c,m,c,c,cd*1.1,q*1.1,c*1.2,c*1.2,b*1.3,b*ps]
#end

n2=[:r,:c5,:g5,:e5,:r,:c5,:g5,:e5,:r,:c5,:g5,:e5,:g5,:e5,:d5,:c5,:d5,:e5,:f5,:f5,:e5,:e5,:d5,:c5,:r,:d5]
d2=[bd,m,m,m,b,m,m,b,c,c,m,m,c,c,q,q,q,q,c,c,c,c,m,m,c,c]
#b12
n2.concat [:e5,:e5,:d5,:c5,:r,:d5,:e5,:e5,:d5,:c5,:g5,:g5,:f5,:e5,:g5,:g5,:e5,:e5,:f5,:g5,:e5,:e5,:r,:g5,:g5,:a5,:b5,:g5,:g5,:e5,:e5,:f5,:g5,:e5,:e5]
d2.concat [c,c,m,m,c,c,c,c,m,m,c,q,q,c,c,m,c,q,q,c,c,m,m,c,q,q,c,c,m,c,q,q,c,c,m]
#b22
n2.concat [:r,:g5,:f5,:e5,:d5,:c5,:b4,:a4,:b4,:b4,:r,:c5,:c5,:d5,:e5,:f5,:g5,:f5,:e5,:d5,:c5,:c5,:b4,:b4,:r,:c5,:e5,:e5,:d5,:c5,:b4,:a4,:g4,:f4,:e4,:e4,:r,:e5]
d2.concat [c,c,c,c,q,q+m,q,q,m,m,b,b,c,c,c,c,c,c,c,c,m,m,b,b,c,c,c,cd,q,q,q,c,q,q,c,c,c,cd] # q over
#b35 +extra q
n2.concat [:d5,:c5,:b4,:a4,:g4,:f4,:e4,:e4,:r,:g5,:f5,:e5,:d5,:c5,:b4,:a4,:g4,:g4,:r,:e5,:c5,:a4,:e5,:d5,:c5,:a4,:e5,:c5,:a4,:e5,:d5,:c5,:a4,:e5]
d2.concat [q,q,q,c,q,q,c,c,c,cd,q,q,q,c,q,q,m,m,md,c,c,c,q,q,c,c,c,c,c,q,q,c,c,m] #c over
#b43 +extra c
n2.concat [:c5,:e5,:f5,:g5,:f5,:e5,:d5,:e5,:r,:g5,:a5,:a5,:g5,:c5,:r,:c6,:a5,:f5,:e5,:f5,:c5,:c5,:d5,:b4,:c5,:a4,:b4,:g5,:g5,:g5,:a5,:g5,:f5,:e5,:f5,:f5,:e5,:c5,:d5,:c5,:b5,:c5,:r]
d2.concat [c,cd,q,c,q,q,m,b,md,c,c,c,m,m,c,c,c,c,m,c,c,c,c,c,c,m,c,c,c,c,q,q,q,q,c,c,m,c,m,c,m,b,b]
#b58
n2.concat [:r,:d5,:c5,:c5,:b4,:a4,:g4,:r,:e5,:f5,:g5,:a5,:g5,:a5,:a5,:g5,:f5,:d5,:e5,:d5,:c5,:b4,:a4,:b4,:c5,:c5,:b4,:a4,:d5,:c5,:d5,:e5,:d5,:d5]
d2.concat [4*b,b,m,b,b,bd,b,m,m,m,m,b,b,c,q,q,c,c,cd,q,c,c,m,m,c,q,q,m,m,cd,q,c,c,m]
#b78
n2.concat [:d5,:g5,:g5,:f5,:e5,:r,:g5,:a5,:g5,:f5,:e5,:d5,:e5,:g5,:a5,:g5,:f5,:e5,:d5,:e5]
d2.concat [m,c,q,q,m,c,c,cd,q,c,c,m,c,c,cd*1.1,q*1.1,c*1.2,c*1.2,b*1.3,b*ps]
#end

n3=[:r,:c5,:a4,:g4,:g4,:c5,:c5,:b4,:a4,:b4,:c5,:d5,:r,:g4,:c5,:a4,:r,:g4,:c5,:c5,:b4,:b4,:a4,:g4,:a4,:b4,:c5,:r,:d5,:e5,:e5,:d5]
d3=[b,m,m,c,c,c,c,q,q,q,q,m,m,m,m,m,m,m,m,m,c,c,q,q,q,q,m,c,c,c,c,m]
#b12
n3.concat [:c5,:r,:d5,:e5,:e5,:d5,:c5,:r,:e5,:e5,:d5,:c5,:c5,:c5,:e5,:e5,:d5,:c5,:c5,:c5,:r,:e5,:d5,:c5,:b4,:c5,:g4,:g4,:f4,:e4,:g4]
d3.concat [m,c,c,c,c,m,m,m,c,q,q,c,c,m,c,q,q,c,c,m,c,c,c,c,bd,m,c,q,q,c,c]
#b22
n3.concat [:g4,:r,:g4,:a4,:g4,:f4,:g4,:a4,:b4,:c5,:d5,:e5,:r,:e4,:e4,:e4,:r,:e4,:e4,:r,:a4,:c5,:c5,:b4,:a4,:g4,:f4,:e4,:d4]
d3.concat [m,2*b,m,c,c,c,c,c,c,c,c,2*b,m,m,b,b,c,c,m,c,c,c,cd,q,q,q,c,q,q]
#b35
n3.concat [:c4,:c4,:r,:c5,:b4,:a4,:g4,:f4,:e4,:d4,:c4,:d4,:e4,:e4,:r,:e5,:c5,:a4,:e5,:d5,:c5,:a4,:e5,:c5,:a4,:e5,:d5,:c5,:a4]
d3.concat [c,c,c,cd,q,q,q,c,q,q,cd,q,m,b,b,c,c,c,q,q,c,c,c,c,c,q,q,c,c]
#b43
n3.concat [:e5,:c5,:g4,:c4,:r,:c5,:a4,:f4,:e4,:f4,:g4,:a4,:b4,:c5,:r,:a4,:a4,:a4,:g4,:g4,:fs4,:g4,:d5,:d5,:c5,:c5,:b4,:a4,:b4,:c5,:c5,:g4,:a4,:b4,:c5,:d5,:e5,:r,:g4]
d3.concat [m,m,b,b,m,m,c,c,m,q,q,q,q,m,b,m,c,c,c,c,m,c,c,c,c,q,q,q,q,md,c,c,c,c,c,m,m,m,b]
#b58
n3.concat [:f4,:f4,:e4,:e4,:d4,:r,:g4,:d5,:e5,:c5,:b4,:b4,:d5,:c5,:b4,:a4,:b4,:c5,:c5,:c5,:c5,:c5,:d5,:b4,:c5,:d5,:e5,:d5,:d5,:b4,:a4,:a4,:b4,:c5,:r,:b4,:g4,:g4,:g4,:g4,:fs4]
d3.concat [m,b,b,m,b*2,bd,m,m,m,b,m,m,m,c,c,m,m,b,b,c,q,q,c,c,cd,q,c,c,m,m,c,q,q,m,c,c,cd,q,c,c,m]
#b78
n3.concat [:g4,:c5,:c5,:d5,:e5,:c5,:c5,:c5,:a4,:c5,:b4,:c5,:c5,:c5,:c5,:a4,:c5,:b4,:a4,:b4,:c5]
d3.concat [b,c,q,q,c,c,cd,q,c,c,m,c,c,cd*1.1,q*1.1,c*1.2,c*1.2+c*1.3,q*1.3,q*1.3,m*1.3,b*ps]
#end

n4=[:r,:c4,:c4,:d4,:e4,:f4,:g4,:g4,:d4,:e4,:f4,:g4,:a4,:c5,:c5,:b4,:c5,:c4,:r,:c4,:c4,:d4,:e4,:f4,:g4,:g4,:d4,:e4,:f4,:g4,:a4,:r,:c5,:c5,:b4]
d4=[2*b+c,c,q,q,q,q,c,c,q,q,q,q,c,c,c,c,b,b,c,c,q,q,q,q,c,c,q,q,q,q,m,md,c,c,c]
#b12
n4.concat [:c5,:g4,:r,:c5,:b4,:c5,:g4,:r,:c4,:c4,:d4,:e4,:c4,:c4,:c4,:c4,:d4,:e4,:c4,:g4,:r,:c4,:d4,:e4,:d4,:e4,:c4,:c4,:d4,:e4,:c4]
d4.concat [m,m,c,m,c,m,m,m,c,q,q,c,c,m,c,q,q,c,c,m,c,c,c,c,b,m,c,q,q,c,c]
#b22
n4.concat [:c4,:r,:f4,:e4,:f4,:g4,:f4,:e4,:f4,:g4,:e4,:b3,:b3,:r,:e4,:e4,:r,:c5,:b4,:a4,:g4,:f4,:e4,:d4,:c4,:c4,:r,:c5]
d4.concat [m,3*b+m,b,c,c,c,c,c,c,m,b,b,m,c,c,m,c,cd,q,q,q,c,q,q,c,c,c,cd]# q over
#b35 +extra q
n4.concat [:b4,:a4,:g4,:f4,:e4,:d4,:c4,:c4,:r,:g4,:g4,:r,:b4,:a4,:g4,:f4,:e4,:d4,:c4,:b3,:b3,:r]
d4.concat [q,q,q,c,q,q,c,c,c,c,m,c,cd,q,q,q,c,q,q,m,m,3*b]
#b43
n4.concat [:r,:g4,:e4,:g4,:c4,:c4,:r,:c5,:a4,:f4,:e4,:f4,:g4,:a4,:b4,:c5,:r,:g4,:g4,:bb4,:a4,:f4,:c4,:d4,:e4,:f4,:g4,:c4,:e4,:e4,:d4]
d4.concat [2*b+c,c,c,c,b,m,c,c,c,c,m,q,q,q,q,m,2*b+c,c,c,c,m,m,c,c,c,c,b,m,m,m,m]
#b58
n4.concat [:d4,:c4,:b3,:a3,:a4,:b3,:c4,:g4,:r,:g4,:a4,:g4,:f4,:e4,:d4,:e4,:f4,:r,:g4,:g4,:g4,:g4,:g4,:fs4,:g4,:r,:f4,:f4,:e4,:d4,:g4,:c4,:b3,:c4,:g3,:d4]
d4.concat [b,bd,b,m,m,m,b,b,b*2+m,b,b,b,md,q,q,m,m,c,c,cd,q,c,c,m,m,m,c,q,q,c,c,cd,q,c,c,m]
#b78
n4.concat [:d4,:e4,:e4,:f4,:g4,:c4,:c4,:c4,:c4,:c4,:d4,:c4,:e4,:c4,:c4,:c4,:c4,:d4,:g4]
d4.concat [m,c,q,q,m,m,cd,q,c,c,m,c,c,cd*1.1,q*1.1,c*1.2,c*1.2,b*1.3,b*ps]
#end

n5=[:r]
d5=[b*11]
#b12
n5.concat [:r,:c4,:c4,:d4,:e4,:c4,:c4,:c4,:c4,:d4,:e4,:c4,:c4,:c4,:b4,:a4,:g4,:g4,:c4,:c4,:d44,:e4,:c4,:c4]
d5.concat [3*b,c,q,q,c,c,m,c,q,q,c,c,m,m,c,c,b,m,c,q,q,c,c,m]
#b22
n5.concat [:r,:c4,:d4,:e4,:f4,:g4,:g3,:f4,:e4,:d4,:e4,:f4,:g4,:a4,:b4,:c5,:c4,:e4,:e4,:r,:a4,:a4,:r]
d5.concat [c,c,c,c,m,m,b,c,c,c,c,c,c,c,c,b*2,b,b,b,c,c,m,2*b]
#b35
n5.concat [:r,:c4,:c4,:r,:e4,:d4,:c4,:b3,:a3,:g4,:f4,:e4,:e4,:r]
d5.concat [md,c,m,c,cd,q,q,q,c,q,q,b,b,3*b]
#b43
n5.concat [:r,:c4,:a3,:f4,:e4,:f4,:g3,:a3,:b3,:c4,:r,:c4,:d4,:d4,:c4,:f4,:f4,:f4,:d4,:e4,:c4,:d4,:g3,:r,:c4,:c4,:bb3]
d5.concat [2*b+m,m,c,c,m,q,q,q,q,m,m,m,c,c,m,c,c,c,c,c,c,m,m,4*b,m,m,m]
#b58
n5.concat [:bb3,:a3,:g3,:d4,:f4,:g3,:a3,:g3,:r,:g3,:b3,:c4,:d4,:c4,:f4,:f4,:e4,:d4,:g4,:c4,:b3,:c4,:g3,:d4,:g3,:a3,:a3,:g3,:a3,:r]
d5.concat [b,bd,b,m,m,m,b,b,b*2+m,m,m,m,b,b*2,c,q,q,c,c,cd,q,c,c,m,m,c,q,q,m,b*2]
#b78
n5.concat [:g4,:g4,:f4,:e4,:c4,:c4,:b3,:a3,:c4,:f4,:e4,:f4,:c4,:g4,:c4,:c4,:f4,:e4,:f4,:c4,:g3,:c4]
d5.concat [c,q,q,m,c,q,q,c,c,cd,q,c,c,m,c,c,cd*1.1,q*1.1,c*1.2,c*1.2,b*1.3,b*ps]
#end

#parts dynamic data
a1=[mf,p,f,mp,f,mf,p,mf,f,p,f,] #levels
as1=[0,bd,0,bd,3*b,0,2*b,0,b,b,8*b]#slide times
ad1=[4*b+m,8*b+m,4*b,9*b,5*b,6*b,7*b+m,6*b+m,4*b,10*b,19*b] #sleep durations at level
a2=[mf,p,f,mp,f,mf,p,mf,f,p,f]
as2=[0,bd,0,b,3*b,0,bd,0,b,2*b,6*b]
ad2=[4*b+m,10*b,2*b+m,9*b,5*b,6*b,8*b+3*c,5*b+c,4*b,10*b,19*b]
a3=[mf,p,f,mp,f,mf,p,mf,f,p,f]
as3=[0,2*b,0,b,4*b,0,2*b,0,b,b,6*b]
ad3=[4*b+m,9*b+m,3*b,8*b,6*b,6*b,8*b,6*b,4*b,10*b,19*b]
a4=[mf,p,f,mp,f,mf,mp,mf,f,p,f]
as4=[0,2*b+m,0,md,3*b,0,2*b,0,b,m,4*b+m]
ad4=[4*b+m,10*b,2*b+m,9*b,4*b+m,6*b+m,7*b,7*b,4*b,11*b+m,17*b+m]
a5=[f,mp,f,mf,mp,mf,p,f]
as5=[0,b,4*b,0,2*b,0,0,4*b]
ad5=[17*b,8*b,6*b,6*b,2*b,16*b,12*b,17*b]

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
      plarray(inst0,samplepitch0,n1,d1,-2,0.9,-0.7) #trumpet I
    end
  end
  in_thread do
    with_fx :level do |amp2|
      in_thread do
        plct(amp2,a2,as2,ad2)
      end
      plarray(inst0,samplepitch0,n2,d2,-2,0.9,0.7) #trumpet II
    end
  end
  in_thread do
    with_fx :level do |amp3|
      in_thread do
        plct(amp3,a3,as3,ad3)
      end
      plarray(inst0,samplepitch0,n3,d3,-2,0.9,-0.4) #trumpet III
    end
  end
  in_thread do
    with_fx :level do |amp4|
      in_thread do
        plct(amp4,a4,as4,ad4)
      end
      plarray(inst0,samplepitch0,n4,d4,-2,0.9,0.4) #trumpet IV
    end
  end
  with_fx :level do |amp5|
    in_thread do
      plct(amp5,a5,as5,ad5)
    end
    plarray(inst0,samplepitch0,n5,d5,-2,0.9,0) #trumpet V
  end
end
comment do #checks for debugging data input (uncomment)
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

set_bpm(160) #set tempo

with_fx :reverb,room: 0.8,mix: 0.6 do #add some reverb
  perform(0)
end

comment do #checks for dynamic levels
  pp=0.02
  p=0.08
  mp=0.2
  mf=0.6
  f=1.0
  ff=1.6
  [pp,p,mp,mf,f,ff].each do |l|
    with_fx :reverb,room: 0.8,mix: 0.6 do #add some reverb
      with_fx :level,amp: l do
        plarray(inst0,samplepitch0,[:c5],[b*2],-2,0.8,-0.7)
        sleep 1.2
      end
    end
  end
end