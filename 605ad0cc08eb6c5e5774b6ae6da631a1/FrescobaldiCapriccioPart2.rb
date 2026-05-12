#Frescobaldi, Capriccio quinto sopra La Bassa Flamenga PART 2
#transcribed for Sonic Pi by Robin Newman April 2016
#run this part, then switch to part 1 and run that. Part 1 cues part 2 when it finishes
#Two parts because of the length restrictions on a buffer in Sonic Pi
use_synth :pulse

s=0.25 #scale factor to get correct use_bpm figures
dsq=0.5 #relative note durations
sq=1
sqd=1.5
q=2
qd=3
c=4
cd=6
m=8
md=12
b=16

sync :go #received from end pf part 1
#b60 (4/4)
use_bpm 80
n1=[:ds5,:r,:b5,:c6,:g5,:a5,:as5,:b5,:b5,:a5,:g5,:fs5,:r,:e6,:e6,:e6,:d6,:cs6,:b5,:d6,:cs6,:b5,:b5,:as5,:b5,:r,:fs6,:e6,:fs6,:d6,:e6,:cs6,:b5,:a5,:b5,:fs5,:fs5,:g5,:r,:b5,:b5,:b5,:a5,:g5,:fs5,:d6,:cs6,:d6,:b5,:r,:b5,:a5,:b5,:g5,:a5,:fs5,:r,:b5,:a5,:b5,:g5,:a5,:fs5,:r,:b5,:b5,:b5,:a5,:g5,:fs5]
d1=[m,q,q,q,q,q,q,c,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,c,m+q,q,sqd,dsq,sqd,dsq,q,q,q,q,c,c,c,b+q,q,q,q,q,q,q,q,c,c,m,q,q,sqd,dsq,sqd,dsq,m,cd,q,sqd,dsq,sqd,dsq,c,q,q,q,q,c,q,q]
n2=[:b5,:e5,:e5,:e5,:d5,:cs5,:b4,:g5,:fs5,:e5,:e5,:ds5,:e5,:cs5,:r,:a5,:g5,:a5,:fs5,:g5,:e5,:cs5,:ds5,:b4,:b4,:b4,:a4,:d5,:cs5,:fs5,:e5,:ds5,:e5,:d5,:cs5,:d5,:e5,:ds5,:e5,:r,:e5,:d5,:e5,:cs5,:d5,:b4,:fs5,:b4,:r,:fs5,:fs5,:fs5,:d5,:cs5,:b4,:r,:g5,:fs5,:e5,:e5,:d5,:cs5,:ds5,:r,:e5,:e5,:e5,:d5,:cs5,:b4,:g5,:fs5,:e5,:e5,:ds5,:cs5,:ds5]
d2=[m,c,q,q,q,q,q,q,q,q,q,q,c,c,cd,q,sqd,dsq,sqd,dsq,q,q,cd,q,q,q,q,q,q,q,q,q,qd,sq,sq,sq,c,q,c,     m+q,q,sqd,dsq,sqd,dsq,q,q,c,m+q,q,q,q,qd,sq,c,q,q,q,q,q,sq,sq,c,cd,q,q,q,q,q,q,q,q,q,q,sq,sq,c]
n3=[:fs3,:r,:b3,:c4,:gs3,:a3,:as3,:b3,:cs4,:d4,:e4,:fs4,:r,:fs3,:g3,:ds3,:e3,:es3,:fs3,:g3,:a3,:fs3,:e3,:r,:b3,:b3,:b3,:a3,:g3,:fs3,:d4,:cs4,:b3,:b3,:as3,:b3,:gs3,:a3,:b3,:cs4,:d4,:a3,:b3,:as3,:b3,:r,:fs3,:g3,:ds3,:e3,:r,:b3,:b3,:b3,:g3,:fs3,:e3,:fs3,:e3,:fs3,:d3,:b3,:a3,:b3,:g3,:a3,:fs3,:b3]
d3=[m,b+cd,q,q,q,q,q,q,sq,sq,q,q,m+q,q,q,q,q,q,qd,sq,cd,q,c,cd,q,q,q,q,q,q,q,q,q,q,q,c,c,q,sq,sq,sq,sq,c,q,c,q,q,q,q,c,cd,q,q,q,q,q,m+sq,sq,sq,sq,q,q,sqd,dsq,sqd,dsq,c,c]
n4=[:b2,:r,:e3,:d3,:e3,:cs3,:d3,:b2,:r,:a3,:g3,:a3,:fs3,:g3,:e3,:d3,:cs3,:fs3,:b2,:r,:b2,:c3,:gs2,:a2,:as2,:b2,:e3,:r,:b2,:b2,:b2,:a2,:g2,:fs2,:fs3,:g3,:ds3,:e3,:es3,:fs3,:e3,:d3,:e3,:fs3,:b2,:b2,:c3,:g2,:a2,:b2,:r,:b2,:c3,:gs2,:a2,:as2,:b2,:b2]
d4=[m,m+cd,q,sqd,dsq,sqd,dsq,c,m+q,q,sqd,dsq,sqd,dsq,q,q,q,q,m,m+cd,q,q,q,q,q,c,c,q,q,q,q,q,q,q,q,q,q,q,q,cd,sq,sq,q,q,c+cd,q,q,q,c,m,q,q,q,q,q,q,c,b]
p(n1,d1,n2,d2,n3,d3,n4,d4)
#b72 (1/2)
use_bpm 50
n1=[:gs5]
n2=[:e5]
n3=[:b3]
n4=[:e3]
d1=d2=d3=d4=[m]
p(n1,d1,n2,d2,n3,d3,n4,d4)
#b73 (3/4)
use_bpm 80
n1=[:r,:e6,:d6,:cs6,:b5,:a5,:g5,:fs5,:g5,:a5,:b5,:cs6,:d6,:fs5,:g5,:a5,:b5,:cs6,:d6,:e6,:fs6,:e6,:d6,:cs6,:b5,:g5,:fs5,:e5,:d5,:cs5,:d5,:e5,:fs5,:a5,:g5,:fs5,:g5,:b4,:cs5,:ds5,:e5,:fs5,:g5,:d5,:e5,:fs5,:g5,:a5,:b5,:fs5,:g5,:a5,:b5,:cs6,:d6,:b5,:e6,:fs6,:d6,:e6,:fs6,:e6,:d6,:cs6,:b5,:a5,:g5,:fs5,:e5,:d5,:cs5,:b4,:cs5,:r,:b5,:b5,:b5,:a5,:g5,:fs5]
d1=[sq]*12*6+[md,md,c,c,c,m,c,md]
n2=[:e5,:e5,:e5,:d5,:d5,:e5,:b4,:a4,:b4,:r,:a5,:a5,:a5,:g5,:fs5,:fs5,:g5,:fs5,:e5,:e5,:ds5]
d2=[c,c,c,m,c,c,c,c,m,c+md*2,c,c,c,m,c,m,c,m,c,m,c]
n3=[:r,:b3,:b3,:b3,:g3,:fs3,:e3,:c4,:b3,:a3,:a3,:gs3,:a3,:e4,:e4,:d4,:r]
d3=[md,c,c,c,m,c,m,c,m,c,m,c,m,c,m,c,md*3]
n4=[:r,:e3,:e3,:e3,:d3,:cs3,:b2,:a2,:e3,:b2,:cs3,:d3,:e3,:fs3,:g3,:a3,:b3,:fs3,:b3,:a3,:g3,:a3,:g3,:fs3,:e3,:b2,:cs3,:d3,:e3,:fs3,:d3,:e3,:fs3,:e3,:d3,:cs3,:d3,:a2,:cs3,:ds3,:e3,:fs3,:g3,:a3,:b3,:fs3,:g3,:e3,:fs3,:b2]
d4=[md*3,c,c,c,m,c,md,md]+[sq]*12*3+[qd,sq,sq,sq,q,c]
p(n1,d1,n2,d2,n3,d3,n4,d4)
#b84 (4/4)
use_bpm 80
n1=[:a5,:g5,:a5,:b5,:b5,:r,:fs5,:g5,:a5,:b5,:fs5,:b5,:d6,:cs6,:b5,:a5,:g5,:fs5,:e5,:r,:b5,:a5,:g5,:a5,:fs5,:a5,:b5,:c6,:b5,:r,:d6,:cs6,:b5,:as5,:fs5,:b5,:a5,:fs5,:g5,:a5,:b5,:fs5,:b5,:d6,:cs6,:b5,:cs6,:e6,:d6,:cs6,:d6,:b5,:fs5,:gs5,:as5,:b5,:cs6]
d1=[c,q,q,m,b,m,sq,dsq,dsq,sq,sq,sq,sq,sq,sq,c,q,q,c,m+sq,sq,sq,sq,sq,sq,sq,sq,c,c,sq,sq,sq,sq,sq,sq,c,q,sq,dsq,dsq,sq,sq,sq,sq,sq,sq,m+sq,sq,sq,sq,sq,sq,sq,sq,q,q,c]
n2=[:e5,:r,:g5,:fs5,:e5,:ds5,:e5,:cs5,:d5,:e5,:b4,:cs5,:ds5,:e5,:ds5,:cs5,:ds5,  :e5,:e5,:e5,:d5,:cs5,:b4,:g5,:fs5,:e5,:e5,:ds5,:e5,:r,:a5,:g5,:fs5,:g5,:fs5,:e5,:fs5,:r,:a5,:g5,:fs5,  :g5,:e5,:g5,:a5,:fs5,:fs5,:r,:e5,:fs5,:g5,:a5,:e5,:fs5,:a5,:g5,:fs5,:g5,:fs5,:e5,:ds5,:cs5]
d2=[m,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,q,c,sq,sq,c,c,q,q,qd,sq,q,q,q,q,q,q,c,sq,sq,sq,sq,q,sq,sq,c,c+sq,sq,sq,sq,sq,sq,sq,sq,c,m,m,sq,dsq,dsq,sq,sq,sq,sq,sq,sq,c,c,cd,sq,sq]
n3=[:r,:a3,:g3,:fs3,:e3,:g3,:fs3,:e3,:ds3,:b3,:a3,:g3,:fs3,:g3,:e3,:fs3,:g3,:fs3,:e3,:fs3,:e3,:fs3,:g3,:a3,:e3,:a3,:c4,:b3,:a3,:b3,:r,:a3,:g3,:fs3,:g3,:e3,:g3,:a3,:b3,:g3,:b3,:cs4,:d4,:d4,:cs4,:b3,:a3,:b3,:bs3,:a3,:e4,:r,:d4,:cs4,:b3,:cs4,:d4,:r,:fs4,:e4,:ds4,:e4,:e3,:g3,:a3,:b3,:e3,:fs3,:g3,:a3,:g3,:fs3]
d3=[sq]*16+[m+q,sq,sq,c,sq,dsq,dsq,sq,sq,sq,sq,sq,sq,m,m+sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,c+sq,sq,sq,sq,sq,sq,sq,sq,c,c+sq,sq,sq,sq,c,m,c+sq,sq,sq,sq,sq,sq,sq,sq,c+sq,sq,sq,sq,sq,sq,q]
n4=[:c3,:b2,:r,:e3,:d3,:cs3,:b2,:c3,:g2,:a2,:b2,:r,:d3,:c3,:b2,:c3,:g2,:a2,:b2,:c3,:r,:e3,:d3,:cs3,:d3,:b2,:d3,:e3,:fs3,:b3,:b3,:b3,:a3,:g3,:fs3,:r,:d3,:cs3,:b2,:b2,:as2]
d4=[m,m,sq,sq,sq,sq,sq,sq,sq,sq,m,b+sq,sq,sq,sq,sq,sq,sq,sq,m,b+sq,sq,sq,sq,sq,sq,sq,sq,m,c,q,q,qd,sq,c,cd,q,q,q,q,q]
p(n1,d1,n2,d2,n3,d3,n4,d4)
#b92 (1/2)
use_bpm 80
n1=[:fs5]
d1=[m]
n2=[:ds5]
d2=[m]
n3=[:fs3,:b3,:b3,:b3]
d3=[q,q,q,q]
n4=[:b2]
d4=[m]
p(n1,d1,n2,d2,n3,d3,n4,d4)
#b93 (4/4)
use_bpm 80
#last two bars removed and played with rit in following section
n1=[:r,:b5,:cs6,:d6,:e6,:e5,:fs5,:a5,:g5,:fs5,:g5,:r,:b5,:a5,:g5,:a5,:fs5,:b5,:cs6,:ds6,:e6,:fs6,:e6,:r,:b5,:b5,:b5,:g5,:fs5,:e5,:r,:c6]#+ [:b5,:a5,:a5,:gs5] +   [:a5,:gs5,:fs5]  +  [:gs5]
d1=[md,sq,dsq,dsq,sq,sq,sq,sq,sq,sq,c,m+sq,sq,sq,sq,sq,sq,sq,sq,q,q,c,c,m+q,q,q,q,qd,sq,c,q,q]#+    [q,q,q,q]+   [cd,sq,sq]+    [b]
n2=[:ds5,:e5,:e5,:e5,:d5,:cs5,:b4,:r,:b4,:cs5,:d5,:e5,:b4,:e5,:g5,:fs5,:e5,:fs5,:r,:a5,:a5,:a5,:g5,:fs5,:e5,:g5,:fs5,:e5,:e5,:ds5,:e5]#  +  [:e5] +   [:e5]
d2=[q,q,q,q,qd,sq,c,c,sq,dsq,dsq,sq,sq,sq,sq,sq,sq,c,m,c,q,q,qd,sq,q,q,q,q,q,q,b]#+  [b]+    [b]
n3=[:g3,:fs3,:e3,:c4,:b3,:a3,:a3,:gs3,:a3,:r,:b3,:a3,:g3,:a3,:fs3,:b3,:cs4,:d4,:d4,:b3,:a3,:g3,:fs3,:c4,:b3,:a3,:g3,:e3,:b3,:cs4,:d4,:g3,:fs3,:g3,:b3,:b3,:b3,:g3,:fs3,:e3]#+  [:e3,:r] + [:e3,:fs3,:gs3,:a3,:e3,:a3,:c4,:b3,:a3]  + [:b3]
d3=[qd,sq,q,q,q,q,q,q,c,c+sq,sq,sq,sq,sq,sq,sq,sq,c,q,q,q,q,c+sq,sq,sq,sq,sq,sq,sq,sq,q,q,c,q,q,q,q,qd,sq,c]#+  [c,c]+    [sq,dsq,dsq,sq,sq,sq,sq,sq,sq]+    [b]
n4=[:r,:e3,:e3,:e3,:d3,:c3,:b2,:r,:g3,:fs3,:e3,:e3,:ds3,:e3,:r,:b2,:cs3,:d3,:e3,:e2,:a2,:c3,:b2,:e3,:r,:c3,:b2,:a2]#+    [:g2,:e2,:c3,:a2,:b2] + [:c3,:a2]  + [:e3]
d4=[b+c,c,q,q,qd,sq,c,q,q,q,q,q,q,c,c,sq,dsq,dsq,sq,sq,sq,sq,q,m,c+sq,sq,sq,sq]#+    [sq,sq,q,q,q]+   [c,c]+    [b]
p(n1,d1,n2,d2,n3,d3,n4,d4)
#implement rit in last two bars
#b98
use_bpm 60
n1=[:b5,:a5,:a5,:gs5]
d1=[q,q,q,q]
n2=[:e5]
d2=[m]
n3=[:e3,:r]
d3=[c,c]
n4=[:g2,:e2,:c3,:a2,:b2]
d4=[sq,sq,q,q,q]
p(n1,d1,n2,d2,n3,d3,n4,d4)

#b98 second half
use_bpm 50
n1=[:a5,:gs5,:fs5]
d1=[cd,sq,sq]
n2=[:e5]
d2=[m]
n3=[:e3,:fs3,:gs3,:a3,:e3,:a3,:c4,:b3,:a3]
d3=[sq,dsq,dsq,sq,sq,sq,sq,sq,sq]
n4=[:c3,:a2]
d4=[c,c]
p(n1,d1,n2,d2,n3,d3,n4,d4)

#b99
use_bpm 40
n1=[:gs5]
d1=[b]
n2=[:e5]
d2=[b]
n3=[:b3]
d3=[b]
n4=[:e3]
d4=[b]
p(n1,d1,n2,d2,n3,d3,n4,d4)
