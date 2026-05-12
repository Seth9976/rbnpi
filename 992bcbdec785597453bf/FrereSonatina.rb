#program to utilise 48 different sample voices from Sonatina Symphonic Library
#written by Robin Newman, March 2016
#requires Sonatina Symphonic Library from http://sso.mattiaswestlund.net/download.html
#requires Sonic Pi ver 2.10
#plays 19 voice Frere Jqeus round!
#tested on Pi2, Pi3, Mac OSX and Windows 10.
#updated to handle new thread structure in SP2.11dev
use_debug false
#path to library samples folder (including trailing /)
path='~/Desktop/Sonatina Symphonic Orchestra/Samples/'

#create array of instrument details
voices=[['1st Violins piz','1st Violins','1st-violins-piz-rr1-',1,:g3,:b6],\
        ['1st Violins sus','1st Violins','1st-violins-sus-',1,:g3,:b6],\
        ['1st Violins stc','1st Violins','1st-violins-stc-rr1-',1,:g3,:b6],\
        ['2nd Violins piz','2nd Violins','2nd-violins-piz-rr1-',1,:g3,:b6],\
        ['2nd Violins sus','2nd Violins','2nd-violins-sus-',1,:g3,:b6],\
        ['2nd Violins stc','2nd Violins','2nd-violins-stc-rr1-',1,:g3,:b6],\
        ['Alto Flute','Alto Flute','alto_flute-',1,:g3,:g6],\
        ['Bass Clarinet','Bass Clarinet','bass_clarinet-',2,:d2,:d5],\
        ['Bass Trombone','Bass Trombone','bass_trombone-',1,:e1,:g4],\
        ['Basses piz','Basses','basses-piz-rr1-',0,:c1,:c4],\
        ['Basses sus','Basses','basses-sus-',0,:c1,:c4],\
        ['Basses stc','Basses','basses-stc-rr1-',0,:c1,:c4],\
        ['Bassoon','Bassoon','bassoon-',1,:as1,:d5],\
        ['Bassoons','Bassoons','bassoons-sus-',1,:as1,:d5],\
        ['Celli piz','Celli','celli-piz-rr1-',0,:a2,:bb5],\
        ['Celli sus','Celli','celli-sus-',0,:a2,:bb5],\
        ['Celli stc','Celli','celli-stc-rr1-',0,:a2,:bb5],\
        ['Cello','Cello','cello-',0,:a2,:bb5],\
        ['Chorus female','Chorus','chorus-female-',3,:as4,:gs5],\
        ['Chorus male','Chorus','chorus-male-',3,:as2,:gs3],\
        ['Clarinet','Clarinet','clarinet-',2,:d3,:d6],\
        ['Clarinets','Clarinets','clarinets-sus-',2,:d3,:d6],\
        ['Contrabassoon','Contrabassoon','contrabassoon-',1,:as0,:as3],\
        ['Cor Anglais','Cor Anglais','cor_anglais-',2,:f3,:f5],\
        ['Flute','Flute','flute-',0,:b3,:a4],\
        ['Flutes sus','Flutes','flutes-sus-',0,:c3,:bb5],\
        ['Flutes stc','Flutes','flutes-stc-rr1-',0,:c3,:bb5],\
        ['Grand Piano p','Grand Piano','piano-p-',0,:b0,:cs8],\
        ['Grand Piano f','Grand Piano','piano-f-',0,:b0,:cs8],\
        ['Harp','Harp','harp-',0,:c2,:c7],\
        ['Horn','Horn','horn-',1,:e2,:e5],\
        ['Horns stc','Horns','horns-stc-rr1-',1,:e2,:e5],\
        ['Horns sus','Horns','horns-sus-',1,:e2,:e5],\
        ['Oboe','Oboe','oboe-',1,:as3,:c6],\
        ['Oboes','Oboes','oboes-sus-',1,:as3,:c6],\
        ['Xylophone','Percussion','xylophone-',1,:a2,:b5],\
        ['Piccolo','Piccolo','piccolo-',0,:b3,:g6],\
        ['Tenor Trombone','Tenor Trombone','tenor_trombone-',1,:ds2,:b4],\
        ['Trombones sus','Trombones','trombones-sus-',1,:ds2,:b4],\
        ['Trombones stc','Trombones','trombones-stc-rr1-',1,:ds2,:b4],\
        ['Trumpet','Trumpet','trumpet-',1,:e3,:f6],\
        ['Trumpets sus','Trumpets','trumpets-sus-',1,:e3,:f6],\
        ['Trumpets stc','Trumpets','trumpets-stc-rr1-',1,:e3,:f6],\
        ['Tuba sus','Tuba','tuba-sus-',1,:e1,:d4],\
        ['Tuba stc','Tuba','tuba-stc-rr1-',1,:e1,:d4],\
        ['Violas piz','Violas','violas-piz-rr1-',0,:c3,:c6],\
        ['Violas sus','Violas','violas-sus-',0,:c3,:c6],\
        ['Violin','Violin','violin-',1,:g3,:d7],\
        ['Timpani roll','Percussion','timpani-roll-',0,:c1,:c2],\
        ['Timpani roll cresc','Percussion','timpani-roll-crsc-',0,:c1,:c2],\
        ['Glockenspiel','Percussion','glockenspiel-',0,:c3,:c6],\
        ['Timpani f lh','Percussion','timpani-f-lh-',0,:c1,:c2],\
        ['Timpani f rh','Percussion','timpani-f-rh-',0,:c1,:c2],\
        ['Timpani p lh','Percussion','timpani-p-lh-',0,:c1,:c2],\
        ['Timpani p rh','Percussion','timpani-p-rh-',0,:c1,:c2]]


llist=[50,0,45,11,33,35,28,39,36,3,29,20,44,7,8,31,42,22,52] #voicenumbers used
killit=0
define :load do |i|
  trigger=0
  live_loop :t do
    sleep 0.3 #can be reduced to 0.2 on Mac or PC
    if trigger== 1
      cue :start
    end
    stop if killit==1
  end
  load_samples path+voices[i][1],voices[i][2]
  trigger=1
  sync :start
end

llist.each do |i|
  load(i)
end
killit=1


puts 'The following voices from Sonatina Symphonic Library can be used:-'
voices.each_with_index do |n,i|
  puts i.to_s,n[0]
end
puts voices.length.to_s+' voices'
#setup global variables
sampledir=''
sampleprefix=''
offsetclass=''
low=''
high=''
paths=''

#setup data for current inst
define :setup do |inst,path|
  sampledir=voices.assoc(inst)[1]
  sampleprefix=voices.assoc(inst)[2]
  offsetclass=voices.assoc(inst)[3]
  low=voices.assoc(inst)[4]
  high=voices.assoc(inst)[5]
  #amend path for instrument sampledir
  paths=path+sampledir+'/'
end



#define routine to play sample
define :pl do |np,d,inst,tp=0,pan=0|
  
  setup(inst,path)
  #check if note in range of supplied samples
  #use lowest/highest sample for out of range
  change=0 #used to give rpitch for coverage outside range
  frac=0
  n=np+tp #note allowing for transposition
  if n.is_a?(Numeric) #allow frac tp or np
    frac=n-n.to_i
    n=n.to_i
  end
  if note(np)+tp<note(low) #calc adjustment for low note
    change=note(np).to_i+tp-note(low)
    n=note(low)
  end
  if note(np).to_i+tp > note(high) #calc adjustment for high note
    change = note(np).to_i+tp-note(high)
    n=note(high)
  end
  if change < -3 or change > 5 #set allowable out of range
    #if outside print messsage
    puts 'inst: '+inst+' note '+np.to_s+' with transpostion '+tp.to_s+' out of sample range'
  else #otherwise calc and play it
    #calculate base note and octave
    base=note(n)%12
    oc = note(n) #do in 2 stages because of alignment bug
    oc=oc/12 -1
    #find first part of sample note
    slookup=['c','c#','d','d#','e','f','f#','g','g#','a','a#','b']
    #lookup sample to use,and rpitch offset, according to offsetclass
    case offsetclass
    when 0
      oc += 1 if base == 11 #adjust if sample needs next octave
      snumber=[0,0,3,3,3,6,6,6,9,9,9,0]
      offset=[ 0,1,-1,0,1,-1,0,1,-1,0,1,-1]
    when 1
      snumber=[1,1,1,4,4,4,7,7,7,10,10,10]
      offset=[-1,0,1,-1,0,1,-1,0,1,-1,0,1]
    when 2
      oc -= 1 if base == 0 #adjust if sample needs previous octave
      snumber=[11,2,2,2,5,5,5,8,8,8,11,11]
      offset=[1,-1,0,1,-1,0,1,-1,0,1,-1,0]
    when 3
      snumber=[0,1,2,3,4,5,6,7,8,9,10,11] #this class has sample for every note
      offset=[0,0,0,0,0,0,0,0,0,0,0,0]
    end
    #generate sample name
    sname=sampleprefix+(slookup[snumber[base]]).to_s+oc.to_s
    #play sample with appropriate rpitch value
    sample paths,sname,rpitch: offset[base]+change+frac,sustain: 0.9*d,release: d,pan: pan
  end
end

#define function to play lists of linked samples/durations
define :plarray do |notes,durations,offsetclass,tp=0,pan=0|
  puts offsetclass
  notes.zip(durations).each do |n,d|
    pl(n,d,offsetclass,tp,pan) if ![nil,:r,:rest].include? n#allow for rests
    sleep d
  end
end

#set up notes and duration for Frere Jaques
notes=[:c4,:d4,:e4,:c4,:c4,:d4,:e4,:c4,:e4,:f4,:g4,:e4,:f4,:g4,\
       :g4,:a4,:g4,:f4,:e4,:c4,:g4,:a4,:g4,:f4,:e4,:c4,:c4,:g3,:c4,:c4,:g3,:c4]
sq=0.15
q=2*sq
c=2*q
durations=[q,q,q,q,q,q,q,q,q,q,c,q,q,c,sq,sq,sq,sq,q,q,sq,sq,sq,sq,q,q,q,q,c,q,q,c]
#now play the round, each part in a thread, spaced by duration of 1st line repeated (4*c)
in_thread do
  plarray(notes,durations,'Glockenspiel')
end
sleep 4*c
in_thread do
  plarray(notes,durations,'1st Violins piz',12,0.6)
end
sleep 4*c
in_thread do
  plarray(notes,durations,'Violas piz',0,-0.6)
end
sleep 4*c
in_thread do
  plarray(notes,durations,'Basses stc',-12,0.4)
end
sleep 4*c
in_thread do
  plarray(notes,durations,'Oboe',12)
end
sleep 4*c
in_thread do
  plarray(notes,durations,'Xylophone',12,-0.5)
end
sleep 4*c
in_thread do
  plarray(notes,durations,'Grand Piano f',-24)
end
sleep 4*c
in_thread do
  plarray(notes,durations,'Trombones stc',-12,0.8)
end
sleep 4*c
in_thread do
  plarray(notes,durations,'Piccolo',12,-0.6)
end
sleep 4*c
in_thread do
  plarray(notes,durations,'2nd Violins piz',0,0.7)
end
sleep 4*c
in_thread do
  plarray(notes,durations,'Harp',12,-0.6)
end
sleep 4*c
in_thread do
  plarray(notes,durations,'Clarinet',0,0.6)
end
sleep 4*c
in_thread do
  plarray(notes,durations,'Tuba stc',-12,-0.7)
end
sleep 4*c
in_thread do
  plarray(notes,durations,'Bass Clarinet',-12,0.5)
end
sleep 4*c
in_thread do
  plarray(notes,durations,'Bass Trombone',-24,-0.6)
end
sleep 4*c
in_thread do
  plarray(notes,durations,'Horns stc',0,-0.9)
end
sleep 4*c
in_thread do
  plarray(notes,durations,'Trumpets stc',12,0.7)
end
sleep 4*c
in_thread do
  plarray(notes,durations,'Contrabassoon',-24,0.7)
end
sleep 4*c
in_thread do
  notes1=notes[0..-6]+[:g4,:c4,:c4,:g4,:c4]#adjust :g3 to :g4
  plarray(notes1,durations,'Timpani f rh',-36,0.7)
end