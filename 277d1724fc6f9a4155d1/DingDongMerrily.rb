#Ding Dong Merrily on High transcribed by Robin Newman December 2014
use_synth :tri
s=0 #define here to set as global
define :setbpm do |n| #redefine correct value of s in here
  s = (1.0 / 8) *(60.0/n.to_f)
end
setbpm(180)

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

define :pl do |notes,durations,vol=0.8|
  notes.zip(durations).each do |n,d|
    play n,sustain: 0.9*d,release: 0.1*d,amp: vol
    sleep d
  end
end

n1=[:bb4,:bb4,:c5,:bb4,:a4,:g4,:f4,:f4,:g4,:bb4,:bb4,:a4,:bb4,:bb4,:bb4,:bb4,:c5,:bb4,:a4,:g4,:f4,:f4,:g4,:bb4,:bb4,:a4,:bb4,:bb4]
d1=[c,c,q,q,q,q,md,c,c,c,c,c,m,m,c,c,q,q,q,q,md,c,c,c,c,c,m,m]
n2=[:f4,:f4,:g4,:g4,:eb4,:eb4,:c4,:f4,:f4,:eb4,:c4,:f4,:f4,:f4,:f4,:f4,:g4,:g4,:eb4,:eb4,:c4,:f4,:f4,:eb4,:c4,:f4,:f4,:f4]
d2=[c,c,q,q,q,q,md,c,c,c,c,c,m,m,c,c,q,q,q,q,md,c,c,c,c,c,m,m]
n3=[:d4,:bb3,:g3,:g3,:c4,:bb3,:a3,:bb3,:bb3,:bb3,:c4,:c4,:d4,:d4,:d4,:bb3,:g3,:g32,:c4,:bb3,:a3,:bb3,:bb3,:bb3,:c4,:c4,:d4,:d4]
d3=[c,c,q,q,q,q,md,c,c,c,c,c,m,m,c,c,q,q,q,q,md,c,c,c,c,c,m,m]
n4=[:bb2,:d3,:eb3,:eb3,:c3,:c3,:f3,:d3,:eb3,:g3,:f3,:f3,:bb2,:bb2,:bb2,:d3,:eb3,:eb3,:c3,:c3,:f3,:d3,:eb3,:g3,:f3,:f3,:bb2,:bb2]
d4=[c,c,q,q,q,q,md,c,c,c,c,c,m,m,c,c,q,q,q,q,md,c,c,c,c,c,m,m]
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
nc1=[:f5,:eb5,:d5,:eb5,:f5,:d5,:eb5,:d5,:c5,:d5,:eb5,:c5,:d5,:c5,:bb4,:c5,:d5,:bb4,:c5,:bb4,:a4,:bb4,:c5,:a4,:bb4,:a4,:g4,:a4,:bb4,:g4,:a4,:g4,:f4,:f4,:g4,:bb4,:bb4,:a4,:bb4,:bb4]
dc1=[cd,q,q,q,q,q,cd,q,q,q,q,q,cd,q,q,q,q,q,cd,q,q,q,q,q,cd,q,q,q,q,q,cd,q,c,c,c,c,c,c,m,m]
nc2=[:r,:f4,:bb4,:a4,:g4,:f4,:g4,:f4,:eb4,:r,:f4,:eb4,:d4,:g4,:f4,:eb4,:d4,:eb4,:d4,:c4,:r,:d4,:c4,:bb3,:eb4,:c4,:d4,:eb4,:d4,:c4,:f4,:f4,:eb4,:c4,:f4,:f4,:f4]
dc2=[c,m,cd,q,q,q,q,q,c,c,q,q,c,cd,q,q,q,q,q,c,c,q,q,c,c,q,q,q,q,c,c,c,c,c,c,m,m]
nc3=[:r,:c4,:d4,:bb3,:c4,:bb3,:c4,:r,:a3,:bb3,:g3,:a3,:g3,:a3,:r,:f3,:g3,:c4,:bb3,:c4,:d4,:bb3,:bb3,:c4,:c4,:d4,:d4]
dc3=[c,c,c,c,c,m,c,c,c,c,c,c,m,c,c,c,m,c,c,c,c,c,c,c,c,m,m]
nc4=[:r,:a3,:bb3,:d3,:c3,:d3,:eb3,:d3,:c3,:r,:f3,:g3,:bb2,:a2,:bb2,:c3,:bb2,:a2,:r,:d3,:eb3,:g3,:g3,:g3,:a3,:bb3,:eb3,:g3,:f3,:f3,:bb2,:bb2]
dc4=[c,c,c,c,c,c,q,q,c,c,c,c,c,c,c,q,q,c,c,c,c,c,c,c,c,c,c,c,c,c,m,m]
define :refrain do |vol|
in_thread do
pl(nc1,dc1,vol)
end
in_thread do
pl(nc2,dc2,vol)
end
in_thread do
pl(nc3,dc3,vol)
end
pl(nc4,dc4,vol)
end

verse
refrain(0.4)
refrain(1)