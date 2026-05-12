#Silent Night transcribed by Robin Newman December 2014
use_synth :tri
s=0 #define s as global here
define :setbpm do |n| #set correct s value in here
  s = (1.0 / 8) *(60.0/n.to_f)
end
setbpm(60)
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

n1=[:g4,:a4,:g4,:e4,:g4,:a4,:g4,:e4,:d5,:d5,:b4,:c5,:c5,:g4,:a4,:a4,:c5,:b4,:a4,:g4,:a4,:g4,:e4,:a4,:a4,:c5,:b4,:a4,:g4,:a4,:g4,:e4,:d5,:d5,:f5,:d5,:b4,:c5,:e5,:c5,:g4,:e4,:g4,:f4,:d4,:c4]
d1=[qd,sq,q,cd,qd,sq,q,cd,c,q,cd,c,q,cd,c,q,qd,sq,q,qd,sq,q,cd,c,q,qd,sq,q,qd,sq,q,cd,c,q,qd,sq,q,cd,cd,qd,sq,q,qd,sq,q,cd*2]
n2=[:e4,:f4,:e4,:c4,:e4,:f4,:e4,:c4,:f4,:f4,:f4,:e4,:e4,:e4,:f4,:f4,:a4,:g4,:f4,:e4,:f4,:e4,:c4,:f4,:f4,:a4,:g4,:f4,:e4,:f4,:e4,:c4,:g4,:g4,:b4,:b4,:g4,:g4,:e4,:c4,:c4,:b3,:b3,:b3,:g3]
d2=[qd,sq,q,cd,qd,sq,q,cd,c,q,cd,c,q,cd,c,q,qd,sq,q,qd,sq,q,cd,c,q,qd,sq,q,qd,sq,q,cd,c,q,qd,sq,q,cd,cd,c,q,qd,sq,q,cd*2]
n3=[:c4,:c4,:g3,:c4,:c4,:g3,:b3,:b3,:d4,:g3,:g3,:c4,:c4,:c4,:c4,:c4,:c4,:c4,:c4,:g3,:c4,:c4,:c4,:c4,:c4,:c4,:c4,:c4,:g3,:b3,:b3,:d4,:d4,:f4,:e4,:g3,:e3,:e3,:d3,:d3,:f3,:e3]
d3=[c,q,cd,c,q,cd,c,q,cd,c,q,cd,c,q,c,q,qd,sq,q,cd,c,q,qd,sq,q,qd,sq,q,cd,c,q,qd,sq,q,cd,cd,c,q,qd,sq,q,cd*2]
n4=[:c3,:c3,:c3,:c3,:c3,:c3,:g3,:g3,:g3,:c3,:c3,:c3,:f3,:f3,:f3,:f3,:c3,:c3,:c3,:c3,:f3,:f3,:f3,:f3,:f3,:c3,:c3,:c3,:c3,:g3,:g3,:g3,:g3,:g3,:c4,:c3,:g2,:g2,:g2,:g2,:g2,:c3]
d4=[c,q,cd,c,q,cd,c,q,cd,c,q,cd,c,q,c,q,qd,sq,q,cd,c,q,qd,sq,q,qd,sq,q,cd,c,q,qd,sq,q,cd,cd,c,q,qd,sq,q,cd*2]

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
