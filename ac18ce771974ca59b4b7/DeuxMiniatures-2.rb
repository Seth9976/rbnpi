sync :part2
#part 2 of Deux Miniatures by Victor Kalinnikow arrange for Oboe and Strings
#written by Robin Newman, March 2016

#path to library samples folder (including trailing /)
path='~/Sonatina Symphonic Orchestra/Samples/'

#create array of instrument details
voices=[['2nd Violins sus','2nd Violins','2nd-violins-sus-',1,:g3,:b6],\
        ['Violas sus','Violas','violas-sus-',0,:c3,:c6],\
        ['Basses piz','Basses','basses-piz-rr1-',0,:c1,:c4],\
        ['Basses sus','Basses','basses-sus-',0,:c1,:c4],\
        ['Basses stc','Basses','basses-stc-rr1-',0,:c1,:c4],\
        ['Oboe','Oboe','oboe-',1,:as3,:c6]]

#setup global variables
sampledir=''
sampleprefix=''
offsetclass=''
low=''
high=''
paths=''


sq=0.14
q=2*sq
c=2*q
cd=3*q
m=2*c
md=3*c
b=2*m
bd=3*m
nv1=[:fs5,:e5,:d5,:cs5,:d5,:b4,:fs4,:g4,:a4,:b4,:a4,:g4,:g5,:fs5,:e5,:d5,:cs5,:fs5,:d5,:cs5,:d5,:cs5,:b4,:e5,:es5,:fs5,\
     :e5,:d5,:cs5,:d5,:b4,:fs4,:g4,:a4,:b4,:a4,:g4,:b4,:cs5,:d5,:e5,:d5,:fs5,:b4,:cs5,:d5]
dv1=[q]*9+[c,c,cd]+[q]*9+[c,c,c,q,q]+\
  [q]*8+[c,c,cd]+[q]*9
nv1rba=[:cs5,:b4,:a4]
dv1rba=[c,c,cd]
nv1rbb=[:cs5,:b4,:a4,:r,:a4]
dv1rbb=[c,c,c,q,q]

nv2=[:r,:fs4,:e4,:g4,:fs4,:a4,:g4,:fs4,:e4,:g4,:fs4]
dv2=[q,bd,m,m,c,c,b,bd,m,m,m]
nv2rba=[:gs4,:e4]
dv2rba=[m,cd]
nv2rbb=[:gs4,:e4,:r]
dv2rbb=[m,c,c]

nvl=[:r,:a3,:as3,:b3,:cs4,:e4,:d4,:fs4,:e4,:d4,:cs4,:b3,:a3,[:a3,:d4],:as3,:b3,[:c4,:ds4],:b3,:as3,:b3]
dvl=[q,c,c,bd,c,c,c,c,c,cd,q,q,q,c,c,m,m,m,m,m]


nvlrba=[:d4,:cs4]
dvlrba=[m,cd]
nvlrbb=[:d4,:cs4,:r]
dvlrbb=[m,c,c]

nc1=[:r,:d3,:d3,:d3,:d3]
dc1=[q,b*2,b*2,b*2,b]
nc1rra=[:e3,:r]
dc1rra=[m,m-q]
nc1rrb=[:e3,:a3,:r]
dc1rrb=[m,c,c]
nc2=[:r,:a3,:r] #single note fill
dc2=[q+b*2,b+md,c+b*3]
nc2rra=[:r,:a3,:e3,:a2] #piz fill
dc2rra=[q+7*b+m,q,q,q]
#letter A
nv1b=[:b4,:e5,:b4,:cs5,:d5,:d5,:e5,:a5,:e5,:fs5,:g5,:g5,:fs5,:a5,:g5,:fs5,:fs5,:e5,:e5,:fs5,:a5,:g5,:fs5,:fs5,:e5,:e5,:fs5,:a5,:fs5,:d5,:g5,:fs5,:e5,:d5,:cs5,:d5,:cs5,:b4,:e5,:a4,:a4]
dv1b=[q,q,q,q,cd,q]*2+[q,q,q,q,q,c,q]*2+[q,q,q,q]*3+[c,q,q]
#letter B
nv1b.concat [:b4,:e5,:b4,:cs5,:d5,:d5,:e5,:a5,:e5,:fs5,:g5,:g5,:b5,:a5,:g5,:fs5,:es5,:fs5,:a5,:g5,:fs5,:e5,:ds5,:e5,:g5,:fs5,:e5,:d5,:cs5,:b4,:a4,:g4,:fs4,:g4,:fs4,:e4,:d4,:fs4,:e4,:d4,:e4,:fs4,:fs5]
dv1b.concat [q,q,q,q,cd,q,q,q,q,q,cd,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,c,q,q]
#letter C
nv1b.concat [:e5,:d5,:cs5,:d5,:b4,:fs4,:g4,:a4,:b4,:a4,:g4,:g5,:fs5,:e5,:d5,:cs5,:fs5,:d5,:cs5,:d5,:cs5,:b4,:e5,:es5,:fs5]
dv1b.concat [q,q,q,q,q,q,q,q,c,c,cd,q,q,q,q,q,q,q,q,q,c,c,c,q,q]
#letter D
nv1b.concat [:e5,:d5,:cs5,:d5,:b4,:fs4,:g4,:a4,:b4,:a4,:g4,:e4,:fs4,:g4,:fs4,:e4,:a4,:fs4,:e4,:g4,:fs4,:e4,:a4,:fs4,:e4,:d4,:cs4,:d4,:fs4,:fs4,:e4,:d4,:cs4,:d,:fs4,:fs4,:e4,:d4,:a3,:r,:d4,:fs4,:a4,:d5,:fs5]
dv1b.concat [q]*8+[c,c,cd,q]+[q,q,q,q,cd,q]*4+[q,q,q,q,c,c,m,m,b]

#letter A
nv2b=[:b4,:bb4,:a4,:e5,:eb5,:d5,:d5,:a4,:b4,:bb4,:a4,:b4,:bb4,:a4,:b4,:bb4,:a4,:e4,:e4]
dv2b=[cd,q,m,cd,q,m,c,c,c,c,m,c,c,m,cd,q,c,c,m]
#letter B
nv2b.concat [:e4,:d4,:a4,:g4,:g4,:b4,:a4,:g4,:fs4,:es4,:fs4,:a4,:g4,:fs4,:e4,:ds4,:e4,:r,:as3,:g4,:fs4,:e4,:d4,:cs4,:b3,:a3,:b3,:a3,:g3,:a3,:d4,:cs4]
dv2b.concat [m,m,m,cd,q]+[q,q,q,q]*6+[m,c,c]
#letter C
nv2b.concat [:fs4,:e4,:g4,:fs4,:a4,:g4]
dv2b.concat [bd,m,m,c,c,b]
#letter D
nv2b.concat [:fs4,:fs4,:e4,:cs4,:e4,:d4,:cs4,:d4,:cs4,:e4,:d4,:cs4,:d4,:bb3,:a3,:d4,:cs4,:b3,:bb3,:a3,:cs4,:b3,:bb3,:a3,:r,:d4,:r,:d5]
dv2b.concat [b,m,m,cd,c,q,q,q,cd,c,q,q,q,m,q,q,q,q,m,q,q,q,q,c,c,m,m,bd]

#letter A
nvlb=[:e4,:d4,:a4,:g4,:a4,:d4,:d4,:cs4,:d4,:d4,:cs4,:d4,:d4,:e4,:e4,:d4,:cs4,:b3,:a3]
dvlb=[m,m,m,m,c,c,cd,q,m,cd,q,m,cd,q,cd,c,q,q,q]
#letter B
nvlb.concat [:b3,:bb3,:a3,:e4,:eb4,:d4,:cs4,[:g3,:d4],:b3,:b3,:g4,:fs4,:as3,:fs3,:e3,:fs3,:g3,:bb3,:a3,:g3]
dvlb.concat [cd,q,m,cd,q,m,m,c,m,c,q,q,c,m,m,m,q,q,q,q]
#letter C
nvlb.concat [:a3,:as3,:b3,:cs4,:e4,:d4,:fs4,:e4,:d4,:cs4,:b3,:a3]
dvlb.concat [c,c,bd,c,c,c,c,c,cd,q,q,q]
#letter D
nvlb.concat [[:a3,:d4],:as3,:b3,[:c4,:ds4],:b3,:bb3,:g3,:fs3,:a3,:bb3,:g3,:fs3,:g3,:fs3,:g3,:fs3,:r,:fs4]
dvlb.concat [c,c,m,m,m,c,c,cd,q,c,c,m,m,m,m,md,m,c+2*b]

nvlb2=[:r,:a4] #extra note last two bars
dvlb2=[q+39*b,2*b]

#letter A
nc3=[:gs3,:g3,:fs3,:es3,:fs3,:cs4,:c4,:b3,:as3,:b3,:a3,:gs3,:g3,:fs3,:a3,:gs3,:g3,:fs3,:e3,:fs3,:g3,:a3,:r]
dc3=[c,cd,q,q,q,c,cd,q,q,q,m,c,c,c,c,c,c,m,q,q,c,md,c]
#letter B
nc3.concat [:gs3,:g3,:fs3,:es3,:fs3,:cs4,:c4,:b3,:as3,:b3,[:a2,:e2],[:d3,:a3],[:g2,:d3],[:cs3,:g3],[:fs2,:cs3],:b2,[:e2,:b2],:a2]
dc3.concat [c,cd,q,q,q,c,cd,q,q,q,m,c,m,c,m,m,m,b]
#letter C
nc3.concat [:d3,:d3,:d3,:d3,:d3,:d3,:d3,:r,:fs3,:e3,:d3,:a2,:fs2,:e2,:d2,:a2,:fs2,:d2]
dc3.concat [b*2,b,b,b*2,b*2,b*2,c,q,q,q,q,q,q,c,c,c,c,b]
puts nc3.length
puts dc3.length

nc4=[:r,:a3]
dc4=[30*b+q,md]

v2="2nd Violins sus"
v1="Oboe"
vl="Violas sus"
vc="Basses sus"
vcp="Basses piz"


with_fx :reverb,room: 0.6 do
  in_thread do
    plarray(nv1,dv1,v1)
    plarray(nv1rba,dv1rba,v1)
    plarray(nv1,dv1,v1)
    plarray(nv1rbb,dv1rbb,v1)
    plarray(nv1b,dv1b,v1)
  end
  in_thread do
    plarray(nv2,dv2,v2,0.3)
    plarray(nv2rba,dv2rba,v2,0.3)
    plarray(nv2,dv2,v2,0.3)
    plarray(nv2rbb,dv2rbb,v2,0.3)
    plarray(nv2b,dv2b,v2,0.3)
  end
  in_thread do
    plarray(nvl,dvl,vl,0.3)
    plarray(nvlrba,dvlrba,vl,0.3)
    plarray(nvl,dvl,vl,0.3)
    plarray(nvlrbb,dvlrbb,vl,0.3)
    plarray(nvlb,dvlb,vl,0.3)
  end
  in_thread do
    plarray(nvlb2,dvlb2,vl,0.3)
  end
  in_thread do
    plarray(nc1,dc1,vc,0.5)
    plarray(nc1rra,dc1rra,vc,0.5)
    plarray(nc1,dc1,vc,0.5)
    plarray(nc1rrb,dc1rrb,vc,0.5)
    plarray(nc3,dc3,vc,0.5)
  end
  in_thread do
    plarray(nc2,dc2,vc,0.5) #single note fill
    sleep b-q
    plarray(nc2,dc2,vc,0.5) #single note fill
  end
  in_thread do
    plarray(nc4,dc4,vc,0.5) #single note fill
  end
  in_thread do
    plarray(nc2rra,dc2rra,vcp,0.7) #piz note  rfill
  end
end
sleep 42*b
cue :part3