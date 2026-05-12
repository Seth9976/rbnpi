#Palestrina Sicut Cervus coded for Sonic Pi by Robin Newman April 2015
#This piece utilises the fx level to alter the dynamic level of each part.
#Each part is wrapped inside a with_fx :level command and the level is controlled by a thread
#which adjusts the level amp: setting via a control function. Since the part playing is inside the fx loop
#its volume is controlled as it plays. The ct function alters the amp setting with a control command
#which includes the new level setting and a slide parameter to adjust how long the change takes
#the plct function reads level settings from three lists a,as and ad associated with each part, which contain
#the level values, the slide time and the delay time before the next level-change command is activated.
#A parameter at the end of the plct command is set either to 0, or to the part number 1-4. In the latter case
#it will print out level changes and slide times so that you can follow the changes as the music plays

i1=i2=i3=i4=:pulse #synth for all parts

#part volumes set quite low as "ff" scales by 1.6
v1=0.5
v2=0.5
v3=0.5
v4=0.5

s=0 #dummy value to define tempo scale variable. Set later using set_bpm
#note duration relative values (not all used)
dsq = 1
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
p=0.08
mp=0.2
mf=0.5
f=1.0
ff=1.6
levlookup=[[p,"p"],[mp,"mp"],[mf,"mf"],[f,"f"],[ff,"ff"]] #allows printing in plct function

#set_bpm sets bpm required adjusting note duration variables accordingly
define :set_bpm do |n|
  s=1.0/8*60/n.to_f
  return s
end

define :pl do |n,d,s,i,v,p=0| #play a note n= note, d duration,s tempo scalefactor, i synth,v amplitude, p pan
  if d !=:r
    with_synth i do
#use adsr enveloped to get desired note shape
      play n,attack: s*d*0.02,decay: s*d*0.02,attack_level: 0.6,sustain_level: 1,sustain: s*d*0.9,release: s*d*0.06,amp:v,pan: p
    end
  end
  sleep d*s #duration of note scaled for tempo
end

define :plarray do |na,da,s,i,v,p=0| #play arrays of notes and durations na,da arrays, s tempo scalefactor, i synth,v amplitude,p pan
  na.zip(da) do |n,d|
    pl(n,d,s,i,v,p)
  end
end

define :ct do |ptr,lev,slid=0,timetonext=0,s,flag| #controls level
  control ptr,amp: lev,amp_slide: slid*s #times scalefactor for tempo
  if flag > 0 then #lets you print level variations
puts "Part "+flag.to_s+" Level change:"
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

define :len do |d| #for checking duration of each part
  tl=0
  d.each do |d|tl += d
  end
  return tl
end

#define note and duration arrays for the five parts
n1=[:r,:a4,:a4,:b4,:a4,:e4,:a4,:b4,:cs5,:cs5,:d5,:cs5,:b4,:cs5,:e5,:d5,:cs5,:b4,:cs5,:e5,:d5,:cs5,:b4,:cs5,:b4,:a4,:gs4,:a4,:r]
d1=[3*b+m,b,m,m,c,c,cd,q,c,c,m,c,c,c,cd,q,m,c,m,cd,q,q,q,cd,q,m,c,m,m]
#b14
n1.concat [:r,:a4,:a4,:b4,:a4,:e4,:a4,:b4,:cs5,:cs5,:d5,:cs5,:a4,:b4,:cs5,:d5,:e5,:cs5,:d5,:cs5,:b4,:a4,:a4,:gs4,:fs4,:gs4,:a4,:r]
d1.concat [b+m,b,m,m,c,c,cd,q,c,c,m,c,q,q,q,q,q,q,m,c,cd,q,m,q,q,m,b,b*2]
#b26
n1.concat [:r,:a4,:gs4,:fs4,:gs4,:a4,:b4,:a4,:a4,:gs4,:fs4,:e4,:fs4,:fs4,:e4,:r,:b4,:a4,:gs4,:a4,:b4,:cs5,:b4,:cs5,:b4,:a4,:b4,:a4,:gs4,:fs4,:r,:d5,:cs5,:cs5,:b4,:a4]
d1.concat [m,b,m,cd,q,c,cd,q,m,c,c,c,c,c,b,b*2+m,b,m,cd,q,c,m,c,md,q,q,m,cd,q,m,m,md,c,m,b,b]
#b44
n1.concat [:r,:a4,:b4,:d5,:cs5,:b4,:a4,:b4,:cs5,:b4,:a4,:b4,:r,:d5,:cs5,:cs5,:b4,:a4,:r,:a4,:b4,:d5,:cs5,:b4,:a4,:fs4,:gs4,:a4,:gs4,:a4]
d1.concat [c,c,c,m,c,b,cd,q,c,q,q,m,b,md,c,m,b,m,c,c,c,m,c,cd,q,q,q,m,c,b+3*c+c*1.1+b*1.2+b*1.4] #rit at end
#end

n2=[:r,:e4,:e4,:fs4,:e4,:cs4,:fs4,:e4,:fs4,:gs4,:a4,:e4,:e4,:fs4,:e4,:fs4,:gs4,:a4,:gs4,:a4,:e4,:r,:a4,:a4,:b4,:a4,:a3,:cs4,:d4]
d2=[b*2,b,m,m,c,c,cd,q,c,c,m,m,c,cd,q,q,q,c,c,m,m,b,b,m,m,c,c,cd,q]
#b14
n2.concat [:e4,:fs4,:e4,:d4,:cs4,:cs4,:fs4,:e4,:e4,:a3,:e4,:cs4,:cs4,:d4,:e4,:e4,:fs4,:e4,:a4,:a4,:gs4,:fs4,:e4,:cs4,:b3,:cs4,:d4,:cs4,:b3,:a3,:b3,:a3]
d2.concat [c,cd,q,cd,q,c,m,c,c,m,md,c,cd,q,c,c,m,m,m,md,c,m,b,cd,q,q,q,m,q,q,m,b]
#b26
n2.concat [:r,:d4,:cs4,:b3,:cs4,:d4,:e4,:d4,:d4,:cs4,:b3,:cs4,:cs4,:b3,:fs4,:e4,:r,:e4,:d4,:cs4,:d4,:e4,:fs4,:e4,:fs4,:e4,:d4,:e4,:d4,:r,:a4,:gs4,:gs4,:fs4,:e4]
d2.concat [2*b,b,m,cd,q,c,cd,q,m,q,q,md,c,m,bd,b,m,b,m,cd,q,c,m,c,md,q,q,m,m,m,md,c,m,m,b] #m over
#b44 +m over
n2.concat [:d4,:e4,:fs4,:e4,:e4,:e4,:r,:a4,:gs4,:gs4,:fs4,:e4,:d4,:e4,:fs4,:e4,:a4,:gs4,:fs4,:d4,:e4,:fs4,:d4,:fs4,:e4,:e4,:r,:e4,:fs4,:a4,:gs4,:fs4,:e4,:d4,:e4,:fs4,:e4]
d2.concat [cd,q,c,c,m,m,c,m,c,m,m,m,cd,q,c,m,m,c,bd,cd,q,m,c,m,c,m,c,c,c,cd,q,q,q,c,c*1.1,b*1.2,b*1.4] #rit at end
#end

n3=[:a3,:a3,:b3,:a3,:e3,:a3,:b3,:cs4,:cs4,:d4,:cs4,:a4,:d4,:cs4,:d4,:e4,:cs4,:r,:e4,:e4,:fs4,:e4,:a4,:cs4,:d4,:e4,:e4,:fs4,:e4,:cs4,:d4,:e4,:a3]
d3=[b,m,m,c,c,cd,q,c,c,m,c,c,cd,q,c,c,b,b,b,m,m,c,c,cd,q,c,c,m,m,cd,q,c,c]
#b14
n3.concat [:cs4,:d4,:e4,:fs4,:e4,:d4,:d4,:cs4,:b3,:cs4,:a3,:gs3,:a3,:r,:a3,:cs4,:d4,:e4,:e4,:fs4,:e4,:d4,:cs4,:d4,:b3,:a3,:r,:e4,:d4,:cs4,:d4]
d3.concat [m,cd,q,c,cd,q,m,q,q,c,m,c,b,md,c,cd,q,c,c,m,cd,q,c,c,b,m,m,b,m,cd,q]
#b26
n3.concat [:e4,:fs4,:e4,:e4,:ds4,:e4,:a3,:r,:b3,:b3,:cs4,:d4,:d4,:a3,:e4,:d4,:cs4,:d4,:cs4,:cs4,:b3,:b3,:e3,:b3,:cs4,:cs4,:b3,:r,:a3,:gs3,:fs3,:gs3,:a3,:b3,:a3,:a3,:gs3,:a3,:b3,:cs4,:d4,:e4,:r,:d4,:cs4]
d3.concat [c,cd,q,m,c,m,m,b+c,c,c,c,c,c,b,b,m,c,cd,q,c,c,c,c,c,c,c,b,m,b,m,cd,q,c,cd,q,m,c,cd,q,cd,q,m,md,m,c]
#b44
n3.concat [:cs4,:b3,:a3,:e3,:b3,:cs4,:d4,:e4,:e3,:fs3,:gs3,:a3,:b3,:gs3,:a3,:b3,:a3,:a3,:gs3,:a3,:r,:d4,:cs4,:cs4,:b3,:a3,:a3,:b3,:d4,:cs4,:b3,:a3,:r,:cs4,:d4,:fs4,:e4,:d4,:cs4]
d3.concat [m,m,m,md,c,c,c,c,q,q,q,q,q,q,c,cd,q,m,c,m,b+c,m,c,m,m,c,c,c,m,c,m,m,c,c,c,m,c*1.1,b*1.2,b*1.4] #rit at end
#end

n4=[:r,:a3,:a3,:b3,:a3,:e3,:a3,:b3,:cs4,:cs4,:d4,:cs4,:cs4,:a4,:a4,:r,:a4]
d4=[5*b+m,b,m,m,c,c,cd,q,c,c,m,c,c,m,m,b,b]
#b14
n4.concat [:a3,:b3,:a3,:d3,:a3,:gs3,:fs3,:fs3,:e3,:a2,:r,:a3,:a3,:a3,:d3,:e3,:fs3,:gs3,:a3,:a3,:d3,:e3,:e3,:fs3,:d3,:e3,:r,:a3,:gs3,:fs3,:gs3,:a3,:fs3]
d4.concat [m,m,m,m,cd,q,c,c,m,m,c,c,c,c,q,q,q,q,m,m,m,c,c,c,c,b,m,b,m,cd,q,c,c]
#b26
n4.concat [:gs3,:a3,:gs3,:fs4,:e3,:fs3,:e3,:d3,:e3,:fs3,:gs3,:a3,:e3,:r,:a3,:gs3,:fs3,:gs3,:a3,:b3,:a3,:a3,:gs3,:fs3,:gs3,:a3,:e3,:r,:d3,:cs3,:b2,:fs3,:gs3,:a3,:a3,:e3,:d3,:fs3,:d3,:a3]#m over
d4.concat [c,cd,q,q,q,m,m,cd,q,c,c,m,m,b+m,b,m,cd,q,c,cd,q,m,q,q,m,m,b,2*b,b,m,m,cd,q,c,c,md,c,c,c,b]
#b44 +m over
n4.concat [:r,:a3,:gs3,:gs3,:fs3,:e3,:e3,:fs3,:d3,:cs3,:b2,:a2,:a3,:e3,:e3,:b3,:fs3,:fs3,:b2,:cs3,:d3,:e3,:fs3,:b2,:cs3,:d3,:a2,:e3,:e3,:fs3,:a3,:gs3,:fs3,:e3,:d3,:cs3,:d3,:a2]
d4.concat [md,m,c,m,m,m,m,c,m,c,m,m,m,c,c,m,m,m,cd,q,q,q,c,cd,q,c,c,c,c,c,cd,q,q,q,md,c*1.1,b*1.2,b*1.4] #rit at end

#parts dynamic data
a1=[mp,mf,p,mp,mf,f,ff] #levels
as1=[0,0,0,0,0,0,0]#slide times
ad1=[14*b,11*b,8*b,6*b,9*b,3*b,7*b] #sleep durations at level
a2=[mp,mf,p,mf,f,ff]
as2=[0,0,2*b,0,0,0]
ad2=[10*b,11*b,14*b,16*b+m,2*b+m,4*b]
a3=[mp,mf,p,mp,mf,f,ff]
as3=[0,0,0,0,0,0,0]
ad3=[7*b,16*b,8*b,5*b,14*b,4*b+m,m+3*b]
a4=[mp,mf,p,mp,mf,f,ff]
as4=[0,0,0,0,0,0,0]
ad4=[12*b,10*b,8*b,8*b,6*b,9*b+m,m+4*b]

comment do #uncomment for debugging checking lengths
#n and d lengths for each part should be the same
  puts n1.length
  puts d1.length
  puts n2.length
  puts d2.length
  puts n3.length
  puts d3.length
  puts n4.length
  puts d4.length
#total durations for all parts should be the same
  puts len(d1)
  puts len(d2)
  puts len(d3)
  puts len(d4)
#these duration totals should be the same. Note NOT adjusted for the rit, but as at end of piece this doesn't matter
#these durations will be less than that of the parts becuase the rit is not included
  puts len(ad1)
  puts len(ad2)
  puts len(ad3)
  puts len(ad4)
end
s=set_bpm(88) #set scaled multiplier for desired tempo 44 minims (or 88) crotchets / minute
with_transpose -2 do #change key form A Major to G major
  #set up and play with reverb
  with_fx :reverb,room: 0.8,mix: 0.6 do
    in_thread do
      with_fx :level do |amp1| #set dynamic level
        in_thread do
          plct(amp1,a1,as1,ad1,s,1)
        end
        plarray(n1,d1,s,i1,v1,-0.7)
      end
    end
    in_thread do
      with_fx :level do |amp2| #set dynamic level
        in_thread do
          plct(amp2,a2,as2,ad2,s,2)
        end
        plarray(n2,d2,s,i2,v2,0.7)
      end
    end
    in_thread do
      with_fx :level do |amp3| #set dynamic level
        in_thread do
          plct(amp3,a3,as3,ad3,s,3)
        end
        plarray(n3,d3,s,i3,v3,-0.5)
      end
    end
    with_fx :level do |amp4| #set dynamic level
      in_thread do
        plct(amp4,a4,as4,ad4,s,4)
      end
      plarray(n4,d4,s,i4,v4,0.5)
    end
  end
end