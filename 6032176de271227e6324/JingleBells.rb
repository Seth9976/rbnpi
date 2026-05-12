#Jingle Bells transcribed by Robin Newman December 2014
use_synth :pretty_bell
s=0 #define here to make it global
define :setbpm do |n| #and sets to correct value
  s = (1.0 / 8) *(60.0/n.to_f)
end

setbpm(120)

dsq = 1 * s #note length definitions
sq = 2 * s
q= 4 * s
qd = 6 * s
c = 8 * s
cd = 12 * s
m = 16 * s
md = 24 * s
b = 32 * s
bd = 48 * s
ppp = 0.1
pp = 0.2
p = 0.3
mf = 0.4
f = 0.6
ff = 0.8

define :pl do |notes,durations,vol=0.8|
  notes.zip(durations).each do |n,d|
    play n,sustain: 0.9*d,release: 0.1*d,amp: vol
    sleep d
  end
end

n1=[:eb4,:c5,:bb4,:ab4,:eb4,:c5,:bb4,:ab4,:f4,:db5,:c5,:bb4,:g4,:eb5,:d5,:eb5,:g5,:f5,:eb5,:db5,:c5,:bb4,:ab4,:g4]
d1=[q,q,q,q,m+q,q,q,q,m+q,q,q,q,q,q,q,q,sq,sq,sq,sq,sq,sq,sq,sq]
n2=[:c4,:r,:c4,:r,:db4,:r]
d2=[q,cd,m+q,cd,m+q,b+q]
n3=[:ab2,:ab3,:eb3,:ab3,:ab2,:ab3,:eb3,:ab3,:ab2,:ab3,:eb3,:ab3,:db3,:ab3,:f3,:ab3,:db3,:bb3,:f3,:bb3,:eb3,:bb3,:g3,:bb3,:eb3,:eb4,:g3,:bb3]
d3=[q]*4*7
n4=[:ab4,:ab4,:ab4,:db4,:db4,:eb4,:eb4]
d4=[m]*7

in_thread do
pl(n1,d1,1)
end
in_thread do
pl(n2,d2,0.8)
end
in_thread do
pl(n3,d3,0.3)
end
pl(n4,d4,0.3)

play [:ab3,:c4,:ab4],sustain: c
sleep m

nt1=[:c5,:c5,:c5,:c5,:c5,:c5,:c5,:eb5,:ab4,:bb4,:c5,:db5,:db5,:db5,:db5,:db5,:c5,:c5,:c5,:c5,:c5,:bb4,:bb4,:c5,:bb4,:eb5]
dt1=[q,q,c,q,q,c,q,q,qd,sq,m,q,q,qd,sq,q,q,q,sq,sq,q,q,q,q,c,c]
nt1.concat [:c5,:c5,:c5,:c5,:c5,:c5,:c5,:eb5,:ab4,:bb4,:c5,:db5,:db5,:db5,:db5,:db5,:c5,:c5,:c5,:c5,:eb5,:eb5,:f5,:g5,:ab5]
dt1.concat [q,q,c,q,q,c,q,q,qd,sq,m,q,q,qd,sq,q,q,q,sq,sq,q,q,q,q,c,c]
nt2=[:ab3,:g3,:f3,:eb3,:ab3,:g3,:f3,:eb3,:ab3,:g3,:f3,:eb3,:ab3,:g3,:f3,:eb3]
nt2.concat [:bb3,:ab3,:g3,:f3,:bb3,:ab3,:g3,:f3,:d3,:eb3,:f3,:g3,:eb3]
nt2.concat [:ab3,:g3,:f3,:eb3,:ab3,:g3,:f3,:eb3,:ab3,:g3,:f3,:eb3,:ab3,:g3,:f3,:eb3]
nt2.concat [:bb3,:ab3,:g3,:f3,:bb3,:ab3,:g3,:f3,:eb3,:eb3,:ab3,:ab2]
dt2=[q]*16
dt2.concat [q,q,q,q,q,q,q,q,m,q,q,q,q]+[q]*16+[q,q,q,q,q,q,q,q,c,c,c,c]

in_thread do
pl(nt1,dt1,0.8)
end
pl(nt2,dt2,0.6)

