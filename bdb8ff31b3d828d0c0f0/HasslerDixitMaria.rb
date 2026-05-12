#Hans Leo Hassler (1564-1612) Dixit Maria ad Angelum coded for Sonic Pi by Robin Newman April 2015

#This piece utilises the fx level to alter the dynamic level of each part.
#Each part is wrapped inside a with_fx :level command and the level is controlled by a thread
#which adjusts the level amp: setting via a control function. Since the part playing is inside the fx loop
#its volume is controlled as it plays. The ct function alters the amp setting with a control command
#which includes the new level setting and a slide parameter to adjust how long teh change takes
#the plct function reads level settings from three list a,as and ad associated with each part, which contain
#the level values, the slide time and the delay time before the next level change command is activated.
#a parameter at the end of the plct command is set either to 0, or to the part number 1-4. In the latter case
#it will print out level changes and slide times so that you can follow the changes as the music plays


i1=i2=i3=i4=:pulse #synth for all parts

#part volumes set quite low
v1=0.4
v2=0.4
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
sf=0.3 #scale factor to adjust overall level for best performance
#dynamic settings
# p mp mf f ff
p=0.06*sf
mp=0.2*sf
mf=0.5*sf
f=1.0*sf
ff=1.3*sf
levlookup=[[p,"p"],[mp,"mp"],[mf,"mf"],[f,"f"],[ff,"ff"]] #allows printing in ct function

#set_bpm sets bpm required adjusting note duration variables accordingly
define :set_bpm do |n|
  s=1.0/8*60/n.to_f
  return s
end

define :pl do |n,d,s,i,v,p=0| #play a note n= note, d duration,s tempo scalefactor, i synth,v amplitude, p pan
  if d !=:r
    with_synth i do
      #use adsr enveloped to get desired note shape:
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

#define note and duration arrays for the four parts
n1=[:r,:f4,:f4,:f4,:g4,:a4,:f4,:a4,:g4,:a4,:bb4,:c5,:b4,:c5,:a4,:c5,:bb4,:a4,:g4,:g4,:r,:g4,:r,:g4,:r,:g4,:r,:a4]
d1=[4*b,m,c,c,m,c,c,cd,q,q,q,m,c,c,c,cd,q,c,c,m,c,  qd,sq,qd,sq,qd,sq  ,m]
#b13
n1.concat [:g4,:a4,:bb4,:a4,:g4,:f4,:f4,:e4,:f4,:r,:f4,:f4,:f4,:g4,:a4,:f4,:a4,:g4,:a4,:bb4,:c5,:b4,:c5,:a4,:f4,:e4,:d4,:e4,:f4,:g4,:g4]
d1.concat [c,c,cd,q,q,q,m,c,m,c,c,c,c,m,c,c,cd,q,q,q,m,c,c,m,cd,sq,sq,q,q,c,c]
#b21
n1.concat [:g4,:a4,:a4,:g4,:f4,:e4,:d4,:e4,:f4,:e4,:f4,:r,:a4,:a4,:g4,:g4,:fs4,:g4,:g4,:g4,:r,:c5,:c5,:bb4,:bb4,:a4,:a4,:a4,:a4,:r,:d5,:c5,:bb4,:a4,:g4,:c5]
d1.concat  [c,c,q,q,q,q,q,q,m,c,  c+qd,q    ,b,m,m,c,c,md,c,  c+qd,q    ,b,m,m,c,c,md,c,m,c,cd,q,q,q,c,c]
#b33
n1.concat [:c5,:bb4,:a4,:g4,:f4,:f4,:r,:d5,:d5,:c5,:bb4,:a4,:g4,:a4,:r,:bb4,:bb4,:a4,:g4,:f4,:e4,:e4,:c5,:c5,:bb4,:a4,:g4,:f4,:e4,:f4,:r]
d1.concat [q,q,q,q,m,m,c,c,c,c,c,c,m,m,3*b+c,c,c,c,c,c,m,c,c,c,c,c,m,m,c,    c+qd,q]
#b45
n1.concat [:a4,:a4,:g4,:g4,:fs4,:g4,:g4,:g4,:r,:c5,:c5,:bb4,:bb4,:a4,:a4,:a4,:a4,:r,:d5,:c5,:bb4,:a4,:g4,:c5,:c5,:bb4,:a4,:g4,:f4,:f4,:r,:d5,:d5,:c5]
d1.concat [b,m,m,c,c,md,c,  c+qd,q    ,b,m,m,c,c,md,c,m,c,cd,q,q,q,c,c,q,q,q,q,m,m,c,c,c,c]
#b57
n1.concat [:bb4,:a4,:g4,:a4,:r,:bb4,:bb4,:a4,:g4,:f4,:e4,:e4,:c5,:c5,:bb4,:a4,:g4,:f4,:e4,:f4,:r,:d5,:d5,:c5,:bb4,:a4,:bb4,:a4]
d1.concat [c,c,m,m,3*b+c,c,c,c,c,c,m,c,c,c,c,c,m,m,c,m,m+c,c*1.1,c*1.2,c*1.2,c*1.3,c*1.3,m*2,b*3]
#end

n2=[:r,:c4,:c4,:c4,:d4,:e4,:c4,:d4,:c4,:d4,:e4,:f4,:e4,:f4,:d4,:f4,:a4,:g4,:f4,:e4,:f4,:e4,:f4,:e4,:e4,:d4,:c4,:d4,:d4,:e4,:r,:e4,:r,:d4,:r,:e4,:r,:f4,:e4,:c4,:d4]
d2=[2*b,m,c,c,m,c,c,cd,q,q,q,m,c,c,c,md,c,cd,q,c,m,c,q,q,q,sq,sq,c,c,   q,q   ,qd,sq,qd,sq,qd,sq  ,q,q,q,q]
#b13
n2.concat [:e4,:c4,:d4,:d4,:d4,:c4,:bb3,:a3,:d4,:f4,:e4,:d4,:c4,:b3,:c4,:d4,:c4,:bb3,:c4,:a3,:d4,:r,:c4,:c4,:c4,:d4]
d2.concat [c,c,m,c,c,cd,q,c,c,cd,q,c,c,c,m,m,q,q,c,c,m,c,c,md,c,m]
#b21
n2.concat [:e4,:f4,:c4,:d4,:f4,:d4,:c4,:c4,:c4,:r,:f4,:f4,:e4,:d4,:c4,:d4,:d4,:e4,:r,:g4,:a4,:f4,:g4,:f4,:e4,:e4,:fs4,:a4,:g4,:f4,:e4,:d4,:d4,:e4,:d4,:e4]
d2.concat [c,c,c,c,c,c,cd,q,  c+qd,q    ,b,m,m,c,c,md,c,  c+qd,q    ,b,m,m,c,c,md,c,c,cd,q,q,q,c,c,cd,sq,sq]
#b33
n2.concat [:f4,:c4,:d4,:d4,:c4,:d4,:f4,:f4,:c4,:d4,:e4,:f4,:e4,:f4,:a4,:a4,:g4,:f4,:e4,:d4,:e4,:a4,:a4,:g4,:f4,:e4,:d4,:e4,:f4,:e4,:d4,:c4,:g4,:g4,:f4,:e4,:d4,:c4,:c4,:r]
d2.concat [c,c,c,c,m,c,c,cd,q,q,q,m,c,c,c,c,c,c,c,m,c,c,c,c,c,c,cd,q,c,c,m,c,c,cd,q,md,c,b,   c+qd,q]
#b45
n2.concat [:f4,:f4,:e4,:d4,:c4,:d4,:d4,:e4,:r,:g4,:a4,:f4,:g4,:f4,:e4,:e4,:fs4,:a4,:g4,:f4,:e4,:d4,:d4,:e4,:d4,:e4,:f4,:c4,:d4,:d4,:c4,:d4,:f4,:f4,:c4]
d2.concat [b,m,m,c,c,md,c,  c+qd,q    ,b,m,m,c,c,md,c,c,cd,q,q,q,c,c,cd,sq,sq,c,c,c,c,m,c,c,cd,q]
#b57
n2.concat [:d4,:e4,:f4,:e4,:f4,:a4,:a4,:g4,:f4,:e4,:d4,:e4,:a4,:a4,:g4,:f4,:e4,:d4,:e4,:f4,:e4,:d4,:c4,:g4,:g4,:f4,:e4,:d4,:c4,:c4,:r,:a4,:a4,:g4,:f4,:e4,:d4,:e4,:f4,:f4]
d2.concat [q,q,m,c,c,c,c,c,c,c,m,c,c,c,c,c,c,cd,q,c,c,m,c,c,cd,q,md,c,m,m,c,c,c,c,c+q*1.1,q*1.1,c*1.2,c*1.2,m*1.3+m*2,b*3]
#end

n3=[:f3,:f3,:f3,:g3,:a3,:f3,:a3,:g3,:a3,:bb3,:c4,:b3,:c4,:a3,:bb3,:a3,:bb3,:c4,:d4,:a3,:bb3,:c4,:f3,:bb3,:c4,:f4,:d4,:c4,:c4,:c4,:g3,:g3,:c3,:r,:c4,:r,:b3,:r,:c4,:r,:f3]
d3=[m,c,c,m,c,c,cd,q,q,q,m,c,c,c,cd,q,q,q,q,q,c,c,c,c,md,c,m,m,m,m,cd,q,   q,q   ,qd,sq,qd,sq,qd,sq   ,m]
#b13
n3.concat [:c4,:a3,:g3,:f3,:g3,:a3,:bb3,:a3,:g3,:g3,:f3,:bb3,:a3,:bb3,:a3,:r,:f3,:f3,:f3,:g3,:a3,:f3,:a3,:g3,:a3,:bb3,:c4,:b3]
d3.concat [c,c,q,q,q,q,cd,q,c,c,c,c,c,c,m,b+c,c,c,c,m,c,c,cd,q,q,q,m,c]
#b21
n3.concat [:c4,:bb3,:a3,:a3,:bb3,:a3,:g3,:g3,:a3,:r,:c4,:c4,:c4,:c4,:b3,:c4,:b3,:a3,:b3,:b3,:c4,:r,:e4,:e4,:f4,:d4,:d4,:d4,:cs4,:b3,:cs4,:cs4,:d4,:d4,:c4,:bb3,:a3,:g3,:c4,:c4,:bb3]
d3.concat [cd,q,c,c,cd,q,c,c,  c+qd,q         ,m,md,c,m,c,m,q,q,c,c,  c+qd,q    ,m,m,m,m,c,m,q,q,c,c,m,cd,q,q,q,c,c,q,q]
#b33
n3.concat [:a3,:g3,:f3,:g3,:a3,:f3,:bb3,:a3,:bb3,:bb3,:bb3,:a3,:g3,:f3,:c4,:f3,:c4,:c4,:g3,:a3,:bb3,:c4,:b3,:a3,:b3,:c4,:c4,:g3,:a3,:bb3,:d4,:d4,:c4,:bb3,:a3,:g3,:c3,:e3,:a3,:bb3,:c4,:bb3,:a3,:g3,:f3,:g3,:a3,:r]
d3.concat [q,q,q,q,q,q,m,c,c,c,c,c,c,c,m,c,c,cd,q,q,q,cd,sq,sq,c,c,m,c,m,c,c,c,c,c,c,m,c,c,c,c,c,c,cd,sq,sq,m,   c+qd,q]
#b45
n3.concat [:c4,:c4,:c4,:c4,:b3,:c4,:b3,:a3,:b3,:b3,:c4,:r,:e4,:e4,:f4,:d4,:d4,:d4,:cs4,:b3,:cs4,:cs4,:d4,:d4,:c4,:bb3,:a3,:g3,:c4,:c4,:bb3,:a3,:g3,:f3,:g3,:a3,:f3,:bb3,:a3,:bb3,:bb3,:bb3,:a3]
d3.concat [m,md,c,m,c,m,q,q,c,c,  c+qd,q    ,m,m,m,m,c,m,q,q,c,c,m,cd,q,q,q,c,c,q,q,q,q,q,q,q,q,m,c,c,c,c,c]
#b57
n3.concat [:g3,:f3,:c4,:f3,:c4,:c4,:g3,:a3,:bb3,:c4,:b3,:a3,:b3,:c4,:c4,:g3,:a3,:bb3,:d4,:d4,:c4,:bb3,:a3,:g3,:c3,:e3,:a3,:bb3,:c4,:bb3,:a3,:g3,:f3,:g3,:a3,:bb3,:c4,:r,:f4,:f4,:e4,:d4,:c4,:d4,:c4]
d3.concat [c,c,m,c,c,cd,q,q,q,cd,sq,sq,c,c,m,c,m,c,c,c,c,c,c,m,c,c,c,c,c,c,cd,sq,sq,m,cd,q,m,c,c*1.1,c*1.2,c*1.2,c*1.3,c*1.3,m*2,b*3]
#end

n4=[:r,:f3,:f3,:f3,:g3,:a3,:f3,:a3,:g3,:a3,:bb3,:c4,:b3,:c4,:r]
d4=[6*b,m,c,c,m,c,c,cd,q,q,q,m,c,m,b]
#b13
n4.concat [:r,:bb2,:bb2,:bb2,:c3,:d3,:bb2,:d3,:c3,:d3,:e3,:f3,:e3,:f3,:r,:f3,:f3,:a3,:g3]
d4.concat [m,m,c,c,m,c,c,cd,q,q,q,m,c,b,b+m,m,c,c,m]
#b21
n4.concat [:c4,:f3,:f3,:e3,:d3,:c3,:bb2,:c3,:f3,:r,:f3,:f3,:c3,:g3,:a3,:g3,:g3,:c3,:r,:c4,:f3,:bb3,:g3,:d3,:a3,:a3,:d3,:r]
d4.concat [c,c,q,q,q,q,m,m,  c+qd,q    ,b,m,m,c,c,md,c,  c+qd,q    ,b,m,m,c,c,md,c,m,bd]
#b33
n4.concat [:f3,:e3,:d3,:bb2,:f3,:bb2,:r,:f3,:f3,:e3,:d3,:c3,:g3,:c3,:f3,:f3,:e3,:d3,:c3,:bb2,:bb2,:c3,:c3,:c3,:c3,:c3,:c3,:f3,:r]
d4.concat [cd,q,c,c,m,m,b+md,c,c,c,c,c,m,c,c,c,c,c,c,b,m,m,m,m,m,m,m,   c+qd,q]
#b45
n4.concat [:f3,:f3,:c3,:g3,:a3,:g3,:g3,:c3,:r,:c4,:f3,:bb3,:g3,:d3,:a3,:a3,:d3,:r,:f3,:e3,:d3,:bb2,:f3,:bb2,:r]
d4.concat [b,m,m,c,c,md,c,  c+qd,q    ,b,m,m,c,c,md,c,m,bd,cd,q,c,c,m,m,m]
#b57
n4.concat [:r,:f3,:f3,:e3,:d3,:c3,:g3,:c3,:f3,:f3,:e3,:d3,:c3,:bb2,:bb2,:c3,:c3,:c3,:c3,:c3,:c3,:f3,:f3,:f3,:e3,:d3,:c3,:bb2,:f3,:bb2,:f3]
d4.concat [b+c,c,c,c,c,c,m,c,c,c,c,c,c,b,m,m,m,m,m,m,m,c,c,c,c,c+q*1.1,q*1.1,m*1.2+1.3*c,c*1.3,m*2,b*3]
#end

#parts dynamic data
a1= [mp,   mf,      p,    mp,   mf,     mp,     mf,   p,    mf,   f,      mp,  mf,    f,    ff    ] #levels
as1=[0,    3*b,     0,    0,    6*b,    0,      b,    0,    6*b,  6*b,    0,   0,     6*c,   m    ] #slide times
ad1=[6*b,  15*b+m,  4*b,  4*b,  7*b+c,  3*b+c,  3*b,  4*b,  4*b,  6*b,    3*b, 4*b+m, 6*c,   2*b  ] #sleep durations at level

a2= [mp,   mf,      p,    mp,   mf,     mp,     mf,   p,    mf,   f,      mp,  mf,    f,     ff   ]
as2=[0,    3*b,     0,    0,    6*b,    0,      b,    0,    6*b,  7*b,    0,   4*b,   b,     m    ]
ad2=[6*b,  15*b+m,  4*b,  4*b,  7*b+c,  3*b+c,  3*b,  4*b,  4*b,  7*b+c,  7*c, 4*b,   2*b,   2*b  ]

a3= [mp,   mf,      p,    mp,   mf,     mp,     mf,   p,    mf,   f,      mp,  mf,    f,     ff   ]
as3=[0,    3*b,     0,    0,    6*b,    0,      b,    0,    6*b,  7*b,    0,   5*b,   b,     m    ]
ad3=[6*b,  15*b+m,  4*b,  4*b,  7*b+c,  3*b+c,  3*b,  4*b,  4*b,  7*b+c,  7*c, 5*b,   b,     2*b  ]
 
a4= [mp,   mf,      p,    mp,   mf,     mp,     mf,   p,    mf,   f,      mp,  mf,    f,     ff   ]
as4=[0,    3*b,     0,    0,    6*b,    0,      b,    0,    6*b,  7*b,    0,   4*b+c, b,     m    ]
ad4=[6*b,  15*b+m,  4*b,  4*b,  7*b+c,  3*b+c,  3*b,  4*b,  4*b,  7*b+c,  7*c, 4*b+c, b+3*c, 2*b  ]

uncomment do #uncomment for debugging checking lengths
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
  #these durations will be less than that of the parts because the rit is not included
  puts len(ad1)
  puts len(ad2)
  puts len(ad3)
  puts len(ad4)
end
s=set_bpm(130) #set scaled multiplier for desired tempo 130 crotchets / minute
with_transpose 2 do #change key form F Major to G major
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