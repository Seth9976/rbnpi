#Correnta 5-7 by Salamone Rossi 1570-1630 coded by Robin Newman May 2015
#From Corrente a tre Score: http://imslp.org/wiki/7_Corrente_%C3%A0_tre_(Rossi,_Salamone)
#http://imslp.org/wiki/IMSLP:Creative_Commons_Attribution-NonCommercial_3.0
#These would orginally probably be for two violins and cello/continuo
#Here they are played by two trumpets and a tenor trombone
#I have matched the tempi to those on the Naxos DVD Catalogue no TC571801

#A separate program plays Correnta 6 and 7, and can be synced to follow this program
#synced from Correnta 1-4. comment out next line for immediate play

sync :correnta


use_debug false
use_sample_pack_as '/home/pi/samples/Correnta',:correnta #adjust location as necessary

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

corlist=["quinta (5)","sesta (6)","settima (7)"]
5.upto(7) do |cor|
  num=cor-4
  puts "Playing Correnta "+corlist[num-1]

  case num
when 1
 n1=[:r,:c5,:c5,:bb4,:a4,:g4,:f4,:e4,:e4,:f4,:e4,:f4,:g4,:a4,:f4,:g4,:g4,:a4,:g4,:a4,:bb4,:c5,:a4]
    d1=[m,m,m,b,m,b,m,b,m,c,c,c,c,c,c,b,m,c,c,c,c,c,c]
    n1.concat [:bb4,:bb4,:c5,:bb4,:c5,:d5,:eb5,:c5,:d5,:c5,:bb4,:c5,:bb4,:a4,:g4,:a4,:g4,:c5,:bb4,:a4,:g4,:d5,:c5,:d5,:e5,:f5,:e5,:d5,:e5,:f5]
    d1.concat [b,m,c,c,c,c,c,c,md,c,m,c,c,c,c,m,b,m,md,c,m,m,m,c,c,m,md,q,q,bd]
    n2=[:r,:a4,:a4,:g4,:f4,:e4,:d4,:cs4,:cs4,:d4,:c4,:d4,:e4,:f4,:d4,:e4,:e4,:f4,:e4,:f4,:g4,:a4,:f4]
    d2=[m,m,m,b,m,b,m,b,m,c,c,c,c,c,c,b,m,c,c,c,c,c,c]
    n2.concat [:g4,:f4,:g4,:a4,:bb4,:a4,:g4,:g4,:fs4,:g4,:f4,:f4,:e4,:f4,:g4,:a4,:bb4,:a4,:g4,:a4]
    d2.concat [b,m,b,m,md,c,m,b,m,b,m,b,m,c,c,m,m,m,b,bd]
    n3=[:r,:f2,:f2,:g2,:a2,:c3,:d3,:a2,:a2,:d3,:d3,:c3,:c3,:f3,:f3]
    d3=[m,m,m,b,m,b,m,b,m,b,m,b,m,b,m]
    n3.concat [:eb3,:d3,:c3,:f3,:bb2,:eb3,:c3,:d3,:g2,:a2,:bb2,:c3,:d3,:f3,:bb2,:f2,:c3,:f2]
    d3.concat [b,m,b,m,b,m,m,b,b,m,b,m,m,m,m,m,b,bd]
    n1b=[:c5,:f5,:e5,:d5,:c5,:f5,:e5,:d5,:g5,:f5,:e5,:d5,:c5,:f5,:e5,:d5,:e5,:f5,:g5,:e5,:d5,:c5,:bb4,:bb4,:a4,:bb4,:c5]
    d1b=[m,m,m,b,m,c,c,m,c,c,md,c,m,b,m,md,c,m,m,b,bd,m,m,m,md,c,m]
    n1b.concat [:bb4,:a4,:g4,:a4,:f5,:e5,:d5,:c5,:d5,:e5,:f5,:e5,:d5,:e5,:d5,:c5,:d5,:c5,:d5,:c5,:d5,:e5,:f5,:e5,:d5,:e5,:f5]
    d1b.concat [md,c,m,b,m,md,c,m,md,c,m,b,m,md,c,m,b,m,m,m,c,c,m,md,q,q,bd]
    n2b=[:a4,:f4,:g4,:a4,:bb4,:a4,:a4,:b4,:c5,:bb4,:a4,:g4,:a4,:f4,:g4,:a4,:bb4,:c5,:d5,:d5,:cs5,:d5,:a4,:d4,:g4,:f4,:g4,:a4]
    d2b=[md,c,c,c,b,m,m,b,md,c,c,c,md,c,c,c,md,c,m,m,b,bd,m,m,m,md,c,m]
    n2b.concat [:g4,:f4,:e4,:f4,:g4,:a4,:bb4,:c5,:bb4,:a4,:bb4,:f4,:g4,:a4,:bb4,:c5,:e4,:f4,:g4,:a4,:bb4,:f4,:bb4,:a4,:g4,:a4]
    d2b.concat [md,c,m,md,c,c,c,md,c,m,b,m,md,c,m,b,m,md,c,m,m,m,m,m,b,bd]
    n3b=[:f3,:d3,:c3,:bb2,:f3,:d3,:g3,:g2,:c3,:f3,:d3,:c3,:bb2,:bb2,:g2,:a2,:d3,:f3,:g3,:e3,:f3,:f3]
    d3b=[m,m,m,b,m,m,m,m,b,m,b,m,b,m,m,b,bd,m,m,m,b,m]
    n3b.concat [:g3,:c3,:f3,:e3,:d3,:c3,:f3,:bb2,:c3,:d3,:c3,:bb2,:a2,:bb2,:c3,:bb2,:a2,:g2,:a2,:bb2,:f2,:c3,:f2]
    d3b.concat [b,m,md,c,m,b,m,md,c,m,b,m,md,c,m,b,m,m,m,m,m,b,bd]
    a=[f,mp,mf,f,ff]
    as=[0,0,0,0,7*bd]
    ad=[16*bd,16*bd,20*bd,13*bd,7*bd]
    shift = 2 #transpose
    set_bpm(300)
rpt=2

  when 2
    n1=[:e5,:f5,:g5,:f5,:e5,:a5,:g5,:f5,:e5,:d5,:e5,:f5,:g5,:c5,:d5,:e5,:f5,:g5,:a5,:gs5,:a5,:cs5]
    d1=[c,c,md,c,m,md,c,m,c,c,c,c,m,md,c,m,b,m,b,m,b,m]
    n1.concat [:d5,:d5,:g5,:f5,:e5,:d5,:c5,:f5,:e5,:d5,:e5,:d5,:c5,:b4,:a4,:d5,:c5,:b4,:a4,:g4,:g5,:f5,:e5,:d5,:c5,:d5,:b4,:a4,:a4,:r]
    d1.concat [b,m,c,c,c,c,m,md,c,m,c,c,c,c,m,c,c,c,c,m,c,c,c,c,m,m,b,bd,b-q,q]
    n2=[:c5,:b4,:c5,:f5,:e5,:d5,:c5,:b4,:a4,:g4,:a4,:e5,:e5,:d5,:cs5,:d5,:e5]
    d2=[m,b,m,md,c,m,b,m,b,m,b,m,m,b,md,c,m]
    n2.concat [:a4,:b4,:e5,:d5,:c5,:b4,:a4,:a4,:b4,:c5,:d5,:e5,:d5,:c5,:f5,:e5,:d5,:c5,:b4,:e5,:d5,:c5,:b4,:a4,:a4,:gs4,:a4,:a4,:r]
    d2.concat [b,m,c,c,c,c,m,b,m,c,c,c,c,m,c,c,c,c,m,c,c,c,c,m,m,b,bd,b-q,q]
    n3=[:a3,:e3,:a3,:f3,:d3,:g3,:c3,:d3,:e3,:f3,:e3,:d3,:c3,:bb2,:a2,:a3]
    d3=[m,b,m,m,m,m,md,c,m,b,m,b,b,b,b,m]
    n3.concat [:fs3,:g3,:e3,:f3,:d3,:g3,:c3,:f3,:d3,:e3,:c3,:f3,:d3,:e3,:a2,:a2,:r]
    d3.concat [b,m,b,m,b,m,b,m,b,m,b,m,m,b,bd,b-q,q]
    n1b=[:cs5,:d5,:d5,:g5,:f5,:e5,:f5,:g5,:a5,:g5,:a5,:f5,:e5,:d5,:e5,:f5,:g5,:f5,:e5,:d5,:d5,:e5,:d5,:b4,:c5,:d5,:b4]
    d1b=[m,b,m,md,c,m,md,c,m,md,c,m,c,c,c,c,m,m,b,bd,b,m,m,c,c,c,c]
    n1b.concat [:c5,:a4,:b4,:c5,:a4,:b4,:g5,:f5,:d5,:e5,:f5,:d5,:e5,:c5,:d5,:e5,:c5,:d5,:b4,:c5,:d5,:b4,:c5,:d5,:e5,:f5,:g5,:d5,:b4,:c5,:d5,:b4]
    d1b.concat [m,c,c,c,c,b,m,m,c,c,c,c,m,c,c,c,c,m,c,c,c,c,c,c,c,c,m,m,c,c,c,c]
    n1b.concat [:c5,:d5,:e5,:d5,:c5,:b4,:a4,:b4,:a4,:b4,:c5,:d5,:e5,:f5,:e5,:f5,:g5,:a5,:g5,:e5,:fs5,:g5,:a5,:gs5,:fs5,:gs5,:a5,:a5]
    d1b.concat [b,m,c,c,c,c,m,c,c,c,c,c,c,c,c,c,c,m,m,m,c,c,m,md,q,q,bd,b]
    n2b=[:e4,:a4,:b4,:b4,:cs5,:d5,:cs5,:d5,:e5,:d5,:c5,:c5,:b4,:c5,:d5,:cs5,:d5,:d5,:a4,:b4,:c5,:b4,:c5,:d5,:c5,:b4]
    d2b=[m,b,m,b,m,b,c,c,b,m,md,c,c,c,m,b,bd,m,c,c,m,c,c,c,c,m]
    n2b.concat [:a4,:b4,:c5,:b4,:a4,:g4,:a4,:b4,:g4,:a4,:f4,:g4,:a4,:b4,:c5,:a4,:b4,:c5,:a4,:b4,:c5,:d5,:e5,:f5,:d5,:e5,:g5,:f5,:e5,:f5,:g5,:d5,:g5]
    d2b.concat [c,c,c,c,m,md,c,c,c,m,c,c,c,c,m,c,c,c,c,c,c,c,c,c,c,m,c,c,c,c,m,m,m]
    n2b.concat [:a5,:e5,:f5,:g5,:g5,:fs5,:g5,:d5,:c5,:b4,:c5,:d5,:d5,:c5,:d5,:e5,:d5,:c5,:b4,:a4,:c5,:b4,:a4,:a4]
    d2b.concat [m,c,c,m,b,m,m,c,c,c,c,md,c,c,c,c,c,c,c,m,m,b,bd,b]
    n3b=[:a3,:fs3,:g3,:e3,:a3,:d3,:e3,:f3,:c3,:d3,:a3,:g3,:d3,:a3,:d3,:d3,:c3,:g3,:g3]
    d3b=[m,b,m,b,m,md,c,m,b,m,b,m,m,b,bd,b,m,b,m]
    n3b.concat [:f3,:f3,:e3,:e3,:d3,:d3,:c3,:c3,:g3,:g3,:c3,:c3,:b2,:b2]
    d3b.concat [b,m,b,m,b,m,b,m,b,m,b,m,b,m]
    n3b.concat [:a2,:b2,:c3,:d3,:d3,:g3,:d3,:e3,:f3,:c3,:d3,:a2,:e3,:a2,:a2]
    d3b.concat [b,m,b,m,b,m,md,c,m,b,m,m,b,bd,b]
    a=[f,mp,mf,f,ff]
    as=[0,0,0,0,6*bd]
    ad=[16*bd-q,q+16*bd,24*bd,18*bd,6*bd]
    shift=0
    set_bpm(280)
rpt=2
  when 3
    n1=[:r,:d5,:f5,:g5,:f5,:e5,:d5,:c5,:a4,:f5,:g5,:a5,:bb5,:g5,:f5,:g5,:a5,:c5,:d5,:e5,:f5,:g5,:e5,:d5,:e5]
    d1=[m,b,md,c,m,m,b,m,m,c,c,c,c,md,q,q,m,m,c,c,c,c,md,q,q]
    n1.concat [:f5,:f5,:a5,:g5,:a5,:g5,:f5,:e5,:f5,:g5,:f5,:e5,:d5,:c5,:a4,:f5,:g5,:a5,:bb5,:g5,:f5,:g5,:a5,:a4,:d5,:e5,:f5,:g5,:e5,:d5,:c5,:d5,:d5]
    d1.concat [bd,b,m,c,c,c,c,m,c,c,c,c,m,m,m,c,c,c,c,md,q,q,m,m,c,c,c,c,md,q,q,b,m]
    n2=[:r,:f5,:a5,:bb5,:a5,:e5,:f5,:g5,:a5,:d5,:e5,:f5,:g5,:e5,:d5,:e5,:f5,:f5,:g5,:a5,:bb5,:g5,:f5,:g5]
    d2=[m,b,md,c,m,m,m,m,b,c,c,c,c,md,q,q,b,c,c,c,c,md,q,q]
    n2.concat [:a5,:g5,:f5,:e5,:d5,:c5,:f5,:e5,:f5,:e5,:d5,:c5,:d5,:c5,:d5,:e5,:f5,:d5,:e5,:c5,:d5,:e5,:f5,:g5,:e5,:d5,:e5,:f5,:c5,:f5,:e5,:d5,:cs5,:e5,:d5,:d5]
    d2.concat [b,q,q,q,q,m,b,c,c,c,c,m,c,c,c,c,c,c,m,m,c,c,c,c,md,q,q,m,m,c,c,m,md,c,b,m]
    n3=[:r,:d3,:d3,:d3,:c3,:bb2,:a2,:bb2,:c3,:f3,:e3,:d3,:bb2,:c3]
    d3=[m,b,b,m,m,b,b,b,b,md,c,m,m,b]
    n3.concat [:f2,:f2,:f3,:c3,:bb2,:a2,:g2,:c3,:f3,:e3,:d3,:g2,:a2,:d3,:d3]
    d3.concat [bd,b,m,bd,bd,b,b,b,md,c,m,m,b,b,m]
    n1b=[:g4,:a4,:bb4,:c5,:d5,:c5,:bb4,:a4,:bb4,:c5,:d5,:e5,:f5,:c5,:d5,:e5,:f5,:g5,:a5,:bb5,:c6,:bb5,:a5,:g5,:f5,:g5,:f5,:e5,:f5,:g5,:e5,:f5,:r]
    d1b=[c,c,m,m,b,m,c,c,c,c,c,c,c,c,c,c,c,c,c,c,m,m,md,c,m,c,c,c,c,c,c,bd-q,q]
    n1b.concat [:a5,:g5,:f5,:e5,:d5,:e5,:d5,:c5,:bb4,:c5,:d5,:e5,:f5,:g5,:e5,:a5,:g5,:f5,:e5,:c5,:d5,:e5,:f5,:e5,:d5,:bb4,:a4,:c5,:a5,:g5,:f5]
    d1b.concat [c,c,c,c,m,b,m,c,c,c,c,c,c,m,m,m,b,m,m,m,c,c,c,c,md,q,q,b,m,b,m]
    n1b.concat [:e5,:c5,:d5,:e5,:f5,:e5,:d5,:c5,:b4,:c5,:a5,:g5,:f5,:e5,:d5,:c5,:a4,:g5,:f5,:e5,:d5,:c5,:bb4,:a4,:bb4,:c5,:d5,:e5,:f5,:g5,:e5,:d5,:c5,:d5,:d5,:r]
    d1b.concat [m,m,c,c,c,c,md,q,q,b,c,c,m,m,m,m,m,c,c,m,m,m]
    n2b=[:eb5,:d5,:c5,:bb4,:a4,:d5,:c5,:bb4,:a4,:g4,:a4,:bb4,:c5,:bb4,:a4,:g4,:f4,:g4,:a4,:d5,:c5,:bb4,:a4,:r]
    d2b=[m,m,m,b,m,m,m,m,md,c,c,c,c,c,m,m,md,c,m,m,md,c,bd-q,q]
    n2b.concat [:f5,:g5,:a5,:g5,:f5,:g5,:g5,:e5,:a4,:bb4,:c5,:c5,:c5,:g4,:a4,:bb4,:c5,:e5,:f5,:a5,:g5,:f5,:e5,:c5,:c5,:g4,:a4,:bb4]
    d2b.concat [c,c,c,c,m,b,m,b,m,m,m,m,md,c,c,c,m,m,m,m,md,c,b,m,md,c,c,c]
    n2b.concat [:c5,:e5,:f5,:a5,:g5,:f5,:e5,:f5,:g5,:a5,:g5,:f5,:e5,:c5,:e5,:f5,:g5,:g5,:fs5,:g5,:f5,:e5,:d5,:d5,:cs5,:e5,:d5,:d5,:r]
    d2b.concat [m,m,m,m,md,c,b,c,c,m,m,m,m,m,c,c,m,m,m]
    n3b=[:c3,:bb2,:a2,:bb2,:f2,:bb2,:a2,:g2,:f2,:f2,:f2,:f3,:g3,:d3,:e3,:f3,:bb2,:c3,:f3,:f3,:r]
    d3b=[m,m,m,b,m,m,m,m,b,m,m,m,m,md,c,m,m,b,b,m-q,q]
    n3b.concat [:d3,:d3,:c3,:g2,:c3,:a2,:d3,:g2,:c3,:f3,:e3,:d3,:c3,:f3,:g3,:c3,:f3,:e3,:d3]
    d3b.concat [b,m,b,m,m,m,m,m,m,m,b,m,b,b,b,b,m,b,m]
    n3b.concat [:c3,:f3,:g3,:c3,:f3,:g3,:a3,:c3,:bb2,:a2,:g2,:a2,:bb2,:g2,:a2,:d3,:r]
    d3b.concat [b,b,b,b,b,b,b,b,m,m]
    d1br1=d1b+[c,c,c,c,c,c,c,c,md,q,q,b,m-q,q]
    d1br2=d1b+[c*1.1,c*1.1,c*1.2,c*1.2,c*1.3,c*1.3,c*1.4,c*1.4,m*1.5+c*1.6,q*1.6,q*1.6,b*1.8,m*2-q,q]
    d2br1=d2b+[m,c,c,m,m,m,m,b,m-q,q]
    d2br2=d2b+[m*1.1,c*1.2,c*1.2,m*1.3,m*1.4,m*1.5,m*1.6,b*1.8,m*2-q,q]
    d3br1=d3b+[m,m,m,m,b,bd-q,q]
    d3br2=d3b+[m*1.1,m*1.2,m*1.3,m*1.4,m*1.5+m*1.6,b*1.8+m*2-1-q,q]
    a=[f,mp]#for first part all aprts together
    as=[0,0]
    ad=[16*bd,16*bd]

    a1=[mf,f,mp,mf,f,f,ff,mf,f,ff] #for second part separate parts control
    as1=[0,0,0,5*bd,5*bd,0,0,0,5*bd,5*bd]
    ad1=[4*bd,4*bd-q,q+7*bd,5*bd,6*bd,4*bd,4*bd,7*bd,5*bd,6*bd]
    a2=[mf,f,mp,mf,f,f,ff,mf,f,ff]
    as2=[0,0,0,5*bd,5*bd,0,0,0,5*bd,5*bd]
    ad2=[2*bd,4*bd,9*bd-q,q+5*bd,6*bd,2*bd,4*bd,9*bd,5*bd,6*bd]
    a3=[mf,f,mp,mf,f,f,ff,mf,f,ff]
    as3=[0,2*bd,5*bd,5*bd,6*bd,0,2*bd,5*bd,5*bd,5*bd]
    ad3=[2*bd,2*bd,11*bd-q,q+5*bd,6*bd,2*bd,2*bd,11*bd,5*bd,6*bd]
    shift = 0
    set_bpm(270)
rpt=1

  end

  al=[n1,d1,n2,d2,n3,d3,n1b,d1b,n2b,d2b,n3b,d3b] #array seelections
  if num == 3 #different array selections with rit control
    al=[n1,d1,n2,d2,n3,d3,n1b+n1b,d1br1+d1br2,n2b+n2b,d2br1+d2br2,n3b+n3b,d3br1+d3br2]
  end
  comment do #for debugging
    puts "check equal parts..."
    puts (len(d1)+len(d1b))*2
    puts (len(d2)+len(d2b))*2
    puts (len(d3)+len(d3b))*2
    if num < 3
      puts len(ad)
    else
      puts "check equal ad..."
      puts len(ad1)
      puts len(ad2)
      puts len(ad3)
    end
  end

    with_fx :reverb,room: 0.6,mix: 0.4 do #add some reverb
      with_fx :level do |amp|
        in_thread do
          plct(amp,a,as,ad,s,9) #control level (with printed output)
        end
        x=0
        rpt.times do #do twice for n=1,n=2 and once for n=3
          2.times do
            #puts x
            in_thread do
              plarray(i[0][0],i[0][1],al[x],al[x+1],0,0.7,-0.5) #trumpet I
            end
            in_thread do
              plarray(i[0][0],i[0][1],al[x+2],al[x+3],0,0.7,0.5) #trumpet II
            end
            plarray(i[1][0],i[1][1],al[x+4],al[x+5],0,0.7) #trombone I
            #sleep 27*bd*s
          end
          x=6
        end

      end
    end

  if num==3 then #for n=3 treat second half separately, with individual level control for each part
    x=6
    #puts x
    with_fx :reverb,room: 0.6,mix: 0.4 do
      with_fx :level do |amp1|
        in_thread do
          in_thread do
            plct(amp1,a1,as1,ad1,s,1) #control level (with printed output)
          end
          plarray(i[0][0],i[0][1],al[x],al[x+1],shift,0.7,-0.5) #trumpet I
        end
      end
      with_fx :level do |amp2|
        in_thread do
          in_thread do
            plct(amp2,a2,as2,ad2,s,2) #control level (with printed output)
          end
          plarray(i[0][0],i[0][1],al[x+2],al[x+3],shift,0.7,0.5) #trumpet II
        end
      end
      with_fx :level do |amp3|
        in_thread do
          plct(amp3,a3,as3,ad3,s,3) #control level (with printed output)
        end
        plarray(i[1][0],i[1][1],al[x+4],al[x+5],shift,0.7) #trombone I
        #sleep 27*bd*s #for debugging
      end

    end
  end
  sleep bd * s #gap between each Correnta
end