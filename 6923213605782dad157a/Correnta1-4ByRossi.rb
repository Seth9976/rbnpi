#Correnta 1-4 by Salamone Rossi 1570-1630 coded by Robin Newman May 2015
#From Corrente a tre Score: http://imslp.org/wiki/7_Corrente_%C3%A0_tre_(Rossi,_Salamone)
#http://imslp.org/wiki/IMSLP:Creative_Commons_Attribution-NonCommercial_3.0
#These would orginally probably be for two violins and cello/continuo
#Here they are played by two trumpets and a tenor trombone
#I have matched the tempi to those on the Naxos DVD Catalogue no TC571801
#The trumpet and trombone voices are generated from two audio samples which should be saved
#in the specified samples directory

#A separate program plays Correnta 5-7, and can be synced to follow this program

use_debug false
use_sample_pack_as '/home/pi/samples/Correnta',:correnta #adjust location as necessary
w=5
#first deal with selecting and setting up the samples
inst0=:correnta__trumpet_cs5
samplepitch0=:cs5
inst1=:correnta__tenor_trombone_as3
samplepitch1=:as3

#preload all the samples

load_flag=0
if sample_loaded? inst0  then #check if sample already loaded
  load_flag=1
end
load_samples [inst0,inst1]
if load_flag==0 then #samples not loaded so allow time
  sleep 1
end

#put the sample names and pitches into an array i
i=[[inst0,samplepitch0],[inst1,samplepitch1]]


#define variables that need to be used globally
s=0 #note duration scale factor
al=[] #arraylist for level control

define :pl do |inst,samplepitch,nv,dv,vol=1,pan=0| #plays a sample note
#parameters samplename, native pitch, note,duration,volume,pan position
  shift=note(nv)-note(samplepitch)
  sample inst,rate: (pitch_ratio shift),sustain: 0.8*dv,release: 0.2*dv,amp: vol,pan: pan
end

define :plarray do |inst,samplepitch,narray,darray,shift=0,vol=1,pan=0| #plays note/duration arrays
#parameters samplename,nativepitch,notes array,duration array,transpose shift,volume,pan postion
  narray.zip(darray) do |nv,dv|
    if nv != :r
      pl(inst,samplepitch,note(nv)+shift,dv*s,vol,pan)
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
sf=1.6 #dynamics scale factor
#dynamic settings
p=0.06*sf
mp=0.2*sf
mf=0.5*sf
f=1.0*sf
ff=1.3*sf
levlookup=[[p,"p"],[mp,"mp"],[mf,"mf"],[f,"f"],[ff,"ff"]] #allows printing in plct function

define :ct do |ptr,lev,slid=0,timetonext=0,s,flag| #controls level
#paramters level ptr, level required,slide time,timetonext adjustment,tempo scale factor,printing flag
  control ptr,amp: lev,amp_slide: slid*s #times scalefactor for tempo
  if flag > 0 then #lets you print level variations
    puts "All parts Level change:"
    puts "level "+levlookup.assoc(lev)[1]
    puts "slide time "+ (slid*s).to_s
    puts " " #blank line
  end
  sleep timetonext*s #scale for tempo
end

define :plct do |pt,am,amsl,amd,s,flag=0| #controls level using values in three arrays
  #params pt control pointer,am amp level,amsl amp_slide:,amd delay to next command,s tempo scale factor,flag to print info
  am.zip(amsl,amd) do |amv,amslv,amdv|
    ct(pt,amv,amslv,amdv,s,flag)
  end
end

define :len do |d| #calculates duration of a part or level control array
  tl=0
  d.each do |d|
    tl += d
  end
  return tl
end

corlist=["prima (1)","seconda detta la Emiglia (2)","terza detta la Cecchina (3)","quarta (4)"]
1.upto(4) do |num|
  #num=3
  puts "Playing Correnta "+corlist[num-1]
  case num
  when 1
    #set up the part lists
    n1=[:e5,:d5,:c5,:f5,:e5,:d5,:g5,:f5,:e5,:e5,:f5,:g5,:f5,:e5,:d5,:e5,:c5,:b4,:c5,:d5]
    d1=[c,c,b,c,c,b,c,c,bd,md,c,m,b,m,md,c,m,md,c,m]
    n1.concat [:e5,:d5,:c5,:d5,:g5,:f5,:e5,:d5,:c5,:d5,:c5,:c5,:r]
    d1.concat [md,c,m,m,b,c,c,c,c,m,bd,b-q,q]
    #b12 upbeat
    n2=[:c5,:b4,:a4,:d5,:c5,:b4,:e5,:d5,:c5,:c5,:b4,:a4,:b4,:c5,:b4,:a4,:g4,:a4,:b4]
    d2=[c,c,b,c,c,b,c,c,bd,b,m,md,c,m,b,m,md,c,m]
    n2.concat [:c5,:c5,:b4,:e5,:d5,:c5,:b4,:a4,:b4,:c5,:c5,:r]
    d2.concat [b,m,m,b,c,c,c,c,m,bd,b-q,q]
    #b12 upbeat
    n3=[:c3,:f3,:d3,:g3,:e3,:a3,:a3,:e3,:f3,:c3,:g3,:a3,:e3,:d3]
    d3=[m,b,m,b,m,bd,b,m,b,m,b,m,b,m]
    n3.concat [:c3,:b2,:a2,:g2,:e2,:f2,:g2,:c3,:c3,:r]
    d3.concat [md,c,m,b,m,m,b,bd,b-q,q]
    #b12 upbeat
    n1b=[:e5,:d5,:e5,:c5,:b4,:c5,:a4,:g4,:d5,:c5,:b4,:a4,:d5,:c5]
    d1b=[m,md,c,m,md,c,m,b,m,b,m,m,m,m]
    n1b.concat [:b4,:a4,:b4,:b4,:b4,:c5,:c5,:d5,:e5,:f5,:e5,:d5,:c5,:b4,:g5,:f5,:e5,:f5,:d5,:c5,:c5]
    d1b.concat [m,b,bd,b,m,b,m,md,c,m,md,c,m,b,m,b,m,m,b,bd,b]
    n2b=[:c5,:b4,:a4,:g4,:f4,:e4,:f4,:g4,:e4,:f4,:g4,:fs4,:g4,:e4,:fs4]
    d2b=[m,b,m,b,m,md,c,m,md,c,m,m,m,c,c]
    n2b.concat [:g4,:fs4,:e4,:fs4,:g4,:g4,:g4,:a4,:g4,:a4,:b4,:c5,:g4,:a4,:g4,:f4,:e4,:a4,:b4,:c5,:c5,:b4,:a4,:b4,:c5,:c5]
    d2b.concat [m,md,q,q,bd,b,m,b,m,b,m,m,m,m,md,c,m,md,c,m,m,md,q,q,bd,b]
    n3b=[:c3,:g3,:a3,:e3,:f3,:c3,:b2,:c3,:g2,:d3,:b2,:c3]
    d3b=[m,b,m,b,m,b,m,b,m,m,m,m]
    n3b.concat [:g2,:d3,:g2,:g2,:g3,:f3,:e3,:d3,:g3,:c3,:a2,:e3,:c3,:f3,:g3,:a3,:f3,:g3,:c3,:c3]
    d3b.concat [m,b,bd,b,m,b,m,b,m,b,m,b,m,md,c,m,m,b,bd,b]

    #level control arrays
    a=[f,mp,mf,f,ff] #dynamic target
    as=[0,0,0,0,6*bd] #slide times
    #ad contains times between each level change
    ad=[12*bd-q,q+12*bd,16*bd,8*bd,8*bd]
    shift =0
    set_bpm(300)

  when 2
    n1=[:d5,:g5,:f5,:eb5,:c5,:d5,:d5,:e5,:f5,:eb5,:d5,:c5,:bb4,:a4,:bb4,:c5,:d5,:c5,:bb4,:c5,:d5]
    d1=[m,b,m,b,m,bd,md,c,m,b,m,b,m,md,c,m,b,m,md,c,m]
    n1.concat [:d5,:c5,:d5,:e5,:f5,:e5,:d5,:c5,:d5,:e5,:f5,:d5,:c5,:bb4,:c5,:d5,:c5,:d5,:eb5,:d5,:g5,:g5,:fs5,:e5,:fs5,:g5,:g5,:r]
    d1.concat [m,b,md,c,m,md,c,m,md,c,m,m,b,md,c,m,md,c,m,b,m,m,md,q,q,bd,b-q,q]
    n2=[:bb4,:bb4,:c5,:d5,:g4,:a4,:bb4,:bb4,:c5,:d5,:g4,:a4,:bb4,:a4,:g4,:f4,:g4,:a4,:bb4,:f4,:g4,:f4]
    d2=[m,md,c,m,b,m,bd,md,c,m,md,c,m,b,m,md,c,m,b,m,b,m]
    n2.concat [:d4,:e4,:d4,:d4,:g4,:a4,:bb4,:a4,:g4,:f4,:bb4,:a4,:g4,:a4,:bb4,:g4,:a4,:bb4,:c5,:bb4,:f4,:c5,:bb4,:a4,:g4,:g4,:r]
    d2.concat [m,b,b,m,b,m,md,q,q,m,m,md,q,q,b,m,md,c,m,m,m,m,m,b,bd,b-q,q]
    n3=[:g3,:eb3,:d3,:c3,:f3,:bb2,:bb2,:bb2,:eb3,:bb2,:f3,:g3,:d3,:c3,:bb2,:a2,:g2,:a2,:b2]
    d3=[m,b,m,b,m,bd,b,m,b,m,b,m,b,m,b,m,md,c,m]
    n3.concat [:bb2,:a2,:d3,:d3,:c3,:c3,:bb2,:c3,:d3,:eb3,:f3,:bb2,:bb2,:a2,:a2,:bb2,:c3,:d3,:g2,:g2,:r]
    d3.concat [m,b,b,m,b,m,md,c,m,m,b,b,m,b,m,b,b,b,bd,b-q,q]
    n1b=[:c5,:c5,:d5,:bb4,:c5,:a4,:bb4,:c5,:d5,:e5,:f5,:d5,:e5,:f5,:e5,:d5,:e5,:d5,:e5,:f5,:d5,:e5,:f5,:g5,:a5,:c5,:d5]
    d1b=[m,b,m,b,m,md,c,m,m,m,m,md,c,m,m,b,md,q,q,m,md,q,q,m,m,m,m]
    n1b.concat [:bb4,:c5,:d5,:e5,:f5,:e5,:d5,:e5,:f5,:d5,:e5,:f5,:g5,:g5,:fs5,:e5,:fs5,:g5,:g5]
    d1b.concat [b,m,md,c,m,md,q,q,m,md,q,q,m,m,md,q,q,bd,b]
    n2b=[:a4,:a4,:bb4,:g4,:f4,:g4,:a4,:f4,:f5,:e5,:f5,:c5,:f4,:bb4,:a4,:c5,:b4,:a4,:b4,:c5,:a4,:c5,:f4,:bb4,:c5,:a4,:bb4]
    d2b=[m,b,m,md,q,q,m,m,m,m,m,b,m,m,m,m,md,q,q,m,m,m,m,b,m,m,m]
    n2b.concat [:g4,:a4,:bb4,:f4,:f4,:g4,:c5,:f4,:c5,:bb4,:bb4,:a4,:g4,:g4]
    d2b.concat [b,m,m,m,m,b,m,m,m,m,m,b,bd,b]
    n3b=[:f3,:f3,:d3,:eb3,:c3,:d3,:c3,:bb2,:a2,:bb2,:c3,:d3,:c3,:g3,:c3,:bb2,:a2,:bb2,:a2,:g2,:f2,:f3,:d3]
    d3b=[m,b,m,b,m,b,m,m,b,md,c,m,m,b,md,c,m,md,c,m,m,m,m]
    n3b.concat [:eb3,:d3,:c3,:bb2,:c3,:d3,:c3,:bb2,:a2,:bb2,:a2,:g2,:g2,:d3,:g2,:g2]
    d3b.concat [md,c,m,md,c,m,md,c,m,m,m,m,m,b,bd,b]
    a=[f,mp,mf,f,ff]
    as=[0,0,0,0,7*bd]
    ad=[20*bd-q,q+20*bd,16*bd,9*bd,7*bd]
    shift=0 #transpose
    set_bpm(270)

  when 3
    n1=[:r,:g4,:a4,:bb4,:bb4,:c5,:c5,:d5,:d5,:e5,:fs5,:g5,:d5,:e5,:f5,:f5,:g5,:fs5,:g5,:a5,:d5,:g5]
    d1=[m,m,m,b,m,b,m,b,m,b,m,m,c,c,m,m,b,md,c,m,m,b]
    n1.concat [:c5,:f5,:bb4,:eb5,:c5,:d5,:e5,:f5,:e5,:d5,:c5,:bb4,:a4,:g4]
    d1.concat [b,m,m,m,m,md,c,m,b,m,b,b,b,bd]
    n2=[:r,:bb4,:a4,:g4,:bb4,:bb4,:a4,:bb4,:f4,:c5,:c5,:bb4,:a4,:a4,:bb4,:g4,:a4,:d5,:c5,:b4,:c5]
    d2=[m,m,m,b,m,b,m,b,m,b,m,b,m,m,m,m,m,m,m,b,m]
    n2.concat [:a4,:bb4,:g4,:a4,:bb4,:f4,:c5,:g4,:f4,:e4,:d4,:e4,:f4,:g4,:g4,:fs4,:g4]
    d2.concat [b,m,b,m,m,m,m,b,m,c,c,c,c,m,m,b,bd]
    n3=[:r,:g3,:fs3,:g3,:g3,:eb3,:f3,:bb2,:bb3,:a3,:a3,:g3,:f3,:eb3,:d3,:eb3,:f3,:g3,:e3]
    d3=[m,m,m,b,m,b,m,b,m,b,m,b,b,b,md,c,m,b,m]
    n3.concat [:f3,:d3,:eb3,:c3,:f3,:bb2,:a2,:c3,:d3,:a2,:c3,:g2,:a2,:bb2,:c3,:d3,:g2]
    d3.concat [b,m,m,m,m,b,m,b,m,m,m,c,c,c,c,b,bd]
    n1b=[:bb4,:c5,:d5,:e5,:f5,:e5,:d5,:g5,:f5,:e5,:f5,:g5,:e5,:f5,:a5,:g5,:f5,:e5,:d5,:g5,:c5,:f5,:eb5,:d5,:e5,:f5]
    d1b=[c,c,c,c,m,b,m,c,c,c,c,c,c,m,m,m,m,b,b,m,m,m,m,md,c,m]
    n1b.concat [:d5,:c5,:bb4,:d5,:g4,:a4,:bb4,:a4,:d5,:bb4,:g4,:a4,:c5,:c5,:f5,:d5,:e5,:f5,:g5,:e5,:d5,:c5,:d5,:e5]
    d1b.concat [m,b,bd,m,m,m,b,m,m,m,m,m,m,m,b,m,md,c,m,m,b,md,c,m]
    n1b.concat [:f5,:e5,:d5,:e5,:f5,:g5,:f5,:e5,:f5,:g5,:a5,:g5,:f5,:d5,:e5,:f5,:g5,:fs5,:e5,:fs5,:g5]
    d1b.concat [b,m,md,c,m,b,m,md,c,m,b,m,m,m,c,c,m,md,q,q,bd]
    n2b=[:g4,:a4,:bb4,:c5,:d5,:c5,:f4,:bb4,:g4,:c5,:bb4,:a4,:c5,:bb4,:c5,:d5,:cs5,:d5,:bb4,:c5,:a4,:f4,:g4,:a4,:bb4,:f4,:bb4]
    d2b=[c,c,c,c,m,b,m,m,m,c,c,m,m,c,c,b,m,m,m,m,md,c,c,c,m,m,m]
    n2b.concat [:bb4,:a4,:bb4,:f4,:e4,:fs4,:g4,:f4,:f4,:g4,:e4,:f4,:a4,:g4,:a4,:b4,:c5,:g4,:c5,:c5,:b4,:c5,:a4,:g4]
    d2b.concat [b,m,bd,m,m,m,b,m,m,m,m,m,m,m,b,m,m,m,m,b,m,m,m,m]
    n2b.concat [:a4,:f4,:g4,:a4,:bb4,:f4,:f4,:bb4,:c5,:d5,:g4,:a4,:bb4,:c5,:d5,:c5,:bb4,:a4,:f4,:g4,:a4,:bb4,:c5,:a4,:g4]
    d2b.concat [md,c,c,c,m,m,m,md,c,m,md,c,m,md,c,c,c,m,m,c,c,c,c,b,bd]
    n3b=[:g3,:d3,:a3,:bb3,:g3,:c4,:c3,:f3,:g3,:d3,:a3,:d3,:g3,:e3,:f3,:d3,:c3,:bb2,:c3,:d3]
    d3b=[b,m,b,m,m,m,m,b,m,m,b,m,m,m,m,m,m,md,c,m]
    n3b.concat [:bb2,:f3,:bb2,:bb2,:c3,:a2,:g2,:d3,:bb2,:g2,:c3,:f2,:f3,:e3,:d3,:g3,:c3,:d3,:e3,:f3,:g3,:c3,:f3,:e3]
    d3b.concat [m,b,bd,m,m,m,b,m,m,m,m,m,m,m,b,m,md,c,m,m,b,m,m,m]
    n3b.concat [:d3,:c3,:bb2,:a2,:g2,:a2,:bb2,:c3,:bb2,:f2,:g2,:d3,:c3,:g2,:d3,:g2]
    d3b.concat [b,m,b,m,md,c,m,b,m,b,m,b,m,m,b,bd]
    a=[f,mp,mf,f,ff]
    as=[0,0,0,0,7*bd]
    ad=[16*bd,16*bd,26*bd,17*bd,9*bd]
    shift = 0 #transpose
    set_bpm(300)

  when 4
    n1=[:r,:d5,:c5,:b4,:a4,:g4,:g4,:a4,:g4,:a4,:b4,:c5,:a4,:b4,:b4,:c5,:b4,:c5,:d5,:e5,:c5,:d5,:d5]
    d1=[m,c,c,c,c,b,m,c,c,c,c,c,c,b,m,c,c,c,c,c,c,b,m]
    n1.concat [:e5,:d5,:e5,:fs5,:g5,:e5,:fs5,:e5,:d5,:g4,:c5,:a4,:b4,:c5,:d5,:b4,:c5,:d5,:e5,:d5,:g5,:fs5,:e5,:fs5,:d5,:e5,:fs5,:g5,:a5,:fs5,:e5,:fs5,:g5]
    d1.concat [c,c,c,c,c,c,md,c,m,m,m,m,md,c,m,m,m,m,b,m,b,c,c,m,m,c,c,c,c,md,q,q,bd]
    n2=[:r,:b4,:a4,:g4,:f4,:e4,:e4,:fs4,:e4,:fs4,:g4,:a4,:fs4,:g4,:g4,:a4,:g4,:a4,:b4,:c5,:a4,:b4,:a4,:b4]
    d2=[m,c,c,c,c,b,m,c,c,c,c,c,c,b,m,c,c,c,c,c,c,b,c,c]
    n2.concat [:cs5,:b4,:cs5,:d5,:e5,:cs5,:d5,:c5,:b4,:b4,:e4,:f4,:g4,:fs4,:g4,:a4,:b4,:c5,:b4,:a4,:b4,:c5,:d5,:a4,:a4,:fs4,:g4,:a4,:b4,:a4,:b4]
    d2.concat [c,c,c,c,c,c,md,c,m,m,m,m,b,m,m,m,m,b,c,c,c,c,m,m,m,m,c,c,m,b,bd]
    n3=[:r,:g2,:c3,:c3,:a2,:d3,:g3,:g3,:e3,:d3,:c3,:g3,:fs3]
    d3=[m,b,b,m,b,m,b,m,m,m,m,b,m]
    n3.concat [:a3,:a2,:d3,:g3,:e3,:a3,:d3,:g3,:d3,:g3,:e3,:d3,:c3,:g3,:e3,:b2,:c3,:d3,:c3,:g2,:d3,:g2]
    d3.concat [b,m,b,m,m,m,m,b,m,m,m,m,b,m,m,m,m,b,m,m,b,bd]
    n1b=[:g5,:f5,:e5,:d5,:c5,:c5,:d5,:e5,:f5,:g5,:d5,:e5,:f5,:c5,:d5,:e5,:f5,:g5,:c5,:d5]
    d1b=[m,m,m,b,m,b,m,md,c,m,md,c,m,c,c,c,c,m,m,b]
    n1b.concat [:c5,:e5,:d5,:b4,:c5,:d5,:e5,:d5,:c5,:a4,:b4,:c5,:d5,:d5,:g5,:e5,:fs5,:g5,:a5,:e5,:e5,:d5,:a5,:g5]
    d1b.concat [bd,m,m,m,md,c,m,m,m,m,md,c,m,m,m,m,md,c,m,m,b,m,m,m]
    n1b.concat [:f5,:e5,:d5,:e5,:g5,:f5,:e5,:d5,:c5,:b4,:e5,:d5,:c5,:b4,:a4,:d5,:e5,:f5,:g5,:a5,:fs5,:e5,:fs5,:g5]
    d1b.concat [md,c,m,m,m,m,md,c,m,b,m,md,c,m,m,m,c,c,c,c,md,q,q,bd]
    n2b=[:e5,:d5,:c5,:b4,:g4,:a4,:b4,:c5,:c5,:b4,:c5,:d5,:e5,:c5,:b4,:g4,:c5,:b4]
    d2b=[m,m,m,b,m,b,m,b,m,md,c,m,m,m,c,c,b,m]
    n2b.concat [:c5,:g4,:fs4,:gs4,:a4,:g4,:g4,:fs4,:g4,:a4,:b4,:a4,:b4,:cs5,:d5,:d5,:d5,:cs5,:d5,:f5,:e5]
    d2b.concat [bd,m,m,m,b,m,b,m,md,c,m,m,m,m,b,m,b,m,m,m,m]
    n2b.concat [:a4,:b4,:c5,:e5,:d5,:g4,:a4,:d5,:d5,:c5,:b4,:a4,:g4,:fs4,:fs4,:g4,:b4,:a4,:b4]
    d2b.concat [b,m,m,m,m,b,m,m,m,m,md,c,m,m,m,m,m,b,bd]
    n3b=[:c3,:d3,:e3,:g3,:e3,:f3,:a3,:g3,:c3,:e3,:g3,:d3,:a3,:e3,:f3,:g3]
    d3b=[m,m,m,b,m,md,c,m,b,m,b,m,b,m,m,b]
    n3b.concat [:c3,:c3,:d3,:e3,:a2,:b2,:c3,:b2,:a2,:d3,:g2,:g3,:fs3,:e3,:a3,:d3,:e3,:fs3,:g3,:a3,:d3,:e3]
    d3b.concat [bd,m,m,m,md,c,m,m,m,m,b,m,m,m,m,md,c,m,m,b,b,m]
    n3b.concat [:f3,:g3,:c3,:d3,:e3,:fs3,:g3,:a2,:b2,:c3,:d3,:c3,:g2,:d3,:g2]
    d3b.concat [b,m,b,m,b,m,b,m,b,m,b,m,m,b,bd]

    #level control arrays
    a=[f,mp,mf,f,ff] #dynamic target
    as=[0,0,0,0,5*bd] #slide times
    #ad contains times between each level change
    ad=[16*bd,16*bd,24*bd,19*bd,5*bd]
    shift = 0 #transpose
    set_bpm(340)
   end


  al=[n1,d1,n2,d2,n3,d3,n1b,d1b,n2b,d2b,n3b,d3b]
  comment do #for debugging
    puts "check equal..."
    puts (len(d1)+len(d1b))*2
    puts (len(d2)+len(d2b))*2
    puts (len(d3)+len(d3b))*2
    puts len(ad)
  end
  with_fx :reverb,room: 0.6,mix: 0.4 do #add some reverb
    with_fx :level do |amp|
      in_thread do
        plct(amp,a,as,ad,s,1) #control level (with printed output)
      end
      x=0
      2.times do
        2.times do
          #puts x
          in_thread do
            plarray(i[0][0],i[0][1],al[x],al[x+1],shift,0.7,-0.5) #trumpet I
          end
          in_thread do
            plarray(i[0][0],i[0][1],al[x+2],al[x+3],shift,0.7,0.5) #trumpet II
          end
          plarray(i[1][0],i[1][1],al[x+4],al[x+5],shift,0.7) #trombone I
          #sleep 27*bd*s
        end
        x=6
      end

    end
  end
  sleep bd * s
end
cue :correnta #cue programs for correnta 6 and 7