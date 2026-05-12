#GoBetween variations
use_debug false
#path to library samples folder (including trailing /)
path="~/Desktop/SSO/Samples/"


#create array of instrument details
# each entry: name,folder name,sample prefix,offsetclass type,lowest note, highest note
voices=[
        ["Grand Piano","Grand Piano","piano-f-",0,:c1,:c8]]

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
  
  for i in (0..0) do
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
  define :plarray do |notes,durations,my_bpm,offsetclass,vol=1,s=0.9,r=1,tp=0,pan=0|
    #puts offsetclass
    notes.zip(durations).each do |n,d|
      if n.respond_to?(:each)
        n.each do |nv|
          pl(nv,d*60.0/my_bpm,offsetclass,vol,s,r,tp,pan) if ![nil,:r,:rest].include? nv#allow for rests
        end
      else
        pl(n,d*60.0/my_bpm,offsetclass,vol,s,r,tp,pan) if ![nil,:r,:rest].include? n#allow for rests
      end
      sleep d*60.0/my_bpm
    end
  end
#use_synth :piano
#with_fx :reverb,room: 1 do
with_fx :gverb, room: 30,preamp: 0.5,premix: 0.5,mix: 0.5,damp: 0.6 do
a1=[]
b1=[]
a1[0]=[:B4,:E4,:G4,:A4,:B4,:A4,:B4,:G4,:C5,:E4,:A4,:B4,:C5,:B4,:C5,:A4,:A4,:E4,:Fs4,:G4,:A4,:G4,:A4,:Fs4,:B4,:Ds4,:Fs4,:A4,:B4,:A4,:B4,:Fs4,:G4,:B3,:E4,:Fs4,:G4,:Fs4,:G4,:E4,:A4,:Cs4,:E4,:G4,:A4,:G4,:A4,:E4,:Fs4,:B3,:Ds4,:E4,:Fs4,:B3,:Ds4,:Fs4,:G4,:Fs4,:E4,:Fs4,:G4,:Fs4,:G4,:A4,:B4,:E4,:G4,:A4,:B4,:A4,:B4,:G4,:C5,:E4,:A4,:B4,:C5,:B4,:C5,:G4,:A4,:E4,:Fs4,:G4,:A4,:G4,:A4,:Fs4,:B4,:Ds4,:Fs4,:A4,:B4,:A4,:B4,:Fs4,:G4,:B3,:E4,:Fs4,:G4,:Fs4,:G4,:E4,:A4,:B3,:Cs4,:E4,:A4,:G4,:A4,:E4,:Fs4,:B3,:Ds4,:E4,:Fs4,:B3,:Ds4,:Fs4,:G4,:Fs4,:E4,:Fs4,:G4,:Fs4,:G4,:A4,:B4,:E4,:G4,:A4,:B4,:A4,:B4,:C5,:D5,:G4,:B4,:C5,:D5,:C5,:D5,:G4,:A4,:D4,:Fs4,:G4,:A4,:G4,:A4,:B4,:C5,:C4,:F4,:A4,:C5,:B4,:C5,:F4,:G4,:C4,:E4,:Fs4,:G4,:Fs4,:G4,:A4,:B4,:A4,:B4,:E4,:Fs4,:E4,:Fs4,:Ds4,:B4,:E4,:G4,:A4,:B4,:A4,:B4,:G4,:C5,:E4,:G4,:B4,:C5,:B4,:C5,:G4,:A4,:E4,:Fs4,:G4,:A4,:G4,:A4,:Fs4,:B4,:Ds4,:Fs4,:A4,:B4,:A4,:B4,:Fs4,:G4,:B3,:E4,:Fs4,:G4,:Fs4,:G4,:E4,:A4,:B3,:Cs4,:E4,:A4,:G4,:A4,:E4,:Fs4,:B3,:Ds4,:E4,:Fs4,:B3,:Ds4,:Fs4,:G4,:Fs4,:E4,:Fs4,:G4,:Fs4,:G4,:A4,:B4,:G4,:B4,:C5,:D5,:G4,:B4,:D5,:E5,:G4,:B4,:D5,:E5,:D5,:E5,:B4,:C5,:G4,:A4,:B4,:C5,:G4,:A4,:C5,:D5,:Fs4,:A4,:C5,:D5,:C5,:D5,:A4,:B4,:D4,:G4,:A4,:B4,:D4,:G4,:B4,:C5,:D4,:G4,:B4,:C5,:B4,:C5,:G4,:A4,:D4,:Fs4,:G4,:A4,:D4,:Fs4,:A4,:B4,:A4,:G4,:Fs4,:G4,:A4,:B4,:C5,:D5,:G4,:B4,:C5,:D5,:G4,:B4,:D5,:E5,:G4,:B4,:D5,:E5,:D5,:E5,:B4,:C5,:G4,:A4,:B4,:C5,:G4,:A4,:C5,:D5,:Fs4,:A4,:C5,:D5,:C5,:D5,:A4,:B4,:D4,:G4,:A4,:B4,:D4,:G4,:B4,:C5,:D4,:G4,:B4,:C5,:B4,:C5,:G4,:A4,:D4,:Fs4,:G4,:A4,:D4,:Fs4,:A4,:B4,:A4,:B4,:C5,:D5,:C5,:D5,:E5,:Fs5,:B4,:D5,:E5,:Fs5,:B4,:D5,:Fs5,:G5,:B4,:D5,:Fs5,:G5,:Fs5,:G5,:D5,:E5,:B4,:Cs5,:D5,:E5,:B4,:Cs5,:E5,:Fs5,:As4,:Cs5,:E5,:Fs5,:E5,:Fs5,:Cs5,:D5,:Fs4,:B4,:Cs5,:D5,:Cs5,:D5,:B4,:E5,:Fs4,:Gs4,:B4,:E5,:D5,:E5,:B4,:Cs5,:Fs4,:As4,:B4,:Cs5,:Fs4,:As4,:Cs5,:D5,:Cs5,:D5,:E5,:Fs5,:E5,:Fs5,:G5,:A5,:D5,:Fs5,:G5,:A5,:D5,:Fs5,:A5,:B5,:D5,:Fs5,:A5,:B5,:A5,:B5,:Fs5,:G5,:D5,:E5,:Fs5,:G5,:D5,:E5,:G5,:A5,:Cs5,:E5,:G5,:A5,:G5,:A5,:E5,:Fs5,:A4,:D5,:E5,:Fs5,:A4,:D5,:Fs5,:G5,:A4,:D5,:Fs5,:G5,:Fs5,:G5,:D5,:E5,:A4,:Cs5,:D5,:E5,:A4,:Cs5,:E5,:Fs5,:E5,:D5,:E5,:Fs5,:E5,:Fs5,:G5,:A5,:D5,:F5,:G5,:A5,:D5,:F5,:A5,:Bf5,:Bf4,:D5,:F5,:Bf5,:A5,:Bf5,:F5,:G5,:As4,:E5,:F5,:G5,:F5,:G5,:E5,:A5,:A4,:C5,:E5,:A5,:G5,:A5,:E5,:F5,:A4,:D5,:E5,:F5,:E5,:F5,:D5,:G5,:G4,:As4,:D5,:G5,:F5,:G5,:D5,:E5,:Cs5,:E5,:Cs5,:A4,:G4,:F4,:G4,:A4,:D4,:F4,:G4,:A4,:G4,:A4,:F4,:Bf4,:D4,:F4,:A4,:Bf4,:A4,:Bf4,:F4,:G4,:D4,:E4,:F4,:G4,:F4,:G4,:E4,:A4,:Cs4,:E4,:G4,:A4,:G4,:A4,:E4,:F4,:A3,:D4,:E4,:F4,:E4,:F4,:D4,:G4,:A3,:B3,:D4,:G4,:F4,:G4,:D4,:E4,:A3,:Cs4,:D4,:E4,:A3,:Cs4,:E4,:F4,:E4,:D4,:E4,:F4,:E4,:F4,:G4,:A4,:D4,:F4,:G4,:A4,:G4,:A4,:F4,:As4,:D4,:F4,:A4,:As4,:A4,:As4,:F4,:G4,:D4,:E4,:F4,:G4,:F4,:G4,:E4,:A4,:Cs4,:E4,:G4,:A4,:G4,:A4,:E4,:F4,:A3,:D4,:E4,:F4,:E4,:F4,:D4,:G4,:A3,:B3,:D4,:G4,:F4,:G4,:D4]
b1[0]=[0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25]
a1[1]=[:E4,:A3,:Cs4,:D4,:E4,:D4,:E4,:Cs4]
b1[1]=[0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25]
a1[2]=[:F4,:G3,:A3,:Cs4]
b1[2]=[0.25,0.25,0.25,0.25]
a1[3]=[:F4,:E4,:F4,:Cs4,:D4]
b1[3]=[0.25,0.25,0.25,0.25,2.0]
c1=[70,65,58,52]
in_thread do
for i in 0..a1.length-1
use_bpm c1[i]
#for j in 0..a1[i].length-1
#play a1[i][j],sustain: b1[i][j]*0.9,release: b1[i][j]
plarray(a1[i],b1[i],c1[i],"Grand Piano",1,0.9,1,0,0.3) #|notes,durations,my_bpm,offsetclass,vol=1,s=0.9,r=1,tp=0,pan=0|
#sleep b1[i][j]
#end
end
end
#end
#with_fx :gverb, room: 30,preamp: 0.5,premix: 0.5,mix: 0.5,damp: 0.6 do
a2=[]
b2=[]
a2[0]=[:E2,:E3,:E2,:E3,:E2,:E3,:E2,:E3,:E2,:E3,:E2,:E3,:E2,:E3,:E2,:E3,:E2,:E3,:E2,:E3,:E2,:E3,:E2,:E3,:E2,:E3,:E2,:E3,:E2,:E3,:E2,:E3,:E2,:E3,:G2,:G3,:D2,:D3,:F2,:F3,:C2,:C3,:B1,:B2,:E2,:E3,:E2,:E3,:E2,:E3,:E2,:E3,:E2,:E3,:E2,:E3,:E2,:E3,:E2,:E3,:G2,:G3,:G2,:G3,:G2,:G3,:G2,:G3,:G2,:G3,:G2,:G3,:G2,:G3,:G2,:G3,:G2,:G3,:G2,:G3,:G2,:G3,:G2,:G3,:G2,:G3,:G2,:G3,:G2,:G3,:G2,:G3,:B2,:B3,:B2,:B3,:B2,:B3,:B2,:B3,:B2,:B3,:B2,:B3,:B2,:B3,:B2,:B3,:r,:r,:A4,:B4,:r,:Fs4,:G4,:r,:G4,:A4,:r,:E4,:Fs4,:r,:Fs4,:G4,:r,:D4,:E4,:D2,:D2,:r,:D4,:F4,:A4,:r,:r,:D4,:G4,:Bf4,:r,:r,:C4,:E4,:G4,:r,:r,:C4,:F4,:A4,:r,:Bf3,:D4,:F4,:r,:G3,:D4,:E4,:r,:A3,:G3,:F3,:D2,:D3,:D2,:D3,:D2,:D3,:D2,:D3,:D2,:D3,:D2,:D3,:D2,:D3,:D2,:D3,:D2,:D3,:D2,:D3,:D2,:D3,:D2,:D3,:D2,:D3,:D2,:D3]
b2[0]=[1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.5,0.25,0.25,1.0,0.75,0.25,1.0,0.75,0.25,1.0,0.75,0.25,1.0,0.75,0.25,1.0,0.75,0.25,1.0,1.0,2.0,0.5,0.5,0.5,0.5,0.25,0.25,0.5,0.5,0.5,0.25,0.25,0.5,0.5,0.5,0.25,0.25,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0]
a2[1]=[:D2,:D3]
b2[1]=[1.0,1.0]
a2[2]=[:D2]
b2[2]=[1.0]
a2[3]=[:D3,[:D2,:A2,:D3,:F3]]
b2[3]=[1.0,2.0]
c2=[70,65,58,52]
in_thread do
for i in 0..a2.length-1
use_bpm c2[i]
#for j in 0..a2[i].length-1
#play a2[i][j],sustain: b2[i][j]*0.9,release: b2[i][j],amp:0.6
plarray(a2[i],b2[i],c2[i],"Grand Piano",1,0.9,1,0,-0.3) #|notes,durations,my_bpm,offsetclass,vol=1,s=0.9,r=1,tp=0,pan=0|
#sleep b2[i][j]
#end
end
end

a3=[]
b3=[]
a3[0]=[:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:D2,:r,:D2,:r,:D2,:r,:D2,:r,:D2,:r,:D2,:r,:r,:r,:D2,:r,:r,:G2,:r,:r,:C3,:r,:F2,:r,:Bf2,:r,:E2,:r,:A2,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r]
b3[0]=[4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,2.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,2.0,1.0,0.5,0.5,1.0,0.5,0.5,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0]
a3[1]=[:r]
b3[1]=[4.0]
c3=[70,58]
in_thread do
for i in 0..a3.length-1
use_bpm c3[i]
#for j in 0..a3[i].length-1
#play a3[i][j],sustain: b3[i][j]*0.9,release: b3[i][j],amp: 0.6
plarray(a3[i],b3[i],c3[i],"Grand Piano",1,0.9,1,0,-0.4) #|notes,durations,my_bpm,offsetclass,vol=1,s=0.9,r=1,tp=0,pan=0|
#sleep b3[i][j]
#end
end
end

end #reverb
