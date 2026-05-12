#a Glass Armonica "voice" for Sonic Pi by Robin Newman November 2014
# revised to use rpitch 2018; corrected 2022 for missing tr function
#This simulates the Glass Armonica invented by Benjamin Franklin and for which Mozart
#composed the piece played here
#This version uses rpitch: parameter added to Sonic Pi after the original was written in 2014
##| sample :ambi_glass_rub
##| play :fs5
##| puts note(:fs5)
##| stop
use_debug false
shift=0 #chnage to say 7 to transpose up a fifth
inst = :ambi_glass_rub
bpm = 90
s=1.0/8 *60.0/bpm #smultipliern to calculate duration variables for notes

#set up function to play a given sample note.
define :pl do |n,d=0.2,pan=0,v=0.8|
  sample inst,rpitch: note(n)-78,attack: d*0.1,sustain: d*0.85,release: d*0.1,amp: v,pan: pan,start: 0.04
end
#define note relative durations. Factor s sets the speed
dsq = 1 * s
sq = 2 * s
sqd = 3 * s
q = 4 * s
qt = 2.0/3*q
qd = 6 * s
qdd = 7 * s
c = 8 * s
cd = 12 * s
cdd = 14 * s
m = 16 * s
md = 24 * s
mdd = 28 * s
b = 32 * s
bd = 48 * s
define :tr do |nv,shift| #this enables transposition of the note. Shift is number of semitones to move
  if shift ==0 then
    return nv
  else
    return note(nv)+shift
  end
end
#function plays an array of note and duration values (nt and dur), with parameters for transposition, volume and pan
define :plarray do |nt,dur,sh=0,vol=0.4,pan=0|
  nt.zip(dur).each do |n,d|
    if n != :r then
      pl(tr(n,sh),d,pan,vol)
    end
    sleep d
  end
end
#===================
#set up arrays of notes and durations for the 5 parts in section 1
n1 = [:g5,:f5,:f5,:e5,:r,:f5,:e5,:f5,:g5,:a5,:g5,:f5,:e5,:e5,:d5,:e5,:f5,:fs5,:g5,:f5,:f5,:e5]
d1 = [md,c,m,c,c,q,q,q,q,q,q,q,q,m,q,q,q,q,md,c,m,m]
#b7
n1.concat [:f5,:g5,:f5,:e5,:f5,:g5,:a5,:f5,:e5,:d5,:d5,:c5,:r]
d1.concat [sq,sq,sq,sq,sq,sq,sq,sq,c,c,m,c,c]
n2 = [:e5,:d5,:d5,:c5,:r,:d5,:cs5,:d5,:e5,:f5,:e5,:d5,:c5,:c5,:b4,:r,:e5,:d5,:d5,:c5,:cs5,:r,:c5,:b4,:b4,:r]
d2 = [md,c,m,c,c,q,q,q,q,q,q,q,q,m,c,c,md,c,m,c,c,m,c,c,m,m]
n3 = [:c4,:e4,:g4,:gs4,:a4,:g4,:f4,:e4,:d4,:e4,:f4,:fs4,:g4,:r,:c4,:e4,:g4,:gs4,:a4,:bb4,:a4,:g4,:g4,:r]
d3 = [c,c,c,c,md,c,cd,q,q,q,q,q,md,c,c,c,c,c,md,c,m,m,md,c]
n4 = [:r,:bb4,:f4,:r,:f4,:e4,:r]
d4 = [5*b+md,c,m,m,m,c,c]
n5 = [:r,:c4,:r]
d5 = [7*b,md,c]
#store a list of arrays and durations to be played
lar = [n1,d1,n2,d2,n3,d3,n4,d4,n5,d5]

#set up note and duration arrays for the second section
#b9
n1b = [:g5,:fs5,:g5,:fs5,:g5,:a5,:g5,:fs5,:c6,:b5,:bb5,:c6,:bb5,:a5,:g5,:fs5,:g5,:a5,:bb5,:b5,:c6,:cs6,:d6]
d1b = [m+q,sq,sq,sq,sq,sq,sq,c,m,c,cd,sq,sq,c,c,q,q,q,q,q,q,q,q]
#b13
n1b.concat [:d6,:e6,:d6,:c6,:b5,:b5,:a5,:r,:g5,:g5,:a5,:g5,:fs5,:e5,:e5,:d5,:r,:c5,:b4,:g5,:e5,:a5,:g5,:fs5]
d1b.concat [q,sq,sq,q,q,q,q,q,q,q,sq,sq,q,q,q,q,q,q,q,q,q,c,c,q]
#b16
n1b.concat [:a5,:g5,:gs5,:a5,:b5,:cs6,:d6,:g5,:a5,:b5,:c6,:fs5,:f5,:cs5,:d5,:e5,:f5,:fs5,:g5,:f5]
d1b.concat [m,c,c,m+q,q,q,q,m+q,q,q,q,b,cd,q,q,q,q,q,md,c]
#b22
n1b.concat [:f5,:e5,:f5,:g5,:f5,:e5,:r,:f5,:e5,:f5,:g5,:a5,:g5,:f5,:e5,:e5,:d5,:e5,:f5,:e5,:d5,:e5,:f5,:fs5]
d1b.concat [c,sq,sq,sq,sq,c,c,q,q,q,q,q,q,q,q,c,sq,sq,sq,sq,q,q,q,q]
#b25
n1b.concat [:g5,:b5,:a5,:c6,:b5,:d6,:c6,:g5,:f5,:f5,:e5,:f5,:g5,:f5,:e5,:f5,:g5,:a5,:f5,:e5,:f5,:fs5,:g5,:g5,:f5,:e5,:d5,:d5,:e5,:d5,:c5,:r]
d1b.concat [q,sq,sq,sq,sq,sq,sq,c,c,m,m,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,cd,sq,sq,c,c]
n2b = [:r,:d5,:c5,:fs5,:r,:eb5,:d5,:c5,:d5,:r,:e5,:d5,:d5,:c5,:r,:d5,:cs5,:d5,:e5,:f5,:e5,:d5,:c5,:c5,:b4,:r]
d2b = [6*b+m,c,c,m,2*b+m,m,c,c,cd,m+q,md,c,m,c,c,q,q,q,q,q,q,q,q,m,c,c]
#b25
n2b.concat [:e5,:r,:e5,:d5,:d5,:cs5,:d5,:r,:b4,:r]
d2b.concat [c,c,c,c,m,m,m,m,m,m]
n3b=[:e5,:d5,:c5,:d5,:e5,:d5,:r,:g5,:fs5,:e5,:d5,:c5,:b4,:a4,:fs4,:g4,:c4,:b4,:a4,:c5,:b4,:r,:g5,:fs5,:r,:f5,:e5,:r,:c5,:b4,:a4]
d3b=[m,m,m,m,b,c,md,cd,q,c,c,cd,q,c,c,c,c,c,c,m,c,m,c,c,m,c,c,c,m,c,c]
#b20
n3b.concat [:b4,:r,:c4,:e4,:g4,:gs4,:a4,:g4,:f4,:g4,:f4,:e4,:d4,:e4,:f4,:fs4,:g4,:r,:c4,:e4,:g4,:gs4,:a4,:bb4,:a4,:g4,:a4,:c5,:b4,:g4,:r]
d3b.concat [cd,q+m,c,c,c,c,md,c,q,q,q,q,q,q,q,q,md,c,c,c,c,c,c,m,q,q,m,c,c,md,c]
n4b=[:c5,:b4,:a4,:g4,:cs5,:r,:e5,:d5,:c5,:b4,:a4,:g4,:fs4,:ds4,:e4,:r,:d4,:g4,:r,:cs5,:d5,:r,:b4,:c5,:r]
d4b=[m,m,m,m,b,b,cd,q,c,c,cd,q,c,c,c,c,m,md,m,c,c,m,c,c,c]
#b19
n4b.concat [:g4,:r,:f4,:g4,:f4,:e4,:r]
d4b.concat [b+cd,q+m+6*b,m,m,m,c,c]
n5b=[:r,:c4,:r]
d5b=[19*b,md,c]
#add these parts to the lar list
lar.concat [n1b,d1b,n2b,d2b,n3b,d3b,n4b,d4b,n5b,d5b]

#sec is defined to play 5 pairs of note/duration arrays. p is the offset in lar list
#sh sets transposition
#parts played together using threads
define :sec do |p,sh=0,amp=0.4|
  in_thread do
    plarray(lar[8+p],lar[9+p],sh,amp,0.6)
  end
  in_thread do
    plarray(lar[6+p],lar[7+p],sh,amp,0.6)
  end
  in_thread do
    plarray(lar[4+p],lar[5+p],sh,amp,-0.6)
  end
  in_thread do
    plarray(lar[2+p],lar[3+p],sh,amp,-0.6)
  end
  plarray(lar[0+p],lar[1+p],sh,amp,-0.6)
end

#now play first and second sections
#shift set at start adjusts transpose. 0 and 10 are offsets in lar and last parameter is vol
with_fx :reverb, room: 0.6 do
  with_fx :lpf, cutoff: 85 do
  #shift is defined line line 11
    sec(0,shift,0.4)
    sec(0,shift,0.3)
    sec(10,shift,0.3)
    sec(10,shift,0.4)
  end
end
