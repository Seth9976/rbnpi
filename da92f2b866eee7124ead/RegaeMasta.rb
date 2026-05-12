#Reggae Masta by Nathan Douglas
#Utilises the Sonatina Symphonic Orchstera library
#written by Robin Newman, March 2016
#music score at http://www.8notes.com/scores/389.asp
#Sonatina Library at http://sso.mattiaswestlund.net/download.html
#updated to handle new thread structure in SP2.11 dev

use_debug false
#path to library samples folder (including trailing /)
path='~/Desktop/Sonatina Symphonic Orchestra/Samples/'

#create array of instrument details
voices=[["Grand Piano p","Grand Piano","piano-p-",0,:b0,:cs8],\
        ["Grand Piano f","Grand Piano","piano-f-",0,:b0,:cs8]]


llist=[0,1] #voicenumbers used
killit=0 #flag to kill live_loop :t when all samples loaded
define :load do |i|
  trigger=0
  live_loop :t do
    sleep 0.3 #can be reduced to 0.2 on Mac or PC
    if trigger== 1
      cue :start
    end
    stop if killit==1 #kill live_loop when all samples laoded
  end
  load_samples path+voices[i][1],voices[i][2]
  trigger=1
  sync :start
end

llist.each do |i|
  load(i)
end
killit=1 #set flag to kill live_loop :t
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
q=0.17
sq=q/2
c=2*q
cd=3*q
m=2*c
b=2*m
#Right hand notes and duratiojns
rhn=[:r,[:a3,:c4,:e4]]*10+[:r]+[:r,[:a3,:c4,:e4]]*3+[:r]+[:r,[:a3,:d4,:f4]]*7+[:r]+[:r,[:a3,:c4,:e4]]*2+[:r]+\
  [:c5,:c5,:d5,:e5]*2+[:d5,:a4,:a4,:a4,:a4,:a4]+[:c5,:c5,:d5,:e5]*2+[:d5,:a4,:a4,:a4,:a4,:a4,:c6,:a5,:a5,:a5,:a5,\
                                                                     :a5,:a5,:a5,:g5,:e5]+[:c6,:a5,:a5,:a5,:a5,:a5]*2+[:a5,:a5,:g5,:e5,:c6,:a5,:a5,:a5,:a5,:a5,:r]+\
  [:r,[:a3,:c4,:e4]]*2+[:r,[:a3,:c4,:e4]]*16
rhd=[c]*20+[b]+[c]*6+[m]+[c]*14+[m]+[c]*4+[b]+[q,c,q,m,q,c,q,m,q,c,q,c,c,b,q,c,q,m,q,c,q,m,q,c,q,c,c,b,q,c,q,c,c,m,q,q,q,q,q,c,q,c,c,b,\
                                               q,c,q,c,c,m,q,q,q,q,q,c,q,c,c,b,b]+[c]*4+[c]*32
#Lewft had notes and durtations
lhn=[:a2,:a2,:c3,:e3,:r]*3+[:ds3,:e3,:c3,:a2,:a2,:c3,:e3,:r,:ds3,:e3,:ds3,:e3,:a2,:a2,:d3,:f3,:r,:g3,:f3,:a2,:a2,:d3,:f3,:r,:e3,:r,:a2]+\
  [:r,[:a3,:c3,:e3]]*2+[:a3,[:c3,:e3],:r,[:c3,:e3]]*2+[:a3,[:d4,:f4],:r,[:d4,:f4]]*2+\
  [:a3,[:c4,:e4],:r,[:c4,:e4]]*2+[:a3,[:d4,:f4],:r,[:d4,:f4]]*2+[:a3,[:c4,:e4],:r,[:c4,:e4]]*2+[:a3,[:d4,:f4],:r,[:d4,:f4]]*2+\
  [:a3,[:c4,:e4],:r,[:c4,:e4]]*2+[:a3,[:d4,:f4],:r,[:d4,:f4]]*2+[:a3,[:c4,:e4],:r,[:c4,:e4]]+[:r]+\
  [:a2,:a2,:c3,:e3,:r]*4
lhd=[cd,q,c,c,b]*2+[cd,q,c,c,c,c,c,c,cd,q,c,c,m,q,q,q,q,cd,q,c,c,m,c,c,cd,q,c,c,m,sq,m-sq,b]+[c]*20+\
  [c]*52+[b]+[cd,q,c,c,b]*4
#Left hand accentd note, played at greater volume
lhnaccent=[:r,:f3]
lhdaccent=[11*b+m+sq,m-sq]


with_fx :level do |vol|
  control vol,amp: 1 #set initial level
  live_loop :audio do
    tick
    if look>= 32*4 #start fade out during last repeated line (bar 33)
      control vol,amp: 1 - (look-32*4).to_f/32 #fade out over 8 bars (4 bars repeated)
    end
    sleep c
    stop if look==32*4+32 #stop loop when vol is 0
  end
  
  
  in_thread do
    plarray(rhn,rhd,'Grand Piano p',0.3) #play RH
  end
  in_thread do
    plarray(lhnaccent,lhdaccent,'Grand Piano f') #play LH accented note
  end
  plarray(lhn,lhd,'Grand Piano p',0.3) #play LH
end