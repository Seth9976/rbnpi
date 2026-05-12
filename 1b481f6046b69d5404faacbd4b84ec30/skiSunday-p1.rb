#program loads samples and functions required by SkiSunday programs
#written by Robin Newman, March 2016
#require Sonatina Sympohonic Orchestra installed on Desktop
# http://sso.mattiaswestlund.net/download.html
# amended to handle new thread structure in sp 2.11 dev

##| sample_free_all  #can uncomment these lines to clear all samples
##| stop

use_debug false
#path to library samples folder (including trailing /)
path="~/Desktop/Sonatina Symphonic Orchestra/Samples/"  #adjust as necessary

#llist=[0,1,2,3,4,5,6,7,8] #voicenumbers used
#create array of instrument details
voices=[["1st Violins sus","1st Violins","1st-violins-sus-",1,:g3,:b6],\
        ["Clarinets","Clarinets","clarinets-sus-",2,:d3,:d6],\
        ["Flutes sus","Flutes","flutes-sus-",0,:c3,:bb5],\
        ["Trombones sus","Trombones","trombones-sus-",1,:ds2,:e5],\
        ["Trumpet","Trumpet","trumpet-",1,:e3,:f6],\
        ["Trumpets sus","Trumpets","trumpets-sus-",1,:e3,:f6],\
        ["Trumpets stc","Trumpets","trumpets-stc-rr1-",1,:e3,:f6],\
        ["Horns stc","Horns","horns-stc-rr1-",1,:e2,:e5],\
        ["Timpani f lh","Percussion","timpani-f-lh-",0,:c1,:c2]]

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
  
  for i in (0..8) do
      load(i)
    end
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
  
  #define function to play lists of linked samples/durations using Sonatina samples
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
  
  define :plnarray do |n,d,v=1,shift=0| #used to play harmony supersaw part
    n.zip(d).each do |n,d|
      play n+shift,sustain: 0.9*d,release: 0.1*d,amp: v
      sleep d
    end
  end
  define :pluckarray do |n,d,v=1,shift=0| #used to play plucked bass part
    n.zip(d).each do |n,d|
      play n+shift,release: 1.5*d,amp: v
      sleep d
    end
  end
  define :dl do |d| #used for debugging to determine durations of duration lists
    t=0
    d.each do |d|
      t +=d
    end
    return t
  end
  
  define :dr do |d,v| #drum roll
    sample :drum_roll,sustain: d*0.9,release: d*0.1,amp: v
    sleep d
    sample :drum_snare_hard,rate: 1.25,amp: v
  end
  
  define :drfall do |n,d,v| #falling tabla drum motif and drumroll
    sample :tabla_na_o,rpitch: n-:ds4,sustain:0,release: 2*d,amp: v
    sleep d
    sample :tabla_na_o,rpitch: n-:ds4,sustain:0,release: 2*d,amp: v
    sleep d
    sample :tabla_na_o,rpitch: n-:ds4,sustain:0,release: 2*d,amp: v
    sleep d
    sample :tabla_na_o,rpitch: n-5-note(:ds4),sustain:0,release: 2*d,amp: v
    sleep d
    sample :tabla_na_o,rpitch: n-5-note(:ds4),sustain:0,release: 2*d,amp: v
    sleep d
    sample :tabla_na_o,rpitch: n-5-note(:ds4),sustain:0,release: 2*d,amp: v
    sleep d
    sample :tabla_na_o,rpitch: n-12-note(:ds4),sustain:0,release: 2*d,amp: v
  end
  
  define :riff do |n1,n2| #these riffs used in plucked base part
    return [n1,:r,n1,n1,:r,n2,:r]
  end
  define :riff2 do |n1,n2,n3|
    return [n1,:r,n2,n3,:r,n2,:r]
  end
  define :riff3 do |n1,n2,n3|
    return [n1,:r,n1,n2,:r,n3,:r]
  end
  
  load_sample :tabla_na_o #used in drfall
  load_sample :drum_cymbal_closed #used in rhythm live_loop :cm
  load_sample :drum_roll
  load_sample :drum_snare_hard
 