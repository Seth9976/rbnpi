#Sonic Pi Galliard Battaglia by Samuel Scheidt first coded for Sonic Pi by Robin Newman, April 2015
#samples need from http://r.newman.ch/rpi/Battaglia.zip
#place unzipped folder in samples folder in Pi home directory.
#at present file is too large to run on a Mac so use run_file comamnd to play it 

#This version setup for Sonic Pi 3

use_debug false
path= '~/Desktop/samples/Battaglia/' #adjust location as necessary

#first deal with selecting and setting up the samples
inst0="trumpet_cs5.wav"
samplepitch0=:cs5
inst1="tenor_trombone_as3.wav"
samplepitch1=:as3
inst2="bass_trombone_as2.wav"
samplepitch2=:as2


#put the sample names and pitches into an array i
i=[[inst0,samplepitch0],[inst1,samplepitch1],[inst2,samplepitch2]]

#define variable that need to be used globally
s=0 #note duration scale factor

#this function plays the sample at the relevant pitch for the note desired
#the note duration is used to set up the envelope parameters
define :pl do |path,inst,samplepitch,nv,dv,vol=1,st=0,pan=0|
  shift=note(nv)-note(samplepitch)
  #start: param used with very small value to give more immediate attack for some samples
  sample path+inst,rate: (pitch_to_ratio shift),sustain: 0.8*dv,release: 0.2*dv,amp: vol,start: st, pan: pan
end

#this function plays an array of notes and associated array of durations
#also uses sample name (inst), sample normal pitch,sample start and shift (transpose) parameters
define :plarray do |path,inst,samplepitch,narray,darray,shift=0,vol=1,st=0,pan=0|
  narray.zip(darray) do |nv,dv|
    if nv != :r
      pl(path,inst,samplepitch,note(nv)+shift,dv*s,vol,st,pan)
    end
    sleep dv*s
  end
end

#set_bpm sets bpm required adjusting note duration variables accordingly
define :set_bpm do |n|
  s=1.0/8*60/n.to_f
end
#set realtive note duration variables
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
sf=1.4 #scale factor to adjust overall level for best performance
#dynamic settings (not all used)
# p mp mf f ff
p=0.06*sf
mp=0.2*sf
mf=0.5*sf
f=1.0*sf
ff=1.3*sf
levlookup=[[p,"p"],[mp,"mp"],[mf,"mf"],[f,"f"],[ff,"ff"]] #allows printing in plct function

define :ct do |ptr,lev,slid=0,timetonext=0,s,flag| #controls level
  control ptr,amp: lev,amp_slide: slid*s #times scalefactor for tempo
  if flag > 0 then #lets you print level variations
    puts "All parts Level change:"
    puts "level "+levlookup.assoc(lev)[1]
    puts "slide time "+ (slid*s).to_s
    puts " " #blank line
  end
  sleep timetonext*s #scale for tempo
end

define :plct do |pt,am,amsl,amd,s,flag=0| #performs level change for a part
  #params pt conrtol pointer,am amp level,amsl amp_slide:,amd delay to next command,s tempo scale factor,flag to print info
  am.zip(amsl,amd) do |amv,amslv,amdv|
    ct(pt,amv,amslv,amdv,s,flag)
  end
end

#set up the part lists
n1=[:c5,:f5,:c5,:c5,:bb4,:a4,:f4,:r,:c5,:d5,:e5,:f5,:c5,:f5,:c5,:c5,:a4,:bb4,:c5,:bb4,:a4,:f4,:r,:g4,:c5,:g4,:g4,:f4,:e4,:c4]
d1=[c,c,c,cd,q,q,q,2*md,q,sq,sq,q,q,q,q,q,sq,sq,q,q,q,q,2*md,c,c,c,cd,q,q,q]
#b11
n1.concat [:r,:g4,:a4,:bb4,:c5,:g4,:c5,:g4,:g4,:e4,:f4,:g4,:f4,:e4,:c4]
d1.concat [md*2,q,sq,sq,q,q,q,q,q,sq,sq,q,q,q,q]
n2=[:r]+n1
d2=[2*md]+d1
n1.concat [:r]
d1.concat [2*md]
#b17
n1b=[:c5,:d5,:e5,:f5,:c5,:f5,:c5,:r,:c5,:a4,:bb4,:c5,:a4,:c5,:a4,:r,:g4,:a4,:bb4,:c5,:g4,:c5,:g4]
d1b=[q,sq,sq,q,q,q,q,md,q,sq,sq,q,q,q,q,md,q,sq,sq,q,q,q,q]
#b22
n1b.concat [:r,:g4,:e4,:f4,:g4,:e4,:g4,:e4,:r,:c5,:d5,:e5,:f5,:c5,:a4,:f4,:r,:c5,:bb4,:g4,:f4,:r,:c5,:c5,:b4]
d1b.concat [md,q,sq,sq,q,q,q,q,md,q,sq,sq,q,q,q,q,md,c,c,c,c,m,c,c,c]
n1.concat n1b+[:c5,:r]
d1.concat d1b+[c,m]
n2.concat [:r]+n1b
d2.concat [md]+d1b
#b31
n1.concat [:c5,:d5,:e5,:f5,:f5,:d5,:c5,:bb4,:g4,:a4,:a4]
d1.concat [c,c,c,cd,q,c,c,c,c,c,m]
n2.concat [:c5,:f4,:bb4,:c5,:c5,:bb4,:a4,:d5,:c5,:c5,:c5]
d2.concat [c,c,c,cd,q,c,c,c,c,c,m]
#end of first section  parts n1 and n2


n3=[:f3,:f3,:f3,:f3,:c3,:a3,:a3,:a3,:a3,:f3,:f3,:f3,:f3,:f3,:f3,:a3,:a3,:a3,:a3,:c4,:c34,:c4,:c4,:g3,:e3,:e4,:e4,:e4,:e4,:g3,:c4,:c4,:c4]
d3=[c,c,c,m,c,c,c,c,m,c,c,c,c,m,c,c,c,c,m,c,c,c,c,m,c,c,c,c,m,c,c,c,c]
#b14
n3.concat [:c4,:c4,:e4,:e4,:e4,:e4,:g4,:f3,:f3,:c4,:c4,:f3,:f3,:a3,:a3,:e4,:e4,:e4,:e4,:g3,:g3,:c3,:c3,:f3,:f3,:a3,:a3]
d3.concat [m,c,c,c,c,m,c,m,c,m,c,m,c,m,c,m,c,m,c,m,c,m,c,m,c,m,c]
#b27
n3.concat [:f4,:f4,:e4,:f4,:f4,:e4,:c4,:f4,:d4,:e4,:f4,:d4,:e4,:d4,:g4,:a3,:a3,:bb3,:c4,:f4,:d4,:e4,:a3,:a3]
d3.concat [c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,cd,q,c,q,c,q,c,c,m]

n4=[:a3,:a3,:a3,:a3,:f3,:f3,:f3,:f3,:f3,:c3,:a3,:a3,:a3,:a3,:c4,:f3,:f3,:f3,:f3,:f3,:e3,:e3,:e3,:e3,:c4,:c4,:c4,:c4,:g3,:e3]
d4=[c,c,c,m,c,c,c,c,m,c,c,c,c,m,c,c,c,c,m,c,c,c,c,m,c,c,c,c,m,c]
#b13
n4.concat [:e4,:e4,:e4,:e4,:g4,:c4,:c4,:c4,:c4,:c4,:c4,:c4,:f4,:f4,:a3,:a3,:f3,:f3,:c3,:c3,:c3,:c3,:c3,:c3,:g3,:g3,:a3,:a3,:f3,:f3]
d4.concat [c,c,c,m,c,c,c,c,m,c,m,c,m,c,m,c,m,c,m,c,m,c,m,c,m,c,m,c,m,c]
#b27
n4.concat [:a3,:d4,:c4,:a3,:d4,:c4,:a3,:r,:c4,:a3,:g3,:g3,:bb3,:g3,:f3,:f3,:g3,:a3,:bb3,:c4,:f3,:f3]
d4.concat [c,c,c,c,c,c,c,m,c,c,c,c,c,c,cd,q,c,c,c,c,c,m]
#================================================
n1b=[:g4,:g4,:g4,:g4,:g4,:g4,:r,:g4,:a4,:b4,:c5,:r,:c5,:c5,:c5,:c5,:c5,:c5,:r,:c5,:d5,:e5,:f5,:r,:a4,:g4,:a4,:bb4,:a4,:a4,:a4,:a4,:c5,:r,:c5,:bb4,:c5,:d5,:c5,:c5,:c5,:c5]
d1b=[c,q,q,q,q,c,m,c,c,c,c,m,c,q,q,q,q,c,m,c,c,c,c,m,sq,sq,sq,sq,q,q,q,q,c,m,sq,sq,sq,sq,q,q,q,q]
#b46
n1b.concat [:a4,:r,:a4,:g4,:a4,:bb4,:a4,:a4,:a4,:a4,:f4,:r,:f4,:e4,:f4,:g4,:f4,:f4,:f4,:f4,:c4,:r,:c5,:bb4,:a4,:g4,:a4,:f4,:c5,:f4,:r]
d1b.concat [c,m,sq,sq,sq,sq,q,q,q,q,c,m,sq,sq,sq,sq,q,q,q,q,c,m,sq,sq,sq,sq,q,q,q,q,md]
#b53
n1b.concat [:g4,:f4,:e4,:d4,:e4,:c4,:g4,:c4,:r,:f5,:e5,:d5,:c5,:d5,:bb4,:f5,:bb4,:r,:d5,:c5,:bb4,:a4,:bb4,:g4,:d5,:g4,:r,:g4,:f4,:e4,:d4,:c4,:d4,:e4,:f4,:g4,:f4,:e4,:d4]
d1b.concat [sq,sq,sq,sq,q,q,q,q,md]*3+[sq,sq,sq,sq]*3
#change next 4 to concat to join
n2.concat [:r]+n1b
d2.concat [md]+d1b
n1.concat n1b+[:c4,:r]
d1.concat d1b+[c,m]
#b61 both n1 and n2 parts
n1.concat [:c5,:c5,:b4,:c5,:e5,:f5,:e5,:d5,:d5,:e5,:r]
d1.concat [c,c,c,cd,q,c,c,c,c,md*1.4,q]
n2.concat [:c4,:a4,:g4,:g4,:c5,:a4,:c5,:c5,:b4,:c5,:r]
d2.concat [c,c,c,cd,q,c,c,c,c,md*1.4,q]
#end of end section both n1 and n2

n3.concat [:r,:e4,:e4,:e4,:f4,:d4,:e4,:f4,:d4,:e4,:r,:a3,:a3,:a3,:bb3,:g4,:a3,:bb3,:g4,:c4,:r,:c4,:c4,:c4,:c4,:c4,:c4,:c4,:c4,:a4,:r]
d3.concat [md,m,c,c,c,c,c,c,c,c,m,m,c,c,c,c,c,c,c,c,m,sq,sq,sq,sq,q,q,q,q,c,m]
#b46
n3.concat [:c4,:c4,:c4,:c4,:c4,:c4,:c4,:c4,:c4,:r]*2+[:a3,:a3,:a3,:a3,:a3,:a3,:a3,:a3,:a3,:c4,:a3,:a3,:c4,:a3,:r,:g3,:e3,:r,:d4,:f4,:d4,:bb3,:d4,:bb3,:bb3,:d4,:bb3,:c4,:c4,:c4,:c4,:c4,:c4]
d3.concat [sq,sq,sq,sq,q,q,q,q,c,m]*2+[sq,sq,sq,sq,q,q,q,q,c,c,c,c,c,c,md,m,c,md,c,c,c,c,c,c,c,c,c,q,q,q,q,q,q]
#b60
n3.concat [:e4,:g4,:e4,:g4,:e4,:g4,:e4,:f4,:d4,:e4,:g4,:f4,:g4,:f4,:d4,:e4,:r]
d3.concat [q,q,q,q,q,q,c,c,c,cd,q,c,c,c,c,md*1.4,q]
#end second section
#b36
n4.concat [:c4,:c4,:c4,:c4,:c4,:r,:c4,:c4,:g3,:c4,:r,:f3,:f3,:f3,:r,:f3,:f3,:c4,:f3,:r,:f3,:f3,:f3,:f3,:f3,:f3,:f3,:f3,:f3,:r]
d4.concat [m,c,m,c,c,m,c,c,c,c,m,m,c,c,m,c,c,c,c,m,sq,sq,sq,sq,q,q,q,q,c,m]
#b46
n4.concat [:f3,:f3,:f3,:f3,:a3,:a3,:a3,:a3,:f3,:r]*3+[:f3,:f3,:c3,:c3,:e3,:c3,:bb2,:bb2,:bb3,:bb3,:g3,:g3,:g2,:g2,:r,:c3,:c3,:c3,:c3,:c3,:c3,:c3,:f3,:g3,:c3,:c3,:d3,:e3,:f3,:g3,:c3,:r]
d4.concat [sq,sq,sq,sq,q,q,q,q,c,m]*3+[m,c,m,c,m,c,m,c,m,c,m,c,m,c,md,q,q,q,q,q,q,c,c,c,cd,q,c,c,c,c,md*1.4,q]
#end of section 2=================================================
n1.concat [:c5,:d5,:e5,:f5,:c5,:f5,:c5,:c5,:bb4,:a4,:c5,:d5,:e5,:f5,:r,:c5,:d5,:e5,:f5,:f5,:f5,:f5,:g5,:f5,:d5,:e5,:e5,:f5,:g5,:f5,:d5,:d5,:f5,:f5,:e5,:f5,:f5,:g5,:f5,:d5,:e5,:c5,:d5,:bb4]
d1.concat [q,sq,sq,q,q,q,q,cd,q,c,c,c,c,c,m,q,sq,sq,q,q,q,q,c,c,c,m,c,c,c,c,m,c,c,c,c,m,c,c,c,c,m,c,c,m]
#b79
n1.concat [:a4,:bb4,:c5,:bb4,:a4,:g4,:c5,:bb4,:c5,:d5,:c5,:bb4,:a4,:g4,:a4,:bb4,:c5,:bb4,:a4,:g4,:c5,:bb4,:a4,:g4,:a4,:c5,:c5,:b4,:c5,:c5,:d5,:f5,:e5,:f5]
d1.concat [q,q,q,sq,sq,q,q,q,q,q,sq,sq,q,q,q,q,q,sq,sq,q,q,q,sq,sq,q,q,q,q,m*1.1,c*1.2,c*1.3,c*1.4,c*1.5,md*2]
#end
n2.concat [:a4,:a4,:a4,:a4,:a4,:a4,:c5,:a4,:bb4,:g4,:c5,:d5,:e5,:f5,:c5,:f5,:c5,:c5,:bb4,:a4,:g4,:a4,:b4,:c5,:c5,:bb4,:bb4,:a4,:bb4,:bb4,:c5,:d5,:c5,:c5,:c5,:c5,:c5,:b4,:c5,:f5,:f4,:e4]
d2.concat [c,q,q,q,q,m,c,c,c,c,q,sq,sq,q,q,q,q,cd,q,c,c,c,c,m,c,c,c,c,m,c,c,c,c,m,c,c,c,c,m,c,m,c]
#b79
n2.concat [:f4,:e4,:d4,:c4,:d4,:e4,:g4,:g4,:f4,:e4,:d4,:e4,:f4,:g4,:f4,:e4,:g4,:f4,:c4,:a4,:g4,:d5,:g4,:c5,:c5,:g4,:a4]
d2.concat [q,sq,sq,q,q,q,q,q,sq,sq,q,q,q,q,m,q,q,c,q,q,q,q,m*1.1,c*1.2,c*1.3,c*1.4+c*1.5,md*2]
#end
n3.concat [:c4,:c4,:c4,:c4,:c4,:c4,:f4,:f4,:f4,:c4,:a3,:a3,:a3,:a3,:a3,:a3,:bb3,:c4,:c4,:a3,:d4,:c4,:c4,:f4,:e4,:c4,:f4,:f4,:f4,:d4,:g4,:a4,:a4,:g4,:c4,:d4,:g4,:c4,:bb3,:bb3]
d3.concat [c,q,q,q,q,m,c,c,c,c,c,q,q,q,q,cd,q,c,c,c,c,m,c,c,c,c,m,c,c,c,c,m,c,c,c,c,m,c,m,c]
#b79
n3.concat [:c4,:f4,:e4,:d4,:c4,:bb3,:f3,:c4,:c4,:c4,:e4,:f4,:f4,:c4,:d4,:e4,:f4,:f4,:c4,:c4]
d3.concat [c,c,c,q,q,c,c,c,c,q,q,cd,q,q,q,m*1.1,c*1.2,c*1.3,c*1.4+c*1.5,md*2]
#end
n4.concat [:f3,:f3,:f3,:f3,:f3,:f3,:f3,:f3,:bb3,:c4,:f3,:f3,:f3,:f3,:f3,:f3,:f3,:e3,:f3,:g3,:c3,:g3,:d3,:e3,:f3,:bb2,:bb2,:a2,:bb2,:c3,:f3,:f3,:e3,:f3,:g3,:c3,:bb2,:a2,:bb2,:g3]
d4.concat [c,q,q,q,q,m,c,c,c,c,c,q,q,q,q,m,c,c,c,c,m,c,c,c,c,m,c,c,c,c,m,c,c,c,c,cd,q,c,c,m]
#b79
n4.concat [:f3,:g3,:a3,:bb3,:c4,:c3,:g3,:a3,:bb3,:c4,:d4,:e4,:f4,:r,:a3,:bb3,:c4,:c3,:d3,:e3,:f3,:e3,:d3,:c3,:bb2,:a2,:bb2,:c3,:f3]
d4.concat [q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,c,q,q,cd*1.1,q*1.1,c*1.2,c*1.3,c*1.4+c*1.5,md*2]

a=[f,mf,f,mf,f,ff]
as=[0,7*md,0,3*md,0,3*md]
ad=[26*md,8*md,25*md,4*md+md*1.4,q+17*md,4*md]

define :len do |d|
  tl=0
  d.each do |d|
    tl += d
  end
  return tl
end
comment do #uncomment to help debugging
  #parts lenght and duration same number of entries
  puts n1.length
  puts d1.length
  puts n2.length
  puts d2.length
  puts n3.length
  puts d3.length
  puts n4.length
  puts d4.length
  #part durations should be the same
  puts len(d1)
  puts len(d2)
  puts len(d3)
  puts len(d4)
end
set_bpm(165) #set tempo: adjusts global variable s


with_fx :reverb,room: 0.6,mix: 0.4 do #add some reverb
  with_fx :level do |amp| #amp controlled by settings in plct function
    in_thread do
      plct(amp,a,as,ad,s,1)
    end
    in_thread do
      plarray(path,i[0][0],i[0][1],n1,d1,0,0.7,0,-0.8) #trumpet I
    end
    in_thread do
      plarray(path,i[0][0],i[0][1],n2,d2,0,0.7,0,0.8) #trumpet II
    end
    in_thread do
      plarray(path,i[1][0],i[1][1],n3,d3,0,0.2,0,0) #trombone I
    end
    plarray(path,i[2][0],i[2][1],n4,d4,0,0.2,0,0) #trombone II
  end
end