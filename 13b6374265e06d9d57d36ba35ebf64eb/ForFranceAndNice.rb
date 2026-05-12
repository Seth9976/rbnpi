#In solidarity with the people of France and Nice
#La Marseillaise arranged for Sonic Pi by Robin Newman, 15th July 2016

define :setbpm do |n|
  return 60.0/(n*4)
end
s=setbpm(120)
sq=1*s
dsq=sq/2
q=2*sq
qd=3*sq
qt=4*sq/3
c=2*q
cd=3*q
m=2*c
md=3*c
b=2*m
bd=3*m
define :plarray do |notes,dur,vol=1|
  notes.zip(dur).each do |n,d|
    if n.respond_to?(:each) #allow for chords in part
      n.each do |nv|
        play nv,sustain: 0.9*d,release: d,amp: vol if nv!=:r
      end
    else
      play n,sustain: 0.9*d,release: d,amp: vol if n!=:r
    end
    sleep d
  end
end


use_synth :piano
nt=[:r,:d4,:d4,:d4,:g4,:g4,:a4,:a4,:d5,:b4,:g4,:r,:g4,:b4,:g4,:e4,:c5,:a4,:fs4,:g4,:r,:g4,:a4,:b4,:b4,:b4,:c5,:b4,:b4,:a4,:r,:a4,:b4,:c5,:c5,:c5,:d5,:c5,:b4,:r,:d5,:d5,:d5,:b4,:g4,:d5,:b4,:g4,\
    :d4,:r,:d4,:d4,:fs4,:a4,:c5,:a4,:fs4,:a4,:g4,:f4,:d4,:g4,:g4,:g4,:fs4,:g4,:a4,:r,:a4,:bb4,:bb4,:bb4,:bb4,:c5,:d5,:a4,:bb4,:a4,:g4,:g4,:g4,:bb4,:a4,:g4,\
    :g4,:fs4,:r,:d5,:d5,:d5,:b4,:g4,:a4,:r,:d5,:d5,:d5,:b4,:g4,:a4,:r,:d4,:g4,:r,:a4,:b4,:r,:c5,:d5,:e5,:a4,:r,:e5,:d5,:b4,:c5,:a4,:g4,:r]
dt=[m+q+sq,sq,qd,sq,c,c,c,c,cd,q,q,sq,sq,qd,sq,c,m,qd,sq,m,c,qd,sq,c,c,c,qd,sq,c,c,c,qd,sq,c,c,c,qd,sq,m,c,qd,sq,c,qd,sq,c,qd,sq,    m,qd,sq,qd,sq,\
    m,c,qd,sq,c,c,m,c,qd,sq,c,qd,sq,md,q,q,cd,q,q,q,q,q,md,q,q,cd,q,q,q,q,q,c,q,m+sq,sq,   m+qd,sq,qd,sq,md,qd,sq,\
    m+qd,sq,qd,sq,m+q,q,c,m,c,c,m,m,m,c,c,m+q,q,c,m+qd,sq,qd,sq,md,c]
nl=[[:g1,:g2],[:g1,:g2],[:g1,:g2],[:d2,:d3],[:g1,:g2],[:b1,:b2],[:d2,:d3],[:c2,:c3],[:b1,:b2],[:d3,:g3,:b3],[:d3,:g3,:b3],[:d3,:g3,:b3],:r,[:b1,:b2],\
    [:c2,:c3],[:a1,:a2],[:d2,:d3],[:g2,:g3],[:d2,:d3],[:b1,:b2],[:g1,:g2],[:b1,:b2],[:a1,:a2],[:b1,:b2],[:d3,:g3,:b3],[:b1,:b2],[:g2,:g3],[:d2,:d3],\
    [:d2,:d3],[:d2,:d3],[:d2,:d3],[:c2,:c3],[:b1,:b2],[:a1,:a2],[:a1,:a2],[:d2,:d3],[:d2,:d3],[:g2,:g3],[:d3,:g3,:b3],[:d3,:g3,:b3],[:d3,:g3,:b3],:d3,:d3,\
    [:d2,:d3],:b2,:g2,[:d2,:d3],:b2,:g2,[:d2,:d3],:d2,:d3,:d2,:d3,:d2,:d3,:d2,:r,[:d2,:d3],[:c2,:c3],[:c2,:c3],[:b1,:b2],[:g1,:g2],[:a1,:a2],[:b1,:b2],[:c2,:c3],[:c2,:c3],\
[:eb2,:eb3],[:eb2,:eb3],[:d2,:d3],[:d2,:d3],[:d2,:d3],[:d2,:d3]]+[:d2,:d3]*16+[[:bb2,:bb3],[:bb2,:bb3],[:g2,:g3],[:bb2,:bb3],:d4,:d3,[:d3,:d4],:r,[:d3,:d4],[:d3,:d4]]+
  [[:g2,:g3],[:d3,:g3,:b3],[:d3,:g3,:b3],[:d3,:g3,:b3],[:d3,:g3,:b3],[:d2,:d3],[:d3,:fs3,:a3],[:d3,:fs3,:a3],[:d2,:d3],[:g2,:g3],[:d3,:g3,:b3],[:d3,:g3,:b3],[:d3,:g3,:b3],[:d3,:g3,:b3],\
   [:d2,:d3],[:c3,:c4],[:b2,:b3],[:a2,:a3],[:g2,:g3],[:d2,:d3],[:d2,:d3],[:g2,:g3],[:fs2,:fs3],[:f2,:f3],[:f2,:f3],[:f2,:f3],[:f2,:f3],[:f2,:f3],[:e2,:e3],[:d2,:d3],[:c2,:c3]]+\
  [[:d2,:d3],[:d3,:g3,:b3],[:d3,:g3,:b3],[:d2,:d3],:r,[:c2,:c3],[:b1,:b2],:d3,:g3,:b3,[:d2,:d3],[:g2,:g3],[:d2,:d3],[:b1,:b2],[:g1,:g2],:r]
dl=[c,c,c,c,c,c,c,c,c,qd,sq,q,q,c,\
c,m,c,c,qd,sq,c,qd,sq,c,c,c,c,c,qd,sq,c,qd,sq,c,c,c,c,c,qd,sq,c,qd,sq,c,qd,sq,c,qd,sq,q,sq,sq,sq,sq,sq,sq,q,q,c,m,m,c,c,c,c,c,c,c,c,c,c,c,c]+[sq]*32+[c,c,c,c,c,c,q,q,q,q]+\
  [c,qd,sq,c,c,c,c,c,c,c,qd,sq,c,c,c,c,c,c,c,qd,sq,c,c,c,qd,sq,c,c,m,c,c,c,qd,sq,q,q,c,c,qd,sq,c,c,c,qd,sq,c,c]
c1=[:b4,:d4,:g4]
c2=[:d4,:fs4,:a4]
c3=[:d4,:g4]
c4=[:e4,:a4]
c5=[:d4,:g4]

nr=[c1]*4+[:d4]+[c1]*2+[c2]*2+[c3]*2+[:d4,:r,:d4,:c4]+[c4]+[:c4]+[c1]*3+[:d4,:fs4]+[c5]*5+[c2]+[:r,:e4,[:e4,:gs4]]+[c4]*2+[[:d4,:fs4]]*2+[[:d4,:g4,:b4],:r,:d4,:d4,:d4,:r,:d4,:r]+\
  [:d4,:d4,:d4]+[c2]+[[:d4,:fs4],:d4,[:a3,:d4],[:g3,:b3],:c4,:d4,[:g3,:c4],[:c4,:e4],[:g3,:c4],[:g3,:c4],:d4,:d4,:d4,:d4]+[c2]+\
  
[c3]*3+[:d4]*5+[[:d4,:fs4],[:g3,:d4],[:g4,:d4],:d4,:d4,[:g3,:d4],:r,[:d4,:d5],[:d4,:d5],[:d4,:d5],[:d4,:d5],[:d4,:g4,:b4],:b4,:g4,:g4,[:d4,:fs4]]+\
  [[:d4,:d5]]*7+[c2]+[:r,[:d4,:d5],[:d4,:g4,:b4],:b4,:g4,:g4]+[c2]+[[:d4,:d5]]*3+[[:d4,:g4,:d5],[:fs4,:a4,:d5],[:g4,:b4,:d5,:g5],[:g4,:b4,:d5,:g5],[:a4,:d5,:fs5,:a5]]+\
  [[:b4,:d5,:g5,:b5],[:g4,:b4,:d5],[:g4,:b4,:d5],[:c4,:g4,:c5],:g4,:g4,[:g4,:b5,:d5],[:g4,:a4,:c5,:e5]]+[c2]+[:r,[:fs4,:a4,:e5],[:d4,:b4,:d5],[:g4,:b4],[:d4,:fs4]]+\
  [c1]*4+[:r]

dr=[c,qd,sq,c,c,c,c,c,c,c,c,q,q,c,c,m,c,c,c,c,qd,sq,c,c,c,c,c,c,c,qd,sq,c,c,c,c,m,c,qd,sq,c,c,c,c,m,c,c,m,c,c,c,c,c,c,c,c,c,c,c,qd,sq,c,c,\
    c,c,c,c,c,qd,sq,c,c,c,c,c,c,cd,c,sq,sq,q,q,m+qd,sq,qd,sq,q,sq,sq,q,sq,sq,q,q,q,sq,sq,m+qd,sq,qd,sq,c,qt,qt,qt,c,c,m,c,c,\
    m,c,c,c,qd,sq,c,c,m+q,q,c,m+qd,sq,c,c,qd,sq,c,c]
nfill=[:r,:g4,:g4,:g4,:r,:f3,:r,:fs4,:r,:fs4]
dfill=[4*b+c,qd,sq,c,c+7*b+m,m,b,md,c+b,md]

with_fx :level ,amp: 4 do
  with_fx :reverb,room: 0.6 do
    in_thread do
      plarray(nt,dt,2)
    end
    in_thread do
      plarray(nl,dl)
    end
    in_thread do
      plarray(nfill,dfill)
    end
    plarray(nr,dr)
  end
end

