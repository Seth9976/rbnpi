#March of the Tin Soldiers by Tchaikovsky played with a sampled Musical Box voice, bu Robin Newman June 2016
#array to hold note info for range 52 to 103. Each entry shows three items:
#note value, offset of sample to use in sample folder and rpitch value to use with the sample
#I recorded 12 samples from a musical box played slowly, and separated them in Audacity
#The piece is played an octave above the notated pitch.

path="~/samples/MusicalBox" #path to sample folder. Adjust as necessary
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

define :plmb do |n,d,vol=1,pan=0| #function to play a note: looks up note info in array to get sample and rpitch value
  if n !=:r then
    nv=note(n)
    puts 'note value: ',nv
    puts "sample offset in folder: ",nlist[nv-52][1]
    puts "rpitch value: ",nlist[nv-52][2]
    sample path,nlist[nv-52][1],rpitch: nlist[nv-52][2],amp: vol,pan: pan,sustain: 0,release: 8*d
  end
end

sq=0.1 #note durations
q=2*sq
qd=3*sq
c=4*sq
cd=6*sq
m=8*sq
#right hand notes first half

define :plarray do |n,d,shift,vol=1,pan=0| #function to play array of notes and durations. Shift is transpose quantity
  n.zip(d).each do |n,d|
    if n!=:r then
      #adjustto play chords if required
      if n.respond_to?('each') #i.e. is a chord if responds
        n.each do |nv|
          plmb(nv+shift,d,vol,pan)
        end
      else
        plmb(n+shift,d,vol,pan)
      end
    end
    sleep d
  end
end
nr=[[:a4,:d5],:r,:d5,:r,:b4,:as4,:b4,:r,:cs5,[:a4,:d5],:r,:d5,:r,:b4,:as4,:b4,:r,:cs5,[:a4,:d5],:r,[:cs5,:e5],:r,:fs5,:r,[:d5,:fs5],:r,[:e5,:g5],:r,[:d5,:fs5],[:cs5,:e5],:r,[:b4,:d5]]
nr.concat [[:cs5,:e5],:g5,:fs5,:r,:e5,[:a4,:d5],:r,:d5,:r,:b4,:as4,:b4,:r,:cs5,[:b4,:d5],:r,:d5,:r,:b4,:as4,:b4,:r,:cs5,[:a4,:d5,],:r,[:cs5,:e5],:r,:fs5,:r,[:d5,:fs5],:r,[:cs5,:e5],:r,[:b4,:d5],[:a4,:cs5],:r,[:gs4,:b4]]
nr.concat [:a4,:r,[:e4,:a4],:r,:a4,:r,:bb4,:a4,:bb4,:r,:gs4,:a4,:r,:a4,:r,:bb4,:a4,:bb4,:r,:gs4,:a4,:r,:b4,:r,[:gs4,:cs5],:r,[:a4,:cs5],:r,[:b4,:d5],:r,:cs5,:b4,:r,:a4]
nr.concat [:gs4,:r,[:e4,:a4],:r,:a4,:r,:bb4,:a4,:bb4,:r,:gs4,:a4,:r,:a4,:r,:bb4,:a4,:bb4,:r,:gs4,:a4,:r,:b4,:r,[:gs4,:cs5],:r,[:a4,:cs5],:r,[:b4,:d5],:r,:cs5,:b4,:r,:cs5]
nr.concat [:a4,:r,:a4,:b4,:cs5,[:a4,:d5],:r,:d5,:r,:b4,:as4,:b4,:r,:cs5,[:a4,:d5],:r,:d5,:r,:b4,:as4,:b4,:r,:cs5,[:a4,:d5],:r,[:cs5,:e5],:r,:fs5,:r,[:d5,:fs5],:r,[:e5,:g5],:r,[:d5,:fs5],[:cs5,:e5],:r,[:b4,:d5]]
nr.concat [[:cs5,:e5],:g5,:fs5,:r,:e5,[:a4,:d5],:r,:d5,:r,:b4,:as4,:b4,:r,:cs5,:d5,:r,:d5,:r,:b4,:as4,:b4,:r,:cs5,[:a4,:d5],:r,[:cs5,:e5],:r,:fs5,:r,[:d5,:fs5],:r,:e5,:r,:ds5,:e5,:r,:fs5,:d5,:r]

dr=[q,q,q,q,qd,sq,q,sq,sq,q,q,q,q,qd,sq,q,sq,sq,q,q,q,q,q,q,q,q,q,sq,sq,q,sq,sq]
dr.concat [qd,sq,q,sq,sq,q,q,q,q,qd,sq,q,sq,sq,q,q,q,q,qd,sq,q,sq,sq,q,q,q,q,q,q,q,q,q,sq,sq,q,sq,sq]
dr.concat [q,cd,q,q,q,q,qd,sq,q,sq,sq,q,q,q,q,qd,sq,q,sq,sq,q,q,q,q,q,q,q,q,q,sq,sq,q,sq,sq]
dr.concat [q,cd,q,q,q,q,qd,sq,q,sq,sq,q,q,q,q,qd,sq,q,sq,sq,q,q,q,q,q,q,q,q,q,sq,sq,q,sq,sq]
dr.concat [q,qd,sq,sq,sq,q,q,q,q,qd,sq,q,sq,sq,q,q,q,q,qd,sq,q,sq,sq,q,q,q,q,q,q,q,q,q,sq,sq,q,sq,sq]
dr.concat [qd,sq,q,sq,sq,q,q,q,q,qd,sq,q,sq,sq,q,q,q,q,qd,sq,q,sq,sq,q,q,q,q,q,q,q,q,q,sq,sq,q,sq,sq,q,cd]

nl=[[:d3,:d4,:fs4],:r,[:g3,:d4,:g4],:fs4,:g4,:r,:e4,[:d3,:d4,:fs4],:r,[:g3,:d4,:g4],:fs4,:g4,:r,:e4,[:d3,:d4,:fs4],:r,:a4,:r,:d5,:r,[:a3,:d4,:a4],:r]
nl.concat [:a4,:a4,:a4,:r,:a4,[:d3,:d4,:fs4],:r,[:g3,:d4,:g4],:fs4,:g4,:r,:e4,[:d3,:d4,:fs4],:r,[:g3,:d4,:g4],:fs4,:g4,:r,:e4,[:d3,:d4,:fs4],:r,:a4,:r,:d5,:r,:d4,:r,[:e3,:e4]]
nl.concat [:a3,:r,[:a3,:cs4],:r,[:a3,:d4,:f4],[:a3,:cs4,:e4],:r,[:a3,:d4,:f4],[:a3,:cs4,:e4],:r,[:e4,:gs4],:r,[:cs4,:es4],:r,:fs4,:r,[:b3,:fs4],:r]
nl.concat [:e4,:r,:d4,:cs4,:r,:b3,[:a3,:cs4],:r,[:a3,:d4,:f4],[:a3,:cs4,:e4],:r,[:a3,:d4,:f4],[:a3,:cs4,:e4],:r,[:e4,:gs4],:r,[:cs4,:es4],:r,:fs4,:r,[:b3,:fs4],:r,[:e4,:gs4],:r]
nl.concat [:a3,:r,:a3,:b3,:r,:cs4,[:d3,:d4,:fs4],:r,[:g3,:d4,:g4],:fs4,:g4,:r,:e4,[:d3,:d4,:fs4],:r,[:g3,:d4,:g4],:fs4,:g4,:r,:e4,[:d3,:d4,:fs4],:r,:a4,:r,[:d4,:d5],:r,[:a3,:d4,:a4],:r]
nl.concat [:a4,:r,[:d3,:d4,:fs4],:r,[:g3,:d4,:g4],:fs4,:g4,:r,:e4,[:d3,:d4,:fs4],:r,[:g3,:d4,:g4,],:fs4,:g4,:r,:e4,[:d3,:d4,:fs4],:r,:a4,:r,[:d4,:d5],:r,:b4,:r,[:b3,:g4,:b4],:r,[:cs4,:a4,:cs5],:r,[:d3,:d4,:fs4,:a4],:r]

dl=[q,cd,qd,sq,q,sq,sq,q,cd,qd,sq,q,sq,sq,q,q,q,q,q,cd,q,cd]
dl.concat [qd,sq,q,sq,sq,q,cd,qd,sq,q,sq,sq,q,cd,qd,sq,q,sq,sq,q,q,q,q,q,q,q,q,m]
dl.concat [q,cd,q,cd,m,q,cd,m,q,q,q,q,q,q,q,q,q,cd]
dl.concat [q,sq,sq,q,sq,sq,q,cd,m,q,cd,m,q,q,q,q,q,q,q,q,q,q,q,q]
dl.concat [q,sq,sq,q,sq,sq,q,cd,qd,sq,q,sq,sq,q,cd,qd,sq,q,sq,sq,q,q,q,q,q,cd,q,cd]
dl.concat [q,cd,q,cd,qd,sq,q,sq,sq,q,cd,qd,sq,q,sq,sq,q,q,q,q,q,q,q,q,q,q,q,q,q,cd]

#now play the piece, right hand part in thread
in_thread do
  plarray(nr,dr,12,2,0.5) #transposed up an octave from written pitch. rh pan right lh pan left
end
plarray(nl,dl,12,1.5,-0.5)
