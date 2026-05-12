#Christmas Medley synced to The PiHut Christmas tree
#coded by Robin Newman, December 2nd 2017
use_osc_logging false
use_debug false
use_osc "127.0.0.1",5005

define :flash do |n|
  time_warp rt(0.2) do #time warp to sync leds with sound
    osc "/xmas/pulse",n
  end
end
puts "Shimmer Christmas tree"
flash(8)# turn on xmas tree shimmer
sleep(4)
flash(0) #turn off all leds
flash(0) #belt and braces. Sometimes a led is missed
use_synth :tri
use_bpm 160
s=1.0/8
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

define :pl do |val,notes,durations,vol=0.8|
  notes.zip(durations).each do |n,d|
    play n,sustain: 0.9*d,release: 0.1*d,amp: vol
    if val!=""
      in_thread do
        flash(val)
      end
    end
    sleep d
  end
end

puts "The Holly and the Ivy"
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
    pl(1,nv1,dv1)
  end
  in_thread do
    pl(2,nv2,dv2)
  end
  in_thread do
    pl(2,nv2b,dv2b)
  end
  in_thread do
    pl(3,nv3,dv3)
  end
  pl(4,nv4,dv4)
end
define :verse do
  in_thread do
    pl(1,n1,d1)
  end
  in_thread do
    pl(2,n2,d2)
  end
  in_thread do
    pl(3,n3,d3)
  end
  pl(4,n4,d4)
end
verse
refrain

sleep 1
puts "Jingle Bells!"
use_synth :pretty_bell
n1=[:eb4,:c5,:bb4,:ab4,:eb4,:c5,:bb4,:ab4,:f4,:db5,:c5,:bb4,:g4,:eb5,:d5,:eb5,:g5,:f5,:eb5,:db5,:c5,:bb4,:ab4,:g4]
d1=[q,q,q,q,m+q,q,q,q,m+q,q,q,q,q,q,q,q,sq,sq,sq,sq,sq,sq,sq,sq]
n2=[:c4,:r,:c4,:r,:db4,:r]
d2=[q,cd,m+q,cd,m+q,b+q]
n3=[:ab2,:ab3,:eb3,:ab3,:ab2,:ab3,:eb3,:ab3,:ab2,:ab3,:eb3,:ab3,:db3,:ab3,:f3,:ab3,:db3,:bb3,:f3,:bb3,:eb3,:bb3,:g3,:bb3,:eb3,:eb4,:g3,:bb3]
d3=[q]*4*7
n4=[:ab4,:ab4,:ab4,:db4,:db4,:eb4,:eb4]
d4=[m]*7

in_thread do
  pl(1,n1,d1,1)
end
in_thread do
  pl(2,n2,d2,0.8)
end
in_thread do
  pl(3,n3,d3,0.3)
end
pl(4,n4,d4,0.3)

play [:ab3,:c4,:ab4],sustain: c
flash(7)
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
  pl(5,nt1,dt1,0.8)
end
pl(6,nt2,dt2,0.6)

sleep 1
puts "Silent night"
use_synth :tri
use_bpm 80

n1=[:g4,:a4,:g4,:e4,:g4,:a4,:g4,:e4,:d5,:d5,:b4,:c5,:c5,:g4,:a4,:a4,:c5,:b4,:a4,:g4,:a4,:g4,:e4,:a4,:a4,:c5,:b4,:a4,:g4,:a4,:g4,:e4,:d5,:d5,:f5,:d5,:b4,:c5,:e5,:c5,:g4,:e4,:g4,:f4,:d4,:c4]
d1=[qd,sq,q,cd,qd,sq,q,cd,c,q,cd,c,q,cd,c,q,qd,sq,q,qd,sq,q,cd,c,q,qd,sq,q,qd,sq,q,cd,c,q,qd,sq,q,cd,cd,qd,sq,q,qd,sq,q,cd*2]
n2=[:e4,:f4,:e4,:c4,:e4,:f4,:e4,:c4,:f4,:f4,:f4,:e4,:e4,:e4,:f4,:f4,:a4,:g4,:f4,:e4,:f4,:e4,:c4,:f4,:f4,:a4,:g4,:f4,:e4,:f4,:e4,:c4,:g4,:g4,:b4,:b4,:g4,:g4,:e4,:c4,:c4,:b3,:b3,:b3,:g3]
d2=[qd,sq,q,cd,qd,sq,q,cd,c,q,cd,c,q,cd,c,q,qd,sq,q,qd,sq,q,cd,c,q,qd,sq,q,qd,sq,q,cd,c,q,qd,sq,q,cd,cd,c,q,qd,sq,q,cd*2]
n3=[:c4,:c4,:g3,:c4,:c4,:g3,:b3,:b3,:d4,:g3,:g3,:c4,:c4,:c4,:c4,:c4,:c4,:c4,:c4,:g3,:c4,:c4,:c4,:c4,:c4,:c4,:c4,:c4,:g3,:b3,:b3,:d4,:d4,:f4,:e4,:g3,:e3,:e3,:d3,:d3,:f3,:e3]
d3=[c,q,cd,c,q,cd,c,q,cd,c,q,cd,c,q,c,q,qd,sq,q,cd,c,q,qd,sq,q,qd,sq,q,cd,c,q,qd,sq,q,cd,cd,c,q,qd,sq,q,cd*2]
n4=[:c3,:c3,:c3,:c3,:c3,:c3,:g3,:g3,:g3,:c3,:c3,:c3,:f3,:f3,:f3,:f3,:c3,:c3,:c3,:c3,:f3,:f3,:f3,:f3,:f3,:c3,:c3,:c3,:c3,:g3,:g3,:g3,:g3,:g3,:c4,:c3,:g2,:g2,:g2,:g2,:g2,:c3]
d4=[c,q,cd,c,q,cd,c,q,cd,c,q,cd,c,q,c,q,qd,sq,q,cd,c,q,qd,sq,q,qd,sq,q,cd,c,q,qd,sq,q,cd,cd,c,q,qd,sq,q,cd*2]

in_thread do
  pl(1,n1,d1)
end
in_thread do
  pl(2,n2,d2)
end
in_thread do
  pl(3,n3,d3)
end
pl(4,n4,d4)

sleep 1
puts "Ding dong merrily on high"
use_bpm 160

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
    pl(1,n1,d1)
  end
  in_thread do
    pl(2,n2,d2)
  end
  in_thread do
    pl(3,n3,d3)
  end
  pl(4,n4,d4)
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
    pl(1,nc1,dc1,vol)
  end
  in_thread do
    pl(2,nc2,dc2,vol)
  end
  in_thread do
    pl(3,nc3,dc3,vol)
  end
  pl(4,nc4,dc4,vol)
end

verse
refrain(0.4)
refrain(1)

sleep 1
puts "Now bring us some figgy pudding"
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
    pl(1,n1,d1)
  end
  in_thread do
    pl(2,n2,d2)
  end
  in_thread do
    pl(3,n3,d3)
  end
  pl(4,n4,d4)
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
    pl(1,n1c,d1c)
  end
  in_thread do
    pl(2,n2c,d2c)
  end
  in_thread do
    pl(3,n3c,d3c)
  end
  pl(4,n4c,d4c)
end
verse
refrain
verse
puts "Shimmer Christmas Tree"
flash(8)
sleep 10
flash(0)
flash(0)#belt and braces as cam miss a led
puts "All finished. Happy Christmas"
