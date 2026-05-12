#Bach Gigue in G minor from English Suite no 3 Coded by Robion Newman December 2014
#Synth version
set_sched_ahead_time! 3
use_debug false
s=0 #to set global scope
define :setbpm do |n| #set bpm equivalent
  s = (1.0 / 8) *(60.0/n.to_f)
end
use_synth :pulse
setbpm(180)
dsq=sq=q=qd=c=cd=cdd=m=md=0 #to setglobal scope

define :lset do
  dsq = 1 * s #demi-semi-quaver
  sq = 2 * s #semi-quaver
  q = 4 * s #quaver
  qd = 6 * s #quaver dotted
  c = 8 * s #crotchet
  cd = 12 * s #crotchet dotted
  m = 16 * s #minim
  md = 24 * s #minim dotted
end
lset
p=0.15 #dynamics
mp=0.2
mf=0.4
f=0.8
ff=1.6


define :plarray do |narray,darray,vol=0.4|
  narray.zip(darray).each do |n,d|
    play n,amp: vol,attack: dsq/10, sustain: 0.9*d-dsq/10,release: 0.1*d #play note
    sleep d #gap till next note
  end
end

define :ct do |ptr,lev,slid=0| #function to adjust level control
  control ptr,amp: lev,amp_slide: slid
end

ritq=ritqb=d1=d2=d3=d1b=d2b=d3b=n1=n2=n3=n1b=n2b=n3b=[] #define global scope
define :parts do
ritq=[q*1.02,q*1.04,q*1.06,q*1.08,q*1.1,q*1.12]
ritqb=[q*1.02,q*1.04,q*1.06,q*1.08,q*1.1,q*1.2,q*1.4,q*1.6,q*1.8]
n1=[:d5,:eb5,:d5,:c5,:bb4,:a4,:g4,:fs4,:a4,:d4,:c4,:bb3,:a3,:bb3,:d4,:g4,:a3,:g4,:fs4,:g4,:bb4,:a4,:bb4,:d5,:c5]
d1=[q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q]
#3
n1.concat [:d5,:e5,:f5,:e5,:f5,:g5,:a5,:g5,:f5,:g5,:f5,:e5,:f5,:g5,:a5,:d5,:c5,:bb4,:c5,:d5,:bb4,:c5]
d1.concat [cd+q,q,q,cd+q,q,q,q,q,q,q,q,q,q,q,q,cd+q,q,q,cd+c,q,c,q]
#6
n1.concat [:a4,:bb4,:c5,:d5,:bb4,:c5,:d5,:e5,:fs5,:g5,:a5,:g5,:f5,:e5,:f5,:eb5,:d5,:c5,:d5,:c5,:bb4,:a4,:bb4,:r,:a4,:r,:a4,:g4,:a4,:r,:e4,:g4]
d1.concat [c,q,c,q,c,q,cd+c,q,cd,cd,cd+cd,cd+q,q,q,cd+cd,cd+q,q,q,cd+cd,cd+q,q,q,cd,q,c,q,q,q,cd,q,q,q]
#12
n1.concat [:f4,:g4,:a4,:g4,:a4,:bb4,:a4,:d5,:f5,:g4,:g5,:e5,:f5,:a5,:g5,:a5,:a4,:cs5,:b4,:c5,:e5,:d5,:e5,:e4,:g4,:f4]
d1.concat [cd+q,q,q,cd+q,q,q,q,q,q,q,q,q,q,q,q,cd,q,q,q,q,q,q,cd,q,q,q]
#15
n1.concat [:g4,:bb4,:a4,:bb4,:cs4,:e4,:d4,:e4,:g4,:f4,:g4,:bb4,:a4,:bb4,:a4,:g4,:cs5,:bb4,:a4,:d5,:a4,:g4,:e5,:a4,:g4,:f4,:g4,:e4,:f4,:e4,:d4,:g4,:e4,:d4]
d1.concat [q,q,q,cd]+[q]*30
#18
n1.concat [:a4,:e4,:d4,:bb4,:e4,:d4,:cs4,:d4,:e4,:a3,:r,:a5,:bb5,:a5,:g5,:f5,:e5,:d5,:cs5,:e5,:a4,:g4,:f4,:e4,:f4,:a4,:d5,:e4,:d5,:cs5,:d5,:a4,:fs4,:d4]
d1.concat [q]*27+ritq+[c*1.12]
#end part 1
n2=[:r,:g4,:bb4,:a4,:g4,:f4,:e4,:d4,:cs4,:e4,:a3,:g3,:f3,:e3,:f3,:a3,:d4,:e3,:d4,:cs4,:d4,:e4,:f4,:e4,:fs4,:g4,:a4,:g4,:fs4,:g4,:fs4,:e4]
d2=[q*24]+[q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,cd+q,q,q,cd+q,q,q,q,q,q,q,q,q]
#6
n2.concat [:fs4,:e4,:d4,:e4,:g4,:fs4,:g4,:a4,:bb4,:a4,:bb4,:c5,:d5,:c5,:bb4,:c5,:bb4,:a4,:bb4,:a4,:g4,:f4,:eb4,:d4,:f4,:e4,:f4,:e4,:d4,:cs4,:b3,:cs4]
d2.concat [q,q,q,q,q,q,cd+q,q,q,cd+q,q,q,q,q,q,q,q,q,md,md,md,md,md,cd+q,q,q,c,q,cd+q,q,q,cd]
#12
n2.concat [:d4,:e4,:f4,:e4,:f4,:g4,:a4,:g4,:r]
d2.concat [cd+q,q,q,cd+q,q,q,cd,cd,cd*2+72*q+9.42*q+c*1.2] #rit at end
#end part 1
n3=[:r,:d4,:eb4,:d4,:c4,:bb3,:a3,:g3,:fs3,:a3,:d3,:c3,:bb2,:a2,:bb2,:d3,:g3,:a2,:g3,:fs3,:g3,:bb3,:a3,:bb3,:d4,:c4,:d4,:a3,:d3]
d3=[q+60*q+5*q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,cd+q,q,q]
#9

n3.concat [:eb3,:g3,:f3,:g3,:bb3,:a3,:bb3,:f3,:bb2,:c3,:eb3,:d3,:eb3,:g3,:f3,:g3,:cs3,:d3,:c3,:bb2,:c3,:bb2,:a2,:r,:a3]
d3.concat [q,q,q,q,q,q,cd+q,q,q,q,q,q,q,q,q,cd+c,q,c,q,sq,sq,c,cd,c,q]
#12
n3.concat [:bb3,:a3,:g3,:f3,:e3,:d3,:cs3,:e3,:a2,:g2,:g2,:e2,:f2,:a2,:d3,:e2,:d3,:cs3,:d3,:f3,:e3,:f3,:a3,:g3,:a3,:a2,:cs3,:b2,:cs3,:e3,:d3]
d3.concat [q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,cd+q,q,q,q,q,q,cd,q,q,q,q,q,q]
#15

n3.concat [:e3,:g3,:f3,:g3,:bb3,:a3,:bb3,:g3,:f3,:e3,:f3,:g3,:a2,:r,:b2,:r,:cs3,:a2,:b2,:cs3,:d3,:r,:e3,:r]
d3.concat [cd+q,q,q,cd+q,q,q,q,q,q,q,q,q,c,q,c,q,c,q,c,q,c,q,c,q]
#18
n3.concat [:f3,:r,:g3,:f3,:e3,:f3,:cs4,:d4,:g3,:cs4,:d4,:gs3,:cs4,:d4,:a3,:cs4,:d4,:e4,:d4,:cs4,:d4,:f3,:g3,:a3,:g3,:a3,:d3,:fs3,:a3,:d4]
d3.concat [c,q,cd+q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q]+ritq+[c*1.12]
#end part1
n1b=[:a3,:fs3,:g3,:a3,:bb3,:c4,:d4,:eb4,:c4,:g4,:a4,:bb4,:c5,:bb4,:g4,:d4,:c5,:e4,:fs4,:g4,:e4,:f4,:e4,:cs4,:d4,:a4,:g4,:f4,:g4,:f4,:e4]
d1b=[q]*25+[cd+q,q,q,cd+q,q,q]
#24
n1b.concat [:d4,:e4,:f4,:e4,:a4,:g4,:f4,:eb4,:d4,:bb4,:a4,:g4,:a4,:g4,:fs4,:g4,:eb5,:f4,:d5,:r,:g4,:fs4,:g4,:a4,:bb4,:c5,:d5,:eb5,:c5,:g5,:a5,:bb5,:c6,:bb5,:g5,:d5,:c6,:e5,:fs5,:g5,:d5,:eb5,:f5,:c5,:d5]
d1b.concat [q,q,q,q,q,q,q,q,q,cd+q,q,q,q,q,q,c,q,c,q,11*q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q]
#29
n1b.concat [:eb5,:f5,:e5,:f5,:e5,:d5,:e5,:f5,:c5,:d5,:eb5,:bb4,:c5,:d5,:a4,:bb4,:c5,:g4,:a4,:bb4,:g5,:ab4,:f5,:g4,:eb5,:f4,:d5,:eb4,:f4,:g4,:d4,:eb4,:c4]
d1b.concat [cd,sq,sq,sq,sq,sq,sq,q,q,q,q,q,q,q,q,q,q,q,q,c,q,c,q,c,q,c,q,q,q,q,q,q,q]
#32
n1b.concat [:b3,:c4,:d4,:eb4,:f4,:g4,:ab4,:f4,:c5,:d5,:eb5,:f5,:g5,:eb5,:c5,:f5,:a4,:b4,:eb5,:c5,:a4,:d5,:fs4,:g4,:c5,:a4,:fs4,:bb4,:d4,:eb4,:a4,:f4,:d4,:g4,:bb3,:c4]
d1b.concat [q]*36
#35
n1b.concat [:d4,:e4,:fs4,:g4,:a4,:bb4,:c5,:d5,:eb5,:d5,:bb5,:eb5,:d5,:c5,:bb4,:g5,:c5,:bb4,:ab4,:g4,:eb5,:ab4,:g4,:f4,:eb4,:c5,:eb4,:d4,:c5,:bb4,:c4,:bb4,:a4,:d4,:c5,:bb4,:e4,:d5,:c5,:fs4,:eb5,:d5]
d1b.concat [cd+q,q,q,q,q,q,q,q,q,c,q,q,q,q,c,q,q,q,q,c,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q]
#39

n1b.concat [:g4,:c5,:bb4,:a4,:bb4,:g4,:fs4,:eb4,:d4,:g4,:d4,:c4,:a4,:d4,:c4,:bb3,:c4,:a3,:bb3,:a3,:g3,:c4,:a3,:g3,:d4,:a3,:g3,:eb4,:a3,:g3,:fs3,:g3,:a3,:bb3,:c4,:d4]
d1b.concat [q]*3*12
#42
n1b.concat [:eb4,:c4,:g4,:a4,:bb4,:c5,:d5,:bb4,:g4,:c5,:e4,:fs4,:g4,:d5,:g5,:f5,:eb5,:d5,:c5,:bb4,:a4,:g4,:fs4,:g4,:eb5,:d5,:bb4,:c5,:bb4,:a4,:g4,:g4,:d4,:bb3,:g3]
d1b.concat [q]*12+[c]+[q]*10+ritqb[0..2]+[dsq*1.08,dsq*1.08,sq*1.08]+ritqb[4..-1]+[c*1.2]
#end part 2
n2b=[:r,:eb4,:d4,:c4,:d4,:c4,:bb3,:c4,:a4,:bb3,:c4,:d4,:c4,:bb3,:c4,:bb3,:a3,:g3,:a3,:bb3,:c4,:bb3,:c4,:b3,:c4,:b3,:a3,:b3,:r]
d2b=[q*61,q,q,q,q,q,q,c,q,c,q,cd+q,q,q,cd+q,q,q,cd,q,q,q,cd,sq,sq,sq,sq,sq,sq,q*12*15+11.3*q+c*1.2]
#end part 2
n3b = [:r,:d2,:cs2,:d2,:e2,:f2,:g2,:a2,:bb2,:g2,:d3,:e3,:f3,:g3,:f3,:d3,:a2,:g3,:b2,:cs3,:d3,:c3,:bb2,:c3,:d3,:eb3,:d3,:c3,:d3,:c3,:b2]
d3b = [q*24,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q,cd+q,q,q,cd+c,q,q,q,q,q,q,q]
#26
n3b.concat [:c3,:a3,:bb2,:g3,:a3,:g3,:fs3,:g3,:f3,:eb3,:d3,:e3,:fs3,:g3,:a3,:bb3,:fs3,:g3,:eb3,:c3,:d3,:g3,:c4,:g3,:a3,:bb3,:f3,:g3,:a3,:f3,:g3,:a3]
d3b.concat [c,q,c,q,q,q,q,q,q,q,q,q,q,cd+q,q,q,cd,c,q,c,q,md,q,q,q,q,q,q,c,q,c,q]
#30
n3b.concat [:bb3,:fs3,:g3,:a3,:e3,:f3,:g3,:d3,:eb3,:f3,:c3,:d3,:eb3,:b2,:c3,:d3,:a2,:b2,:c3,:d3,:eb3,:f3,:g3,:ab3,:g3,:a3,:b3,:c3,:d3,:eb3,:f3,:g3,:ab3,:b2,:c3,:d3]
d3b.concat [q]*12*3
#33
n3b.concat [:eb3,:ab3,:d3,:g3,:c3,:r,:bb3,:a3,:r,:g3,:f3,:r,:eb3,:fs2,:g2,:a2,:bb2,:c3,:d3,:eb3,:c3,:g3,:a3,:bb3,:c3]
d3b.concat [c,q,c,q,c,cd,q,cd,c,q,cd,c,q,q,q,q,q,q,q,q,q,q,q,q,q]
#36
n3b.concat [:bb3,:g3,:d3,:c4,:e3,:fs3,:g3,:d3,:bb2,:ab3,:c3,:d3,:eb3,:bb2,:g2,:f3,:a2,:b2,:c3,:r,:g2,:r,:e2,:r,:fs2,:r,:g2,:r,:a2,:r]
d3b.concat [q]*18+[c,q,c,q,c,q,c,q,c,q,c,q]
#39
n3b.concat [:bb2,:r,:c3,:r,:d3,:r,:e3,:r,:fs3,:d2,:e2,:fs2,:g2,:r,:a2,:r,:bb2,:r,:c3,:r,:d3,:e3,:fs3,:g2,:a2,:bb2]
d3b.concat [c,q,c,q,c,q,c,q,c,q,c,q,c,q,c,q,c,q,c,q,q,q,q,q,q,q]
#42
n3b.concat [:c3,:d3,:eb3,:fs2,:g2,:a2,:bb2,:eb3,:a2,:d4,:eb4,:d4,:c4,:bb3,:a3,:g3,:fs3,:a3,:d3,:c3,:bb2,:a2,:bb2,:g3,:c3,:d3,:c3,:d3,:g2,:bb2,:d3,:g3]
d3b.concat [q,q,q,q,q,q,c,q,c,q]+[q]*12+ritqb+[c*1.2]
end
define :part1 do
  with_fx :level do |x| #control level
    in_thread do #dynamics thread
      ct(x,mf,0)
      sleep 13*q
      ct(x,mp,6*q)
      sleep 6*q
      ct(x,mf,6*q)
      sleep 30*q #5
      ct(x,p,12*q)
      sleep 12*q
      ct(x,f,6*q)
      sleep 3*12*q+3*q #4th 9
      ct(x,p,15*q) #end at 11
      sleep 15*q+2*q
      ct(x,f,22*q) #end at 13
      sleep 34*q #till 14
      ct(x,ff,6*q)
      sleep 6*q
      ct(x,f,3*q)
      sleep 3*q
      ct(x,ff,6*q)
      sleep 6*q
      ct(x,f,3*q)
      sleep 3*q
      ct(x,ff,18*q)
      sleep 18*q
      ct(x,f,6*q)
      sleep 6*q #end mid 17
      ct(x,ff,9*q)
      sleep 9*q
      ct(x,f,8*q)
      sleep 8*q
      ct(x,ff,0) #last q of 18
      sleep 25*q
    end
    in_thread do
      plarray(n1,d1)
    end
    in_thread do
      plarray(n2,d2)
    end
    plarray(n3,d3)
  end
end
define :part2 do
  with_fx :level do |x|
    in_thread do #dynamics thread
      ct(x,mf,0)
      sleep 25*q #end at start 23
      ct(x,f,47*q) #end last q of 26
      sleep 82*q #till last beat 22
      ct(x,mf,21*q) #till 24 3rd beat
      sleep 29*q #until 3rd q 25
      ct(x,f,10) #till start 26
      sleep 16*q
      ct(x,p,18*q) #to last q 27
      sleep 21*q
      ct(x,f,9*q) #to start 29
      sleep 18*q
      ct(x,mf,9*q)
      sleep 15*q
      ct(x,f,12*q) #end 31
      sleep 12*q
      ct(x,mf,6)
      sleep 9*q
      ct(x,f,3*q)
      sleep 3*q
      ct(x,p,6*q)
      sleep 10*q
      ct(x,f,25*q)
      sleep 32*q
      ct(x,mf,17*q)
    end
    in_thread do
      plarray(n1b,d1b)
    end
    in_thread do
      plarray(n2b,d2b)
    end
    plarray(n3b,d3b)
  end
end
parts #setup parts arraya
part1
part1
part2
setbpm(170)
lset #reset length variables
parts #reset parts arrays
part2