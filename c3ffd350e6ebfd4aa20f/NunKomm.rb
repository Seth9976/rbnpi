#Sonic Pi Nun komm, der Heiden Heiland by J.S. Bach. Coded by Robin Newman, April 2015
#based on transcription by Richard Fiset for Two Trumpets and two trombones Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported licence
#see http://imslp.org/wiki/18_Chorale_Preludes,_BWV_651-668_%28Bach,_Johann_Sebastian%29 (number 2.2.4)
#sample pack download at http://r.newman.ch/rpi/NunKomm.zip
#at present file is too large to run on a Mac until tcp rather than udp comms are implemented: tested ok on Pi B+ and Pi2

#uses function pitch_ratio defined in SP ver 2.5dev
#The function is defined in the program. If you have 2.5dev or later you can comment out the definition

use_debug false
use_sample_pack_as '/home/pi/samples/NunKomm',:nunkomm #adjust location as necessary

#first deal with selecting and setting up the samples
inst0=:nunkomm__trumpet_cs5
samplepitch0=:cs5
inst1=:nunkomm__tenor_trombone_as3
samplepitch1=:as3
inst2=:nunkomm__bass_trombone_as2
samplepitch2=:as2
inst3=:nunkomm__trumpetstretch_as4
samplepitch3=:as4
inst4=:nunkomm__tenor_trombonestretch2_as3
samplepitch4=:as3
inst5=:nunkomm__bass_trombonestretch_as2
samplepitch5=:as2

#preload all the samples

load_flag=0
if sample_loaded? inst0  then #check if sample already loaded
  load_flag=1
end
load_samples [inst0,inst1,inst2,inst3,inst4,inst5]
if load_flag==0 then #samples not loaded so allow time
  sleep 3
end

#put the sample names and pitches into an array i
i=[[inst0,samplepitch0],[inst1,samplepitch1],[inst2,samplepitch2],[inst3,samplepitch3],[inst4,samplepitch4],[inst5,samplepitch5]]

#define variables that need to be used globally
s=0 #note duration scale factor

#prior to the release of version 2.5 you need the next function
#if you get an error message saying it exists then delete it or comment it out
uncomment do
  define :pitch_ratio do |n|
    return 2**(n.to_f/12)
  end
end

#this function plays the sample at the relevant pitch for the note desired
#the note duration is used to set up the envelope parameters
define :pl do |inst,samplepitch,nv,dv,vol=1,st=0|
  shift=note(nv)-note(samplepitch)
  #start: param used with very small value to give more immediate attack for some samples
  sample inst,rate: (pitch_ratio shift),sustain: 0.8*dv,release: 0.2*dv,amp: vol,start: st
end

#this function plays an array of notes and associated array of durations
#also uses sample name (inst), sample normal pitch,sample start and shift (transpose) parameters
define :plarray do |inst,samplepitch,narray,darray,shift=0,vol=1,st=0|
  narray.zip(darray) do |nv,dv|
    if nv != :r
      pl(inst,samplepitch,note(nv)+shift,dv*s,vol)
    end
    sleep dv*s
  end
end

#set_bpm sets bpm required adjusting note duration variables accordingly
define :set_bpm do |n|
  s=1.0/8*60/n.to_f
end
#set realtive note duration variables
dsq = 1.0 #must be float as divided later
sq = 2
sqd = 3
q = 4
qt = 2.0/3*q
qd = 6
qdd = 7
c = 8
cd = 12
cdd = 14
m = 16
md = 24
mdd = 28
b = 32
bd = 48
#set up the part lists
n1=[:r,:g4,:g4,:fs4,:g4,:a4,:bb4,:g4,:a4,:g4,:fs4,:g4,:c5,:a4,:bb4,:a4,:g4,:a4,:d5,:r,:g4,:a4,:bb4,:c5,:d5,:eb5,:d5,:c5,:bb4,:a4,:a4,:bb4,:c5]
d1=[b*3+c,c,c,q,sq,sq,c+sq,sq,dsq,dsq,dsq,dsq,c+sq,sq,dsq,dsq,dsq,dsq,c,sq,dsq,dsq,dsq,dsq,sq,qd,sq,sq,dsq,dsq,sq,dsq,dsq]
#b7
n1.concat [:g4,:fs4,:e4,:d4,:g4,:a4,:g4,:fs4,:g4,:c5,:a4,:g4,:fs4,:g4,:fs4,:g4,:g4,:r]
d1.concat [sq,sq,sq,sq,c+dsq,dsq,dsq,dsq,sq,dsq,dsq,q,dsq/2,dsq/2,sqd-dsq,dsq,m,2*b+m]
#b11
n1.concat [:g4,:bb4,:a4,:bb4,:c5,:bb4,:c5,:bb4,:a4,:bb4,:c5,:d5,:eb5,:c5,:bb4,:c5,:d5,:eb5,:f5,:d5,:c5,:d5,:eb5,:f5,:g5,:c5,:d5,:eb5,:bb4,:a4,:g4,:f4,:f5]
n1.concat [:g5,:f5,:eb5,:f5,:d5,:eb5,:a5,:bb5,:c6,:eb5,:d5] #hangs sq
d1.concat [q,sq,sq,dsq/2,dsq/2,c-dsq,c+sq,sq,sq,sq,sq,sq,qd,sq,sq,sq,sq,sq,qd,sq,sq,sq,sq,sq,qd,sq,sq,sq,sq,sq,sq,sq,c+sq,dsq,dsq,dsq,dsq,sq,c+sq,dsq,dsq,sq,sq,c+sq]
#b15
n1.concat  [:g4,:g4,:f4,:g4,:c5,:bb4,:a4,:bb4,:a4,:g4,:f4,:g4,:a4,:bb4,:c5,:d5,:eb5,:f5,:g5,:f5,:eb5,:d5,:c5,:bb4,:d5,:c5,:d5,:c5,:bb4,:bb4,:r]
n1.concat [:bb4,:c5,:bb4,:a4,:bb4,:c5,:d5,:c5,:bb4,:c5,:d5,:bb4,:a4,:bb4,:bb4,:f5,:eb5,:d5]
d1.concat  [sq,dsq,dsq,sq,dsq,dsq,sq,dsq,dsq,sq,sq,dsq,dsq,dsq,dsq,dsq,dsq,c+sq,dsq,dsq,dsq,dsq,dsq,dsq,q,dsq/2,dsq/2,sqd-dsq,dsq,m,b*2]
d1.concat [q,dsq,dsq,dsq,dsq,q,dsq,dsq,dsq,dsq,sq,sq,sq,sq,sq,q,dsq,dsq] #extra sq at start
#b20
n1.concat [:c5,:d5,:c5,:bb4,:c5,:d5,:eb5,:d5,:c5,:d5,:eb5,:c5,:bb4,:c5,:c5,:g5,:f5,:eb5,:d5,:g5,:a5,:bb5,:f5,:eb5,:d5,:d5,:c5,:c5,:fs5,:g5,:a5,:eb5,:d5,:c5,:c5,:bb4]#hang dsq
n1.concat [:bb4,:g5,:f5,:eb5,:d5,:c5,:d5,:c5,:b4,:c5,:eb5,:d5,:c5,:d5,:eb5,:c5,:ab4,:g4,:ab4,:eb5,:d5,:eb5,:c5,:b4,:c5,:c5,:ab4,:g4,:ab4,:ab4,:g4,:fs4,:g4,:fs4,:a4,:c5,:eb5,:d5,:d5] #hang dsq
d1.concat [sq,dsq,dsq,sq,sq,sq,dsq,dsq,sq,sq,sq,sq,sq,sq,sq,q,dsq,dsq,sq,dsq,dsq,sq,sq,sq,sq,sq,sq,sq,dsq,dsq,sq,sq,sq,sq,sq,sq]
d1.concat [sq,sq+dsq,dsq,dsq,dsq,dsq,dsq,dsq,dsq,qd,dsq,dsq,dsq,dsq,sq+dsq,dsq,dsq,dsq,qd]+[dsq]*14+[sq,dsq,dsq,sq,sq,c+dsq]
#b24
n1.concat [:g5,:fs5,:eb5,:d5,:c5,:bb4,:a4,:bb4,:a4,:g4,:a4,:g4,:r,:g4,:g4,:fs4,:g4,:a4,:g4,:fs4,:g4,:fs4,:g4,:a4]
d1.concat [dsq,dsq,dsq,sqd,dsq,q,dsq/4,dsq/4,dsq/2,dsq,sq,m,b*3+c,c,dsq,dsq,sq,dsq,dsq,dsq,dsq,q,sq,sq]
#b29
n1.concat [:bb4,:g4,:g4,:a4,:g4,:fs4,:g4,:c5,:a4,:a4,:bb4,:a4,:g4,:a4,:d5,:g4,:a4,:bb4,:c5,:d5,:eb5,:d5,:c5,:bb4,:a4,:a4,:bb4,:c5]
n1.concat [:g4,:fs4,:e4,:d4,:g4,:a4,:g4,:fs4,:g4,:c5,:a4,:g4,:fs4,:g4,:fs4,:g4,:g4,:g5,:f5,:eb5,:d5,:g5,:f5,:eb5,:d5,:f5,:eb5,:d5,:c5,:bb5,:a5,:bb5,:c6,:bb5,:a5,:g5,:fs5]
d1.concat [c+sq,sq,dsq/4,dsq/4,dsq/2,dsq,sq,c+sq,sq,dsq/4,dsq/4,dsq/2,dsq,sq,c+sq,dsq,dsq,dsq,dsq,sq,qd,sq,sq,dsq,dsq,sq,dsq,dsq]
d1.concat [sq,sq,sq,sq,c+dsq,dsq,dsq,dsq,sq,dsq,dsq,q,dsq/4,dsq/4,sqd-dsq/2,dsq,sq,sq,qd]+[dsq]*10+[q+dsq,dsq,dsq,dsq,dsq,dsq,dsq,dsq]
#b33
n1.concat [:g5,:fs5,:g5,:a5,:c5,:eb5,:d5,:c5,:d5,:c5,:bb4,:a4,:bb4,:g5,:eb5,:cs5,:d5,:g4,:bb4,:a4,:bb4,:a4,:bb4,:a4,:g4,:a4]#last note separate
d1.concat [dsq,dsq,dsq,dsq,q+dsq,dsq,dsq,dsq,dsq,dsq,dsq,dsq,sq,dsq,dsq,dsq,dsq,sq,sq,dsq,dsq,dsq/4,dsq/4,dsq/2,dsq,sq]
#end

n2=[:r,:d4,:d4,:c4,:f4,:eb4,:d4,:eb4,:d4,:c4,:d4,:r,:bb3,:a3,:g3,:a3,:r,:g4,:fs4,:g4,:eb4]
d2=[md,c,c,c,cd,sq,sq,m,md,c,md,q,c,sq,sq,c,cd,c,q,q,q]
#b7
n2.concat [:d4,:r,:bb3,:eb4,:d4,:c4,:bb3,:c4,:d4,:c4,:bb3,:a3,:bb3,:c4,:d4,:eb4,:f4,:g4,:c4,:d4,:eb4,:f4,:g4,:f4,:eb4]
d2.concat [c,q,q,c,q,c,sq,sq,q,sq,sq,cd,sq,sq,q,q,q,q,cd,sq,sq,cd,sq,sq,m]
#b11
n2.concat [:d4,:eb4,:f4,:g4,:f4,:eb4,:d4,:c4,:r,:g4,:f4,:r,:bb4,:bb4,:r,:g4,:f4,:r,:ab4,:g4,:r,:g4,:f4,:r,:f4]
d2.concat [cd,sq,sq,sq,sq,sq,sq,q,c,q,m,q,q,c,q,q,c,q,q,c,q,q,c,q,q]
#b15
n2.concat  [:g4,:r,:g4,:r,:c4,:r,:eb4,:d4,:g4,:f4,:d4,:eb4,:d4,:eb4,:f4,:eb4,:d4,:c4,:d4,:eb4,:f4,:eb4,:d4,:eb4,:c5,:fs4,:g4,:a4,:g4,:f4,:eb4,:d4,:g4]
d2.concat  [q,q,q,q,q,c,q,q,q,sq,sq,c,sq,sq,q,sq,sq,cd,sq,sq,m+q,sq,sq,q,q,q,q,cd,q,cd,q,q,q]
#b20
n2.concat [:a4,:r,:b4,:c5,:r,:a4,:bb4,:r,:bb4,:a4,:r,:a4,:g4,:r,:f4,:g4,:f4,:g4,:r,:d4,:eb4,:d4,:eb4,:r,:eb4,:d4,:fs4,:g4,:a4]
d2.concat [q,c,q,q,c,q,c,q,q,c,q,q,c,sq,sq,sq,sq,q,qd,sq,sq,sq,q,c,q,q,q,q,q]
#b24
n2.concat [:d4,:g4,:r,:d4,:c4,:b3,:c4,:d4,:d4,:eb4,:eb4,:d4,:c4,:d4,:eb4,:eb4,:f4,:f4,:eb4,:g4,:f4,:f4,:eb4,:eb4,:d4]
n2.concat [:d4,:ab4,:Ab4,:g4,:g4,:f4,:f4,:eb4,:eb4,:f4,:d4,:eb4,:d4,:g4,:eb4,:f4,:f4,:eb4,:eb4,:d4,:d4,:c4,:c4,:bb3,:bb3,:a3,:a3,:bb3,:c4]
d2.concat [q,q,q,c,sq,sq,sq,sq,sq,sq,m+q,sq,sq,sq,sq,sq,sq,m+sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,qd,sq,dsq/2,dsq/2,qd-dsq,sq]
d2.concat [sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,sq,sq]
#b29
n2.concat [:fs3,:r,:bb3,:a3,:g3,:a3,:r,:g4,:fs4,:g4,:eb4,:d4,:r,:bb3,:eb4,:d4,:c4,:b3,:c4,:d4,:b3,:c4,:d4,:c4,:d4,:bb3]
d2.concat [c,q,c,sq,sq,c,cd,c,q,q,q,c,q,q,c,q,q,q,q,q,q,q,q,q,sq,sq]
#b33
n2.concat [:a3,:g3,:fs3,:a3,:eb4,:d4,:c4,:b3,:f4,:d4,:eb4,:b3,:c4,:d4]
d2.concat [q,q,q,sq,sq,c+qd,q,sq*1.05,sq*1.1,sq*1.15,sq*1.2,sq*1.25,q*1.25,md]
#end

n3=[:r,:f3,:f3,:eb3,:ab3,:g3,:f3,:g3,:f3,:bb3,:ab3,:g3,:f3,:e3,:f3,:g3,:ab3,:g3,:f3,:g3,:f3,:e3,:f3,:r,:bb3,:ab3,:g3,:ab3,:c4,:bb3,:ab3,:g3,:f3,:bb3]
d3=[c,c,c,c,cd,sq,sq,c,m,m,q,q,q,q,q,q,q,sq,sq,cd,sq,sq,c,cd,c,sq,sq,q,qd,q,sq,sq,sq,q]
#b7
n3.concat [:g3,:r,:f3,:bb3,:g3,:f3,:eb3,:ab3,:g3,:a3,:bb3,:c4,:bb3,:a3,:bb3]
d3.concat [c,q,c,q,c,md,m,m,cd,sq,sq,cd,sq,sq,cd] #hangs a quaver
#b11
n3.concat [:ab3,:bb3,:c4,:r,:f3,:g3,:r,:ab3,:bb3,:g3,:ab3,:c4,:bb3,:c4,:eb4,:ab3,:db4,:c4,:bb3,:ab3,:g3,:ab3,:bb3,:c4,:bb3,:a3,:bb3,:ab3,:g3,:ab3]
d3.concat [sq,sq,c,q,q,q,c,q,q,q,q,sq,sq,q,q,q,sq,sq,cd,sq,sq,sq,sq,c,sq,sq,cd,sq,sq,cd]#extra q start hangs q
#b15
n3.concat  [:r,:db4,:r,:g3,:r,:g3,:ab3,:g3,:eb3,:ab3,:g3,:a3,:bb3,:c4,:bb3,:a3,:g3,:f3,:g3,:ab3,:bb3,:c4,:db4,:c4,:bb3,:ab3,:db4,:c4,:bb3,:ab3,:ab3]
d3.concat  [q,q,q,q,c,q,cd,q,c,m,cd,sq,sq,sq,sq,sq,sq,cd,sq,sq,sq,sq,c,sq,sq,q,c,sq,sq,cd,q]
#b20
n3.concat [:eb4,:r,:eb4,:f4,:eb4,:db4,:r,:c4,:f4,:eb4,:db4,:c4,:r,:c4,:c4,:r,:c4,:db4,:c4,:db4,:r,:a3,:bb3,:a3,:bb3,:r,:bb3,:ab3,:g3,:bb3,:c4,:bb3,:bb3,:ab3]
d3.concat [q,c,q,q,q,c,q,q,q,q,q,q,q,q,c,sq,sq,sq,sq,q,qd,sq,sq,sq,q,c,sq,sq,q,q,sq,sq,sq,sq]
#b24
n3.concat [:ab3,:f3,:e3,:f3,:f3,:eb3,:f3,:g3,:g3,:ab3,:ab3,:g3,:f3,:g3,:a3,:a3,:bb3,:r,:c4,:a3,:bb3,:a3,:g3,:a3,:bb3,:r]
d3.concat [q,c,q,m+q,sq,sq,sq,sq,sq,sq,m+q,sq,sq,sq,sq,sq,sq,b+qd,sq,dsq/2,dsq/2,qd-dsq,dsq,dsq,q,cd+m]
#b29
n3.concat [:r,:c3,:f3,:r,:bb3,:ab3,:g3,:ab3,:c4,:bb3,:ab3,:g3,:f3,:bb3,:ab3,:g3,:r,:f3,:bb3,:g3,:f3,:g3,:a3,:f3,:eb3,:db3,:c3,:db3]
d3.concat [q,q,c,cd,c,sq,sq,q,qd,q,sq,sq,sq,sq,sq,c,q,c,q,c,q,q,q,c,q,q,sq,sq]
#b33
n3.concat [:bb2,:db3,:c3,:e3,:f3,:e3,:f3,:e3,:ab3]
d3.concat [q,q,q,q,cd,q,8*sq,sq*1.25,md]
#end

n4=[:f2,:g2,:ab2,:bb2,:c3,:db3,:c3,:bb2,:ab2,:c3,:eb3,:db3,:c3,:bb2,:a2,:f2,:bb2,:ab2,:g2,:f2,:e2,:c2,:f2,:eb2,:db2,:c2,:db2,:c2]
n4.concat [:c3,:db3,:c3,:d3,:bb2,:eb3,:db3,:e3,:c3,:f3,:f2,:bb2,:c3,:db3,:bb2]
d4=[q]*26+[c,m+q]+[q]*15
#b7
n4.concat [:c3,:bb2,:ab2,:db3,:bb2,:g2,:c3,:c2,:f2,:g2,:ab2,:bb2,:c3,:db3,:c3,:bb2,:ab2,:bb2,:c3,:db3,:eb3,:f3,:eb3,:db3,:c3,:bb2,:a2,:f2,:bb2,:c3,:db3,:bb2]
d4.concat [q]*32
#b11
n4.concat [:f3,:f2,:f3,:eb3,:db3,:bb2,:eb3,:f3,:g3,:f3,:g3,:eb3,:ab3,:ab2,:ab3,:gb3,:f3,:eb3,:db3,:db2,:c2,:bb2,:a2,:f2,:bb2,:ab2,:g2,:eb2,:ab2,:c3]
d4.concat [q]*18+[cd]+[q]*11
#b15
n4.concat  [:db3,:c3,:db3,:c3,:db3,:c3,:db3,:bb2,:c3,:db3,:eb3,:eb2,:ab2,:bb2,:c3,:db3,:eb3,:f3,:eb3,:db3,:c3,:bb2,:a2,:f2]
n4.concat [:bb2,:c3,:bb2,:ab2,:g2,:f2,:e2,:c2,:f2,:f3,:g3,:eb3,:ab2,:bb2,:c3,:db3]
d4.concat  [q]*40
#b20
n4.concat [:eb3,:eb2,:db2,:c2,:bb1,:c2,:db2,:bb1,:f2,:f3,:r,:f3,:f3,:e3,:r,:e3,:f3,:eb3,:db3,:c3,:bb2,:bb1,:bb2,:g2,:ab2,:e2]
d4.concat [q]*18+[cd,q,cd,q,cd,q,q,q]
#b24
n4.concat  [:f2,:ab2,:bb2,:c3,:db3,:eb3,:db3,:c3,:bb2,:bb1,:r,:bb2,:f2,:f3,:eb3,:db3,:c3,:c2,:c3,:f2,:bb2,:db3,:gb2,:bb2]
n4.concat [:eb2,:eb3,:db3,:gb3,:f3,:eb3,:f3,:f2,:bb2,:c3,:bb2,:ab2,:g2,:c2,:c3] #hang q
d4.concat  [q]*38+[cd]
#b29
n4.concat [:ab2,:db3,:c3,:d3,:bb2,:eb3,:db3,:e3,:c3,:f3,:f2,:bb2,:c3,:db3,:bb2,:c3,:bb2,:ab2,:db3,:bb2,:g2,:c3,:c2] #last note separate
d4.concat  [q]*23
#b33
n4.concat [:f2,:ab2,:c3,:c2]
d4.concat [m+q,q,q,q]
#end
nbodge=[:r,:bb3] #play long note with stretched sample
dbodge=[25*b+m,b+qd]
finaln1=[:r,:g4] #play final notes with stretched samples
finald1=[33*b,17.25*sq+c]
finaln4=[:r,:f2]
finald4=[33*b,17.25*sq+c]

set_bpm(40) #set tempo 40 crotchets or 80 quavers per minute


with_fx :reverb,room: 0.6,mix: 0.4 do #add some reverb
  with_fx :level,amp: 1.4 do #boost levels
    in_thread do
      plarray(i[4][0],i[4][1],nbodge,dbodge,0,0.4) #long note in part 3 trombone I
    end
    in_thread do
      plarray(i[3][0],i[3][1],finaln1,finald1,-2,0.5) #final trumpet I note
    end
    in_thread do
      plarray(i[5][0],i[5][1],finaln4,finald4,0,0.4,0) #final trombone II note
    end
    in_thread do
      plarray(i[0][0],i[0][1],n1,d1,-2,0.7) #trumpet I
    end
    in_thread do
      plarray(i[0][0],i[0][1],n2,d2,-2,0.6) #trumpet II
    end
    in_thread do
      plarray(i[1][0],i[1][1],n3,d3,0,0.6) #trombone I
    end
    plarray(i[2][0],i[2][1],n4,d4,0,0.4) #trombone II
  end
end