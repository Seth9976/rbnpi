#Program demonstrating the streamlined method of setting up a sample based voice
#from a single sample with a medley of rounds and voices
#written by Robin Newman, March 2015
#Works best with a Pi2 and Sonic Pi 2.5dev or later, but can be adjusted for other configurations
#See article on https://rbnrpi.wordpress.com/
#most of the rounds from http://www-personal.umich.edu/~msmiller/rounds.html
#the rest from Wikipedia en.wikipedia.org/wiki/Round_(music)
# if using version 2.5dev or later remove or comment out function pitch_ratio

#The program is arranged to deal with 3 or 4 part rounds. The three or four parts
#are played twice, the second time up an octave.
#The program utilises just 5 single note audio samples for 5 different instruments
#The function pl enables note to be played using each of these instruments
#Transposition, allocation of instruments and tempo can be adjusted for each round
#Most of the four part rounds are transposed down, to allow for the pitch range of the trumpet voice
#used for the fourth part.
#One round, 'Sumer Is Icumen In' has a drone bass part added. This is played
#by the bassoon voice which is only used for this round.
#The remaining three voices are shuffled at random between each of the first three
#parts of each round.
#Each round has its notes stored in a notes array, and the corresponding
#note durations in a related array
#These are processed by the function plarray
#Note durations are expressed in terms of variables defining each note value
#These are set up by the function setupround, which first sets the tempo,
#redefining the note duration variables, and then the arrays holding each round
#CONFIGURATION CHOICES=============================================================
#location of samples
use_sample_pack_as '/home/pi/samples/Rounds',:rounds #adjust location as necessary
#program needs sample name and normal pitch of that sample
selectionmode=true #set to true for random selection of 5 choices or false to play all 26 rounds
use_random_seed(11111) #change seed number to get a different selection of choices if using selection mode
num=26 #number of rounds to choose from (set to one LESS than then number of rounds if using a Pi B or B+
#to exclude the round 'SUMER IS ACUMIN IN" which will not play on these models
#num MUST be adjusted if you change the number of rounds in the data section
#on a Pi model B or B+ comment out fx_reverb and associated end towards end of program
#END OF CONFIGURATION CHOICES======================================================
use_debug false

#first deal with selecting and setting up the samples

inst0=:rounds__bassoon_g3
samplepitch0=:g3
inst1=:rounds__flute_ds5
samplepitch1=:ds5
inst2=:rounds__clarinet_gs4
samplepitch2=:gs4
inst3=:rounds__harp_a4
samplepitch3=:a4
inst4=:rounds__trumpet_cs5
samplepitch4=:cs5

#preload all the samples
load_flag=0
if sample_loaded? inst0 then #check if sample already loaded
  flag=1
end
load_samples [inst0,inst1,inst2,inst3,inst4]
if load_flag==0 then #samples not loaded so allow time
  sleep 3
end

#put the sample names and pitches into an array i
i=[[inst0,samplepitch0],[inst1,samplepitch1],[inst2,samplepitch2],[inst3,samplepitch3]]
i.concat [[inst4,samplepitch4]]

#build list of instrument choices for each round.
instlist=[]
num.times do #first three voices allocated at random
  instlist.concat [[i[2],i[1],i[3]].shuffle+[i[4],i[0]]]
end

#define variables that need to be used globally
s=dsq=sq=sqd=q=qt=qd=qdd=c=cd=cdd=m=md=mdd=b=bd=0 #note duration variables
roundlist=[] #round names
notes=[] #notes list for a round (an array of arrays)
dur=[] #note durations for a round (an array of arrays)
notesbass=[] #etra part notes for round 3
durbass=[] #extra part durations for round 3
gapslist=[] #gap between parts coming in
tempolist=[] #tempo of a round
partslist=[] #number of part entries in round
shiftlist=[] #transpose shift to play round

#prior to the release of version 2.5 you need the next function
#if you get an error message saying it exists then delete it or comment it out
comment do
  define :pitch_ratio do |n|
    return 2**(n.to_f/12)
  end
end

#this function plays the sample at the relevant pitch for the note desired
#the note duration is used to set up the envelope parameters
define :pl do |inst,samplepitch,nv,dv|
  shift=note(nv)-note(samplepitch)
  sample inst,rate: (pitch_ratio shift),sustain: 0.8*dv,release: 0.2*dv
end

#this function plays an array of notes and associated array of durations
#also uses sample name (inst), sample normal pitch, and shift (transpose) parameters
define :plarray do |inst,samplepitch,narray,darray,shift=0|
  narray.zip(darray) do |nv,dv|
    if nv != :r
      pl(inst,samplepitch,note(nv)+shift,dv)
    end
    sleep dv
  end
end

#set_bpm sets bpm required adjusting note duration variables accordingly
define :set_bpm do |n|
  s=1.0/8*60/n.to_f
  dsq = 1 * s #demisemiquaver
  sq = 2 * s #semiquaver
  sqd = 3 * s #semi quaver dotted
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
end

#this section sets the bpm then defines the note and duration arrays
#for all the differnt rounds
define :setuprounds do |bpmvalue|
  set_bpm(bpmvalue) #define notes and durations in terms of currrent bpm value
#DATA SECTION DETAILING THE ROUNDS==============================
  v=0 #index counter for rounds
  roundlist[v]='Three Blind Mice'
  notes[v]=[:fs4,:e4,:d4,:r,:a4,:g4,:r,:g4,:fs4,:r,:a4,:d5,:d5,:cs5,:b4,:cs5,:d5,:a4,:a4,:a4,:d5,:d5,:d5,:cs5,:b4,:cs5]
  notes[v].concat [:d5,:a4,:a4,:a4,:d5,:d5,:cs5,:b4,:cs5,:d5,:a4,:a4,:a4,:g4,:fs4,:e4,:d4,:r]
  dur[v]=[cd,cd,cd+q,c,cd,q,q,q,c,c,c,c,q,q,q,q,c,q,c,q,q,q,q,q,q,q]
  dur[v].concat [c,q,c,q,c,q,q,q,q,q,q,q,c,q,cd,cd,cd,cd]
  tempolist[v]=180
  gapslist[v]=4*cd
  partslist[v]=4
  shiftlist[v]=-5
  v +=1
  roundlist[v]='Row the Boat'
  notes[v]=[:c4,:c4,:c4,:d4,:e4,:e4,:d4,:e4,:f4,:g4,:c5,:c5,:c5]
  notes[v].concat [:g4,:g4,:g4,:e4,:e4,:e4,:c4,:c4,:c4,:g4,:f4,:e4,:d4,:c4]
  dur[v]=[cd,cd,c,q,cd,c,q,c,q,cd*2,q,q,q,q,q,q,q,q,q,q,q,q,c,q,c,q,cd*2]
  tempolist[v]=180
  gapslist[v]=4*cd
  partslist[v]=4
  shiftlist[v]=0
  v +=1
  roundlist[v]='Frere Jaques'
  notes[v]=[:c4,:d4,:e4,:c4]*2+[:e4,:f4,:g4]*2+[:g4,:a4,:g4,:f4,:e4,:c4]*2+[:c4,:g3,:c4]*2
  dur[v]=[c,c,c,c,c,c,c,c,c,c,m,c,c,m,q,q,q,q,c,c,q,q,q,q,c,c,c,c,m,c,c,m]
  tempolist[v]=160
  gapslist[v]=8*c
  partslist[v]=4
  shiftlist[v]=0
  v +=1
  roundlist[v]='Wind, gentle evergreen'
  notes[v]=[:d5,:e5,:d5,:c5,:b4,:c5,:d5,:e4,:g4,:c5,:b4,:c5,:b4,:a4,:d5,:d5,:cs5,:c5,:c5,:b4,:g4,:b4,:a4,:g4,:fs4,:g4,:g4]
  notes[v].concat [:b4,:c5,:b4,:g4,:a4,:fs4,:g4,:a4,:b4,:c5,:b4,:a4,:g4,:g4,:fs4,:a4,:gs4,:b4,:e4,:a4,:a4,:a4,:fs4,:g4,:d5,:c5,:b4,:a4,:g4,:g4]
  notes[v].concat [:g4,:g4,:d4,:g4,:g4,:c4,:e4,:fs4,:g4,:d4,:b3,:a3,:fs4,:g4,:b3,:c4,:c4,:d4,:d4,:g4]
  dur[v]=[qd,sq,c,c,cd,q,c,qd,sq,c,qd,sq,c,c,c,c,c,c,c,c,q,q,qd,sq,cd,q,md]
  dur[v].concat [qd,sq,q,q,q,q,cd,q,c,qd,sq,c,c,c,q,q,q,q,c,c,c,qd,sq,c,c,qd,sq,cd,q,md]
  dur[v].concat [c,c,c,m,c,qd,sq,c,c,m,c,m,c,m,c,qd,sq,cd,q,md]
  tempolist[v]=160
  gapslist[v]=8*md
  partslist[v]=3
  shiftlist[v]=0
  v +=1
  roundlist[v]='Upon Christ Church Bells in Oxford'
  notes[v]=[:c5,:c5,:c5,:c5,:c5,:c5,:c5,:e5,:d5,:c5,:b4,:a4,:g4,:g4,:g4,:g4,:e4,:g4,:c4,:g4,:c5,:f4,:g4,:g5,:f5,:e5,:a5,:d5,:e5,:f5,:e5,:d5,:c5]
  notes[v].concat [:e5,:e5,:e5,:e5,:e5,:e5,:e5,:g5,:f5,:e5,:f5,:d5,:c5,:d5,:g4,:d5,:d5,:e5,:d5,:e5,:d5,:e5,:d5,:d5,:c5,:b4,:c5,:a4,:d5,:b4,:c5,:d5,:e5]
  notes[v].concat [:g5,:g5,:g5,:g5,:g5,:g5,:g5,:g5,:g5,:g5,:g5,:g4,:a4,:a4,:b4,:c5,:b4,:r,:a4,:b4,:c5,:b4,:c5,:b4,:c5,:d5,:b4,:a4,:g4,:a4,:f4,:g4,:g4,:c4]
  dur[v]=[cd,q,c,c,c,c,c,c,c,c,c,c,cd,q,c,c,c,c,c,c,c,c,c,q,q,c,c,q,q,c,cd,q,m]
  dur[v].concat [cd,q,c,c,c,c,c,c,c,q,q,c,c,c,c,c,c,c,c,c,c,c,c,c,q,q,c,c,c,c,cd,q,m]
  dur[v].concat [q,q,q,q,c,q,q,c,q,q,c,c,cd,q,c,c,m,c,q,q,c,c,c,c,c,c,c,q,q,c,c,cd,q,b]
  tempolist[v]=160
  gapslist[v]=8*b
  partslist[v]=4
  shiftlist[v]=-7
  v +=1
  roundlist[v]='To The Greenwood'
  notes[v] = [:c5,:b4,:b4,:a4,:a4,:g4,:g4,:f4,:f4,:e4,:c4,:f4,:g4,:c4]
  notes[v].concat [:c4,:d4,:e4,:f4,:g4,:e4,:f4,:d4,:e4,:c4,:a4,:b4,:c5,:d5,:g4,:c5,:c5,:b4,:c5]
  notes[v].concat [:e5,:e5,:d5,:e5,:c5,:c5,:b4,:c5,:a4,:a4,:g4,:e5,:d5,:c5,:c5]
  dur[v]=[m,c,c,c,c,c,c,c,c,c,c,c,c,m,q,q,q,q,c,c,c,c,c,c,q,q,q,q,c,c,c,c,m,cd,q,c,c,cd,q,c,c,c,c,c,c,cd,q,m]
  tempolist[v]=160
  gapslist[v]=4*b
  partslist[v]=3
  shiftlist[v]=0
  v +=1
  roundlist[v]='Viva La Musica!'
  notes[v]=[:d5,:c5,:b4,:a4,:g4,:fs4,:g4,:fs4,:b4,:c5,:d5,:c5,:b4,:a4,:g4,:a4,:g4,:g4,:c4,:d4,:e4,:d4]
  dur[v]=[cd,q,c,q,q,c,c,m,cd,q,c,q,q,c,c,m,c,m,c,c,c,m]
  tempolist[v]=160
  gapslist[v]=2*b
  partslist[v]=3
  shiftlist[v]=0
  v +=1
  roundlist[v]='Shalaom Chavarim'
  notes[v]=[:b3,:e4,:e4,:fs4,:g4,:e4,:g4,:g4,:a4,:b4,:b4,:e5,:d5,:b4,:b4,:e5,:b4,:a4,:g4,:a4,:b4,:g4,:fs4,:e4,:b3,:e4,:fs4,:g4,:e4]
  dur[v]=[c,c,q,q,c,c,c,q,q,c,c,md,c,md,c,c,q,q,c,c,c,q,q,c,c,md,q,q,md]
  tempolist[v]=160
  gapslist[v]=4*c
  partslist[v]=3
  shiftlist[v]=0
  v +=1
  roundlist[v]='Oh My Love Lovst Thou Me II'
  notes[v]=[:g4,:a4,:bb4,:bb4,:c5,:d5,:g5,:d5,:g5,:g5,:f5,:g5,:d5,:c5,:bb4,:a4,:g4]
  dur[v]=[m,m,b,m,m,md,c,c,c,c,c,m,cd,q,m,m,b]
  tempolist[v]=180
  gapslist[v]=2*b
  partslist[v]=4
  shiftlist[v]=-5
  v +=1
  roundlist[v]='Celebrons sans cesse'
  notes[v]=[:c5,:bb4,:a4,:bb4,:g4,:f4,:f4,:c4,:d4,:bb3,:c4,:c5,:bb4,:a4,:g4,:f4,:f4,:e4,:f4,:f5,:e5,:d5,:c5,:a4]
  dur[v]=[md,c,m,m,b,m,b,m,m,m,m,md,c,b,md,c,b,m,m,b,m,b,b,b]
  tempolist[v]=220
  gapslist[v]=4*b
  partslist[v]=4
  shiftlist[v]=-5
  v +=1
  roundlist[v]='Gaudeamus Hodie'
  notes[v]=[:c4,:c4,:e4,:g4,:f4,:g4,:f4,:e4,:d4,:c4,:c4,:e4,:g4,:f4,:e4,:d4,:c4,:c4,:e4,:g4,:c5,:b4,:a4,:g4,:f4,:e4,:d4,:c4]
  notes[v].concat [:c4,:d4,:e4,:f4,:g4,:a4,:g4,:e4,:f4,:d4,:c4]
  notes[v].concat [:g4,:g4,:a4,:c5,:g4,:g4,:a4,:f4,:g4,:c5,:e5,:d5,:c5,:d5,:g4,:c5,:b4,:c5]
  dur[v]=[c,c,c,c,c,c,q,q,c,c,c,c,c,c,c,m,c,c,c,c,c,c,q,q,c,m,m,b]
  dur[v].concat [b,b,b,b,b,b,c,c,c,c,b,m,m,c,md,m,m,c,md,m,m,c,c,c,c,c,m,c,b]
  tempolist[v]=200
  gapslist[v]=8*b
  partslist[v]=3
  shiftlist[v]=0
  v +=1
  roundlist[v]='Come Let us All A-Maying Go'
  notes[v]=[:g5,:fs5,:e5,:d5,:e5,:d5,:c5,:b4,:g4,:a4,:g4,:g5,:fs5,:d5,:g5,:fs5,:d5,:g5,:fs5,:e5,:g5,:fs5,:g5]
  notes[v].concat [:e5,:d5,:c5,:b4,:a4,:b4,:c5,:b4,:a4,:g4,:d5,:c5,:b4,:b4,:c5,:d5,:b4,:g4,:d5,:b4,:g4,:c5,:a4,:r,:b4,:g4]
  notes[v].concat [:g4,:g4,:g4,:g4,:g4,:g4,:g4,:g4,:d4,:g4,:fs4,:e4,:d4,:g4,:fs4,:e4,:d4,:c4,:d4,:g4]
  dur[v]=[c,c,c,cd,q,q,q,cd,q,c,m,c,c,c,c,c,c,q,q,cd,q,c,md]
  dur[v].concat [c,c,c,q,q,q,q,q,q,c,c,c,m,q,q,q,cd,c,q,cd,c,q,cd,c,m,c]
  dur[v].concat [m,c,m,c,m,c,m,c,c,q,q,c,c,q,q,q,q,m,c,md]
  tempolist[v]=180
  gapslist[v]=4*bd
  partslist[v]=3
  shiftlist[v]=-4
  v +=1
  roundlist[v]='Come Follow Me Merrily'
  notes[v]=[:d5,:b4,:c5,:d5,:e5,:e5,:d5,:d5,:c5,:b4,:a4,:b4,:c5,:c5,:b4,:a4,:g4,:a4,:b4,:g4]
  notes[v].concat [:g4,:d4,:a4,:d4,:g4,:g4,:d4,:g4,:c4,:g4,:d4,:d4,:g4,:r,:b4]
  notes[v].concat [:d5,:e5,:fs5,:e5,:fs5,:g5,:g5,:g5,:fs5,:d5,:e5,:fs5,:g5,:fs5,:e5,:fs5,:g5,:r]
  dur[v]=[c,cd,q,c,c,c,c,c,c,c,m,c,c,c,c,cd,q,c,md+m,c,m,c,m,c,m,c,m,c,m,c,m,c,md,m,c]
  dur[v].concat [cd,q,c,m,c,c,c,c,m,c,cd,q,c,cd,q,c,md+m,c]
  tempolist[v]=180
  gapslist[v]=4*bd
  partslist[v]=3
  shiftlist[v]=-4
  v +=1
  roundlist[v]='Now We Are Met'
  notes[v]=[:c4,:e4,:f4,:g4,:a4,:b4,:c5,:a4,:g4,:f4,:e4,:e4,:d4,:c4,:f4,:g4,:c4]
  notes[v].concat [:r,:c5,:c5,:c5,:b4,:r,:c5,:c5,:c5,:b4,:r,:g4,:g4,:g4,:a4,:b4,:c5,:b4,:c5]
  notes[v].concat [:r,:b4,:c5,:d5,:e5,:r,:a4,:b4,:c5,:d5,:c5,:c5,:f5,:e5,:d5,:d5,:c5]
  dur[v]=[c,q,q,c,q,q,c,c,m,c,q,q,c,c,c,c,m,q,q,q,q,c,cd,q,q,q,c,cd,q,q,q,q,q,m,c,m]
  dur[v].concat [m+q,q,q,q,c,cd,q,q,q,c,q,q,c,c,c,c,m]
  tempolist[v]=180
  gapslist[v]=4*b
  partslist[v]=3
  shiftlist[v]=0
  v +=1
  roundlist[v]='Merrily, Merrily'
  notes[v]=[:eb4,:eb4,:eb4,:eb4,:eb4,:eb4,:g4,:f4,:eb4,:r,:g4,:g4,:g4,:g4,:g4,:g4,:bb4,:ab4,:g4,:r]
  notes[v].concat [:eb5,:eb5,:eb5,:eb5,:bb4,:eb5,:d5,:eb5,:c5,:bb4,:c5,:bb4,:eb5,:g4,:bb4,:bb4,:r]
  dur[v]=[q,q,q,q,q,q,c,q,c,q,q,q,q,q,q,q,c,q,c,q,c,sq,sq,q,c,c,q,c,q,c,q,c,q,c,q,c,q]
  tempolist[v]=140
  gapslist[v]=2*md
  partslist[v]=4
  shiftlist[v]=-4
  v +=1
  roundlist[v]='The Huntsmen'
  notes[v]=[:c4,:e4,:e4,:e4,:f4,:f4,:f4,:e4,:e4,:e4,:e4,:d4,:d4,:d4,:d4,:c4,:d4,:e4,:c4,:g4]
  notes[v].concat [:g4,:g4,:g4,:g4,:g4,:g4,:g4,:g4,:a4,:a4,:a4,:b4,:b4,:b4,:c5,:c5,:r]
  notes[v].concat [:c5,:r,:d5,:r,:e5,:c5,:e4,:e4,:f4,:f4,:f4,:g4,:g4,:g4,:c4,:r]
  dur[v]=[q,q,q,q,q,q,q,c,q,c,q,q,q,q,q,q,q,cd,c,q,q,q,q,q,q,q,cd+c,q,q,q,q,q,q,q,cd,c,q]
  dur[v].concat [c,q,c,q,q,m,sq,sq,c,s,sq,c,sq,sq,cd+c,q]
  tempolist[v]=150
  gapslist[v]=4*md
  partslist[v]=3
  shiftlist[v]=0
  v +=1
  roundlist[v]='Hey We to the Other World'
  notes[v]=[:a4,:c5,:bb4,:a4,:g4,:f4,:e4,:c4,:a4,:c5,:f4,:c5,:d5,:c5,:bb4,:a4,:g4]
  notes[v].concat [:c5,:c5,:a4,:f4,:f4,:bb4,:c5,:d5,:e5,:d5,:e5,:f5,:a4,:g4,:c5,:c5]
  dur[v]=[m,m,q,q,q,q,c,c,c,c,cd,q,q,q,q,q,m,cd,q,c,q,q,q,q,c,c,q,q,md,c,cd,q,m]
  tempolist[v]=180
  gapslist[v]=2*b
  partslist[v]=3
  shiftlist[v]=-2
  v +=1
  roundlist[v]='Dona Nobis Pacem'
  notes[v]=[:g4,:d4,:b4,:a4,:d4,:c5,:b4,:a4,:g4,:g4,:fs4,:e5,:d5,:c5,:b4,:a4,:d5,:c5,:b4,:b4,:a4,:g4,:fs4,:g4]
  notes[v].concat [:d5,:d5,:d5,:c5,:b4,:b4,:a4,:e5,:e5,:d5,:d5,:d5,:c5,:b4,:a4,:g4]
  notes[v].concat [:g4,:fs4,:g4,:a4,:b4,:c5,:d5,:d4,:c5,:c5,:b4,:b4,:fs4,:a4,:d5,:d4,:g4]
  dur[v]=[q,q,m,q,q,m,c,c,c,c,m,c,q,q,q,q,cd,q,c,q,q,c,c,md]
  dur[v].concat [md,md,c,c,c,c,m,c,m,c,m,q,q,c,c,md,md,md,cd,q,q,q,c,m,c,m,c,m,q,q,c,c,md]
  tempolist[v]=140
  gapslist[v]=8*md
  partslist[v]=3
  shiftlist[v]=-2
  v +=1
  roundlist[v]='Fox and Geese'
  notes[v]=[:f4,:a4,:bb4,:c5,:d5,:e5,:f5,:g5,:e5,:f5,:c5,:c5,:bb4,:a4,:g4,:g4,:f4,:c4,:c4,:c4,:f4,:a4,:f4,:g4,:a4,:b4,:a4]
  notes[v].concat [:g4,:a4,:g4,:a4,:c5,:c5,:f5,:c5,:f5,:d5,:e5,:c5,:c5]
  dur[v]=[c,cd,q,c,cd,q,c,m,c,m,c,cd,q,c,c,c,c,c,c,c,m,c,cd,q,c,m,c,cd,q,c,m,q,q,c,m,c,m,m,c,md]
  tempolist[v]=180
  gapslist[v]=4*md
  partslist[v]=4
  shiftlist[v]=-5
  v +=1
  roundlist[v]='Hey, Ho, Nobody Home'
  notes[v]=[:d4,:c4,:d4,:d4,:d4,:a3,:a3,:d4,:d4,:e4,:e4,:f4,:f4,:f4,:f4,:e4,:a4,:g4,:a4,:g4,:a4,:g4,:a4,:g4,:f4,:e4]
  dur[v]=[m,m,c,q,q,c,c,c,c,c,c,q,q,q,q,m,cd,q,cd,q,cd,q,q,q,q,q]
  tempolist[v]=180
  gapslist[v]=b*2
  partslist[v]=4
  shiftlist[v]=3
  v +=1
  roundlist[v]='White Sand and Grey'
  notes[v]=[:a4,:b4,:a4,:gs4,:a4,:cs5,:d5,:cs5,:b4,:cs5,:a4,:fs4,:d4,:e4,:a3]
  dur[v]=[b,m,m,b,b,b,m,m,b,b,b,m,m,b,b]
  tempolist[v]=210
  gapslist[v]=4*b
  partslist[v]=3
  shiftlist[v]=-4
  v +=1
  roundlist[v]='Hava Nashira, Shir "Alleluia"'
  notes[v]=[:g3,:d4,:e4,:d4,:g3,:c4,:b3,:a3,:g3,:a3,:g3,:g4,:fs4,:g4,:a4,:b4,:g4,:g4,:a4,:b4,:c5,:b4]
  notes[v].concat [:b4,:a4,:g4,:fs4,:g4,:e4,:d4,:g4,:g4,:fs4,:e4,:fs4,:g4]
  dur[v]=[m,c,c,m,m,m,c,q,q,m,m,m,c,c,m,m,m,c,q,q,m,m,m,c,c,m,m,m,c,c,q,q,q,q,m]
  tempolist[v]=160
  gapslist[v]=4*b
  partslist[v]=3
  shiftlist[v]=2
  v +=1
  roundlist[v]='Oaken Leaves'
  notes[v]=[:f4,:c4,:f4,:f4,:f4,:f4,:e4,:f4,:g4,:f4,:g4,:g4,:fs4,:g4,:d4,:g4]
  notes[v].concat [:a4,:a4,:c5,:a4,:g4,:a4,:bb4,:a4,:g4,:a4,:bb4,:a4,:g4,:fs4,:g4]
  notes[v].concat [:f4,:c5,:a4,:bb4,:c5,:c5,:c5,:d5,:eb5,:d5,:c5,:c5,:bb4,:c5,:d5,:c5,:bb4,:a4,:b4]
  dur[v]=[md,c,m,c,c,cd,q,c,c,b,m,m,m,m,b,b,m,m,b,cd,q,c,c,b,c,c,m,m,m,b,b,m,m,cd,q,m,c,c,c,c,c,c,m,c,c,m,m,m,b,b]
  tempolist[v]=180
  gapslist[v]=8*b
  partslist[v]=3
  shiftlist[v]=0
  v +=1
  roundlist[v]='The Spring is Come'
  notes[v]=[:bb4,:ab4,:g4,:ab4,:bb4,:eb5,:ab4,:g4,:ab4,:bb4,:eb5,:bb4,:ab4,:g4,:f4,:eb4,:r,:eb4,:r,:eb4,:r,:eb4,:bb3,:bb3,:eb4]
  notes[v].concat [:g4,:f4,:eb4,:f4,:g4,:g4,:f4,:eb4,:f4,:g4,:ab4,:g4,:f4,:eb4,:d4,:eb4]
  dur[v]=[c,q,c,q,c,c,q,c,q,c,c,c,c,c,c,md,c,m,m,m,m,m,c,c,md,c,q,c,q,c,c,q,c,q,c,c,c,c,c,c,md]
  tempolist[v]=160
  gapslist[v]=4*b
  partslist[v]=3
  shiftlist[v]=0
  v +=1
  roundlist[v]='The Hillside'
  notes[v]=[:c5,:b4,:b4,:a4,:a4,:g4,:g4,:f4,:f4,:e4,:c4,:f4,:g4,:c4,:c4,:d4,:e4,:f4,:g4,:e4,:f4,:d4,:e4,:c4,:f4,:g4,:a4,:b4,:c5,:c5,:c5,:b4,:c5]
  notes[v].concat [:e5,:e5,:d5,:e5,:c5,:d5,:b4,:c5,:a4,:b4,:c5,:d5,:e5,:e5,:f5,:d5,:d5,:e5]
  dur[v]=[m,c,c,c,c,c,c,c,c,c,c,c,c,m,q,q,q,q,c,c,c,c,c,c,q,q,q,q,c,c,c,c,m]
  dur[v].concat [cd,q,c,c,cd,q,c,c,q,q,q,q,c,q,q,c,c,m]
  tempolist[v]=180
  gapslist[v]=8*m
  partslist[v]=3
  shiftlist[v]=-4
  v +=1
  roundlist[v]='SUMER IS ICUMEN IN'
  notes[v]=[:f5,:e5,:d5,:e5,:f5,:f5,:e5,:d5,:c5,:a4,:a4,:bb4,:g4,:a4,:r,:f4,:a4,:g4,:bb4,:a4,:a4,:g4,:f4,:a4,:c5,:d5,:d5,:c5,:r]
  notes[v].concat [:f5,:d5,:f5,:r,:c5,:a4,:bb4,:g4,:a4,:c5,:bb4,:a4,:f4,:a4,:g4,:e4,:f4,:r,:a4,:a4,:g4,:bb4,:c5,:c5,:d5,:e5]
  notes[v].concat [:f5,:e5,:d5,:e5,:f5,:r,:c5,:d5,:c5,:bb4,:a4,:f4,:a4,:bb4,:g4,:a4,:bb4,:c5,:a4,:c5,:g4,:e4,:f4,:r]
  dur[v]=[c,q,c,q,c,q,q,q,q,c,q,c,q,cd,cd,c,q,c,q,c,q,c,q,c,q,c,q,cd,cd]
  dur[v].concat [cd,cd,cd,cd,c,q,c,q,c,q,c,q,c,q,c,q,cd,cd,c,q,c,q,c,q,c,q,c,q,c,q,cd,cd,cd,cd,cd,c,q,c,q,c,q,cd,c,q,c,q,c,q,cd,cd]
  notesbass=[:f3,:g3,:f3,:g3,:a3,:c4,:bb3,:c4,:r]*8+[:f3,:g3,:f3]
  durbass=[cd,cd,cd,c,q,cd,cd,cd,cd]*8+[cd,cd,cd]
  tempolist[v]=160
  gapslist[v]=4*cd
  partslist[v]=4
  shiftlist[v]=-5
#END OF ROUNDS DATA SECTION==============================

end
define :printlist do |num| #prints round info on screen
  0.upto(num-1) do |i|
    puts "round "+(i+1).to_s+" '"+roundlist[i]+"'"
  end
  puts "" #blank line
end
define :adjustedchoices do |rlist| #bump choices in list by 1 for printing purposes
  alist=[]
  0.upto(4) do |i|
    alist << (rlist[i]+1)
  end
  return alist
end
setuprounds(180) #prime the tempolist so it can be used as a parameter for subsequent calls
printlist(num)
#now play the rounds
if selectionmode then
  rlist=range(0,num).shuffle #choose 5 rounds from the list in random order
  puts "Selection choices: "+adjustedchoices(rlist).to_s #print them
  limit=4
else limit=num
end
0.upto(limit) do |i| #play the choices
  if selectionmode then
    ch=rlist[i]
  else
    ch=i
  end
  #adjust duration arrays for correct tempo
  setuprounds((tempolist[ch]))
  #print info on the screen
  puts "round "+(ch+1).to_s+" of "+num.to_s+" now playing:"
  puts "'"+roundlist[ch]+"'"
  puts partslist[ch].to_s+" voices"
  #allocate choices for the current round
  notes=notes[ch]
  dur=dur[ch]
  gaps=gapslist[ch]
  shift=shiftlist[ch]
  with_fx :reverb,room: 0.6 do #comment out reverb and corresponding end line if on model B or B+
    if roundlist[ch]=='SUMER IS ICUMEN IN' then #deal with the special case of bass part for this round
      in_thread {plarray(instlist[ch][4][0],instlist[ch][4][1],notesbass,durbass,shift)}
    end
    in_thread {plarray(instlist[ch][0][0],instlist[ch][0][1],notes,dur,shift)}
    sleep gaps
    in_thread {plarray(instlist[ch][1][0],instlist[ch][1][1],notes,dur,shift)}
    sleep gaps
    in_thread {plarray(instlist[ch][2][0],instlist[ch][2][1],notes,dur,shift)}
    sleep gaps
    if partslist[ch]==4 then #add 4th part if 4 part round
      in_thread {plarray(instlist[ch][3][0],instlist[ch][3][1],notes,dur,shift)}
      sleep gaps
    end
    in_thread {plarray(instlist[ch][0][0],instlist[ch][0][1],notes,dur,12+shift)}
    sleep gaps
    in_thread {plarray(instlist[ch][1][0],instlist[ch][1][1],notes,dur,12+shift)}
    sleep gaps
    if partslist[ch]==4 then  #4 part round
      in_thread {plarray(instlist[ch][2][0],instlist[ch][2][1],notes,dur,12+shift)}
      sleep gaps
      plarray(instlist[ch][3][0],instlist[ch][3][1],notes,dur,12+shift)
    else
      plarray(instlist[ch][2][0],instlist[ch][2][1],notes,dur,12+shift)
    end
    sleep b #gap before next round
  end #comment out this end if reverb commented out
end
puts "Finished!"