#Frescobaldi, Capriccio quinto sopra La Bassa Flamenga PART 1
#transcribed for Sonic Pi by Robin Newman April 2016
#File in two parts to accommodate SP length restrictions
#Run part 2 then start part one. This cues part 2

use_synth :pulse
dsq=0.5 #note relative durations
sq=1
sqd=1.5
q=2
qd=3
c=4
cd=6
m=8
md=12
b=16
s=0.25 #scale factor to give timings for bpm 60 : crotchet value 1. Then use_bpm figures will work correctly
define :plarray do |notes,dur| #plays two linked lists of notes and durations
  notes.zip(dur).each do |n,d|
    play n,attack: 0.1,sustain: d*s*0.9,release: d*s*0.1,env_curve: 1,amp: 0.5
    sleep d*s
  end
end

define :p do |n1,d1,n2,d2,n3,d3,n4,d4| #plays 4 parts together using threads
  with_fx :reverb,room: 0.8,mix: 0.3 do
    in_thread do
      plarray(n1,d1)
    end
    in_thread do
      plarray(n2,d2)
    end
    in_thread do
      plarray(n3,d3)
    end
    plarray(n4,d4)
  end
end
use_bpm 80 #tempo varies during the piece. Set bpm for each section
n1=[:r,:b5,:b5,:b5,:g5,:fs5,:e5,:c6,:b5,:a5,:a5,:gs5,:a5,:g5,:fs5,:e5,:e5,:ds5,:cs5,:ds5,:r,:e5,:g5,:a5,:b5,:cs6,:ds6,:e6,:fs6,:fs5]
d1=[b+m,m,c,c,cd,q,cd,q,q,q,q,q,qd,sq,q,q,q,sq,sq,c,q,q,sq,sq,sq,sq,q,q,q,q]
n2=[:e5,:e5,:e5,:d5,:cs5,:b4,:g5,:fs5,:e5,:e5,:ds5,:e5,:d5,:cs5,:b4,:e5,:e5,:fs5,:b4,:a4,:g4,:fs4,:e4,:fs4,:e4,:r]
d2=[m,c,c,cd,q,cd,q,q,q,q,q,c,q,q,c,m,c,q,q,c,q,sq,sq,c,m,m]
n3=[:r,:e3,:g3,:a3,:b3,:cs4,:d4,:e4,:fs4,:e4,:e3,:g3,:a3,:b3,:a3,:g3,:fs3,:g3,:a3,:b3,:c4,:b3,:fs3,:r,:b3,:b3,:b3,:a3,:g3,:fs3]
d3=[b+m+q,q,sq,sq,sq,sq,q,q,c,sq,sq,sq,sq,q,c,sq,sq,q,q,q,q,c,c,m,c,c,c,q,q,c]
n4=[:r,:e3,:e3,:e3,:d3,:cs3,:b2,:r,:g3,:fs3,:e3,:e3,:ds3]
d4=[b*3,m,c,c,cd,q,m,cd,q,q,q,q,q]
#b7
n1.concat [:g5,:c6,:b5,:a5,:r,:fs5,:g5,:a5,:b5,:cs6,:d6,:e6,:fs6,:e6,:d6,:cs6,:b5,:a5,:g5,:fs5,:e5,:r,:e6,:e6,:e6,:d6,:cs6,:b5,:d6,:cs6,:b5,:b5,:as5]
d1.concat [cd,q,md,c,q,q,sq,sq,sq,sq,sq,sq,q,q,q,c,cd,sq,sq,c,c,md,c,q,q,qd,sq,q,q,q,q,q,q]
n2.concat [:e5,:e5,:e5,:d5,:cs5,:b4,:r,:d5,:cs5,:b4,:b4,:as4,:b4,:g5,:fs5,:e5,:e5,:ds5,:e5,:fs5,:g5,:fs5,:e5,:fs5,:e5,:r]
d2.concat [m,c,c,cd,q,m,q,q,q,q,q,q,q,q,q,q,q,q,cd,q,q,sq,sq,c,m,b]
n3.concat [:r,:c4,:b3,:a3,:a3,:g3,:fs3,:g3,:r,:g4,:fs4,:e4,:e4,:ds4,:e4,:fs4,:r,:b3,:b3,:b3,:g3,:fs3,:e3,:d4,:cs4,:b3,:b3,:as3,:b3,:a3,:gs3,:as3,:b3,:cs4]
d3.concat [q,q,q,q,q,sq,sq,c,q,q,q,q,q,q,c,c,m,c,c,c,cd,q,cd,q,q,q,q,q,q,c,q,q,q,c]
n4.concat [:e3,:r,:e2,:g2,:a2,:b3,:cs3,:d3,:a2,:b2,:e3,:d3,:e3,:fs3,:g3,:r,:b2,:c3,:d3,:e3,:fs3,:g3,:d3,:cs3,:d3,:e3,:fs3,:g3,:a3,:g3,:fs3,:e3,:d3,:cs3,:b2,:fs3]
d4.concat [m,cd,q,sq,sq,sq,sq,q,q,c,c,c,c,c,c,cd,q,sq,sq,sq,sq,q,c,q,sq,sq,sq,sq,q,sq,sq,sq,sq,q,m,m]
#b13
n1.concat [:b5,:fs5,:g5,:a5,:b5,:fs5,:r,:b5,:a5,:g5,:g5,:fs5,:e5,:c6,:b5,:a5,:a5,:gs5,:a5,:g5,:a5,:b5,:a5,:g5,:fs5,:g5,:e5,:fs5,:d5,:d6,:cs6,:b5,:b5,:as5,:b5,:b5,:a5,:g5,:a5,:gs5,:fs5,:gs5]
d1.concat [q,q,cd,q,c,m,cd,q,q,q,q,c,c,q,q,q,q,q,cd,sq,sq,q,sq,sq,sq,sq,sq,sq,cd,q,q,q,q,q,cd,q,q,q,cd,sq*1.4,sq*1.6,c*2]
n2.concat [:r,:b4,:d5,:e5,:fs5,:g5,:a5,:g5,:fs5,:g5,:d5,:r,:e5,:e5,:e5,:d5,:cs5,:b4,:fs5,:e5,:d5,:d5,:cs5,:ds5,:e5,:fs5,:e5]
d2.concat [b-q,q,sq,sq,sq,sq,cd,sq,sq,q,q,b,m,c,c,cd,q,cd,q,q,q,q,q,c,c,m,m+sq+c*2]
n3.concat [:b3,:c4,:b3,:a3,:a3,:g3,:a3,:d4,:c4,:e3,:g3,:a3,:b3,:e3,:fs3,:gs3,:a3,:b3,:bs3,:b3,:r,:fs3,:g3,:a3,:b3,:cs4,:ds4,:e4,:fs4,:b3]
d3.concat [cd,q,q,q,q,q,m,m,q,q,q,q,c,qd,sq,q,q,c,m,m,b+q,q,sq,sq,sq,sq,q,q,c,m+sq+c*2]
n4.concat [:r,:e3,:e3,:e3,:d3,:cs3,:b2,:r,:c3,:b2,:a2,:a2,:gs2,:a2,:e3,:r,:a2,:c3,:d3,:e3,:fs3,:g3,:a3,:b3,:r,:b2,:d3,:e3,:fs3,:g3,:a3,:a2,:b2,:cs3,:d3,:e3,:fs3,:b2,:g3,:fs3,:e3,:e3,:ds3,:e3]
d4.concat [c,c,c,c,cd,q,m,q,q,q,q,q,q,c,m,q,q,sq,sq,sq,sq,q,q,c,q,q,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,cd,q,q,q,q,q,m+sq+c*2]
p(n1,d1,n2,d2,n3,d3,n4,d4)
#b20 (6/8)
use_bpm 100
n1= [:b5,:a5,:b5,:c6,:e6,:d6,:b5,:c6,:a5,:b5,:a5,:g5,:g5,:fs5,:e5,:e5,:ds5,:e5,:e6,:d6,:cs6,:b5,:d6,:cs6,:b5,:b5,:as5,:b5,:bs5,:b5,:a5,:a5,:g5,:fs5,:g5,:fs5]
d1= [cd,c,q,c,q,c,q,c,q,cd,cd,cd,cd,c,q,c,q,c,q,c,q,c,q,c,q,c,q,cd,c,q,cd,c,q,cd,c,q]
n2= [:r,:e5,:g5,:fs5,:e5,:fs5,:g5,:fs5,:g5,:g5,:fs5,:e5,:e5,:d5,:c5,:b4,:b4,:b5,:a5,:g5,:fs5,:e5,:d5,:cs5,:b4,:g5,:fs5,:e5,:g5,:fs5,:e5,:ds5,:e5,:d5,:cs5]
d2= [q,q,c,c,cd,c,c,c,cd,c,q,cd,c,q,cd,cd,m,q,q,c,c,c,q,c,q,q,q,c,q,c,q,c,q,cd,cd]
n3= [:r,:a3,:c4,:b3,:a3,:g3,:r,:g3,:b3,:c4,:b3,:a3,:g3,:g3,:fs3,:g3,:r,:b3,:a3,:g3,:fs3,:g3,:r,:a3,:g3,:fs3,:b3,:b3,:fs3,:b3,:b3,:as3]
d3= [7*q,q,c,c,cd,cd,m,q,q,c,q,q,c,q,c,cd,m,c,c,q,cd,cd,m,q,q,q,c,q,q,q,c,q]
n4= [:r,:g2,:b2,:c3,:d3,:e3,:e2,:g2,:a2,:b2,:e3,:r,:e3,:d3,:c3,:g2,:a2,:b2,:cs3,:d3,:e3,:fs3]
d4= [md*2+m,q,q,q,c,m,q,q,cd,cd,cd,md*2+q,q,q,q,c,cd,c,q,cd,q,c]
p(n1,d1,n2,d2,n3,d3,n4,d4)
use_bpm 80
n1= [:fs5,:fs5,:e6,:e6,:e6,:d6,:cs6,:b5,:d6,:cs6,:b5,:b5,:as5,:b5,:g5,:e5,:fs5,:g5,:a5,:b5,:cs6,:d6,:r,:b5,:g5,:a5,:b5,:cs6,:d6,:e6,:cs6,:d6,:cs6,:b5,:a5,:g5,:fs5,:e5,:d5,:b5,:d6,:cs6,:b5,:a5,:g5,:fs5,:e5,:r,:fs5,:fs5,:fs5,:e5,:d5,:cs5,:fs5,:d5,:r,:e6,:e6,:e6,:d6,:cs6,  :b5,:d6,:cs6,:b5,:b5,:as5,:b5,:a5,:g5,:fs5,:g5,:a5,:fs5,:g5,:c6,:b5,:a5,:as5,:b5,:cs6,:b5,:b5]
d1= [m,b,c,q,q,qd,sq,q,q,q,q,q,q,sq,sq,sq,sq,sq,sq,sq,sq,c,c+sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,q,m,c,sq,sq,sq,sq,sq,sq,sq,sq,c,m+q,q,q,q,qd,sq,q,q,m,7*c+q,q,q,q,qd,sq,  q,q,q,q,q,q,c+sq,dsq,dsq,dsq,dsq,dsq,dsq,cd,sq,sq,q,q,qd,sq,c,md] #add extra crotchet to last beat as a pause
n2= [:ds5,:e5,:d5,:cs5,:ds5,:e5,:ds5,:cs5,:ds5,:e5,:g5,:fs5,:e5,:d5,:cs5,:d5,[:b5,:d5],:r,:fs5,:a5,:g5,:fs5,:e5,:d5,:cs5,:d5,:d5,:e5,:fs5,:r,:d5,:b4,:cs5,:d5,:e5,:fs5,:g5,:a5,:a4,:b4,:cs5,:b4,:b5,:b5,:b5,:a5,:g5,:fs5,:g5,:fs5,:e5,:e5,:ds5,:cs5,:ds5,:r,:e5,:g5,:fs5,:e5,:d5,:cs5,:b4,:cs5,:d5,:cs5,:fs5,  :e5,:g5,:fs5,:e5,:d5,:e5,:fs5,:e5,:ds5,:e5,:e5,:ds5,:e5]
d2= [c,q,q,q,q,cd,sq,sq,c+sq,sq,sq,sq,sq,sq,sq,sq,m,b+sq,sq,sq,sq,sq,sq,sq,sq,c,c,c,m,5*c+sq,sq,sq,sq,sq,sq,sq,sq,c,cd,q,c,q,q,q,q,qd,sq,cd,q,q,q,q,sq,sq,c,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,sq,m,  q,q,qd,sq,q,q,cd,sq,sq,m,c,c,md] #add extra crotchet to last beat as a pause
n3= [:b3,:a3,:b3,:r,:d4,:b3,:cs4,:d4,:e4,:fs4,:d4,:e4,:fs4,:d4,:e4,:cs4,:b3,:a3,:b3,:b3,:b3,:a3,:g3,:fs3,:d4,:cs4,:b3,:b3,:as3,:b3,:r,:cs4,:e4,:d4,:cs4,:b3,:a3,:g3,:fs3,:g3,:fs3,:fs3,:r,:b3,:g3,:a3,:b3,:cs4,:d4,:e4,:fs4,:cs4,:d4,:b3,:cs4,:b3,:a3,:g3,:fs3,:e3,:g3,:fs3,:e3,:fs3,:g3,:a3,:r,  :cs4,:e4,:d4,:cs4,:b3,:cs4,:b3,:b3,:a3,:g3,:a3,:g3,:fs3,:e3,:g3,:fs3,:g3,:a3,:g3,:fs3,:fs3,:gs3]
d3= [m,m,m,m+sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,c,m,m,c,q,q,qd,sq,cd,q,q,q,q,q,c,sq,sq,sq,sq,sq,sq,sq,sq,q,q,c,m,m+sq,sq,sq,sq,sq,sq,sq,sq,q,q,c+sq,sq,sq,sq,sq,sq,sq,sq,q,sq,sq,c,m,c,m+sq,sq,sq,sq,sq,sq,q,md,q,sq,sq,sq,sq,sq,sq,dsq,dsq,dsq,dsq,sq,sq,c,md] #add extra crotchet to last beat as a pause
n4= [:b2,:a2,:gs2,:a2,:b2,:c3,:b2,:r,:g3,:g3,:g3,:fs3,:e3,:d3,:fs3,:b2,:r,:d3,:b2,:cs3,:d3,:e3,:fs3,:g3,:a3,:fs3,:d3,:e3,:cs3,:fs3,:b2,:r,:b2,:b2,:b2,:a2,:g2,:fs2,:d3,:cs3,:b2,:b2,:as2,:b2,:r,:d3,:fs3,:e3,:d3,:cs3,:b2,:a2,:g2,:a2,:c3,:b2,:e3,:r,:d3,:b2,:cs3,  :d3,:e3,:fs3,:g3,:a3,:e3,:fs3,:g3,:fs3,:e3,:ds3,:e3,:c3,:cs3,:b2,:as2,:b2,:e3]
d4= [cd,sq,sq,q,q,c,m,m+b,c,q,q,qd,sq,q,q,c,m+sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,q,c,m,c,q,q,qd,sq,q,q,q,q,q,q,c,c+sq,sq,sq,sq,sq,sq,sq,sq,c,q,q,m,m,c+sq,sq,sq,sq,  sq,sq,sq,sq,q,q,c,q,sq,sq,c,c,c,c,qd,sq,c,md] #add extra crotchet to last beat as a pause
p(n1,d1,n2,d2,n3,d3,n4,d4)
#b45 (6/8)
use_bpm 100
n1=[:r,:e6,:d6,:cs6,:b5,:d6,:cs6,:b5,:b5,:as5,:b5,:r,:b5,:e6,:d6,:cs6,:d6,:b5,:c6,:b5,:c6,:a5,:b5,:r,:a5,:g5,:fs5,:e5,:g5,:fs5,:e5,:e5,:ds5,:e5]
d1=[md+q,c,c,q,c,q,cd,cd,c,q,cd,q,q,q,q,sq,sq,q,q,sq,sq,q,cd,cd+4*md,cd,cd,cd,c,q,c,q,c,q,md]
n2=[:r,:a5,:g5,:e5,:fs5,:fs5,:e5,:d5,:cs5,:r,:d5,:g5,:fs5,:e5,:fs5,:cs5,:ds5,:r,:e5,:g5,:fs5,:e5,:fs5,:d5,:e5,:d5,:e5,:cs5,:d5,:e5,:c5,:d5,:b4,:c5,:a4,:b4,:r,:b4,:e5,:d5,:cs5,:d5,:e5,:fs5,:fs5,:e5,:e5,:ds5,:e5,:r,:b4,:c5,:b4,:a4,:g4,:a4,:b4,:c5,:g5]
d2=[m,c,c,q,cd,cd,q,q,q,q,q,q,q,sq,sq,q,cd,cd+md+q,q,q,q,sq,sq,q,q,sq,sq,q,c,q,c,q,c,q,c,q,q,q,q,c,q,cd,c,q,c,q,c,q,cd,c,q,c,q,q,sq,sq,q,c,q]
n3=[:e4,:d4,:cs4,:b3,:cs4,:b3,:r,:fs3,:b3,:b3,:as3,:b3,:r,:b3,:e4,:d4,:cs4,:b3,:e4,:a3,:d4,:g3,:a3,:b3,:b3,:as3,:b3,:a3,:g3,:fs3,:g3,:fs3,:g3,:a3,:b3,:e3,:b3,:a3,:b3,:g3,:a3,:g3,:a3,:b3,:c4,:b3,:b3,:a3,:fs3,:e3]
d3=[cd,c,q,c,q,cd,q,q,q,c,q,cd,m,q,q,c,q,c,q,c,q,cd,c,q,c,q,cd,cd,cd,cd,cd,c,q,c,q,cd,q,sq,sq,q,q,sq,sq,q,c,q,cd,c,q,md]
n4=[:r,:e3,:a3,:fs3,:a3,:e3,:r,:b2,:cs3,:d3,:e3,:fs3,:g3,:e3,:fs3,:r,:e3,:d3,:cs3,:b2,:g3,:fs3,:e3,:ds3,:e3,:r,:b2,:e3,:d3,:cs3,:d3,:b2,:c3,:b2,:c3,:a3,:b2,:r,:a2,:e3,:d3,:cs4,:d3,:g2,:a2,:g2,:a2,:b2,:c3,:gs2,:a2,:g2,:a2,:e2]
d4=[q,q,q,c,q,cd,q,q,q,cd,q,c,c,q,cd,md*2,cd,cd,cd,q,cd,cd,cd,c,cd,q,q,q,q,sq,sq,q,q,sq,sq,q,cd,m,q,q,q,sq,sq,q,q,sq,sq,q,c,q,q,sq,sq,q]
p(n1,d1,n2,d2,n3,d3,n4,d4)
cue :go