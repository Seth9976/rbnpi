#Salvator Mundi by Thomas Tallis, coded by Robin Newman, March 2015
#score from http://www1.cpdl.org/wiki/images/a/a4/Tallis_Salvator.pdf

s=1.0/8*60/180 #sets tempo scale factor for 90 minim/min
i1=i2=:tri #synth for top two parts
i3=i4=i5=:saw #synth for bottom three parts
#part volumes to balance sound
v1=1
v2=0.8
v3=v4=0.5
v5=0.7
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

p=2*b #pause

define :pl do |n,d,s,i,v| #play a note n= note, d duration,s tempo scalefactor, i synth,v amplitude
  if d !=:r
    with_synth i do
      play n,sustain: s*d*0.9,release: s*d*0.1,amp:v
    end
  end
  sleep d*s
end

define :plarray do |na,da,s,i,v| #play arrays of notes and durations na,da arrays, s tempo scalefactor, i synth,v amplitude
  na.zip(da) do |n,d|
    pl(n,d,s,i,v)
  end
end
#define note and duration arrays for the five parts
n1=[:g4,:d5,:a4,:bb4,:g4,:d5,:c5,:bb4,:a4,:f4,:g4,:bb4,:a4,:f4,:g4,:eb4,:d4,:d4,:e4,:f4,:g4,:a4,:r,:a4,:d5,:a4,:bb4,:g4,:d5]
d1=[b,bd,m,m,m,b,b,bd,b,m,m,md,c,m,m,m,m,md,c,c,c,b,b+b+m,m,bd,m,m,m,b]
#b12
n1.concat [:c5,:bb4,:a4,:f4,:g4,:bb4,:a4,:f4,:g4,:eb4,:d4,:d4,:e4,:f4,:g4,:a4,:g4,:f4,:r,:f4,:g4,:bb4]
d1.concat [b,bd,b,m,m,md,c,m,m,m,m,md,c,c,c,b,b,b,b*2,b,m,b]
#b20
n1.concat [:a4,:g4,:g4,:c4,:g4,:g4,:a4,:c5,:bb4,:a4,:g4,:fs4,:g4,:g4,:a4,:c5,:bb4,:a4,:g4,:f4,:e4]
d1.concat [md,c,b,m,m,m,m,b,m,m,b,m,m,m,m,b,m,m,c,q,q]
#b26
n1.concat [:f4,:g4,:a4,:r,:a4,:a4,:a4,:a4,:a4,:f4,:g4,:a4,:d4,:d5,:d5,:d5,:d5,:d5,:bb4,:c5]
d1.concat [c,c,m,m,m,m,m,m,m,md,c,b,m,m,m,m,m,m,md,c]
#b31
n1.concat [:d5,:g4,:c5,:bb4,:a4,:g4,:a4,:a4,:a4,:g4,:f4,:d4,:e4,:d4,:e4,:f4,:g4,:a4,:g4,:g4,:f4,:d4,:a4,:e4,:f4,:g4,:a4]
d1.concat [b,m,m,m,c,c,m,m,m,m,m,m,b,md,c,c,c,md,c,m,c,c,b,m,m,m,b]
#b38
n1.concat [:r,:d5,:a4,:c5,:d5,:bb4,:a4,:g4,:f4,:e4,:d4,:e4,:d4,:e4,:f4,:g4,:a4,:g4,:g4,:f4,:e4,:d4,:d5,:c5,:bb4,:bb4,:a4,:g4,:g4,:fs4,:g4]
d1.concat [m,m,m,m,m,m,bd,m,m,c,c,b,md,c,c,c,md,c,b,b,md,c,b,md,c,b,md,c,b,m,b*6+p]

n2=[:r,:g3,:d4,:a3,:bb3,:g3,:d4,:c4,:bb3,:a3,:f3,:bb3,:a3,:g3,:a3,:bb3,:c4,:a3,:bb3,:a3,:d4,:bb3,:eb4,:d4,:c4,:bb3,:a3]
d2=[b*2*3,b,bd,m,m,m,b,b,b,b*2,m,m,c,c,c,c,m,m,b,m,m,m,m,c,c,c,c]
#b12
n2.concat [:g3,:r,:g3,:d4,:a3,:bb3,:g3,:d4,:c4,:bb3,:a3,:c4,:bb3,:a3,:bb3,:a3,:bb3,:a3,:g3]
d2.concat [b,m,m,bd,m,m,m,b,b,b,bd,m,b,m,b,m,bd,m,b]
#b20
n2.concat [:d4,:r,:bb3,:c4,:eb4,:eb4,:d4,:c4,:a3,:d4,:r,:c4,:d4,:f4,:eb4,:d4,:c4,:a3,:d4,:r,:c4]
d2.concat [b,m,m,m,md,c,m,m,m,b,m,m,m,m,m,m,m,m,b,m,m]
#b26
n2.concat [:d4,:f4,:e4,:d4,:cs4,:d4,:a3,:a3,:a3,:d4,:d4,:d4,:c4,:bb3,:a3,:g3,:g4]
d2.concat [m,m,m,b,m,m,b,m,m,b,m,md,c,md,c,m,m]
#b31
n2.concat [:g4,:g4,:g4,:g4,:g4,:fs4,:f4,:e4,:d4,:d4,:cs4,:d4,:bb3,:a3,:bb3,:c4,:d4,:f4,:e4,:d4,:d4,:cs4]
d2.concat [m,m,m,m,b,m,b,md,c,b,m,m,m,b,m,m,b,m,md,c,b,m]
#b38
n2.concat [:d4,:c4,:bb3,:a3,:g3,:f3,:d4,:a3,:c4,:d4,:bb3,:a3,:bb3,:g3,:d4,:g3,:a3,:bb3,:c4,:c4,:bb3,:g3,:a3,:g3,:f3,:a3,:bb3,:c4,:d4,:r,:d4,:g3,:c4,:bb3,:a3,:g3]
d2.concat [bd,m,m,c,c,m,m,m,m,m,m,b,m,m,bd,m,md,c,m,md,c,m,bd,m,m,m,m,m,b,m,m,m,m,md,c,b*3+p]

n3=[:r,:d4,:g4,:d4,:eb4,:c4,:g4,:f4,:d4,:d4,:c4,:bb3,:a3,:g3,:d3,:d4,:c4,:d4,:f4,:eb4,:d4,:r,:d4,:g4,:d4]
d3=[b*2,b,bd,m,m,m,b,bd,m,md,c,m,m,bd,b,b,m,bd,m,b,b,m,m,bd,m]
#b12
n3.concat [:eb4,:c4,:g4,:f4,:d4,:d4,:c4,:bb3,:a3,:g3,:d3,:d4,:c4,:d4,:r,:bb3,:c4,:eb4,:d4,:d4,:c4,:bb3]
d3.concat [m,m,b,bd,m,md,c,m,m,bd,b,b,m,b,m,m,m,b,b,m,m,m]
#b20
n3.concat [:f4,:eb4,:d4,:g3,:c4,:bb3,:g3,:r,:a3,:bb3,:c4,:d4,:g3,:r,:a3,:c4,:d4,:f4,:bb3,:c4,:d4,:g3]
d3.concat [md,c,b,m,m,m,m,m,m,md,c,m,m,m,m,m,m,b,md,c,m,m]
#b26
n3.concat [:r,:f3,:f3,:c4,:a3,:a3,:g3,:fs3,:d4,:d4,:d4,:d4,:e4,:f4,:d4,:g4,:fs4,:g4,:d4,:d4]
d3.concat [m,c,c,m,m,md,c,m,m,c,c,md,c,md,c,b,m,m,b,m]
#b31
n3.concat [:d4,:bb3,:bb3,:g3,:d4,:d4,:a3,:c4,:d4,:bb3,:a3,:bb3,:g3,:d4,:g3,:a3,:c4,:a3,:bb3,:c4,:bb3,:a3,:g3]
d3.concat [m,m,m,b,b,m,m,m,m,m,b,m,m,bd,m,b,b,m,m,c,c,c,c]
#b38
n3.concat [:f3,:bb3,:a3,:r,:d4,:f4,:e4,:d4,:d4,:cs4,:d4,:bb3,:a3,:bb3,:c4,:d4,:a4,:r,:e3,:a3,:bb3,:c4,:d4,:bb3,:f4,:d4,:e4,:f4,:eb4,:d4,:c4,:b3,:bb3,:c4,:eb4,:d4,:c4,:c4,:b3,:a3,:b3]
d3.concat [m,m,b,m,b,b,md,c,b,m,m,m,b,m,m,m,m,m,m,m,m,b,m,m,b,m,m,c,c,c,c,m,m,m,b,md,c,b,c,c,b+p]

n4=[:r,:d3,:g3,:d3,:eb3,:c2,:g3,:f3,:e3,:d3,:g3,:f3,:g3,:eb3,:f3,:f3,:g3,:bb3,:a3,:g3,:f3]
d4=[b*2*4,b,bd,m,m,m,b,bd,m,m,b,m,m,m,b,b,m,md,c,c,c]
#b12
n4.concat [:eb3,:d3,:r,:d3,:g3,:d3,:eb3,:c3,:g3,:f3,:e3,:d3,:f3,:eb3,:c3,:f3,:r]
d4.concat [b,b,b,b,bd,m,m,m,b,bd,m,bd,m,m,m,b,b*2]
#b20
n4.concat [:f3,:g3,:bb3,:a3,:g3,:g3,:fs3,:g3,:g3,:a3,:c4,:bb3,:a3,:g3,:g3,:fs3,:g3,:g3,:a3,:c4]
d4.concat [b,m,b,md,c,b,m,m,m,m,m,m,md,c,b,m,m,m,m,m]
#b26
n4.concat [:bb3,:a3,:g3,:f3,:e3,:d3,:f3,:f3,:d3,:e3,:f3,:g3,:a3,:bb3,:a3,:g3,:bb3,:bb3,:g3,:a3]
d4.concat [m,md,c,m,b,m,m,m,c,c,c,c,m,b,b,m,m,m,c,c,]
#b31
n4.concat [:bb3,:c4,:d4,:eb4,:d4,:c4,:bb3,:a3,:r,:g3,:d3,:f3,:g3,:e3,:d3,:e3,:f3,:g3,:a3,:g3,:f3,:d3,:e3]
d4.concat [c,c,m,b,m,c,c,b,b*3+m,m,m,m,m,m,c,c,c,c,md,c,m,m,b]
#b38
n4.concat [:d3,:g3,:f3,:e3,:d3,:r,:g3,:d3,:f3,:g3,:e3,:d3,:e3,:f3,:g3,:a3,:g3,:f3,:d3,:e3,:d3,:d4,:c4,:bb3,:g3,:a3,:g3,:f3,:eb3,:c3,:g3,:f3,:eb3,:d3]
d4.concat [m,m,m,m,b,b*4+m,m,m,m,m,m,c,c,c,c,md,c,m,m,b,m,b,m,m,m,b,md,c,m,m,md,c,b,b*2+p]

n5=[:r,:g2,:d3,:a2,:bb2,:g2,:d3,:c3,:bb2,:d3,:f3,:eb3,:d3,:bb2]
d5=[b*2*6,b,bd,m,m,m,b,b,b,m,m,md,c,b]
n5.concat [:c3,:g2,:r,:g2,:d3,:a2,:bb2,:g2,:d3,:c3,:bb2,:d3,:f3,:eb3]
d5.concat [b,b,b*2*2+b,b,bd,m,m,m,b,b,b,m,m,b]
#b20
n5.concat [:d3,:bb2,:g2,:c3,:g2,:bb2,:a2,:a2,:g2,:g3,:f3,:eb3,:d3,:d3,:c3,:bb2,:a2,:g2,:g3,:f3,:eb3]
d5.concat [b,m,m,b,m,m,md,c,m,m,m,m,m,m,m,m,b,m,m,m,m]
#b26
n5.concat [:d3,:c3,:d3,:a2,:r,:d3,:d3,:d3,:d3,:d3,:bb2,:c3,:d3,:g2,:g3,:g3,:g3]
d5.concat [b,m,m,b,m,m,m,m,m,m,md,c,b,m,m,m,m]
#b31
n5.concat [:g3,:g3,:eb3,:f3,:g3,:d3,:r,:d3,:a2,:c3,:d3,:bb2,:a2]
d5.concat [m,m,md,c,b,b,b*2*3+m,m,m,m,m,m,b]
#b38
n5.concat [:bb2,:g2,:d3,:a2,:bb2,:c3,:d3,:r,:d3,:a2,:c3,:d3,:bb2,:a2,:d3,:g3,:d3,:f3,:g3,:e3,:d3,:g2,:r,:c3,:g2,:bb2,:c3,:g2]
d5.concat [m,m,m,m,md,c,b,b*2*3+m,m,m,m,m,m,b,m,m,m,m,m,m,b,b,m,m,m,m,b,b*2+p]

#set up and play with reverb
with_fx :reverb,room: 0.8,mix: 0.4 do
  in_thread do
    plarray(n1,d1,s,i1,v1)
  end
  in_thread do
    plarray(n2,d2,s,i2,v2)
  end
  in_thread do
    plarray(n3,d3,s,i3,v3)
  end
  in_thread do
    plarray(n4,d4,s,i4,v4)
  end
  plarray(n5,d5,s,i5,v5)
end