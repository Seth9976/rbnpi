#Le Messeger by Michel Legrand from the Film The Go Between 1971
#arranged for Sonic Pi 2.11 by Robin Newman, November 2016
#I transcribed the music by ear from a YouTube recording, utilising Audacity to play
#short loops whilst I sorted out the notes. I also used a low pass filter to make it
#easier to hear the left hand part notes. It was then converted to SP code via a
#MusicXML file and a script running under the app Processing. It took a couple of days
#but I think the end result is very effective.
#I am playing it with  a sample based grand piano from Sonatina Symphonic Library
#as the built in piano synth can't handle sustaining then long notes in the left hand.
#it should be played using the run_file command in Sonic Pi 2.11 as it is too long
#to play in a buffer
#The Sonatina Library should be donwloaded from http://sso.mattiaswestlund.net/ 
#unzipped and placed on the Desktop, renamed as SSO

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
#with_fx :reverb,room: 0.8 do
with_fx :gverb, room: 30,preamp: 0.5,premix: 0.5,mix: 0.5,damp: 0.6 do
a1=[]
b1=[]
a1[0]=[:r,:E4,:B4,:G4,:C5,:E4,:A4,:Fs4,:B4,:Ds4,:G4,:E4,:A4,:Cs4,:Fs4,:Ds4,:G4,:E4,:B4,:G4,:C5,:E4,:A4,:Fs4,:B4,:Ds4,:G4,:E4,:A4,:Cs4,:Fs4,:Ds4,:G4,:B3,:E4,:C4,:F4,:A3,:D4,:B3,:E4,:Gs3,:C4,:A3,:D4,:Fs3,:B3,:Gs3,:C4,:E3,:A3,:Fs3,:B3,:Ds3,:Fs3,:Ds3,[:B2,:E3,:Gs3],:r,:B4,:C5,:B4,:E5,:B4,:C5,:B4,:B5,:B4,:C5,:B4,:G5,:B4,:C5,:B4,:C6,:B4,:C5,:B4,:E5,:B4,:C5,:B4,:G5,:Fs5,:E5,:D5,:C5,:B4,:A4,:G4,:A4,:B4,:C5,:B4,:E5,:B4,:C5,:B4,:A5,:B4,:C5,:B4,:Fs5,:B4,:C5,:B4,:B5,:B4,:C5,:B4,:E5,:B4,:C5,:B4,:Fs5,:E5,:D5,:C5,:B4,:A4,:G4,:Fs4,:G4,:B4,:C5,:B4,:Ds5,:B4,:C5,:B4,:G5,:B4,:C5,:B4,:E5,:B4,:C5,:B4,:A5,:B4,:C5,:B4,:E5,:B4,:C5,:B4,:G5,:Fs5,:E5,:D5,:C5,:B4,:A4,:G4,:Fs4,:B4,:C5,:B4,:Cs5,:B4,:C5,:B4,:Fs5,:B4,:C5,:B4,:Ds5,:B4,:C5,:B4,:G5,:B4,:C5,:B4,:Fs5,:B4,:C5,:B4,:C6,:B4,:C5,:B4,:B5,:B4,:C5,:B4,:G4,:B4,:C5,:B4,:E5,:B4,:C5,:B4,:B5,:B4,:C5,:B4,:G5,:B4,:C5,:B4,:C6,:B4,:C5,:B4,:E5,:B4,:C5,:B4,:G5,:Fs5,:E5,:D5,:C5,:B4,:A4,:G4,:D5,:C5,:D5,:C5,:G5,:C5,:D5,:C5,:C6,:C5,:D5,:C5,:A5,:C5,:D5,:C5,:D6,:C5,:D5,:C5,:Fs5,:C5,:D5,:C5,:A5,:G5,:Fs5,:E5,:D5,:C5,:B4,:A4,:B4,:B4,:C5,:B4,:Fs5,:B4,:C5,:B4,:B5,:A5,:G5,:Fs5,:E5,:D5,:C5,:B4,:A4,:B4,:C5,:A4,:E5,:C5,:B4,:A4,:A5,:G5,:Fs5,:E5,:D5,:C5,:B4,:A4,:B4,:G4,:A4,:G4,:D5,:G4,:A4,:G4,:G5,:Fs5,:E5,:D5,:C5,:B4,:A4,:G4,:E4,:Fs4,:G4,:A4,:B4,:C5,:D5,:E5,:Fs5,:G5,:A5,:B5,:C6,:D6,:E6,:Fs6,:G6,:B5,:C6,:B5,:E6,:B5,:C6,:B5,:B6,:B5,:C6,:B5,:G6,:B5,:C6,:B5,:C7,:B5,:C6,:B5,:E6,:B5,:C6,:B5,:B6,:A6,:G6,:Fs6,:E6,:D6,:C6,:B5,:A5,:B5,:C6,:B5,:E6,:B5,:C6,:B5,:A6,:B5,:C6,:B5,:Fs6,:B5,:C6,:B5,:B6,:B5,:C6,:B5,:E6,:B5,:C6,:B5,:Fs6,:E6,:D6,:C6,:B5,:A5,:G5,:Fs5,:A5,:G5,:A5,:G5,:C6,:G5,:A5,:G5,:G6,:G5,:A5,:G5,:E6,:G5,:A5,:G5,:A6,:A5,:B5,:A5,:C6,:A5,:B5,:A5,:G6,:Fs6,:E6,:D6,:C6,:B5,:A5,:G5,:C6,:B5,:C6,:B5,:E6,:D6,:E6,:D6,:G6,:Fs6,:E6,:D6,:C6,:B5,:A5,:G5,:C6,:B5,:C6,:B5,:A5,:G5,:A5,:G5,:Fs5,:E5,:D5,:C5,:B4,:A4,:G4,:Fs4,:G4,:B4,:C5,:B4,:D5,:B4,:C5,:B4,:G5,:B4,:C5,:B4,:D5,:B4,:C5,:B4,:B5,:B4,:C5,:B4,:D5,:B4,:C5,:B4,:D6,:C6,:B5,:A5,:G5,:Fs5,:E5,:D5,:C5,:E5,:Fs5,:E5,:A5,:E5,:Fs5,:E5,:C6,:E5,:Fs5,:E5,:A5,:E5,:Fs5,:E5,:E6,:E5,:Fs5,:E5,:A5,:E5,:Fs5,:E5,:C6,:B5,:A5,:G5,:Fs5,:E5,:D5,:C5,:E5,:A5,:B5,:A5,:C6,:A5,:B5,:A5,:E6,:A5,:B5,:A5,:D6,:A5,:B5,:A5,:A6,:A5,:B5,:A5,:D6,:A5,:B5,:A5,:Fs6,:E6,:D6,:C6,:B5,:A5,:G5,:Fs5,:G5,:B5,:C6,:B5,:D6,:B5,:C6,:B5,:G6,:B5,:C6,:B5,:D6,:B5,:C6,:B5,:B6,:B5,:C6,:B5,:G6,:B5,:C6,:B5,:C7,:B5,:C6,:B5,:B6,:B5,:C6,:B5,:r,:B5,:C6,:B5,:E6,:B5,:C6,:B5,:G6,:Fs6,:E6,:D6,:C6,:B5,:A5,:G5,:r,:E5,:Fs5,:E5,:G5,:E5,:Fs5,:E5,:B5,:A5,:G5,:Fs5,:E5,:D5,:C5,:B4,:r,:B4,:Cs5,:B4,:E5,:B4,:Cs5,:B4,:G5,:Fs5,:E5,:D5,:Cs5,:B4,:A4,:G4,:Fs4,:E4,:D4,:Cs4,:D4,:E4,:Fs4,:Gs4,:As4,:B4,:Cs5,:D5,:E5,:Fs5,:Gs5,:As5,:B5,:Fs5,:G5,:Fs5,:B5,:Fs5,:G5,:Fs5,:Fs6,:Fs5,:G5,:Fs5,:D6,:Fs5,:G5,:Fs5,:G6,:Fs5,:G5,:Fs5,:B5,:Fs5,:G5,:Fs5,:D6,:Cs6,:B5,:A5,:G5,:Fs5,:E5,:D5,:E5,:Fs5,:G5,:Fs5,:B5,:Fs5,:G5,:Fs5,:E6,:Fs5,:G5,:Fs5,:Cs6,:Fs5,:G5,:Fs5,:Fs6,:Fs5,:G5,:Fs5,:B5,:Fs5,:G5,:Fs5,:Cs6,:B5,:A5,:G5,:Fs5,:E5,:D5,:Cs5,:D5,:Fs5,:G5,:Fs5,:Bf5,:Fs5,:G5,:Fs5,:D6,:Fs5,:G5,:Fs5,:B5,:Fs5,:G5,:Fs5,:E6,:E5,:F5,:E5,:Gs5,:E5,:F5,:E5,:B5,:A5,:Gs5,:Fs5,:E5,:D5,:C5,:B4,:D5,:C5,:D5,:C5,:G5,:C5,:D5,:C5,:C6,:C5,:D5,:C5,:A5,:C5,:D5,:C5,:D6,:C5,:D5,:C5,:Fs5,:C5,:D5,:C5,:A5,:G5,:Fs5,:E5,:D5,:C5,:B4,:A4,:B4,:B4,:C5,:B4,:Fs5,:B4,:C5,:B4,:B5,:B4,:C5,:B4,:G5,:B4,:C5,:B4,:C6,:C5,:D5,:C5,:E5,:C5,:D5,:C5,:G5,:Fs5,:E5,:D5,:C5,:B4,:A4,:G4]
b1[0]=[1.0-0.0625,0.0625,0.9375,0.0625,0.9375,0.0625,0.9375,0.0625,0.9375,0.0625,0.9375,0.0625,0.9375,0.0625,0.9375,0.0625,0.9375,0.0625,0.9375,0.0625,0.9375,0.0625,0.9375,0.0625,0.9375,0.0625,0.9375,0.0625,0.9375,0.0625,0.9375,0.0625,0.9375,0.0625,0.9375,0.0625,0.9375,0.0625,0.9375,0.0625,0.9375,0.0625,0.9375,0.0625,0.9375,0.0625,0.9375,0.0625,0.9375,0.0625,0.9375,0.0625,0.9375,0.0625,0.9375,0.0625,4 ,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125]
a1[1]=[:A4,:B4,:C5,:B4,:E5,:B4,:C5,:B4]
b1[1]=[0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125]
a1[2]=[:A5,:B4,:C5,:B4,:Fs5,:B4,:C5,:B4]
b1[2]=[0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125]
a1[3]=[:B5,:E4,:Fs4,:E4,:B4,:E4,:Fs4,:E4]
b1[3]=[0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125]
a1[4]=[:Ds4,:Fs3,:G3,:Fs3,:Ds4,:Fs3,:G3,:Fs3,:E3]
b1[4]=[0.125,0.125,0.125,0.125,0.125,0.125,0.125,0.125,4.0]
c1=[50,48,44,38,32]
in_thread do
for i in 0..a1.length-1
plarray(a1[i],b1[i],c1[i],"Grand Piano",1,0.9,1,0,0.3) #|notes,durations,my_bpm,offsetclass,vol=1,s=0.9,r=1,tp=0,pan=0|
end
end



a2=[]
b2=[]
a2[0]=[[:E2,:E3],[:E2,:E3],[:E2,:E3],[:E2,:E3],[:E2,:E3],[:E2,:E3],[:E2,:E3],[:E2,:E3],[:E1,:E2],[:B3,:E4,:G4],[:E1,:E2],[:B3,:E4,:G4],[:E1,:E2],[:A3,:C4,:E4,:Fs4],[:E1,:E2],[:A3,:B3,:Ds4,:Fs4],[:E1,:E2],[:B3,:E4,:G4],[:E1,:E2],[:B3,:E4,:G4],[:E1,:E2],[:A3,:C4,:E4,:Fs4],[:E1,:E2],[:A3,:C4,:E4,:Fs4],[:E1,:E2],[:B3,:E4,:G4],[:E1,:E2],[:B3,:E4,:G4],[:A1,:A2],[:A3,:C4,:E4],[:D1,:D2],[:Fs3,:A3,:D4],[:B1,:B2],[:G3,:B3,:D4],[:C2,:C3],[:G3,:C4,:E4],[:D2,:D3],[:G3,:B3],[:G3,:C4,:E4],[:D2,:D3],[:G1,:G2],[:B3,:E4,:G4],[:G1,:G2],[:B3,:E4,:G4],[:Fs1,:Fs2],[:B3,:E4,:Fs4],[:Fs1,:Fs2],[:Fs3,:D4,:Fs4],[:E1,:E2],[:E3,:G3,:C4],[:E1,:E2],[:A3,:C4,:E4],[:D1,:D2],[:G3,:B3,:D4],[:D1,:D2],[:Fs3,:A3,:C4],[:G1,:G2],[:D3,:G3,:B3],[:G1,:G2],[:B3,:D4,:G4],[:G1,:G2],[:A3,:C4,:E4],[:G1,:G2],[:A3,:C4,:E4],[:G1,:G2],[:C4,:D4,:Fs4],[:G1,:G2],[:C4,:D4,:Fs4],[:G1,:G2],[:B3,:D4,:G4],[:B3,:D4,:G4],[:B3,:D4,:G4],[:G1,:G2],[:B3,:E4,:G4],[:G1,:G2],[:B3,:E4,:G4],[:Fs1,:Fs2],[:As3,:Cs4,:Fs4],[:Fs1,:Fs2],[:Fs3,:As3,:Cs4],[:B1,:B2],[:B3,:D4,:Fs4],[:B1,:B2],[:B3,:D4,:Fs4],[:B1,:B2],[:Cs4,:E4,:Fs4],[:B1,:B2],[:Cs4,:E4,:G4],[:B1,:B2],[:Fs3,:B3,:D4],[:Gs1,:Gs2],[:B3,:E4,:Gs4],[:A1,:A2],[:A3,:C4,:E4],[:D1,:D2],[:Fs3,:A3,:D4],[:G1,:G2],[:B3,:D4,:Fs4],[:C1,:C2],[:G3,:C4,:E4]]
b2[0]=[4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0]
a2[1]=[[:Fs1,:Fs2]]
b2[1]=[1.0]
a2[2]=[[:A3,:C4,:E4]]
b2[2]=[1.0]
a2[3]=[[:B0,:B1]]
b2[3]=[1.0]
a2[4]=[[:B1,:B2],[:E1,:E2,:G2,:B2]]
b2[4]=[1.0,4.0]
c2=[50,48,44,38,32]
#in_thread do
for i in 0..a2.length-1
plarray(a2[i],b2[i],c2[i],"Grand Piano",1,0.9,1,0,-0.3) #|notes,durations,my_bpm,offsetclass,vol=1,s=0.9,r=1,tp=0,pan=0|
end
#end
end #reverb
cue :variation #start second file