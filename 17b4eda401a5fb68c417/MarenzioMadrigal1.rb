# Luca Marenzio Madrigal 1553-1599 "Togli dolce ben mio" arranged for 5 trumpets coded for by Robin Newman, April 2015
#uses sample based voice, and also has variable dynamic settings for each part and final rit.
#requires version >=2.9 
#Sample requires can be downloaded from http://r.newman.ch/rpi/Marenzio.zip
#This version altered for syntax changes. Wrosk with later versions of SP
use_debug false
path= '~/Desktop/samples/Marenzio/' #path to sample folder

#first deal with selecting and setting up the sample
inst0 = 0  #first (in fact only) sample in folder
samplepitch0=:cs5
#preload the sample
load_sample path,0

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
# p mp mf f ff
pp=0.02
p=0.08
mp=0.2
mf=0.6
f=1.0
ff=1.6

#set up the part lists
n1=[:e5,:fs5,:g5,:g5,:a5,:b5,:b5,:a5,:a5,:g5,:fs5,:fs5,:ds5,:e5,:fs5,:e5,:ds5,:e5,:ds5,:e5,:r,:g5,:a5,:b5,:a5,:g5,:fs5,:g5,:g5]
d1=[b,c,cd,q,c,m,m,c,q,q,m,c,m,c,md,c,c,m,c,b,m,m,c,cd,q,c,m,c,c]
#b12
n1.concat [:fs5,:e5,:fs5,:e5,:ds5,:e5,:fs5,:fs5,:fs5,:fs5,:r,:fs5,:g5,:fs5,:e5,:d5,:e5,:e5,:fs5,:e5,:d5,:cs5,:cs5,:fs5,:e5,:d5,:cs5]
d1.concat [cd,q,c,c,cd,q,c,c,b,b,b*5+m,m,md,c,c,c,b,m,c,q,q,c,c,c,q,q,m]
#b27
n1.concat [:b4,:r,:e5,:e5,:a4,:d5,:b4,:d5,:d5,:g5,:fs5,:e5,:d5,:d5,:g5,:fs5,:e5,:ds5,:e5,:r,:b4,:d5,:e5,:fs5,:e5,:fs5]
d1.concat [b,3*b+m,m,m,c,m,c,b,m,c,q,q,c,c,c,q,q,m,m,c,c,c,c,b,m,b]
#b41
n1.concat [:fs5,:b5,:a5,:g5,:fs5,:fs5,:b5,:a5,:g5,:fs5,:fs5,:b5,:a5,:g5,:fs5,:e5,:d5,:e5,:fs5,:fs5,:b5,:b5,:a5,:g5,:fs5,:e5,:d5,:b4,:e5,:ds5,:cs5,:ds5,:e5]
d1.concat [m,c,q,q,c,c,c,q,q,c,c,md,c,c,q,q,m,m,m,c,c,c,c,c,q,q,c,c,m+c*1.2,   q*1.2,q*1.2,m*1.2,  b*1.6]
#end

n2=[:e5,:ds5,:e5,:e5,:fs5,:g5,:g5,:fs5,:fs5,:e5,:cs5,:ds5,:fs5,:g5,:a5,:g5,:fs5,:e5,:fs5,:gs5,:r,:g5,:a5,:b5,:a5,:g5,:fs5,:g5,:r,:b5]
d2=[b,c,cd,q,c,m,m,c,q,q,m,c,m,c,md,c,c,c,m,m,c,c,c,cd,q,c,m,m,md,c]
#b12
n2.concat [:a5,:a5,:a5,:g5,:fs5,:g5,:a5,:b5,:as5,:gs5,:as5,:b5,:r,:fs5,:g5,:fs5,:e5,:d5,:e5,:e5,:r,:ds5,:e5,:d5,:cs5,:b4,:cs5,:cs5,:d5,:cs5,:b4,:as4,:as4,:d5,:cs5,:b4,:as4]
d2.concat [cd,q,c,c,cd,q,c,m,q,q,m,m,c,c,md,c,c,c,b,m,2*b+m,m,md,c,c,c,b,m,c,q,q,c,c,c,q,q,m]
#b27
n2.concat [:b4,:r,:fs5,:b5,:a5,:g5,:fs5,:e5,:d5,:b4,:e5,:ds5,:cs5,:ds5,:e5,:r]
d2.concat [m,c,c,c,c,c,q,q,c,c,md,q,q,m,b,9*b]
#b41
n2.concat [:r,:b5,:a5,:g5,:fs5,:fs5,:b5,:a5,:g5,:fs5,:fs5,:g5,:a5,:b5,:a5,:g5,:fs5,:e5,:d5,:d5,:fs5,:g5,:a5,:b5,:a5,:g5,:fs5,:e5,:fs5,:gs5]
d2.concat [b,c,q,q,c,c,c,q,q,c,c,c,c,c,q,q,m,m,m,c,c,c,c,c,q,q,m,m,  b*1.2  ,b*1.6]
#end

n3=[:b4,:b4,:b4,:b4,:d5,:d5,:d5,:d5,:d5,:b4,:as4,:b4,:b4,:e5,:d5,:e5,:b4,:b4,:r,:b4,:d5,:b4,:d5,:d5,:d5,:d5,:d5]
d3=[b,c,cd,q,c,m,m,c,q,q,m,c,m,c,md,c,b,m,c,c,m,m,m,m,m,c,c]
#b12
n3.concat [:d5,:e5,:d5,:b4,:b4,:b4,:fs4,:d5,:cs5,:ds5,:r,:d5,:e5,:d5,:cs5,:b4,:cs5,:cs5,:fs5,:e5,:d5,:cs5,:cs5,:fs5,:e5,:d5,:cs5,:b4,:r]
d3.concat [cd,q,c,c,cd,q,c,c,b,m,c,c,md,c,c,c,b,m,c,q,q,c,c,c,q,q,m,m,5*b+m]
#b27
n3.concat [:r,:d5,:d5,:cs5,:b4,:a4,:b4,:e4,:e4,:a3,:b3,:d4,:e4,:d4,:d4,:r,:b4,:g4,:a4,:b4,:e4,:r,:e5,:fs5,:e5,:d5,:cs5,:b4,:a4,:fs4,:b4,:as4,:gs4,:as4]
d3.concat [m,m,md,c,m,m,b,m,m,md,c,c,c,b,m,md,cd,q,c,m,m,c,c,c,c,c,q,q,c,c,md,q,q,m]
#b41
n3.concat [:b4,:fs5,:fs5,:e5,:d5,:d5,:r,:b4,:d5,:cs5,:b4,:g4,:b4,:b4,:d5,:d5,:cs5,:b4,:b4,:b4,:b4]
d3.concat [m,c,q,q,b,m,c,c,c,c,b,m,m,c,c,c,c,b,m,  b*1.2,  b*1.6]
#end

n4=[:e4,:b3,:e4,:e4,:d4,:g4,:g4,:d4,:d4,:e4,:fs4,:b3,:b3,:e4,:d4,:e4,:b3,:e4,:r,:e4,:fs4,:d5,:cs5,:b4,:a4,:g4]
d4=[b,c,cd,q,c,m,m,c,q,q,m,c,m,c,md,c,b,b,m,m,c,cd,q,c,m,m]
#b12
n4.concat [:r,:b4,:e4,:fs4,:a4,:b4,:a4,:a4,:r,:fs4,:d4,:e4,:fs4,:b3,:b4,:e4,:fs4,:a4,:b4,:a4,:a4,:r]
d4.concat [b*3+m,m,md,c,c,c,b,m,m+c,cd,q,c,m,m,m,md,c,c,c,b,m,2*b]
#b27
n4.concat [:r,:fs4,:g4,:a4,:b4,:a4,:g4,:fs4,:e4,:fs4,:gs4,:r,:gs4,:a4,:g4,:fs4,:e4,:fs4,:fs4,:b5,:a5,:g5,:fs5,:fs5,:b5,:a5,:g5,:fs5,:e5,:r,:g5,:a5,:g5,:fs5,:e5,:d5,:cs5,:b4,:cs5]
d4.concat [m,m,c,c,c,q,q,m,m,b,m,c,c,md,c,c,c,b,m,c,q,q,c,c,c,q,q,m,m,c,c,c,c,c,q,q,m,m,b]
#b41
n4.concat [:ds5,:r,:fs4,:fs4,:e4,:d4,:d4,:d5,:d5,:cs5,:b4,:d5,:r,:fs4,:d4,:e4,:fs4,:g4,:fs4,:gs4]
d4.concat [b,m,c,q,q,c,c,c,q,q,m,m,b+m,m,md,c,m,m,  b*1.2,  b*1.6]
#end

n5=[:r,:e4,:fs4,:g4,:fs4,:e4,:d4,:g3,:a3,:b3,:cs4,:d4,:r,:g4]
d5=[7*b+m,m,c,cd,q,c,m,q,q,q,q,m,c,c]
#b12
n5.concat [:d4,:cs4,:d4,:e4,:b3,:e4,:d4,:b3,:fs4,:b3,:r,:d5,:cs5,:b4,:as4,:as4,:d5,:cs5,:b4,:as4,:b4,:r,:fs4,:d4,:e4,:fs4]
d5.concat [cd,q,c,c,cd,q,c,c,b,b,b*3,c,q,q,c,c,c,q,q,m,b,3*b+md,cd,q,c,m]
#b27
n5.concat [:b3,:g3,:a3,:b3,:c4,:b3,:b4,:r,:b4,:c5,:b4,:a4,:g4,:a4,:a4,:r,:e4,:d4,:e4,:fs4,:g4,:fs4]
d5.concat [b,md,c,m,m,b,m,c,c,md,c,c,c,b,m,2*b+m,m,md,c,m,m,b]
#b41
n5.concat [:b3,:b3,:g3,:a3,:b3,:c4,:b3,:e4]
d5.concat [b,2*b,md,c,m,m,b*3+b*1.2,b*1.6]
#end

#parts dynamic data
a1=[f,mp,mf,f,ff] #levels
as1=[0,0,0,7*c,0]#slide times
ad1=[20*b+m,10*b,2*b,8*b,9*b+m] #sleep durations at level

a2=[f,p,mp,mf,ff]
as2=[0,3*c,0,0,0] #added 0
ad2=[14*b,6*b+m,6*b+c,14*b+c,9*b]

a3=[f,p,mf,f,ff]
as3=[0,3*c,0,7*c,0]
ad3=[14*b,12*b+m,6*b+m,7*b+m,9*b+m]

a4=[f,p,mp,mf,f,ff]
as4=[0,0,0,0,4*c,0]
ad4=[14*b+m,6*b,6*b,6*b+m,8*b+m,8*b+m]

a5=[f,p,mp,mf,f,ff]
as5=[0,4*b,0,0,3*b+m,0]
ad5=[14*b,10*b+3*c,2*b+c,6*b,8*b,9*b]


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
    plarray(inst0,samplepitch0,n5,d5,-2,0.8,0) #trumpet V
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
  perform(1)
end