#We wish you a Merry Christmas transcribed by Robin Newman December 2014
use_synth :tri
s=0
define :setbpm do |n|
  s = (1.0 / 8) *(60.0/n.to_f)
end
setbpm(150)
set_volume! 1

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

n1=[:eb4,:ab4,:ab4,:bb4,:ab4,:g4,:f4,:f4,:f4,:bb4,:bb4,:c5,:bb4,:ab4,:g4,:eb4,:eb4,:c5,:c5,:db5,:c5,:bb4,:ab4,:f4,:eb4,:eb4,:f4,:bb4,:g4,:ab4]
d1=[c,c,q,q,q,q,c,c,c,c,q,q,q,q,c,c,c,c,q,q,q,q,c,c,q,q,c,c,c,m]
n2=[:eb4,:c4,:c4,:c4,:c4,:c4,:db4,:db4,:db4,:d4,:d4,:d4,:d4,:d4,:eb4,:eb4,:eb4,:e4,:e4,:e4,:e4,:e4,:f4,:c4,:eb4,:eb4,:db4,:f4,:eb4,:eb4]
d2=[c,c,q,q,q,q,c,c,c,c,q,q,q,q,c,c,c,c,q,q,q,q,c,c,q,q,c,c,c,m]
n3=[:eb3,:eb3,:eb3,:eb3,:ab3,:ab3,:ab3,:ab3,:ab3,:f3,:f3,:ab3,:g3,:f3,:bb3,:g3,:g3,:g3,:g3,:g3,:c4,:c4,:c4,:ab3,:ab3,:ab3,:ab3,:db4,:db4,:c4]
d3=[c,c,q,q,q,q,c,c,c,c,q,q,q,q,c,c,c,c,q,q,q,q,c,c,q,q,c,c,c,m]
n4=[:eb3,:ab2,:ab2,:ab2,:ab2,:ab2,:db3,:db3,:db3,:bb2,:bb2,:bb2,:bb2,:bb2,:eb3,:eb3,:eb3,:c3,:c3,:c3,:c3,:c3,:f3,:f3,:c3,:c3,:db3,:bb2,:eb3,:ab3]
d4=[c,c,q,q,q,q,c,c,c,c,q,q,q,q,c,c,c,c,q,q,q,q,c,c,q,q,c,c,c,m]
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
n1c=[:eb4,:ab4,:ab4,:ab4,:g4,:g4,:ab4,:g4,:f4,:eb4,:bb4,:c5,:bb4,:ab4,:eb5,:eb4,:eb4,:eb4,:f4,:bb4,:g4,:ab4]
d1c=[c,c,c,c,m,c,c,c,c,m,c,c,c,c,c,c,q,q,c,c,c,m]
n2c=[:c4,:eb4,:eb4,:eb4,:eb4,:eb4,:d4,:d4,:d4,:eb4,:eb4,:eb4,:db4,:c4,:eb4,:eb4,:eb4,:eb4,:db4,:f4,:eb4,:eb4]
d2c=[c,c,c,c,m,c,c,c,c,m,c,c,c,c,c,c,q,q,c,c,c,m]
n3c=[:ab3,:c4,:c4,:c4,:bb3,:bb3,:c4,:bb3,:ab3,:g3,:g3,:ab3,:ab3,:ab3,:ab3,:ab3,:ab3,:ab3,:ab3,:db4,:db4,:c4]
d3c=[c,c,c,c,m,c,c,c,c,m,c,c,c,c,c,c,q,q,c,c,c,m]
n4c=[:ab3,:ab2,:ab2,:ab2,:bb2,:bb2,:bb2,:bb2,:bb2,:eb2,:eb2,:ab2,:ab2,:ab2,:c3,:c3,:c3,:c3,:db3,:bb2,:eb3,:ab3]
d4c=[c,c,c,c,m,c,c,c,c,m,c,c,c,c,c,c,q,q,c,c,c,m]
define :refrain do
in_thread do
pl(n1c,d1c)
end
in_thread do
pl(n2c,d2c)
end
in_thread do
pl(n3c,d3c)
end
pl(n4c,d4c)
end
verse
refrain
verse