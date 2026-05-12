#Ravel's Bolero Part 2(Bernard Dewagtere Piano/Clarinet arrangement)
#coded for Sonic Pi by Robin Newman 1st March 2016
#Use with Part1 in a separate Buffer, Run part2 first
#note 4 lines to change around if using SP2.10
inst=:piano
#carlinet sample from http://sso.mattiaswestlund.net/
inst2=:clarinet_gs4
#swap next two lines comments for SP 2.10
#path="~/Desktop/samples/clarinet/"
use_sample_pack "/Users/rbn/Desktop/samples/clarinet"

pitch=:gs4
define :setbpm do |n|
  return 60.0/(n*4)
end
s=setbpm(68) #time for a semiquaver
sq=1*s
dsq=sq/2
q=2*sq
qd=3*sq
qt=q/3
c=2*q
ct=c/3
cd=3*q
m=2*c
md=3*c
b=2*m

define :pl do |inst,n,d,tr,v|
  use_synth inst
  use_transpose tr
  play n,sustain: d*0.5,amp: v if n != :r
  sleep d
end

define :plarray do |inst,n,d,tr=0,v=1|
  n.zip(d).each do |n,d|
    pl(inst,n,d,tr,v)
  end
end
define :pls do |inst,pitch,n,d,tr=0,v=1|
  #swap next two lines comments for SP2.10
  #sample path,inst,rpitch: (n-note(pitch)+tr),attack: d/50,sustain: d*0.88,release: d*0.1,amp: v if n != :r
  sample inst,rpitch: (n-note(pitch)+tr),attack: d/50,sustain: d*0.88,release: d*0.1,amp: v if n != :r
  sleep d
end
define :plsarray do |inst,pitch,notes,durations,tr=0,v=1|
  notes.zip(durations).each do |n,d|
    pls(inst,pitch,n,d,tr,v)
  end
end

ban=[[:c2,:g2,:c3],[:c2,:g2],:c3,[:c2,:g2],[:c2,:g2,:c3],[:c2,:g2],:c3,[:c2,:g2],[:g1,:c2,:g2],\
     [:g1,:c2,:g2],[:c2,:g2,:c3],[:c2,:g2],:c3,[:c2,:g2],[:c2,:g2,:c3],[:c2,:g2],:c3,[:c2,:g2],\
     [:g1,:c2],:g2,[:g1,:c2],[:g1,:c2],:g2,[:g1,:c2]]
bad=[q,qt,qt,qt,q,qt,qt,qt,q,q]+[q,qt,qt,qt,q,qt,qt,qt,qt,qt,qt,qt,qt,qt]

pn33=[[:g3,:c4,:d4,:e4,:g4],[:c4,:d4,:e4,:g4],:g3,[:c4,:d4,:e4,:g4],[:c4,:d4,:e4,:g4],[:c4,:d4,:e4,:g4],\
      :g3,[:c4,:d4,:e4,:g4],[:g3,:bb3,:d4,:g4],[:g3,:bb3,:d4,:g4]]
pd33=[q,qt,qt,qt,q,qt,qt,qt,q,q]
pn34=[[:g3,:c4,:d4,:e4,:g4],[:c4,:d4,:e4,:g4],:g3,[:c4,:d4,:e4,:g4],[:c4,:d4,:e4,:g4],[:c4,:d4,:e4,:g4],\
      :g3,[:c4,:d4,:e4,:g4],[:b3,:d4,:g4],:g3,[:bb3,:d4,:g4],[:bb3,:d4,:g4],:g3,[:bb3,:d4,:g4]]
pd34=[q,qt,qt,qt,q,qt,qt,qt,qt,qt,qt,qt,qt,qt]
pn35=[[:g3,:c4,:d4,:e4,:g4],[:c4,:d4,:e4,:g4],:g3,[:c4,:d4,:e4,:g4],[:c4,:d4,:e4,:g4],[:c4,:d4,:e4,:g4],\
      :g3,[:c4,:d4,:e4,:g4],[:g3,:bb3,:d4,:g4],[:g3,:bb3,:d4,:g4]]
pd35=pd33
pn36=[[:g3,:c4,:d4,:f4,:g4],[:c4,:d4,:f4,:g4],:g3,[:c4,:d4,:f4,:g4],[:g3,:c4,:d4,:f4,:g4],[:c4,:d4,:f4,:g4],\
      :g3,[:c4,:d4,:f4,:g4],[:b3,:d4,:g4],:g3,[:b3,:d4,:g4],[:b3,:d4,:g4],:g3,[:b3,:d4,:g4]]
pd36=[q,qt,qt,qt,q,qt,qt,qt,qt,qt,qt,qt,qt,qt]
pn37=[[:gs3,:b3,:e4,:gs4],[:b3,:e4,:gs4],:gs4,[:b3,:e4,:gs4],[:gs3,:b3,:e4,:gs4],[:b3,:e4,:gs4],:gs4,[:b3,:e4,:gs4],\
      [:fs3,:b3,:d4,:e4,:fs4],[:fs3,:b3,:d4,:e4,:fs4]]
pd37=[q,qt,qt,qt,q,qt,qt,qt,q,q]
pn38=[[:gs3,:b3,:e4,:gs4],[:b3,:e4,:gs4],:gs4,[:b3,:e4,:gs4],[:gs3,:b3,:e4,:gs4],[:b3,:e4,:gs4],:gs4,[:b3,:e4,:gs4],\
      [:b3,:d4,:e4,:fs4],:fs3,[:b3,:d4,:fs4],[:b3,:d4,:e4,:fs4],:fs3,[:b3,:d4,:fs4]]
pd38=pd36
bn=pn35[8..9]+(pn34+pn33)*2+pn34+pn35+pn36+pn37+pn38+pn37
bd=pd35[8..9]+(pd34+pd33)*2+pd34+pd35+pd36+pd37+pd38+pd37

ben=[[:e1,:b1,:e2],[:e1,:b1],:e2,[:e1,:b1],[:e1,:b1,:e2],[:e1,:b1],:e2,[:e1,:b1],[:b1,:fs2,:b2],[:b1,:fs2,:b2],\
     [:e1,:b1,:e2],[:e1,:b1],:e2,[:e1,:b1],[:e1,:b1,:e2],[:e1,:b1],:e2,[:e1,:b1],[:b1,:fs2],:b2,[:b1,:fs2],\
     [:b1,:fs2],:b2,[:b1,:fs2]]
bed=pd35+pd36

bbn=ban[8..-1]+ban*3+ben*2
bbd=bad[8..-1]+bad*3+bed*2

tn=[:f4,:r,:c5,:d5]+[:eb5]*9+[:d5,:c5,:eb5,:d5,:c5,:eb5,:d5,:c5,:bb4,:a4,:g4,:f4,:r,:eb4,:f4,:eb4,:f4,:g4,:a4,\
                              :cs5,:cs5,:b4,:as4,:gs4,:as4,:b4,:cs5,:d5,:cs5,:d5,:e5,:d5,:cs5,:b4,:as4,:gs4,:as4,:b4,:cs5,:d5,:e5,:d5,:cs5,:b4,:a4,:gs4]
td=[m,q,q,q,c,c,q,q,q,ct,ct,ct,q,sq,sq,q,sq,sq,sq,sq,sq,sq,sq,sq,b,q,cd,cd,sq,sq,cd,q,q,c+sq,sq,sq,sq,sq,sq,sq,sq,c+sq,\
    sq,sq,sq,sq,sq,sq,sq,sq,sq,qd,sq,sq,sq,sq,sq,sq,sq]
#end page 6
bfn=ben[0..7]+[[:g1,:d2],:g2,[:g1,:d2],[:g1,:d2],:g2,[:g1,:d2]]
bfd=bed[0..7]+[qt]*6
bgn=[[:c1,:c2],:r,[:fs2,:fs3],:ab3,[:g2,:e3],:fs3]*4
bgd=[q,q,dsq,c-dsq,dsq,c-dsq]*4
bln=[[:f1,:c2,:ab2],[:ab3,:d4],[:c1,:c2],:r]
bld=[q,q+m,q,q+m]


pn39=[[:gs3,:b3,:e4,:gs4],[:b3,:e4,:gs4],:gs3,[:b3,:e4,:gs4],[:gs3,:b3,:e4,:gs4],[:b3,:e4,:gs4],:gs3,[:b3,:e4,:gs4],\
      [:b3,:d4,:g4],:g3,[:b3,:d4,:g4],[:b3,:d4,:g4],:g3,[:b3,:d4,:g4]]
pd39=pd38
pn40=[[:b3,:c4,:e4,:g4],[:c4,:e4],:g3,[:c4,:e4],:g3,[:c4,:e4],[:c4,:e4],:g3,[:c4,:e4],:f3,[:g3,:b3,:d4],[:g3,:b3,:d4]]
pd40=[q,qt,qt,qt,dsq,q-dsq,qt,qt,qt,dsq,q-dsq,q]
pn41=[[:g3,:c4,:e4],[:c4,:e4],:g3,[:c4,:e4],:g3,[:c4,:e4],[:c4,:e4],:g3,[:c4,:e4],:f3,[:b3,:d4],:g3,[:b3,:d4],\
      [:b3,:d4],:g3,[:b3,:d4]]
pd41=[q,qt,qt,qt,dsq,q-dsq,qt,qt,qt,dsq,qt-dsq,qt,qt,qt,qt,qt]
pn42=[[:g3,:c4,:e4],[:c4,:e4],:g3,[:c4,:e4],:g3,[:c4,:e4],[:c4,:e4],:g3,[:c4,:e4],:f3,[:g3,:b3,:d4],[:g3,:b3,:d4]]
pd42=pd40
pn43=[:r,[:c5,:f5],:e5,[:bb4,:db5,:f5],:eb5,:d5,:c5,:bb4,:ab4,[:g4,:c5,:e5],:r]
pd43=[q,qt,qt,qt*2+c,qt,qt,qt,qt,qt,q,q+m]

bn.concat (pn38+pn37)*2+pn39+pn40+pn41+pn42+pn41+pn43
bd.concat (pd38+pd37)*2+pd39+pd40+pd41+pd42+pd41+pd43

bbn.concat ben+ben[0..9]+bfn+bgn+bln
bbd.concat bed+bed[0..9]+bfd+bgd+bld

tn.concat [:as4,:gs4,:fs4,:e4,:d4,:e4,:fs4,:g4,:a4,:g4,:fs4,:e4,:d4,:e4,:fs4,:gs4,:as4,:gs4,:fs4,:e4,:fs4,:e4,:d4,\
           :r,:d6,:cs6,:c6,:bb5,:a5,:g5,:fs5,:e5,:d5,:r]
td.concat [sq,sq,cd,sq,sq,sq,sq+m,sq,sq,sq,sq+m,sq,sq,sq,sq+m,sq,sq,sq,sq+m,sq,sq,sq,qd,q+m+md*3+q,qt,qt,2*qt+c,qt,\
           qt,qt,qt,qt,q,q+m]

extn=[:r,[:b3,:c4],:db4,:d4,:eb4,:e4,:f4,:fs4,:r]
extd=[c+19*md+q,q+c+sq,dsq,dsq,dsq,dsq,dsq,dsq,md]
sync :bolero2

with_fx :reverb,room: 0.7 do
  in_thread do
    plarray(inst,bbn,bbd,0,0.4) #bass
  end
  in_thread do
    plarray(inst,bn,bd,0,0.2) #RH piano
  end
  in_thread do
    plsarray(inst2,pitch,tn,td,-2) #clarinet
  end
  plarray(inst,extn,extd,0,0.3) #last bar LH extra
end