#Fy gar her o'er with Straw arranged for Sonic Pi by Robin Newman, May 2017
#anon scottish song
#music from The harpsichord or spinnet miscellany by Robert Bremner (c 1765)

use_synth :blade #makes a good harpsichord sound when gverb added
use_bpm 140
#note values relative to crotchet=1
m=2;cd=1.5;c=1;q=0.5;sq=0.25;dsq=0.125;hdsq=0.0625;qd=0.75

define :shake do |n,d,f=0| #quick entry for ornament
  #n=main note,q its duration,f note/duration selector
  t=[n,n+1,n]
  dt=[dsq,dsq,d-2*dsq] if d>sq #choose appropriate short notes
  dt=[hdsq,hdsq,d-2*hdsq] if d<=sq#choose appropriate short notes
  return t if f==0 #returns notes when f=0
  return dt if f==1 #returns durations when f=1
end

define :pl do |nt,durs| #plays corresponding arrays of notes and their durations
  nt.zip(durs).each do |n,d|
    play n,release: d
    sleep d
  end
end

nr=[] #arrays to hold the data nr,dr right hand notes and durations, nl,dl left hand notes and durations
dr=[]
nl=[]
dl=[]

nr[0]=[shake(:c5,cd),:b4,shake(:a4,c),:e5,:d5,:e5,shake(:c5,q),:d5,shake(:b4,c),:a4,:g4,shake(:c5,cd),:d5,:E5,:FS5,:G5,:E5,:D5,:C5,:B4].flatten+[[:C4,:E4,:A4]]
dr[0]=[shake(:c5,cd,1),q,shake(:a5,c,1),c,q,q,shake(:c5,q,1),q,shake(:b4,c,1),q,q,shake(:c5,cd,1),q,q,q,c,qd,sq,q,q,m].flatten
nr[1]=[:g5,:e5,shake(:e5,c),:d5,:c5,:b4,:c5,:d5,:e5,shake(:b4,c),:a4,:g4,:g5,:a5,:g5,:f5,shake(:e5,c),:g5,:a5,:g5,:e5,:g5,shake(:a5,cd),:c6,:g5,:e5,shake(:e5,c),:d5,:c5,:b4,:c5,:d5,:e5,shake(:b4,c),:a4,:g4,shake(:c5,cd),:d5,:e5,:fs5,:g5,:e5,:d5,:c5,:b4].flatten+[[:c4,:e4,:a4]]
dr[1]=[c,c,shake(:e5,c,1),q,q,q,q,q,q,shake(:b4,c,1),q,q,qd,sq,q,q,shake(:e5,c,1),c,q,q,q,q,shake(:a5,cd,1),q,c,c,shake(:e5,c,1),q,q,q,q,q,q,shake(:b4,c,1),q,q,shake(:c5,cd,1),q,q,q,c,qd,sq,q,q,m].flatten
nr[2]=[:c5,:d5,shake(:c5,q),:b4,:a4,:e5,:c5,:e5,:d5,:g5,shake(:c5,q),:g5,:b4,:a4,:b4,:g4,:c5,:e5,:g5,:c5,:d5,:g5,:b4,:g5,:e5,:d5,:c5,:b4].flatten+[[:C4,:E4,:A4]]
dr[2]=[qd,sq,shake(:c5,q,1),q,q,q,q,q,q,q,shake(:c5,q,1),q,q,q,q,q,q,q,q,q,q,q,q,q,qd,sq,q,q,m].flatten
nr[3]=[:g5,:a5,shake(:g5,q),:f5,:e5,:d5,:e5,:c5,:d5,:g5,shake(:c5,q),:g5,:b4,:a4,:b4,:g4,:g5,:a5,shake(:g5,q),:f5,:e5,:d5,:e5,:g5,:a5,:g5,:e5,:g5,:a5,:g5,:a5,:c6,:g5,:a5,:g5,:f5,:g5,:f5,:e5,:d5,:e5,:c5,:d5,:e5,:d5,:c5,:d5,:c5,:b4,:a4,:b4,:g4,:c5,:b4,:c5,:a4,:d5,:c5,:d5,:b4,:e5,:d5,:c5,:b4].flatten+[[:c4,:e4,:a4]]
dr[3]=[qd,sq,shake(:g5,q,1),q,q,q,q,q,q,q,shake(:c5,q,1),q,q,q,q,q,qd,sq,shake(:g5,q,1),q,q,q,q,q,q,q,q,q,q,q,q,q,q,sq,sq,q,sq,sq,q,q,q,q,q,sq,sq,q,sq,sq,q,q,q,q,q,q,q,q,q,q,q,q,qd,sq,q,q,m].flatten
nr[4]=[:c5,:b4,:c5,:d5,:c5,:d5,:c5,:b4,shake(:a4,q),:e5,:c5,:e5,:d5,:c5,:d5,:e5,:d5,:e5,:d5,:c5,:b4,:a4,:b4,:g4,shake(:c5,sq),:d5,:e5,:f5,:g5,:c5,:d5,:e5,:fs5,:g5,:b4,:e5,:f5,:e5,:d5,:e5,:d5,:c5,:b4].flatten+[[:C4,:E4,:A4]]
dr[4]=[sq,sq,sq,sq,sq,sq,sq,sq,shake(:a4,q,1),q,q,q,sq,sq,sq,sq,sq,sq,sq,sq,q,q,q,q,shake(:c5,sq,1),sq,sq,sq,q,q,q,sq,sq,q,q,sq,sq,sq,sq,sq,sq,sq,sq,m].flatten
nr[5]=[:g5,:f5,:g5,:a5,:g5,:a5,:g5,:f5,:e5,:d5,:e5,:f5,:e5,:d5,:e5,:c5,:d5,:c5,:d5,:e5,:d5,:e5,:d5,:c5,:b4,:a4,:b4,:c5,:b4,:g4,:g5,:f5,:g5,:a5,:g5,:a5,:g5,:f5,:e5,:d5,:e5,:f5,:e5,:g5,:a5,:g5,:e5,:g5,:a5,:g5,:e5,:g5,:a5,shake(:a4,q),:a5,:c6,:g5,:f5,:g5,:a5,:g5,:f5,:e5,:d5,:e5,:f5,:e5,:c5,:d5,:c5,:d5,:e5,:d5,:c5,:b4,:a4,:b4,:c5,:b4,:g4,:c5,:b4,:c5,:d5,:c5,:a4,:d5,:c5,:d5,:e5,:d5,:b4,:e5,:f5,:e5,:d5,:e5,:d5,:c5,:b4].flatten+[[:c4,:e4,:a4]]
dr[5]=[sq]*28+[q,q]+[sq]*12+[q,q]+[sq]*8+[q,shake(:a4,q,1),q,q].flatten+[sq,sq,sq,sq,q,q]*6+[sq]*8+[m]
nr[6]=[:c5,:e5,shake(:a4,q),:e5,:c5,:e5,:a4,:e5,:d5,:g4,:b4,:d5,:d5,:g4,:b4,:d5,:c5,:e5,shake(:a4,q),:e5,:d5,:g5,:g4,:g5,:e5,:d5,:c5,:b4].flatten+[[:c4,:e4,:a4]]
dr[6]=[q,q,shake(:a4,q,1),q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,shake(:a4,q,1),q,q,q,q,q,qd,sq,q,q,m].flatten
nr[7]=[:e5,:g5,shake(:c5,q),:g5,:e5,:g5,:c5,:g5,:d5,:g5,shake(:b4,q),:g5,:d5,:g5,:b4,:d5,:g5,:e5,:c5,:g5,:e5,:c5,:e5,:g5,:a5,:g5,:e5,:g5,:a5,:g5,:a5,:c6,:g5,:e5,:c5,:g5,:e5,:c5,:e5,:g5,:d5,:c5,:b4,:a4,:g4,:d5,:b4,:g4,:b4,:d5,:c5,:a4,:c5,:e5,:d5,:b4,:d5,:g5,:e5,:d5,:c5,:b4].flatten+[[:c4,:e4,:a4]]
dr[7]=[q,q,shake(:c5,q,1),q,q,q,q,q,q,q,shake(:b4,q,1),q].flatten+[q]*28+[sq,sq,sq,sq,q,q,q,q,q,q,q,q,q,q,q,q,q,q,qd,sq,q,q,m]
nr[8]=[shake(:a4,sq),:b4,:c5,:d5,:e5,:a4,:c5,:a4,:e5,:a4,shake(:g4,sq),:a4,:b4,shake(:c5,sq),:d5,:g5,shake(:g4,sq),:a4,:b4,:c5,:d5,:b4,shake(:a4,sq),:b4,:c5,shake(:d5,sq),:e5,:a5,shake(:g4,sq),:a4,:b4,:c5,:d5,:b4,shake(:a4,sq),:b4,:c5,:d5,:e5,:d5,:c5,:b4].flatten+[[:a3,:e4,:a4]]
dr[8]=[shake(:a4,sq,1),sq,sq,sq,q,q,q,q,q,q,shake(:g4,sq,1),sq,sq,shake(:c5,sq,1),q,q,shake(:g4,sq,1),sq,sq,sq,q,q,shake(:a4,sq,1),sq,sq,shake(:d5,sq,1),q,q,shake(:g4,sq,1),sq,sq,sq,q,q,shake(:a4,sq,1),sq,sq,sq,sq,sq,sq,sq,m].flatten
nr[9]=[shake(:c5,sq),:d5,:e5,:f5,:g5,:c5,:e5,:c5,:g5,:c5,shake(:g4,sq),:a4,:b4,:c5,:d5,:g4,:b4,:g4,:d5,:g4,shake(:c5,sq),:d5,:e5,:f5,:g5,:c5,:e5,:c5,:g5,:c5,:a5,:g5,:f5,:e5,:d5,:c5,:b4,shake(:a4,sq),:b4,:c5,shake(:d5,sq),:e5,:a5,shake(:c5,sq),:d5,:e5,:f5,:g5,:c5].flatten+[[:e4,:g4,:c5]]+[shake(:g4,sq),:a4,:b4,:c5,:d5,:b4,shake(:g4,sq),:a4,:b4,shake(:c5,sq),:d5,:g5,shake(:a4,sq),:b4,:c5,shake(:d5,sq),:e5,:a5,shake(:g4,sq),:a4,:b4,:c5,:d5,:b4,:a5,:g5,:f5,:e5,:d5,:c5,:b4].flatten+[[:c4,:e4,:a4]]
dr[9]=[shake(:c5,sq,1),sq,sq,sq,q,q,q,q,q,q,shake(:g4,sq,1),sq,sq,sq,q,q,q,q,q,q,shake(:c5,sq,1),sq,sq,sq,q,q,q,q,q,q,q,sq,sq,sq,sq,sq,sq,shake(:a4,sq,1),sq,sq,shake(:d5,sq,1),q,q,shake(:c5,sq,1),sq,sq,sq,q,q,m,shake(:g4,sq,1),sq,sq,sq,q,q,shake(:g4,sq,1),sq,sq,shake(:c5,sq,1),q,q,shake(:a4,sq,1),sq,sq,shake(:d5,sq,1),q,q,shake(:g4,sq,1),sq,sq,sq,q,q,q,sq,sq,sq,sq,sq,sq,m].flatten
nr[10]=nr[1][0..-6] #to setup rall at end
dr[10]=dr[1][0..-6]
nr[11]=nr[1][-5..-1]
dr[11]=dr[1][-5..-1]

nl[0]=[:a3,:b3,:c4,:a3,:b3,:a3,:g3,:b3,:a3,:b3,:c4,:d4,:e4,:e3,:a3,:a2]
dl[0]=[c]*16
nl[1]=[:c4,:e4,:g4,:c4,:g3,:b3,:d4,:g3,:c3,:d3,:e3,:c3,:e3,:e2,:a3,:a2,:c3,:e3,:g3,:c3,:g3,:b3,:d4,:g3,:a3,:b3,:c4,:d4,:e4,:e3,:a3,:a2]
dl[1]=[c]*32
nl[2]=[:a3,:b3,:c4,:a3,:b3,:a3,:g3,:b3,:a3,:c4,:b3,:d4,:e4,:e3,:a3,:a2]
dl[2]=[c]*16
nl[3]=[:c4,:e4,:g4,:c4,:b3,:a3,:g3,:b3,:c3,:d3,:e3,:c3,:e3,:e2,:a3,:a2,:c3,:d3,:e3,:c3,:g3,:a3,:b3,:g3,:a3,:c4,:b3,:d4,:e4,:e3,:a3,:a2]
dl[3]=[c]*32
nl[4]=[:a3,:b3,:c4,:a3,:b3,:a3,:g3,:b3,:a3,:c4,:b3,:d4,:e4,:e3,:a3,:a2]
dl[4]=[c]*16
nl[5]=[:c4,:e4,:g4,:c4,:g3,:b3,:d4,:g3,:c3,:d3,:e3,:c3,:e3,:e2,:a3,:a2,:c3,:d3,:e3,:c3,:g3,:a3,:b3,:g3,:a3,:c4,:b3,:d4,:e4,:e3,:a3,:a2]
dl[5]=[c]*32
nl[6]=[:a3,:c4,:a3,:c4,:b3,:g3,:b3,:g3,:a3,:c4,:b3,:d4,:e4,:e3,:a3,:a2]
dl[6]=[c]*16
nl[7]=[:c4,:e4,:g4,:c4,:g3,:b3,:d4,:g3,:c3,:e3,:g3,:c3,:e3,:e2,:a3,:a2,[:c3,:c4],[:e3,:e4],[:c3,:c4],[:g3,:b3,:d4],[:g3,:b3,:d4],:a3,:c4,:b3,:d4,:e4,:e3,:a3,:a2]
dl[7]=[c]*16+[m,c,c,m,m,c,c,c,c,c,c,c,c]
nl[8]=[:a3,:c4,:a3,:c4,:b3,:g3,:b3,:g3,:a3,:c4,:b3,:d4,:e4,:e3,:a3,:a2]
dl[8]=[c]*16
nl[9]=[:c4,:e4,:g4,:c4,:b3,:a3,:g3,:b3,:c3,:e3,:g3,:c3,:e3,:e2,:a3,:a2,[:c3,:e3,:g3],:c3,:d3,:e3,:f3,:g3,:e3,[:g2,:g3],[:b2,:b3],[:g2,:g3],:a3,:c4,:b3,:d4,:e4,:e3,[:a2,:a3]]
dl[9]=[c]*16+[m,sq,sq,sq,sq,q,q,m]+[c]*8+[m]
nl[10]=nl[1][0..-5] #to setup rall at end
dl[10]=dl[1][0..-5]
nl[11]=nl[1][-4..-1]
dl[11]=dl[1][-4..-1]

define :section do |num,reps| #plays one section for left and right hand, with repeat if required
  reps.times do
    in_thread do
      pl(nr[num],dr[num])
    end
    pl(nl[num],dl[num])
  end
end

#play the entire piece with gverb effect
with_fx :gverb,room: 25 do
  10.times do |i| #play 10 sections with their repeats
    section(i,2)
  end
  section(0,1) #reprise: play first section again no repeat
  section(10,1)# section10=section1 without last bar Play second section again, no repeat, with rall in last bar
  use_bpm 125 #start rall
  in_thread do #play 1st beat (section 11 contains last bar of section 1)
    pl(nr[11][0..1],dr[11][0..1]) #rh
  end
  pl(nl[11][0..0],dl[11][0..0]) #lh nb use [0..0] to keep as a list [0] returns just single value: crashes pl
  use_bpm 100 #further rit
  in_thread do #play remainder of last bar
    pl(nr[11][2..-1],dr[11][2..-1]) #rh
  end
  pl(nl[11][1..-1],dl[11][1..-1]) #lh
end #gverb fx