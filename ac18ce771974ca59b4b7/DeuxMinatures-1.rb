#Deux Miniatures by Victor Kalinnikow here arranged for Oboe and strings
#Utilises the Sonatina Symphonic ORchstera library
#written by Robin Newman, March 2016
#Uses three separate buffers linced by cue and sync#run part 3  THEN part 2 THEN part 1
#path variable needs to be adjusted in all three parts
#amended to handle new thread structure in SP2.11dev
use_debug false
#path to library samples folder (including trailing /)
path='~/Sonatina Symphonic Orchestra/Samples/'

#create array of instrument details
voices=[['2nd Violins sus','2nd Violins','2nd-violins-sus-',1,:g3,:b6],\
        ['Violas sus','Violas','violas-sus-',0,:c3,:c6],\
        ['Basses piz','Basses','basses-piz-rr1-',0,:c1,:c4],\
        ['Basses sus','Basses','basses-sus-',0,:c1,:c4],\
        ['Basses stc','Basses','basses-stc-rr1-',0,:c1,:c4],\
        ['Oboe','Oboe','oboe-',1,:as3,:c6]]


llist=[0,1,2,3,4,5] #voicenumbers used
killit=0 #flag to kill live_loop :t when all samples laoded
define :load do |i|
  trigger=0
  live_loop :t do
    sleep 0.3 #can be reduced to 0.2 on Mac or PC
    if trigger== 1
      cue :start
    end
    stop if killit==1 #kill loop when all samples loaded
  end
  load_samples path+voices[i][1],voices[i][2]
  trigger=1
  sync :start
end

llist.each do |i|
  load(i)
end
killit=1 #set flag to killl live_loop :t
sleep 2

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
define :pl do |np,d,inst,vol=1,s=0.9,r=0.1,tp=0,pan=0|
  
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
  if change < -5 or change > 5 #set allowable out of range
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
    sample paths,sname,rpitch: offset[base]+change+frac,sustain: s*d,release: r*d,pan: pan,amp: vol
  end
end

#define function to play lists of linked samples/durations
define :plarray do |notes,durations,offsetclass,vol=1,s=0.9,r=0.1,tp=0,pan=0|
  puts offsetclass
  notes.zip(durations).each do |n,d|
    if n.respond_to?(:each)
      n.each do |nv|
        pl(nv,d,offsetclass,vol,s,r,tp,pan) if ![nil,:r,:rest].include? nv#allow for rests
      end
    else
      pl(n,d,offsetclass,vol,s,r,tp,pan) if ![nil,:r,:rest].include? n#allow for rests
    end
    sleep d
  end
end

cue :part2