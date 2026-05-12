#Piece based on Reggae Gay by Bernard Dewagtere http://www.free-scores.com/download-sheet-music.php?pdf=32561
#arranged for Sonic Pi by Robin Newman
#This part of the program plays the pieces. The samples and functions used
#need to be preloaded by part 1. CAn bed played on its own once part1 is run.
#also requires Sonatina Symphonic Symphonic library http://sso.mattiaswestlund.net/download.html
sync :part2
path="~/Desktop/Sonatina Symphonic Orchestra/Samples/" #path to SSO samples

#create array of instrument details
# each entry: name,folder name,sample prefix,offsetclass type,lowest note, highest note
voices=[["Celli piz","Celli","celli-piz-rr1-",0,:a2,:bb5],\
        ["Cello","Cello","cello-",0,:a2,:bb5],\
        ["Xylophone","Percussion","xylophone-",1,:a2,:b5],\
        ["Trumpet","Trumpet","trumpet-",1,:e3,:f6],\
        ["WoodBlock","Percussion","wood_block-lo",0,nil,nil]]
#set up note durations
q=60.0/135/2
sq=q/2
sqt=2*sq/3
qd=3*sq
c=2*q
cd=3*q
m=2*c
md=3*c
b=2*m
bd=3*m
#bass part 8 bar intro
nbpre=[:g2,:g2,:g2,:c3,:c3,:a3,:g2,:d3,:a2,:d3,:c3,:f3,:c4,:g3]
dbpre=[bd,c,q,q+bd,c,c,md+q,q+m+qd,sq,q,q+bd,c,q,q]
#bass part main section
nb=[:g3,:g2,:g3,:c3,:g2,:c3,:g2,:d3,:a2,:d3,:c3,:c3,:c3,:g2,:bb2,:a2,:d3,:f3,:d4,:eb3,\
    :f2,:g2,:g2,:g2,:eb3,:eb3,:r,:bb2,:bb2,:bb2,:r,:f2,:f2,:r,:g2,:f2,:g2,:g2,:r,:eb3,:eb3,:eb3,:r,:bb2,:bb2,:bb2,:bb2,:f3,:f3,:d3,:c4,:g3,:g3,:c3,:c3,:c3,:eb3,:eb3,:bb2,:bb2,:bb2,:r,:f2,:f2,:f2,:f2,:r,:g2,\
    :g2,:g3,:r,:eb3,:eb3,:bb2,:bb2,:bb2,:bb2,:a2,:g2,:a2,:a2,:r,:d3,:d3,:d3,:r]
db=[bd,c,q,q+bd,c,q,q+md+q,q+m+qd,sq,q,q+bd,c,q,q+bd,c,q,q+bd,c,c,md+q,q+md+q,q+bd,c,c,c,c,m,c,c,c,\
    c,c,c,m,qd,sq,c,c,c,c,c,c,c,c,c,c+qd,sq,c,m+q,q,qd,sq,q,q,c,c,md+qd,sq,c,c,c,c,qd,sq,c,c,c,qd,sq,c,m,md+qd,sq,c,c,c+qd,sq,qd,sq,c,c,c,c,c,c,c]
#Trumpet 8 bar intro
nt0=[:r]
dt0=[8*b]
#Trumpet main section
nt=[:r,:e5,:r,:d5,:c5,:d5,:r,:ds5,:e5,:r,:d5,:c5,:b4,:e4,:d4,:e4,:r,:e5,:e5,:e5,:d5,:e5,:g5,:fs5,:d5,:c5,:e5,:d5,:c5,:b4,:r,:c5,:d5,:e5,:a4,:r,:b4,\
    :c5,:b4,:e4,:r,:a4,:a4,:a4,:a4,:a4,:g4,:g4,:e4,:g4,:f4,:e4,:d4,:e4,:r,:c5,:c5,:c5,:c5,:b4,:c5,:d5,:r,:a4,:a4,:a4,:a4,:a4,:g4,:fs4,:g4,:g4,:d4,:g4,\
    :f4,:e4,:d4,:e4,:r,:eb5,:e5,:d5,:c5,:c5,:b4,:c5,:e5,:r]
dt=[m,m+cd,q+qd,sq,qd,sq+md,c+b+c+qd,sq,m+cd,q+qd,sq,qd,sq+c,qd,sq,m+md,c+m,q,q,qd,sq,c,q,q+qd,sq,qd,sq+md+q,sq,sq,m,qd,sq,qd,sq+cd,q+md,c+qd,sq,qd,\
    sq+cd,q+md,md+m,qd,sq,qd,sq,c,q,cd,c,c,c,c,qd,sq+c,md+m,c,q,cd,q,cd,qd,sq+md,c+b+m,qd,sq,qd,sq,qd,sq,qd,sq,c,c,c,c,c,qd,sq+m,m+c+qd,sq,c,q,cd,c,c,qd,sq+b,b]
#Trumpet last two extra bars
ntend=[:r,:d5,:e5]
dtend=[b,q,md+q]
#Xylophone part (Marimba)
nm=[:r]+[:f3,:a3]*7+[:r,[:g3,:bb3],[:g3,:bb3],[:f3,:a3],[:g3,:bb3],:r,:f3,:d3,:f3,:d3,:f3,:f3,:d3,:d3,:f3,:f3,:d3,:r,\
:d4,:e4,:f4,:g4,:a4,:a4,:a4,:a4,:f4,:r,:d4,:c4,:bb3,:a3,:a3,:g3]+[:g3]*29+[:a3,:a3,:a3,:c4]+[:f3]*8+[:r,:f4,:e4,:d4,:e4,:d4,:c4,\
:d4,:c4,:a3,:c4,:a3,:g3,:a3,:g3,:f3,:g3,:a3,:bb3,   :d4,:bb3,:d4,:c4,:d4,:g4,:e4,:f4,:a4,:g4,:g4,:c5,:a4]+[[:d4,:d5]]*4+[[:c4,:c5],[:c4,:c5],[:a3,:a4],[:a3,:a4],:g4,:g4,:f4]+\
  [:f4,:d4]*6+[[:d4,:f4],:f4,:d4,:r,:d4,:e4,:f4,:g4,:f4,:e4,:d4,:c4,:d4,:d4,:a3,:a3,:a3,:bb3,:c4,:d4,:e4,:f4,:g4,:a4,\
  :r,:c5,:c5,:c5,:a4,:c5,:c4,:d4,:d4,:e4,:e4,:f4,:c4]+[:g4,:c4]*5+[:r,\
                                                                   :e4,:d4,:c4,:a3,:g3,:e3,:d3,:c3,:d3,:e3,:c3,:r,:f3,:g3,:bb3,:c4,:d4,:f4]+[:a4,:g4]*8+[:e4,:c4,:d4,:e4,:d4,:c4,:a3,:r]+   [:e4,:d4,:c4,:g3]*9+\
  [:e4,:d4,:c4,:a3]*2+[:g4,:e4,:d4,:c4]+[:g4,:f4,:d4,:c4]*2+[:bb3,:d4,:c4]*2+[:bb3,:c4,:bb3,:a3,:g3,:a3,:g3,:f3,:r]
dm=[3*b+sq,q,sq,sq,sq,sqt,sqt,sqt,sqt,sqt,sqt,sq,sq,sq,qd,  c,q,q,c,c,b+q,q,sq,sq,q,q,q,q,q,q,q,m,c+31*b+md,sq,q,sq,\
    qd,sq,qd,sq,c,c,qd,sq+q,q,qd,sq,sq,qd,c,qd,sq,sq,sq,q,sqt,sqt,sqt,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sqt,sqt,sqt,sq,sq,q,sq,sq,\
    sq,qd,qd,sq,sq,qd,qd,sq,sq,sq,sq,sq,sq,qd,b,sq,sq,q,sq,sq,q,sq,q,sq,sq,sq,q,sq,sq,q,sq,sq,q,q,sq,sq,m+sq,q,sq,c+sq,sq,q,c+sq,sq,q,m,q,qd,qd,qd,sq,sq,qd,qd,sq,sq,qd,\
    q,sq,sq,sq,sq,sq,sq,sqt,sqt,sqt,sq,sq,sq,sq,q,m,sq,sq,sq,sq,sq,sq,sq,sq,c,qd,sq,m+q,q,sq,sq,q,sq,q,sq,c,c,qd,sq,c,c,m,qd,sq,sq,qd,c,qd,sq,q,sq,sq,sq,sq,sqt,sqt,sqt,sq,qd,c+m+q,\
    sq,sq,q,sq,sq,q,q,sq,sq,sq,sq+c,md,q,q,q,q,q,q,q,q,q,q,qd,sq,q,q,q,q,q,q,q,q,q,q,sq,sq,q,sq,sq,q,c,m+sq,sq,q,sq,q,sq,q,sq,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,\
    sq,q,sq,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,qd,8*b]

#set up shorthand for synth chord part
r=[:r]
c1=[[:c4,:c5,:f5,:g5,:c6]]
c2=[[:d4,:g4,:bb4,:f5,:a5,:c6]]
c3=[[:eb4,:bb4,:eb5,:g5,:bb5]]
c4=[[:bb3,:f4,:bb4,:d5,:f5,:bb5]]
c5=[[:f4,:c5,:f5,:a5,:c6]]
c6=[[:c4,:c5,:f5,:g5]]
c7=[[:f4,:a4,:eb5,:g5]]
c8=[[:d4,:a4,:c5,:f5,:a5,:d6]]
c9=[[:f4,:c5,:f5,:bb5]]
c10=[[:c4,:g4,:c5,:e5,:g5,:c6]]
c11=[[:g4,:bb4,:eb5,:g5]]
c12=[[:a3,:g4,:c5,:eb5]]
c13=[[:d4,:fs4,:c5,:e5]]
cend=[[:d4,:f4,:a4,:c5]]
#synth chord part intro
ncpre=r+c6+r+c1
dcpre=[2*b+c,md+b,2*b+c,md+b]
#synth chord part main section
nc=r+c2+r+c6+r+c2+r+c1+r+c2+r+c8+r+c3+c7+r+c3+c3+r+c4+c4+r+c5+c5+r+c3+c3+r+c4+c4+r+c9+c9+r+c10+c10+r+c3+c3+r+c4+c4+r+c5+c5+r+c11+c11+r+c4+c4+r+c12+c12+r+c13+c13
dc=[c,md+b,c,md+b,m,md,md+c,md+b,c,md+b,c,md+b,m,b,md,md+b+c,m,c,c,m,c,c,m,c,b+c,m,c,c,m,c,c,m,c,c,m,c,c,m,c,c,m,c,c,m,c,b+c,m,c,c,m,c,c,m,c,c,m,c]
#synth chord part extra last two bars
ncend=r+cend+cend+cend
dcend=[c,m,c,b+m]

######## start playing here ###############
#intro two bars rhythm to set tempo

use_synth :tri #synth for chords

with_fx :reverb,room: 0.8 do
  2.times do
    sample path+'Percussion','wood_block-lo',amp: 0.5
    sleep m
  end
  4.times do
    sample path+'Percussion','wood_block-lo',amp: 0.5
    sleep c
  end
  #start drum parts
  r1=(ring 1,0,0,0, 1,0,0,1, 1,0,0,1, 0,0,0,0,  1,0,0,0, 1,0,0,1, 1,0,0,1, 1,1,0,1)
  live_loop :r1 do
    sample :drum_snare_soft,amp: 0.5 if r1.tick == 1
    sleep sq
    stop if look >= 106*16
  end
  r2=(ring 0,0,0,0, 1,0,0,0, 1,0,0,0, 1,0,1,0, 0,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,0,0)
  
  live_loop :r2 do
    sample :drum_cymbal_closed,amp: 0.4 if r2.tick == 1
    sleep sq
    stop if look >= 106*16
  end
  r3=(ring 0,0,1,0, 0,0,1,0, 1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,1,0)
  
  live_loop :r3 do
    sample :drum_tom_mid_soft,amp: 0.3 if r3.tick == 1
    sleep sq
    stop if look >= 106*16
  end
  
  #Xylop[hone (marimba) part plays linearly straight through
  in_thread do
    plarray(nm,dm,'Xylophone',0.5)
  end
  #at sema time start 8 bar intro
  in_thread do
    plarray(nbpre,dbpre,'Cello')
  end
  in_thread do
    plarray(nbpre,dbpre,'Celli piz',2)
  end
  in_thread do
    plarray(nt0,dt0,'Trumpet',1,0.9,0.1,-2)
  end
  pa(ncpre,dcpre,0.8)
  #follow with main section 3 times
  3.times do
    in_thread do
      plarray(nb,db,'Cello')
    end
    in_thread do
      plarray(nb,db,'Celli piz',2)
    end
    in_thread do
      plarray(nt,dt,'Trumpet',1,0.9,0.1,-2)
    end
    pa(nc,dc,0.7)
  end
  #finish with last two bars
  in_thread do
    pa(ncend,dcend,0.4)
  end
  plarray(ntend,dtend,'Trumpet',0.4)
end