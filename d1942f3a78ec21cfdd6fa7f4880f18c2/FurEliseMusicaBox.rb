#Fur Elise by Beethoven played with a sampled Musical Box voice, by Robin Newman June 2016
#array to hold note info for range 52 to 103. Each entry shows three items:
#note value, offset of sample to use in sample folder and rpitch value to use with the sample
#I recorded 12 samples from a musical box played slowly, and separated them in Audacity
#The piece is played an octave above the notated pitch.

path="~/Desktop/Samples/MusicalBox/mb2" #path to sample folder. Adjust as necessary
nlist=[
  [52,0,-22],[53,0,-21],[54,0,-20],[55,0,-19],[56,0,-18],
  [57,0,-17],[58,0,-16],[59,0,-15],[60,0,-14],[61,0,-13],
  [62,0,-12],[63,0,-11],[64,0,-10],[65,0,-9],[66,0,-8],
  [67,0,-7],[68,0,-6],[69,0,-5],[70,0,-4],[71,0,-3],
  [72,0,-2],[73,0,-1],[74,0,0],[75,0,1],[76,0,2],
  [77,1,-2],[78,1,-1],[79,1,0],[80,2,-1],[81,2,0],
  [82,3,-1],[83,3,0],[84,4,0],[85,5,-1],[86,5,0],
  [87,5,1],[88,5,2],[89,5,3],[90,6,-3],[91,6,-2],
  [92,6,-1],[93,6,0],[94,7,-1],[95,7,0],[96,8,0],
  [97,9,-1],[98,9,0],[99,9,1],[100,9,2],[101,10,-1],
[102,10,0],[103,11,0]]


define :plmb do |n| #function to play a note: looks up note info in array to get sample and rpitch value
  if n !=:r then
    nv=note(n)
    puts 'note value: ',nv
    puts "sample offset in folder: ",nlist[nv-52][1]
    puts "rpitch value: ",nlist[nv-52][2]
    sample path,nlist[nv-52][1],rpitch: nlist[nv-52][2]
  end
end
sq=0.22 #note durations
q=2*sq
qd=3*sq
#right hand notes first ahlf
nr=[:e5,:ds5,:e5,:ds5,:e5,:b4,:d5,:c5,:a4,:r,:c4,:e4,:a4,:b4,:r,:e4,:gs4,:b4,:c5,:r,:e4,:e5,:ds5,:e5,:ds5,:e5,:b4,:d5,:c5,:a4,:r,:c4,:e4,:a4,:b4,:r,:e4,:c5,:b4,:a4,:r]
#right hand note durations first half
dr=[sq,sq,sq,sq,sq,sq,sq,sq,q,sq,sq,sq,sq,q,sq,sq,sq,sq,q,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,sq,sq,sq,sq,q,sq,sq,sq,sq,q,q]
#bass notes first half
nb=[:r,:a2,:e3,:a3,:r,:e2,:e3,:gs3,:r,:a2,:e3,:a3,:r,:a2,:e3,:a3,:r,:e2,:e3,:gs3,:r,:a2,:e3,:a3,:r]
#bass note durations first half
db=[8*sq,sq,sq,sq,3*sq,sq,sq,sq,3*sq,sq,sq,sq,3*sq+6*sq,sq,sq,sq,3*sq,sq,sq,sq,3*sq,sq,sq,sq,sq]
#right hand notes second half
nr2=[:b4,:c5,:d5,  :e5,:g4,:f5,:e5,  :d5,:f4,:e5,:d5,  :c5,:e4,:d5,:c5,   :b4,:r,:e4,:e5,:r,  :e5,:e6,:r,:ds5,:e5,:r,:ds5,:e5,:ds5,:e5,:ds5,:e5,:b4,:d5,:c5,:a4,:r,:c4,:e4,:a4,\
     :b4,:r,:e4,:gs4,:b4,:c5,:r,:e4,:e5,:ds5,:e5,:ds5,:e5,:b4,:d5,:c5,:a4,:r,:c4,:e4,:a4,:b4,:r,:e4,:c5,:b4,:a4,:r]
#right hand druations second half
dr2=[sq,sq,sq,qd,sq,sq,sq,qd,sq,sq,sq,qd,sq,sq,sq,q,sq,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,sq,sq,sq,sq,q,sq,sq,sq,sq,q,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,sq,sq,sq,sq,q,sq,sq,sq,sq,q,sq]
#bass notes second half
nb2=[:r,:c3,:g3,:c4,:r,:g2,:g3,:b3,:r,:a2,:e3,:a3,:r,:e2,:e3,:e4,:r,:e4,:e5,:r,:ds5,:e5,:r,:ds5,:e5,:r,:a2,:e3,:a3,:r,:e2,:e3,:gs3,:r,:a2,:e3,:a3,:r,:a2,:e3,:a3,:r,:e2,:e3,:gs3,:r,:a2,:e3,:a3]
#left hand durations second half
db2=[qd,sq,sq,sq,qd,sq,sq,sq,qd,sq,sq,sq,qd,sq,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,qd+qd*2,sq,sq,sq,qd,sq,sq,sq,qd,sq,sq,sq,qd+2*qd,sq,sq,sq,qd,sq,sq,sq,qd,sq,sq,sq]

define :plarray do |n,d,shift| #ffunction to play array of notes and durations. Shift is transpsoe quantity
  n.zip(d).each do |n,d|
    if n!=:r then
      plmb(n+shift)
    end
    sleep d
  end
end

#now play the piece
in_thread do #first half repeated apart from last rest (right hand in thread)
  plarray(nr,dr,12)
  plarray(nr[0..-2],dr[0..-2],12)
end
plarray(nb,db,12) #first half repeated apart from alst rest (bass part)
plarray(nb[0..-2],db[0..-2],12)
2.times do #second half repeated
  in_thread do #right hand in thread
    plarray(nr2,dr2,12)
  end
  plarray(nb2,db2,12) #bass part
end