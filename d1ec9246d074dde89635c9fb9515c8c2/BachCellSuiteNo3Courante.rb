#Bach Cello Suite no 3: Courante
#coded by Robin Newman, August 2016
#require Sonatina Sympohonic Orchestra installed on Desktop
# http://sso.mattiaswestlund.net/download.html

##| sample_free_all  #can uncomment these lines to clear all samples
##| stop

use_debug false
#path to library samples folder (including trailing /)
path="~/Desktop/Sonatina Symphonic Orchestra/Samples/"  #adjust as necessary


#create array of instrument details
voices=[
["Cello","Cello","cello-",0,:c2,:bb5]]

t=0.12

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

puts "The following voices from Sonatina Symphonic Library can be used:-"
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

#define routine to play sample using Sonatina data
define :pl do |np,d,inst,vol=1,s=0.8,r=0.2,tp=0,pan=0,atk=0.2| #atk*d= attack parameter
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
    #set start: to 0.012 to get better attack
    sample paths,sname,rpitch: offset[base]+change+frac,attack: d*atk,start: 0.010,sustain: s*d,pan: pan,amp: vol #,release: r*d
  end
end

#define function to play lists of linked samples/durations using Sonatina samples
define :plarray do |notes,durations,offsetclass,vol=1,s=0.9,r=0.1,tp=0,pan=0|
  #puts offsetclass
  notes.zip(durations).each do |n,d|
    if n.respond_to?(:each)
      n.each do |nv|
        pl(nv,d*t,offsetclass,vol,s,r,tp,pan) if ![nil,:r,:rest].include? nv#allow for rests
      end
    else
      pl(n,d*t,offsetclass,vol,s,r,tp,pan) if ![nil,:r,:rest].include? n#allow for rests
    end
    sleep d*t
  end
end

#Bach Courante from Cello suite 3 BWV 1009
d=[2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,6,\
   1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,\
   2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,\
   2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,\
   2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,6,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,\
   2,2,2,2,2,2,8,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,\
   2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,\
   2,2,2,2,2,6,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,\
   2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,\
   2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,\
   2,2,2,2,2,2,2,2,2,6,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,8,2]
n=[:C4,:C4,:G3,:E3,:C3,:G2,:E2,:C2,:C4,:D4,:C4,:B3,:C4,:D4,:B3,:G3,:D3,:B2,:G2,:F2,:D4,\
   :C4,:B3,:A3,:G3,:C4,:B3,:A3,:G3,:F3,:E3,:F3,:D3,:G2,:A3,:G3,:F3,:E3,:D3,:C3,:B2,:C3,:G2,\
   :C2,:C3,:D3,:E3,:F3 + 1,:B2,:D3,:G3,:A3,:B3,:C4,:G3 + 1,:D4,:E3,:D4,:C4,:B3,:C4,:B3,:A3,\
   :G3 + 1,:A3,:E3,:C3,:D3,:E3,:C3,:A2,:G2,:F2 + 1,:A2,:D3,:E3,:F3 + 1,:G3,:A3,:F3 + 1,:D3,\
   :C4,:B3,:A3,:B3,:A3,:G3,:F3 + 1,:G3,:D3,:B2,:C3,:D3,:B2,:G2,:F2,:E2,:G3,:A3,:G3,:F3 + 1,\
   :G3,:C3,:D3,:C3,:B2,:A2,:G2,:F2 + 1,:A3,:B3,:A3,:G3,:A3,:C3,:E3,:D3,:C3,:B2,:A2,:G2,:B3,\
   :C4,:B3,:E3,:B3,:A2,:C4,:D4,:C4,:F3 + 1,:C4,:B2,:D4,:E4,:D4,:C4,:B3,:A3,:G3,:F3,:E3,:F3,\
   :D3,:C2,:F3,:E3,:D3,:E3,:C3,:B2,:C3,:D3,:E3,:F3 + 1,:G3,:A2,:D3,:E3,:F3 + 1,:G3,:A3,:G2,\
   :E3,:F3 + 1,:G3,:A3,:B3,:D2,:C4,:A3,:C4,:F3 + 1,:C4,:D3,:C4,:A3,:C4,:F3 + 1,:C4,:D3,\
   :B3 + -1,:G3,:B3 + -1,:F3 + 1,:B3 + -1,:D3,:B3 + -1,:G3,:B3 + -1,:F3 + 1,:B3 + -1,\
   :E3 + -1,:A3,:G3,:A3,:F3 + 1,:A3,:E3 + -1,:A3,:G3,:A3,:F3 + 1,:A3,:C4,:A3,:F3 + 1,:D3,\
   :A2,:F2 + 1,:D2,:D3,:F3 + 1,:A3,:B3,:C4,:D4,:A3,:B3,:G3,:A3,:B3,:C4,:G3,:A3,:F3 + 1,:G3,\
   :D3,:E3,:C3,:A2,:F3 + 1,:G2,:r,:D4,:D4,:B3,:G3,:D3,:B2,:D3,:F3,:D3,:B2,:A2,:B2,:G2,:C2,:F3,\
   :E3,:D3,:E3,:G3,:C4,:D4,:E4,:B3,:C4,:A3,:F3,:G3,:A3,:E3,:F3,:D3,:B2,:A3,:B3,:C4,:D4,:B3,\
   :G3 + 1,:F3 + 1,:G3 + 1,:A3,:B3,:G3 + 1,:E3,:B3,:G3 + 1,:E3,:E4,:D3,:C3,:A3,:E3,:C3,:B2,\
   :G3,:A2,:F3,:C3,:A2,:G2,:E3,:F2,:D3,:A2,:F2,:E2,:C3,:D2,:C4,:B3,:C4,:D4,:G3 + 1,:C2,:E4,\
   :D4,:C4,:B3,:A3,:E3,:D4,:C4,:B3,:A3,:G3 + 1,:A3,:E3,:D3,:C3,:D3,:E3,:A2,:A3,:B3,:C4,:B3,\
   :C4,:A3,:G3,:E3,:C3,:E3,:G3,:B3 + -1,:E2,:D4,:C4,:B3 + -1,:A3,:G3,:A3,:F3,:E3,:F3,:C3,\
   :F3,:A2,:C3,:F2,:A3,:G3,:A3,:B3 + -1,:A3,:G3,:F3,:E3,:G3,:C3 + 1,:E3,:G2,:B2 + -1,:A2,\
   :G2,:F2,:E2,:F2,:G2,:A2,:F2,:D2,:F2,:A2,:D3,:E3,:F3,:G2 + 1,:F3,:E3,:D3,:C3,:B2,:A2,:C3,\
   :F3,:A3,:F3,:D3,:B2,:A3,:G3,:F3,:E3,:D3,:C3,:E3,:A3,:C4,:A3,:F3,:D3,:C4,:B3,:A3,:G3,:F3,\
   :E3,:G3,:C4,:E4,:C4,:A3,:F3,:E4,:D4,:C4,:B3,:A3,:B3,:D4,:B3,:G3,:D3,:B2,:G2,:F3,:D3,:F3,\
   :B2,:F3,:G2,:F3,:D3,:F3,:B2,:F3,:G2,:E3 + -1,:C3,:E3 + -1,:B2,:E3 + -1,:G2,:E3 + -1,:C3,\
   :E3 + -1,:B2,:E3 + -1,:A2 + -1,:D3,:C3,:D3,:B2,:D3,:A2 + -1,:D3,:C3,:D3,:B2,:D3,:F3,:G2,\
   :B2,:D3,:F3,:B3,:D4,:C4,:B3,:A3,:G3,:F3,:E3,:G3,:F3,:D3,:E3,:D3,:C3,:E3,:D3,:B2,:C3,:G3,\
   :A3,:F3,:D3,:B3,[:C2,:G2,:E3,:C4], :r]

in_thread do
  with_fx :reverb,room: 0.8 do
    plarray(n,d,"Cello",1.5)
  end
end

