#Fanfare for St Cecilia's Hall by Andrew Blair, first performed 29th November 2017
#at the official opening of St Cecilia's Hall  by HRH The Princess Royal, following a major refurbishment
#coded by Robin Newman, December 2017 with the composer's permission
#I am using code I developed to play samples from Sonatina Symphonic Library, but I have replaced
#the trumpet samples with ones I created myself, using the same file names.

#path to library samples folder (including trailing /)
path="~/Desktop/samples/Fanfare/"

#create array of instrument details
# each entry: name,folder name,sample prefix,offsetclass type,lowest note, highest note
voices=[
["Trumpet","Trumpet","trumpet-",1,:e3,:f6]]

uncomment do #can comment if samples loaded, to allow quick redefine of functions
  killit = 0 #used to stop live_loop :t when all samples loaded
  define :load do |i|
    trigger=0
    live_loop :t do
      sleep 0.3
      if trigger== 1
        cue :start
      end
      stop if killit == 1 # stop when all samples loaded
    end
    load_samples path+voices[i][1],voices[i][2]
    trigger=1
    sync :start
  end
  
  
  load(0)
  
  killit = 1 #stop live_loop :t
  sleep 2
end

puts "The following voices can be used:-"
voices.each_with_index do |n,i|
  puts i.to_s,n[0]
end

puts voices.length.to_s+" voices"
#setup global variables
sampledir=""
sampleprefix=""
offsetclass=""
low=""
high=""
paths=""

#setup data for current inst
define :setup do |inst,path|
  sampledir=voices.assoc(inst)[1]
  sampleprefix=voices.assoc(inst)[2]
  offsetclass=voices.assoc(inst)[3]
  low=voices.assoc(inst)[4]
  high=voices.assoc(inst)[5]
  #amend path for instrument sampledir
  paths=path+sampledir+"/"
end

sleep 0.2

#define routine to play sample using "Sonatina like" data
define :pl do |np,d,inst,vol=1,s=0.9,r=0.1,tp=0,pan=0| #nv,d,offsetclass,vol,s,r,tp,pan
  m=60.0/current_bpm #missing scaling factor
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
    sample paths,sname,rpitch: offset[base]+change+frac,sustain: s*d*m,release: r*d*m,pan: pan,amp: vol
  end
end

#define function to play lists of linked samples/durations using Sonatina samples
define :plarray do |notes,durations,offsetclass,tp=0,pan=0,vol=1,s=0.9,r=0.1|
  #puts offsetclass
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




use_bpm 85

with_fx :reverb, room: 0.8,mix: 0.6 do
  ##| define :plarray do |notes,durations,pan=0,amp =0.5|
  ##|   notes.zip(durations).each do |n,d|
  ##|     play n,sustain: d*0.9,release: d*0.1,amp: amp,pan: pan
  ##|     sleep d
  ##|   end
  ##| end
  b=4;md=3;m=2;cd=1.5;c=1;qd=0.75;q=0.5;sqd=0.375;sq=0.25;dsq=0.125
  
  n1=[:c4,:g4,:c5,:f5,:bb5,:f5,:c6,:g5,:g5,:bb5,:f5,:e5,:d5,:e5,:r]
  d1=[c,c,c,c,m,m,m,cd,q,m,md,q,q,m+md,c+c]
  #d1=[1,1,1,1,2,2,2,1.5,0.5,2,3,0.5,0.5,5,2]
  n1b=[:c5,:g4,:c5,:c5,:c5,:c5,:g4,:c5,:c5,:d5,:e5,:d5,:e5,:d5,:c5,:g5,\
       :d5,:g4,:g4,:g4,:e5,:d5,:f5,:e5,:d5,:c5,:d5,:c5,:d5,:e5,:r,:c5,:g4,:c5,:c5,:c5,:c5,:g4,:c5]
  d1b=[q,q,qd,dsq,dsq,q,q,c,sq,sq,c,dsq/2,dsq/2,dsq,sq,m,\
       qd,dsq,dsq,q,q,cd,q,sq,sq,q,qd,dsq,dsq,m,q,q,q,qd,dsq,dsq,q,q,c]
  n1c=[:c5,:d5,:e5,:d5,:e5,:d5,:c5,:g5,:f5,:e5,:d5,:e5,:f5,:e5,:d5,:e5,:f5,:g5,:g5,:c6,:e5,:f5,:g5,:g5,:c5,:r,:g4]
  d1c=[sq,sq,c,dsq/2,dsq/2,dsq,sq,m,cd,sq,sq,dsq/2,dsq/2,dsq,sq,sq,sq,q,q,q,sq,sq,q,q,c,q,q]
  n1d=[:c5,:c5,:c5,:d5,:e5,:d5,:e5,:d5,:g4,:g4,:g4,:d5,:d5,:d5,:e5,:f5,:e5,:f5,:e5,:d5,:c5,:c5,\
       :af5,:f5,:f5,:g5,:af5,:g5,:e5,:g5,:c6,:g5,:r,:g4]
  d1d=[qd,sq,q,sq,sq,dsq/2,dsq/2,dsq+q,sq,q,q,qd,sq,q,sq,sq,dsq/2,dsq/2,dsq+q,sq,q,q,qd,sq,q,sq,sq,c+sq,sq,sq,sq,m+cd,sq,q]
  n1e=[:c5,:g4,:e4,:g4,:c5,:d5,:e5,:d5,:e5,:d5,:g4,:g4,:g4,:g4,:d5,:c5,:d5,:e5,:d5,:e5,:f5,\
       :e5,:f5,:e5,:d5,:e5,:d5,:c5,:c5,:c5,:g4,:c5,:e5,:d5,:e5,:d5,:c5,:d5,:e5,:d5,:e5,:g5]
  d1e=[sqd,dsq,sqd,dsq,q,sq,sq,dsq/2,dsq/2,dsq+sq,sqd,dsq,q,q,    sqd,dsq,sqd,dsq,q,sq,sq,dsq/2,dsq/2,dsq,sq,sq,sq,q,q,q,q,q,sq,sq,dsq,dsq,sq,sq,sq,q,sq,sq]
  n1f=[:c6,:e5,:f5,:g5,:g5,:c5,:r,:c4,:g4,:c5,:f5,:bb5,:ab5,:g5,:ab5,:g5,:f5,:c6,:g5,:g5,\
       :bb5,:f5,:e5,:f5,:e5,:d5,:e5,:r]
  d1f=[q,sq,sq,q,q,m,sq,c,c,c,c,cd,q,dsq/2,dsq/2,dsq+sq+q,c,m,cd,q,m,md,dsq/2,dsq/2,dsq+sq,q,b+q,q+c]
  
  n2=[:c4,:g4,:c5,:d5,:bb4,:c5,:g4,:g4,:bb4,:g4,:c5,:c4,:r]
  d2=[m,c,m,m,c,m,cd,q,md,c,b,md,c+c]
  n2b=[:r,:c4,:g4,:c4,:c4,:c4,:c4,:g4,:c5,:c5,:d5,:e5,:e5,:f5,:e5,:d5,:c5,:g4,:g4,:g4,:g4,:g4,:d5,:c5,:g4,:g4,:g4,:c4,\
       :r,:r,:c5,:g4,:c4,:c4,:c4]
  d2b=[c,cd,q,qd,dsq,dsq,q,q,c,sq,sq,q,dsq/2,dsq/2,dsq+sq,sq,sq,m,qd,dsq,dsq,q,q,q,q,qd,sq,m,q,    c,cd,q,qd,dsq,dsq]
  n2c=[:c4,:g4,:c5,:c5,:d5,:e5,:e5,:f5,:e5,:d5,:c5,:d5,:g4,:g4,:c5,:g4,:c5,:d5,:e5,:g4,:g4,:g3,:g3,:c4,:r,:g4]
  d2c=[q,q,c,sq,sq,q,dsq/2,dsq/2,dsq+sq,sq,sq,qd,sq,c,sq,sq,sq,sq,q,q,c,qd,sq,c,q,q]
  n2d=[:c4,:c4,:g3,:g3,:g3,:g3,:c4,:c4,:c4,:c4,:e4,:g4,:c5,:g4,:g4,:g4,:g4,:r,:g4]
  d2d=[cd,q,cd,q,cd,q,cd,q,cd,q,c,q,q,cd,sqd,dsq,cd,sq,q]
  n2e=[:c4,:e4,:c4,:g3,:g3,:g3,:g4,:e4,:c4,:c4,:c4,:g3,:c4,:e4,:g4,:c5,:g4,:g4,:g4]
  d2e=[c,qd,sq,cd,q,c,qd,sq,cd,q,q,q,q,q,qd,sq,q,sq,sq]
  n2f=[:c5,:e4,:g4,:g4,:c4,:r,:c4,:g4,:c5,:d5,:bb4,:c5,:g4,:g4,:bb4,:g4,:c5,:c4,:c4,:c4,:c4,:r]
  d2f=[q,q,q,q,m,sq,m,c,m,m,c,m,cd,q,md,c,md,qd,dsq,dsq,m+q,q+c]
  tr=-2
  
  #use_transpose -2
  in_thread do
    plarray(n1,d1,"Trumpet",tr,-0.5)
  end
  plarray(n2,d2,"Trumpet",tr,0.5)
  in_thread do
    plarray(n1b,d1b,"Trumpet",tr,-0.5)
  end
  plarray(n2b,d2b,"Trumpet",tr,0.5)
  in_thread do
    plarray(n1c,d1c,"Trumpet",tr,-0.5)
  end
  plarray(n2c,d2c,"Trumpet",tr,0.5)
  in_thread do
    plarray(n1d,d1d,"Trumpet",tr,-0.5)
  end
  plarray(n2d,d2d,"Trumpet",tr,0.5)
  in_thread do
    plarray(n1e,d1e,"Trumpet",tr,-0.5)
  end
  plarray(n2e,d2e,"Trumpet",tr,0.5)
  in_thread do
    plarray(n1f,d1f,"Trumpet",tr,-0.5)
  end
  plarray(n2f,d2f,"Trumpet",tr,0.5)
  
end #reverb