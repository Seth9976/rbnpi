sync :part3
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

use_bpm_mul 1.1
sq=0.14
q=2*sq
c=2*q
cd=3*q
m=2*c
md=3*c
b=2*m
bd=3*m

nv1=[:g4,:a4,:bb4,:c5,:d5,:d5,:f5,:d5,:c5,:d5,:c5,:bb4,:c5,:d5,:d5,:g4,:a4,:bb4,:c5,:d5,:d5,:g5,:f5,:eb5,:d5,:c5,:d5,:c5,:bb4,:c5]
dv1=[sq,sq,sq,sq,q,q,q,cd,sq,sq,q,q,q,c,c,sq,sq,sq,sq,q,q,q,sq,sq,c,sq,sq,q,q,q]
nv1rba=[:g4,:g4]
dv1rba=[c,c]
nv1rbb=[:g4,:g4,:d5]
dv1rbb=[c,q,q]
nv1b=[:f5,:d5,:d5,:f5,:d5,:d5,:f5,:d5,:f5,:d5,:f5,:d5,:g4,:a4,:bb4,:c5,:d5,:d5,:g5,:f5,:eb5,:d5,:c5,:d5,:c5,:bb4,:c5]
dv1b=[q,c,q,q,c,q,q,q,q,q,q,cd,sq,sq,sq,sq,q,q,q,sq,sq,c,sq,sq,q,q,q]
nv1brba=[:g4,:g4,:d5]
dv1brba=[c,q,q]
nv1brbb=[:g4,:g4,:bb4]
dv1brbb=[c,q,q]
nv1c=[:g4,:g4,:bb4,:g4,:g4,:bb4,:g4,:a4,:bb4,:c5,:d5,:f5,:d5,:d5,:bb5,:g5,:g5,:bb5,:g5,:g5,:bb4,:g4,:a4,:bb4,:c5,:d5,:d5,:g5,:g5,:r]
dv1c=[c,q,q,c,q,q,sq,sq,sq,sq,q,q,c,q,q,c,q,q,c,q,q,sq,sq,sq,sq,m,q,sq,sq,sq+c]

nv2=[:r,:d4,:d4,:r,:c4,[:a3,:d4],:d4,:d4,[:g3,:eb4],[:bb3,:d4],:c4,:eb4]
dv2=[c,c,m,c,c,m,c,c,c,c,c,c]
nv2rba=[:d4]
dv2rba=[m]
nv2rbb=[:d4,:r]
dv2rbb=[cd,q]
nv2b=[:a4,:bb4,:a4,:bb4,:a4,:bb4,:a4,:bb4,:a4,:d4,:d4,[:g3,:eb4],[:bb3,:d4],:c4,:eb4]
dv2b=[c,c,c,c,q,q,q,q,m,c,c,c,c,c,c]
nv2brba=[:d4,:r]
dv2brba=[cd,q]
nv2brbb=nv2brba
dv2brbb=dv2brba
nv2c=[:eb4,:d4,:r,:d4,:d4,:r,:eb5,:d5,:r,:r,:a4,[:g4,:d5],[:g4,:d5],:r]
dv2c=[m,m,c,c,cd,q,m,cd,q+c,m,q,sq,sq,q+c]

nvl=[:r,:bb3,:a3,:r,:bb3,:a3,:bb3,:a3,:bb3,:f3,:g3,:g3]
dvl=[c,c,m,c,c,m,c,c,c,c,c,c]
nvlrba=[:bb3]
dvlrba=[m]
nvlrbb=[:bb3,:r]
dvlrbb=[cd,q]
nvlb=[:d4,:g4,:d4,:g4,:d4,:g4,:d4,:g4,:d4,:bb3,:a3,:bb3,:f3,:g3,:g3,:bb3,:r]
dvlb=[c,c,c,c,q,q,q,q,m,c,c,c,c,c,c,cd,q]
nvlc=[:c4,:g3,:r,:a3,:bb3,:r,:c5,:g4,:r,:r,[:a3,:d4],[:g3,:d4],[:g3,:d4],:r]
dvlc=[m,m,c,c,cd,q,m,cd,q+c,m,q,sq,sq,q+c]

nc=[:r,:g3,:f3,:r,:eb3,:d3,:g3,:f3,:eb3,:bb2,:eb3,:c3]
dc=[c,c,m,c,c,m,c,c,c,c,c,c,]
ncrba=[:g3]
dcrba=[m]
ncrbb=[:g3,:r]
dcrbb=[cd,q]
ncb=[:r,:g3,:f3,:eb3,:bb2,:eb3,:c3,:g3,:r]
dcb=[4*m,c,c,c,c,c,c,cd,q]
ncc=[:r,:d3,:g3,:r,:r,:d3,[:g2,:d3],[:g2,:d3],:r]
dcc=[2*m+c,c,cd,q+2*m+c,m,q,sq,sq,q+c]


v1="Oboe"
v2="2nd Violins sus"
vl="Violas sus"
vc="Basses stc"
with_fx :reverb,room: 0.6 do
  in_thread do
    plarray(nv1,dv1,v1)
    plarray(nv1rba,dv1rba,v1)
    plarray(nv1,dv1,v1)
    plarray(nv1rbb,dv1rbb,v1)
    plarray(nv1b,dv1b,v1)
    plarray(nv1brba,dv1brba,v1)
    plarray(nv1b,dv1b,v1)
    plarray(nv1brbb,dv1brbb,v1)
    plarray(nv1c,dv1c,v1)
  end
  in_thread do
    plarray(nv2,dv2,v2,0.3)
    plarray(nv2rba,dv2rba,v2,0.3)
    plarray(nv2,dv2,v2,0.3)
    plarray(nv2rbb,dv2rbb,v2,0.3)
    plarray(nv2b,dv2b,v2,0.3)
    plarray(nv2brba,dv2brba,v2,0.3)
    plarray(nv2b,dv2b,v2,0.3)
    plarray(nv2brbb,dv2brbb,v2,0.3)
    plarray(nv2c,dv2c,v2,0.3)
  end
  in_thread do
    plarray(nvl,dvl,vl,0.3)
    plarray(nvlrba,dvlrba,vl,0.3)
    plarray(nvl,dvl,vl,0.3)
    plarray(nvlrbb,dvlrbb,vl,0.3)
    plarray(nvlb,dvlb,vl,0.3)
    plarray(nvlb,dvlb,vl,0.3)
    plarray(nvlc,dvlc,vl,0.3)
  end
  in_thread do
    plarray(nc,dc,vc,0.3)
    plarray(ncrba,dcrba,vc,0.3)
    plarray(nc,dc,vc,0.3)
    plarray(ncrbb,dcrbb,vc,0.3)
    plarray(ncb,dcb,vc,0.3)
    plarray(ncb,dcb,vc,0.3)
    plarray(ncc,dcc,vc,0.3)
  end
end