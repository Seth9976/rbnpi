#The holly and the Ivy, transcribed by Robin Newman December 2014
use_synth :tri
s=0 #define s as global here
define :setbpm do |n| #set correct value of s in here
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

n1=[:ab4,:ab4,:ab4,:ab4,:f5,:eb5,:c5,:ab4,:ab4,:ab4,:ab4,:f5,:eb5,:eb5,:db5,:c5,:bb4,:ab4,:c5,:c5,:f4,:f4,:eb4,:ab4,:bb4,:c5,:db5,:c5,:bb4,:ab4,:r,:ab4]
d1=[c,q,q,c,c,c,cd,q,q,q,c,c,m,q,q,q,q,c,q,q,q,q,c,q,q,q,q,c,c,m,q,q]
n2=[:eb4,:c4,:db4,:eb4,:f4,:g4,:ab4,:eb4,:f4,:f4,:eb4,:f4,:ab4,:g4,:eb4,:eb4,:eb4,:ab4,:eb4,:eb4,:db4,:db4,:db4,:c4,:db4,:eb4,:eb4,:f4,:bb3,:eb4,:f4,:db4]
d2=[c,q,q,c,c,c,cd,q,q,q,c,c,c,c,c,q,q,c,q,q,q,q,c,q,q,q,q,c,c,c,c,c]
n3=[:c4,:ab3,:bb3,:c4,:db4,:bb3,:c4,:c4,:c4,:c4,:eb4,:db4,:c4,:bb3,:bb3,:ab3,:ab3,:c4,:bb3,:ab3,:ab3,:ab3,:bb3,:ab3,:ab3,:ab3,:f3,:g3,:ab3,:ab3]
d3=[c,q,q,c,c,c,cd,q,q,q,c,q,q,m,c,q,q,c,q,q,q,q,c,c,q,q,c,c,m,c]
n4=[:ab3,:ab3,:ab3,:ab3,:ab3,:ab3,:ab3,:ab3,:f3,:f3,:c3,:db3,:eb3,:g3,:ab3,:g3,:f3,:c3,:c3,:db3,:f3,:g3,:f3,:eb3,:eb3,:db3,:db3,:c3,:db3,:f3]
d4=[c,q,q,c,c,c,cd,q,q,q,c,c,m,c,q,q,c,q,q,q,q,c,c,q,q,c,c,c,c,c]
nv1=[:ab4,:ab4,:ab4,:f5,:eb5,:c5,:ab4,:ab4,:ab4,:ab4,:ab4,:f5,:eb5,:eb5,:db5,:c5,:bb4,:ab4,:c5,:f4,:f4,:eb4,:ab4,:bb4,:c5,:db5,:c5,:bb4,:ab4]
dv1=[q,q,c,c,c,c,q,q,q,q,c,c,m,q,q,q,q,c,c,q,q,c,q,q,q,q,c,c,m]
nv2=[:ab4,:ab4,:ab4,:ab4,:bb4,:ab4,:ab4,:ab4,:ab4,:ab4,:f4,:eb4,:f4,:ab4,:g4,:ab4,:eb4,:eb4,:eb4,:eb4,:eb4,:db4,:c4,:bb3,:eb4,:f4,:eb4,:eb4,:eb4,:ab4,:g4,:f4,:eb4]
dv2=[q,q,c,q,q,m,q,q,q,q,q,q,q,q,c,c,c,q,q,c,c,q,q,c,q,q,q,q,q,q,q,q,m]
nv2b=[:r,:f4,:g4]
dv2b=[m,q,q]
nv3=[:c4,:db4,:eb4,:db4,:eb4,:eb4,:eb4,:db4,:c4,:ab3,:db4,:c4,:bb3,:ab3,:bb3,:ab3,:ab3,:ab3,:ab3,:ab3,:ab3,:g3,:ab3,:ab3,:ab3,:bb3,:c4,:db4,:c4]
dv3=[q,q,c,c,m,q,q,q,q,c,q,q,c,c,c,q,q,c,c,q,q,c,q,q,q,q,c,c,m]
nv4=[:ab3,:bb3,:c4,:db4,:c4,:ab3,:g3,:g3,:f3,:eb3,:db3,:c3,:bb2,:eb3,:f3,:g3,:ab3,:ab3,:c3,:bb2,:ab2,:db3,:db3,:db3,:c3,:db3,:eb3,:eb3,:eb3,:eb3,:ab2]
dv4=[q,q,c,c,c,c,q,q,q,q,q,q,c,c,c,c,q,q,c,q,q,q,q,c,q,q,q,q,c,c,m]
define :refrain do
in_thread do
pl(nv1,dv1)
end
in_thread do
pl(nv2,dv2)
end
in_thread do
pl(nv2b,dv2b)
end
in_thread do
pl(nv3,dv3)
end
pl(nv4,dv4)
end
define :verse do
in_thread do
pl(n1,d1)
end
in_thread do
pl(n2,d2)
end
in_thread do
pl(n3,d3)
end
pl(n4,d4)
end
verse
refrain