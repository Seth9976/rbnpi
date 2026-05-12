#Ravel's Bolero Part 1(Bernard Dewagtere Piano/Clarinet arrangement)
#coded for Sonic Pi by Robin Newman 1st March 2016
#Use with Part2 in a separate Buffer, Run part2 first
#note 4 lines to change around if using SP2.10
inst=:piano
#carlinet sample from http://sso.mattiaswestlund.net/
inst2=:clarinet_gs4
#swap next two lines comments for SP2.10
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
  #swap next two lines domments for SP 2.10
  #sample path,inst,rpitch: (n-note(pitch)+tr),attack: d/50,sustain: d*0.88,release: d*0.1,amp: v if n != :r
  sample inst,rpitch: (n-note(pitch)+tr),attack: d/50,sustain: d*0.88,release: d*0.1,amp: v if n != :r
  sleep d
end
define :plsarray do |inst,pitch,notes,durations,tr=0,v=1|
  notes.zip(durations).each do |n,d|
    pls(inst,pitch,n,d,tr,v)
  end
end
pn1=[:g3,:g3,:g3,:g3,[:g3,:g4],:g3,:g3,:g3,:g3,:g3]
pd1=[q,qt,qt,qt,q,qt,qt,qt,q,q]
pn2=[:g3,:g3,:g3,:g3,[:g3,:g4],:g3,:g3,:g3,:g3,:g3,:g3,:g3,:g3,:g3]
pd2=[q,qt,qt,qt,q]+[qt]*9
pn3=[:g3]*10
pd3=[q,qt,qt,qt,q,qt,qt,qt,q,q]
pn4=[:g3]*14
pd4=[q,qt,qt,qt,q]+[qt]*9
pn5=[[:e3,:g3],:g3,:g3,:g3,[:c4,:d4,:e4],:g3,:g3,:g3,[:b3,:c4,:d4],:g3]
pd5=pd1
pn6=[[:e3,:g3],:g3,:g3,:g3,[:c4,:d4,:e4],:g3,:g3,:g3,[:b3,:c4,:d4],:g3,:g3,:g3,:g3,:g3]
pd6=pd4

bn=(pn1+pn2)*3+(pn3+pn2)*2+pn3+pn4+(pn1+pn2)*3+pn1+pn4+pn1+pn2+pn5+pn6
bd=(pd1+pd2)*3+(pd3+pd2)*2+pd3+pd4+(pd1+pd2)*3+pd1+pd4+pd1+pd2+pd5+pd6
#end page 2

tn=[:r,:d5,:cs5,:d5,:e5,:d5,:cs5,:b4,:d5,:d5,:b4,:d5,:cs5,:d5,:b4,:a4,\
    :fs4,:g4,:a4,:g4,:fs4,:e4,:fs4,:g4,:a4,:b4,:a4,:b4,:cs5,:b4,:a4,:g4,\
    :fs4,:e4,:fs4,:e4,:d4,:d4,:e4,:fs4,:g4,:e4,:a4,:r]
tn.concat [:e5,:d5,:cs5,:b4,:cs5,:d5,:e5,:d5,:cs5,:d5,:cs5,:b4,:d5,:cs5,\
           :b4,:g4,:g4,:g4,:g4,:b4,:d5,:b4,:cs5,:a4,:g4,:g4,:g4,:g4,:b4,:cs5,:a4,:b4,\
           :g4,:e4,:e4,:d4,:e4,:e4,:e4,:e4,:g4,:b4,:g4,:a4,:fs4,:e4,:e4,:d4,:e4,:e4,\
           :d4,:e4,:fs4,:g4,:a4,:g4,:fs4,:e4,:d4,:r,:d5,:cs5,:d5,:e5,:d5,:cs5,:b4,:d5,\
           :d5,:b4,:d5,:cs5,:d5]

#end of page 2
td=[4*md,cd,sq,sq,sq,sq,sq,sq,q,sq,sq,cd,sq,sq,sq,sq,sq,sq,m+sq,sq,sq,\
    sq,sq,sq,sq,sq,m+sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,c,sq,sq,q,q,c,b+q,q]
td.concat [c+qd,sq,sq,sq,sq,sq,sq,sq,qd,sq,sq,sq,sq,sq,sq,qd,sq,sq,q,q,\
           sq,sq,sq,sq,q,sq,sq,q,q,sq,sq,sq,sq,q,sq,sq,cd,sq,sq,q,q,sq,sq,sq,sq,q,\
           sq,sq,cd,sq,sq,q,sq,sq,m+sq,sq,sq,sq,q,md+m+q,cd,sq,sq,sq,sq,sq,sq,q,sq,sq,cd,sq,sq]
#end of page 2

bbn=[:c3,:r,:g2,:r,:c3,:r,:g2,:g2]*10 + [:c3,:r,[:g2,:c3],:r,:c3,:r,[:g2,:c3],:g2]

bbd=[q,cd,q,q]*22
bxn=[[:c2,:g2],:r,:g3,:r,[:g2,:c3,:g3],:r,[:c2,:g2],:r,:g3,:r,[:g2,:c3,:g3],:g2]
bxd=[q]*12

bbn.concat bxn
bbd.concat bxd
#end page 2

pn7=[[:e3,:g3],:g3,:g3,:g3,[:c4,:d4,:f4],:g3,:g3,:g3,[:b3,:c4],:g3,:g3,:g3,:g3,:g3]
pd7=pd6
pn8=[[:d3,:g3],:g3,:g3,:g3,[:c4,:f4],:g3,:g3,:g3,[:b3,:c4,:d4],:g3]
pd8=pd5
pn9=pn8+[:g3]*4
pd9=pd7
pn10=[[:e3,:g3],:g3,:g3,:g3,[:c4,:d4,:f4],:g3,:g3,:g3,[:b3,:c4,:d4],:g3]
pd10=pd8
pn11=pn10+[:g3]*4
pd11=pd9
pn13=[[:e3,:g3],:g3,:g3,:g3,[:c4,:d4],:g3,:g3,:g3,[:b3,:c4,:d4],:g3]
pd13=pd10
pn14=pn13+[:g3]*4
pd14=pd11
pn15=[[:e3,:g3],:g3,:g3,:g3,[:c4,:d4,:f4],:g3,:g3,:g3,[:b3,:c4],:g3]
pd15=pd10
pn16=[[:e3,:g3],:g3,:g3,:g3,[:c4,:d4],:g3,:g3,:g3,[:b3,:c4],:g3,:g3,:g3,:g3,:g3]
pd16=pd14

bn.concat pn5+pn6+pn5+pn7+pn8+pn9+pn10+pn11+pn13+pn14+pn15+pn16
bd.concat pd5+pd6+pd5+pd7+pd8+pd9+pd10+pd11+pd13+pd14+pd15+pd16

bbn.concat bxn*6
bbd.concat bxd*6

tn.concat [:b4,:a4,:fs4,:g4,:a4,:g4,:fs4,:e4,:fs4,:g4,:a4,:b4,:a4,:b4,:cs5,:b4,:a4,:g4,:fs4,:e4,\
           :fs4,:e4,:d4,:d4,:e4,:fs4,:g4,:e4,:a4,:r,:e5,:d5,:cs5,:b4,:cs5,:d5,:e5,:d5,:cs5,:d5,:cs5,\
           :b4,:d5,:cs5,:b4,:g4,:g4,:g4,:g4,:b4,:d5,:b4,:cs5,:a4,:g4,:g4,:g4,:g4,:b4,:cs5,:a4,:b4,:g4,\
           :e4,:e4,:d4,:e4,:e4,:e4,:e4,:g4,:b4,:g4,:a4,:fs4,:e4,:e4,:d4]
td.concat [sq,sq,sq,sq,m+sq,sq,sq,sq,sq,sq,sq,sq,m+sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,c,sq,sq,q,q,c,b+q,\
           q,c+qd,sq,sq,sq,sq,sq,sq,sq,qd,sq,sq,sq,sq,sq,sq,qd,sq,sq,q,q,sq,sq,sq,sq,q,sq,sq,q,q,sq,sq,\
           sq,sq,q,sq,sq,cd,sq,sq,q,q,sq,sq,sq,sq,q,sq,sq]

#end of page 3
pn17=[[:d3,:g3],:g3,:g3,:g3,:r,:g3,:g3,:g3,:b3,:g3]
pd17=pd15
pn18=[[:e3,:g3],:g3,:g3,:g3,[:c4,:d4,:e4,:g4],:g3,:g3,:g3,[:b3,:c4,:d4,:g4],:g3]
pd18=pd17
pn19=pn18+[:g3]*4
pd19=pd16
pn20=[[:e3,:g3],:g3,:g3,:g3,[:c4,:d4,:e4],:g3,:g3,:g3,[:bb3,:c4,:d4],:g3]
pd20=pd5
pn21=pn20+[:g3]*4
pd21=pd19
pn22=[[:e3,:g3],:g3,:g3,:g3,[:c4,:d4],:g3,:g3,:g3,[:bb3,:c4],:g3]
pd22=pd20
pn23=[[:e3,:g3],:g3,:g3,:g3,[:c4,:d4],:g3,:g3,:g3,[:bb3,:c4,:d4],:g3,:g3,:g3,:g3,:g3]
pd23=pd21
pn24=[[:e3,:g3],:g3,:g3,:g3,[:c4,:d4],:g3,:g3,:g3,[:bb3,:c4,:d4],:g3]
pd24=pd20

bn.concat pn17+pn6+pn18+pn19+pn20+pn21+pn22+pn23+pn20+pn21+pn24+pn23
bd.concat pd17+pd6+pd18+pd19+pd20+pd21+pd22+pd23+pd20+pd21+pd24+pd23

byn=[[:c2,:g2],:r,[:c3,:g3],:r,[:g1,:c2,:g2],:r,[:c2,:g2],:r,[:c3,:g3],:r,[:g1,:c2,:g2],:g2]
byd=bxd
bbn.concat bxn*2+byn*4
bbd.concat bxd*2+byd*4

tn.concat [:e4,:e4,:d4,:e4,:fs4,:g4,:a4,:g4,:fs4,:e4,:d4,:r,:c5,:b4,:a4,:g4,:c5,:d5,:b4,:a4,:c5,:b4,\
           :a4,:c5,:b4,:c5,:b4,:a4,:g4,:fs4,:e4,:fs4,:r,:c5,:d5,:eb5,:eb5,:eb5,:eb5,:eb5,:eb5,:eb5,:eb5,\
           :eb5,:d5,:c5,:eb5,:d5,:c5,:eb5,:d5,:c5,:bb4,:a4,:g4,:fs4,:r]
td.concat [cd,sq,sq,q,sq,sq,m+sq,sq,sq,sq,q,md+m+q,c+sq,sq,sq,sq,sq,sq,sq,sq,q,sq,sq,c,sq,sq,sq,cd,sq,\
           sq,sq,m,q,q,q,c,c,q,q,q,ct,ct,ct,q,sq,sq,q,sq,sq,sq,sq,sq,sq,sq,sq,m*2,q]
#end page 4
pn25=[[:e3,:g3]]+[:g3]*9
pd25=pd13
pn26=pn25+[:g3]*4
pd26=pd14
pn27=[:g3,:g3,:g3,:g3,[:c4,:d4],[:ab4,:c4,:f4],[:bb3,:d4,:g4],:f4,[:g3,:bb3,:eb3],[:ab4,:c4,:f4],\
      :eb4,:f4,[:f3,:ab3,:db4],:db4,[:g3,:bb3,:eb3],:db4,[:ab4,:c4,:f4],:eb4,:d4] #minus lastchord
pd27=[q,qt,qt,qt,q,q+m+sq,sq,sq,sq+m,sq,sq,sq,q+m,sq,sq,sq,sq,sq,sq] #minus last sq
pn31=[[:e3,:g3,:c4],[:c4,:d4,:e4,:g4],:g3,[:c4,:d4,:e4,:g4],[:g3,:c4,:d4,:e4,:g4],[:c4,:d4,:e4,:g4]\
      ,:g3,[:c4,:d4,:e4,:g4],[:g3,:b3,:d3,:g4],[:g3,:b3,:d3,:g4]]
pd31=[sq+q,qt,qt,qt,q,qt,qt,qt,q,q]
pn32=[[:g3,:d4,:e4,:g4],[:c4,:d4,:e4,:g4],:g3,[:c4,:d4,:e4,:g4],[:g3,:c4,:d4,:e4,:g4],\
      [:c4,:d4,:e4,:g4],:g3,[:c4,:d4,:e4,:g4],[:b3,:d4,:g4],:g3,[:b3,:d4,:g4],[:b3,:d4,:g4],:g3,[:b3,:d4,:g4]]
pd32=pd26
pn33=[[:g3,:c4,:d4,:e4,:g4],[:c4,:d4,:e4,:g4],:g3,[:c4,:d4,:e4,:g4],[:c4,:d4,:e4,:g4],[:c4,:d4,:e4,:g4],\
      :g3,[:c4,:d4,:e4,:g4],[:g3,:bb3,:d4,:g4],[:g3,:bb3,:d4,:g4]]
pd33=pd25
pn34=[[:g3,:c4,:d4,:e4,:g4],[:c4,:d4,:e4,:g4],:g3,[:c4,:d4,:e4,:g4],[:c4,:d4,:e4,:g4],[:c4,:d4,:e4,:g4],\
      :g3,[:c4,:d4,:e4,:g4],[:b3,:d4,:g4],:g3,[:bb3,:d4,:g4],[:bb3,:d4,:g4],:g3,[:bb3,:d4,:g4]]
pd34=pd32
pn35=[[:g3,:c4,:d4,:e4,:g4],[:c4,:d4,:e4,:g4],:g3,[:c4,:d4,:e4,:g4],[:c4,:d4,:e4,:g4],[:c4,:d4,:e4,:g4],\
      :g3,[:c4,:d4,:e4,:g4],[:g3,:bb3,:d4,:g4],[:g3,:bb3,:d4,:g4]]
pd35=pd33
bn.concat pn13+pn14+pn25+pn26+pn27+pn31+pn32+pn33+pn34+pn35[0..7]
bd.concat pd13+pd14+pd25+pd26+pd27+pd31+pd32+pd33+pd34+pd35[0..7]

bzn=[[:c2,:g2],:r,:c3,:r,[:g1,:c2,:g2],:r,[:c2,:g2,:c3,:d3],:r,:c3,:r,[:g1,:c2,:g2],:g2,[:c2,:g2],\
     :r,[:c3,:f3,:g3],:r,[:g1,:c2,:g2],:r,[:c2,:g2],:r,[:c3,:f3,:g3],:r,[:g1,:c2,:g2],:g2]
bzd=[q]*24
ban=[[:c2,:g2,:c3],[:c2,:g2],:c3,[:c2,:g2],[:c2,:g2,:c3],[:c2,:g2],:c3,[:c2,:g2],[:g1,:c2,:g2],\
     [:g1,:c2,:g2],[:c2,:g2,:c3],[:c2,:g2],:c3,[:c2,:g2],[:c2,:g2,:c3],[:c2,:g2],:c3,[:c2,:g2],\
     [:g1,:c2],:g2,[:g1,:c2],[:g1,:c2],:g2,[:g1,:c2]]
bad=pd25+pd26

bbn.concat byn*2+bzn+ban*2 +ban[0..7]
bbd.concat byd*2+bzd+bad*2 +bad[0..7]#crot before end

tn.concat [:e5,:fs5,:e5,:fs5,:g5,:a5,:bb5,:g5,:a5,:fs5,:e5,:fs5,:e5,:d5,:c5,:c5,:d5,:c5,:d5,:e5,:fs5,:e5,\
           :d5,:e5,:d5,:c5,:bb4,:c5,:bb4,:a4,:r,:g4,:a4,:g4,:a4,:f4,:g4,:f4,:g4,:eb4,:eb4,:f4,:eb4,:g4,:f4,\
           :eb4,:d4,:d4,:r,:c5,:b4,:a4,:g4,:c5,:d5,:b4,:a4,:c5,:b4,:a4,:c5,:b4,:c5,:b4,:a4,:g4,:f4,:e44]
td.concat [cd,q,sq,sq,cd,q,q,ct,ct,ct,sq,sq,sq,qd,q,c+sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,q,\
           q+m+sq,sq,sq,sq,m,sq,sq,sq,m+q,sq,sq,sq,sq,sq,sq,sq,q,md+m+q,c+sq,sq,sq,sq,sq,sq,sq,sq,q,sq,sq,\
           c,sq,sq,sq,cd,sq,sq,sq] #crotchet before end page
#end page 5
with_fx :reverb,room: 0.7 do
  in_thread do
    plarray(inst,bbn,bbd,0,0.4) #bass
  end
  in_thread do
    plarray(inst,bn,bd,0,0.2) # RH piano
  end
  plsarray(inst2,pitch,tn,td,-2) #clarinet
end
cue :bolero2