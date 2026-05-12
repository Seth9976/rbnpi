#Gabrieli Sonata XIII sample version
#converted to Sonic Pi format viam MusicXML from MuseScore by James Kelly
#voiced for appropriate brass instruments using Sonatina Symphonic Orchestra
#by Robin Newman, October 2016
#The Sonatina Symphinic Orchestra download folder is unzipped and placed on the Desktop
#of the machine playing the program, renamed to SSO (to keep pathnames short for Windows)
#The program needs to be executed using the run_file command in Sonic Pi 2.11beta or later
#eg run_file "path/to/program/GabrieliSonataXIII-samples-RF.rb"
use_debug false
#path to Sonatina samples folder (including trailing /)
path="~/Desktop/SSO/Samples/"


#create array of instrument details
# each entry: name,folder name,sample prefix,offsetclass type,lowest note, highest note
voices=[
        ["Tenor Trombone","Tenor Trombone","tenor_trombone-",1,:ds2,:b4],\
        ["Trumpet","Trumpet","trumpet-",1,:e3,:f6],\
        ["Tuba sus","Tuba","tuba-sus-",1,:e1,:d4],\
        ["Horn","Horn","horn-",1,:e2,:e5]]

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
  
  for i in (0..3) do #4 voives in total
      load(i)
    end
    killit = 1 #stop live_loop :t
    sleep 2
  end
  
  puts "The following voices from Sonatina Symphonic Library can be used:-"
  voices.each_with_index do |n,i|
    puts i.to_s,n[0]
  end
  puts
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

with_fx :reverb,room: 0.8 do

#p1 Eb trumpet
a1=[]
b1=[]
a1[0]=[:Fs4,:Fs4,:E4,:Fs4,:Gs4,:A4,:A4,:Gs4,:A4,:B4,:Cs5,:B4,:A4,:Gs4,:Fs4,:Gs4,:Fs4,:A4,:A4,:A4,:Gs4,:Cs5,:Cs5,:Cs5,:B4,:D5,:D5,:D5,:Cs5,:Fs5,:Es5,:Fs5,:Fs5,:Cs5,:A4,:B4,:Cs5,:B4,:Cs5,:B4,:A4,:Gs4,:A4,:Gs4,:Fs4,:Gs4,:A4,:B4,:Cs5,:A4,:B4,:Cs5,:r,:Cs5,:Cs5,:E5,:Cs5,:r,:r,:r,:r,:Fs4,:Es4,:Fs4,:A4,:Gs4,:Fs4,:Cs5,:Cs5,:Cs5,:Cs5,:E5,:E5,:E5,:E5,:Fs5,:Fs5,:Fs5,:Fs5,:Fs5,:Es5,:Fs5,:Fs5,:Cs5,:A4,:B4,:Cs5,:E5,:D5,:B4,:Cs5,:Cs5,:B4,:As4,:B4,:Gs4,:Gs4,:As4,:r,:r,:r,:r,:Cs5,:Cs5,:Cs5,:Cs5,:E5,:E5,:E5,:E5,:Fs5,:Fs5,:Fs5,:Fs5,:Fs5,:Es5,:Fs5,:Fs5,:Cs5,:A4,:Gs4,:Fs4,:Gs4,:A4,:Cs5,:B4,:A4,:E5,:D5,:Cs5,:B4,:D5,:Cs5,:B4,:A4,:Cs5,:B4,:A4,:Gs4,:B4,:A4,:Gs4,:Fs4,:Es4,:Fs4,:A4,:Gs4,:Fs4,:r,:Cs5,:C5,:Cs5,:E5,:Ds5,:Cs5,:r,:Cs5,:Cs5,:B4,:A4,:A4,:Gs4,:Gs4,:Fs4,:r,:Fs5,:Fs5,:E5,:D5,:D5,:Cs5,:Cs5,:B4,:r,:Fs4,:Es4,:Fs4,:A4,:Gs4,:Fs4,:Cs5,:Cs5,:Cs5,:Cs5,:E5,:E5,:E5,:E5,:Fs5,:Fs5,:Fs5,:Fs5,:Fs5,:Es5,:Fs5,:Fs5,:Fs5,:r,:Fs5,:Fs5,:Fs5,:Fs5,:Fs5,:E5,:r,:Fs5,:Fs5,:Fs5,:Fs5,:Fs5,:E5,:A4,:B4,:Cs5,:r,:Cs5,:Ds5,:E5,:r,:E4,:Fs4,:Gs4,:r,:Gs4,:As4,:B4,:r,:B4,:Cs5,:Ds5,:r,:Ds5,:Es5,:Fs5,:Fs5,:Es5,:Cs5,:Ds5,:Es5,:Ds5,:B4,:Cs5,:Ds5,:Cs5,:As4,:B4,:Cs5,:B4,:Gs4,:As4,:B4,:As4,:Fs4,:Gs4,:As4,:B4,:As4,:Gs4,:As4,:B4,:r,:Fs4,:Gs4,:As4,:B4,:Cs5,:Ds5,:E5,:Fs5,:r]
b1[0]=[1.0,0.5,0.5,1.0,1.0,1.0,0.5,0.5,1.0,1.0,3.0,0.5,0.5,1.0,1.0,2.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.5,0.5,3.0,1.0,1.0,1.0,1.5,0.5,0.5,0.5,1.5,0.5,0.5,0.5,1.5,0.5,0.5,0.5,0.5,0.5,2.0,2.0,1.0,1.0,1.0,1.0,2.0,1.0,3.0,3.0,3.0,1.5,0.5,1.0,1.0,2.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.5,0.5,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,2.0,1.0,3.0,1.0,1.0,1.0,3.0,3.0,3.0,3.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.5,0.5,3.0,1.0,1.0,1.0,1.5,0.5,1.0,1.0,2.0,1.5,0.5,0.5,0.5,1.5,0.5,0.5,0.5,1.5,0.5,0.5,0.5,1.5,0.5,0.5,0.5,1.5,0.5,1.0,1.0,2.0,3.0,3.0,1.5,0.5,1.0,1.0,2.0,3.0,3.0,1.0,1.0,1.0,1.5,0.5,0.5,0.5,2.0,1.0,1.0,1.0,1.0,1.5,0.5,0.5,0.5,3.0,3.0,1.5,0.5,1.0,1.0,2.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.5,0.5,3.0,4.0,4.0,2.0,1.0,1.0,2.0,2.0,4.0,4.0,2.0,1.0,1.0,2.0,2.0,1.0,0.5,0.5,2.0,1.0,0.5,0.5,2.0,1.0,0.5,0.5,2.0,1.0,0.5,0.5,2.0,1.0,0.5,0.5,2.0,1.0,0.5,0.5,2.0,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,1.0,2.0,0.5,0.5,2.0,4.0,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,2.0,2.0]
a1[1]=[:Fs5,:Fs5,:Fs5,:Fs5,:G5,:Fs5,:E5,:Fs5,:E5,:Fs5,:G5,:Fs5,:E5,:Fs5,:E5,:B4,:As4,:B4,:Cs5,:B4,:Cs5,:D5,:Cs5,:D5,:E5,:D5,:E5,:D5,:Cs5,:D5,:E5,:D5,:E5,:D5,:Cs5,:D5,:Fs5,:D5,:E5,:D5,:E5,:Fs5,[:Fs5,:Bf5]]
b1[1]=[2.0,1.0,1.0,0.5,0.25,0.25,0.5,0.25,0.25,0.5,0.25,0.25,0.5,0.25,0.25,0.5,0.25,0.25,0.5,0.25,0.25,0.5,0.25,0.25,0.5,0.25,0.25,0.5,0.25,0.25,0.5,0.25,0.25,0.5,0.25,0.25,0.5,0.25,0.25,1.5,0.5,2.0,4.0]
c1=[180,100]
in_thread do
for i in 0..a1.length-1
use_bpm c1[i]
#plarray do |notes,durations,offsetclass,tp=0,pan=0,vol=1,s=0.9,r=0.1|
plarray(a1[i],b1[i],"Trumpet",3,0.8,0.8)
end
end

#p2 Bb trumpet
a2=[]
b2=[]
a2[0]=[:r,:r,:Fs4,:Fs4,:E4,:Fs4,:Gs4,:As4,:B4,:As4,:B4,:Fs4,:Fs4,:Fs4,:Fs4,:A4,:A4,:A4,:A4,:B4,:B4,:B4,:B4,:E5,:Fs5,:Fs5,:B4,:B4,:Cs5,:D5,:A4,:B4,:Fs4,:G4,:A4,:B4,:G4,:A4,:G4,:Fs4,:r,:D5,:D5,:Cs5,:D5,:r,:r,:r,:r,:Fs4,:Fs4,:Fs4,:Ds4,:Fs4,:B4,:Fs4,:Fs4,:A4,:D5,:A4,:A4,:B4,:E5,:B4,:B4,:E5,:Fs5,:Fs5,:B4,:B4,:B4,:As4,:D5,:D5,:Cs5,:D5,:D5,:Cs5,:B4,:B4,:B4,:As4,:B4,:r,:r,:r,:r,:Fs4,:B4,:Fs4,:Fs4,:A4,:D5,:A4,:A4,:B4,:E5,:B4,:B4,:B4,:Fs5,:Cs5,:Ds5,:B4,:B4,:Fs4,:G4,:A4,:B4,:D5,:Cs5,:D5,:A4,:A4,:A4,:B4,:Gs4,:A4,:Fs4,:G4,:Fs4,:Fs4,:Fs4,:r,:B4,:Cs5,:Cs5,:As4,:r,:Cs5,:Cs5,:Cs5,:A4,:A4,:A4,:A4,:Fs4,:r,:D5,:D5,:D5,:B4,:E5,:D5,:D5,:E5,:E4,:r,:Ds4,:Fs4,:Fs4,:Fs4,:B4,:B4,:B4,:As4,:D5,:D5,:D5,:Cs5,:E5,:E5,:E5,:D5,:B4,:Cs5,:B4,:B4,:r,:D5,:D5,:D5,:D5,:D5,:D5,:r,:D5,:D5,:D5,:D5,:D5,:D5,:A4,:A4,:A4,:A4,:B4,:B4,:B4,:B4,:B4,:B4,:B4,:r,:B4,:B4,:r]
b2[0]=[4.0,4.0,1.0,0.5,0.5,1.0,1.0,1.0,2.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,2.0,3.0,1.0,1.0,1.0,2.0,1.0,2.0,1.0,1.5,0.5,0.5,0.5,1.0,2.0,2.0,1.0,1.0,1.0,1.0,2.0,1.0,3.0,3.0,3.0,3.0,1.0,2.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,2.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,2.0,1.0,3.0,1.0,1.0,1.0,3.0,3.0,3.0,3.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,1.5,0.5,1.0,2.0,1.0,2.0,1.0,2.0,1.0,2.0,1.0,2.0,1.0,3.0,1.0,2.0,3.0,3.0,3.0,1.0,2.0,3.0,3.0,1.0,1.0,1.0,1.5,0.5,0.5,0.5,2.0,1.0,1.0,1.0,1.0,1.5,0.5,0.5,0.5,1.0,2.0,3.0,3.0,1.0,2.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,2.0,3.0,4.0,4.0,2.0,1.0,1.0,2.0,2.0,4.0,4.0,2.0,1.0,1.0,2.0,2.0,2.0,2.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,2.0,2.0,2.0,2.0]
a2[1]=[:E5,:E5,:E5,:E5,:E5,:E5,:B4,:Ds5]
b2[1]=[2.0,1.0,1.0,4.0,4.0,6.0,2.0,4.0]
c2=[180,100]
in_thread do
use_transpose -2
for i in 0..a2.length-1
use_bpm c2[i]
plarray(a2[i],b2[i],"Trumpet",-2,0.8,0.8)
end
end

#p3 Bb trumpet
a3=[]
b3=[]
a3[0]=[:r,:r,:r,:r,:r,:B4,:B4,:B4,:As4,:D5,:D5,:D5,:Cs5,:E5,:E5,:E5,:D5,:B4,:Cs5,:B4,:r,:r,:r,:r,:r,:Fs5,:Fs5,:A5,:Fs5,:r,:Fs5,:G5,:A5,:D5,:E5,:Fs5,:B4,:As4,:B4,:D5,:Cs5,:B4,:r,:r,:Fs5,:Fs5,:Fs5,:Fs5,:A5,:A5,:A5,:A5,:B5,:B5,:B5,:B5,:B5,:As5,:B5,:B5,:r,:r,:r,:r,:r,:r,:r,:r,:Fs5,:E5,:Ds5,:E5,:Cs5,:Cs5,:Ds5,:Fs5,:Fs5,:Fs5,:Fs5,:A5,:A5,:A5,:A5,:B5,:B5,:B5,:B5,:B5,:As5,:B5,:B5,:r,:r,:r,:r,:r,:r,:r,:r,:r,:B4,:As4,:B4,:D5,:Cs5,:B4,:r,:Fs5,:F5,:Fs5,:A5,:Gs5,:Fs5,:r,:B5,:B5,:A5,:G5,:G5,:Fs5,:Fs5,:E5,:r,:B4,:As4,:B4,:D5,:Cs5,:B4,:r,:r,:D5,:D5,:D5,:Cs5,:Fs5,:Fs5,:Fs5,:E5,:G5,:G5,:G5,:Fs5,:E5,:Fs5,:Fs5,:Fs5,:r,:G5,:G5,:G5,:G5,:G5,:Fs5,:r,:G5,:G5,:G5,:G5,:G5,:Fs5,:r,:D5,:E5,:Fs5,:r,:Fs5,:Gs5,:A5,:r,:A4,:B4,:Cs5,:r,:Cs5,:Ds5,:E5,:r,:E5,:Fs5,:Gs5,:r,:Gs5,:As5,:B5,:r,:B5,:As5,:Fs5,:Gs5,:As5,:Gs5,:E5,:Fs5,:Gs5,:Fs5,:Ds5,:E5,:Fs5,:G5,:Fs5,:E5,:B4,:Cs5,:Ds5,:E5,:Fs5,:Gs5,:A5,:B5,:r,:r]
b3[0]=[4.0,4.0,4.0,4.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,2.0,3.0,3.0,3.0,3.0,3.0,3.0,1.0,1.0,1.0,2.0,1.0,1.5,0.5,1.0,1.5,0.5,1.0,1.5,0.5,1.0,1.0,2.0,3.0,3.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.5,0.5,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,2.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.5,0.5,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,1.5,0.5,1.0,1.0,2.0,3.0,3.0,1.5,0.5,1.0,1.0,2.0,3.0,3.0,1.0,1.0,1.0,1.5,0.5,0.5,0.5,2.0,1.0,1.5,0.5,1.0,1.0,2.0,3.0,3.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,2.0,3.0,4.0,4.0,2.0,1.0,1.0,2.0,2.0,4.0,4.0,2.0,1.0,1.0,2.0,2.0,2.0,1.0,0.5,0.5,2.0,1.0,0.5,0.5,2.0,1.0,0.5,0.5,2.0,1.0,0.5,0.5,2.0,1.0,0.5,0.5,2.0,1.0,0.5,0.5,2.0,2.0,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,1.0,1.0,4.0,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,2.0,2.0,4.0]
a3[1]=[:G5,:G5,:G5,:G5,:G5,:A5,:G5,:Fs5,:G5,:Fs5,:G5,:A5,:G5,:Fs5,:G5,:Fs5,:E5,:Ds5,:E5,:Fs5,:E5,:Fs5,:B5,:G5,:B5,:E5,:Fs5,:Fs5]
b3[1]=[2.0,1.0,1.0,2.0,0.5,0.25,0.25,0.5,0.25,0.25,0.5,0.25,0.25,0.5,0.25,0.25,0.5,0.25,0.25,0.5,0.25,0.25,3.0,1.0,1.0,1.0,2.0,4.0]
c3=[180,100]
in_thread do
for i in 0..a3.length-1
use_bpm c3[i]
plarray(a3[i],b3[i],"Trumpet",-2,-0.6,0.8)
end
end

#p4 Bb trumpet
a4=[]
b4=[]
a4[0]=[:r,:r,:r,:r,:r,:Fs4,:B4,:Fs4,:Fs4,:A4,:D5,:A4,:A4,:B4,:E5,:B4,:B4,:B4,:Fs5,:Cs5,:Ds5,:r,:r,:r,:r,:r,:D5,:D5,:Cs5,:D5,:r,:D5,:D5,:A4,:B4,:B4,:Fs4,:G4,:E4,:Fs4,:Ds4,:r,:r,:B4,:B4,:B4,:As4,:D5,:D5,:D5,:Cs5,:E5,:E5,:E5,:D5,:B4,:Cs5,:Ds5,:r,:r,:r,:r,:r,:r,:r,:r,:D5,:Cs5,:B4,:B4,:B4,:As4,:B4,:Fs4,:Fs4,:Fs4,:As4,:Fs4,:A4,:A4,:Cs5,:G4,:B4,:B4,:D5,:E5,:Fs5,:Fs5,:r,:r,:r,:r,:r,:r,:r,:r,:r,:Fs4,:Fs4,:Fs4,:Fs4,:r,:Cs5,:Cs5,:Cs5,:As4,:r,:r,:D5,:D5,:Cs5,:B4,:G4,:A4,:Fs4,:B4,:r,:E4,:Fs4,:Fs4,:Fs4,:r,:r,:Fs4,:B4,:Fs4,:Fs4,:A4,:D5,:A4,:A4,:B4,:E5,:B4,:B4,:B4,:Fs5,:Cs5,:Ds5,:Ds5,:r,:B4,:B4,:B4,:D5,:B4,:Fs4,:r,:B4,:B4,:B4,:D5,:B4,:Fs4,:r,:A4,:A4,:A4,:B4,:B4,:B4,:B4,:B4,:B4,:B4,:B4,:B4,:r,:r]
b4[0]=[4.0,4.0,4.0,4.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,3.0,3.0,3.0,3.0,3.0,1.0,1.0,1.0,2.0,1.0,1.5,0.5,1.0,1.5,0.5,1.0,2.0,1.0,3.0,3.0,3.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,2.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,2.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,2.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,1.0,2.0,3.0,3.0,3.0,1.0,2.0,2.0,1.0,3.0,1.0,1.0,1.0,1.5,0.5,0.5,0.5,2.0,1.0,3.0,1.0,2.0,3.0,3.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,4.0,4.0,2.0,1.0,1.0,2.0,2.0,4.0,4.0,2.0,1.0,1.0,2.0,2.0,2.0,2.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,2.0,2.0,2.0,2.0,4.0]
a4[1]=[:B4,:B4,:B4,:B4,:B4,:E4,:E5,:B4,:B4,:B4]
b4[1]=[2.0,1.0,1.0,4.0,2.0,2.0,2.0,2.0,4.0,4.0]
c4=[180,100]
in_thread do
for i in 0..a4.length-1
use_bpm c4[i]
plarray(a4[i],b4[i],"Trumpet",-2,-0.6,0.8)
end
end

#p5 F horn
a5=[]
b5=[]
a5[0]=[:r,:r,:r,:r,:r,:G4,:G4,:E4,:Fs4,:G4,:B4,:G4,:A4,:A4,:C5,:A4,:B4,:A4,:Fs4,:B4,:B4,:B4,:B4,:D5,:D5,:B4,:B4,:G4,:G4,:G4,:G4,:Fs4,:G4,:r,:B4,:G4,:A4,:B4,:r,:r,:r,:r,:Gs4,:Fs4,:E4,:E4,:Ds4,:E4,:E4,:G4,:E4,:Fs4,:G4,:B4,:G4,:A4,:A4,:C5,:A4,:B4,:E4,:B4,:B4,:B4,:B4,:E4,:Fs4,:B4,:A4,:A4,:G4,:D5,:D5,:B4,:C5,:B4,:B4,:B4,:r,:r,:r,:r,:E4,:E4,:G4,:B4,:G4,:G4,:B4,:D5,:A4,:A4,:C5,:E5,:A4,:A4,:B4,:B4,:B4,:B4,:Fs4,:G4,:D5,:C5,:A4,:B4,:G4,:A4,:A4,:B4,:E5,:A4,:D5,:G4,:Fs4,:E4,:E4,:Ds4,:E4,:r,:Gs4,:B4,:Bf4,:B4,:r,:B4,:B4,:D5,:B4,:B4,:A4,:A4,:G4,:r,:G4,:G4,:G4,:C5,:E5,:E5,:B4,:Cs5,:r,:B4,:E4,:Ds4,:E4,:G4,:B4,:B4,:B4,:B4,:D5,:D5,:D5,:C5,:E5,:E5,:E5,:E5,:B4,:B4,:B4,:r,:E5,:E5,:E5,:E5,:C5,:D5,:r,:E5,:E5,:E5,:E5,:C5,:D5,:G4,:G4,:A4,:A4,:A4,:A4,:B4,:A4,:Gs4,:Fs4,:E4,:B4,:Cs5,:r,:A4,:A4,:r]
b5[0]=[4.0,4.0,4.0,4.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.5,0.5,3.0,1.0,1.0,1.0,2.0,1.0,2.0,1.0,2.0,1.0,2.0,1.0,2.0,1.0,1.0,1.0,1.0,2.0,1.0,3.0,3.0,3.0,1.5,0.5,1.0,2.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,2.0,1.0,3.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,2.0,1.0,3.0,1.0,1.0,1.0,3.0,3.0,3.0,3.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,2.0,1.0,2.0,1.0,2.0,1.0,2.0,1.0,1.5,0.5,1.0,2.0,1.0,3.0,3.0,3.0,2.0,1.0,3.0,3.0,1.0,1.0,1.0,1.5,0.5,0.5,0.5,2.0,1.0,1.0,1.0,1.0,1.5,0.5,0.5,0.5,3.0,3.0,3.0,2.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,2.0,3.0,4.0,4.0,2.0,1.0,1.0,2.0,2.0,4.0,4.0,2.0,1.0,1.0,2.0,2.0,2.0,2.0,4.0,4.0,4.0,4.0,4.0,2.0,2.0,2.0,2.0,4.0,4.0,4.0,2.0,2.0,2.0,2.0]
a5[1]=[:C5,:C5,:C5,:E4,:E5,:E5,:D5,:C5,:B4,:A4,:Gs4]
b5[1]=[2.0,1.0,1.0,4.0,4.0,3.0,1.0,2.0,1.0,1.0,4.0]
c5=[180,100]
in_thread do
use_transpose -7
for i in 0..a5.length-1
use_bpm c5[i]
plarray(a5[i],b5[i],"Horn",-7,0,0.4)
end
end

#p6 Trombone
a6=[]
b6=[]
a6[0]=[:r,:A3,:A3,:G3,:A3,:B3,:C4,:C4,:B3,:C4,:D4,:E4,:E3,:r,:A3,:A3,:C4,:E4,:C4,:C4,:E4,:G4,:D4,:D4,:F4,:E4,:A4,:E4,:E4,:r,:r,:r,:r,:r,:E4,:C4,:D4,:E4,:r,:G4,:G4,:D4,:E4,:E4,:B3,:C4,:B3,:A3,:A3,:Gs3,:A3,:r,:r,:C4,:E4,:E4,:E4,:E4,:G4,:G4,:G4,:F4,:A4,:A4,:A4,:A4,:E4,:E4,:r,:r,:r,:r,:r,:r,:r,:r,:G4,:G4,:E4,:F4,:E4,:E4,:E4,:C4,:C4,:A3,:B3,:C4,:E4,:C4,:D4,:D4,:F4,:D4,:E4,:D4,:B3,:E4,:E4,:r,:r,:r,:r,:r,:r,:r,:r,:r,:Cs4,:D4,:E4,:A3,:Gs3,:A3,:r,:E4,:E4,:Ef4,:E4,:r,:r,:E4,:E4,:E4,:C4,:C4,:C4,:C4,:A3,:r,:A3,:A3,:Gs3,:A3,:r,:r,:A3,:C4,:A3,:B3,:C4,:E4,:C4,:D4,:D4,:F4,:D4,:E4,:D4,:B3,:E4,:E4,:E4,:r,:F4,:F4,:F4,:F4,:C4,:C4,:r,:F4,:F4,:F4,:F4,:C4,:C4,:r,:C4,:D4,:D4,:D4,:D4,:A3,:A3,:A3,:E4,:D4,:D4,:D4,:r,:r]
b6[0]=[4.0,1.0,0.5,0.5,1.0,1.0,1.0,0.5,0.5,1.0,1.0,2.0,2.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,2.0,3.0,3.0,3.0,3.0,3.0,3.0,1.0,1.0,1.0,2.0,1.0,1.5,0.5,1.0,1.5,0.5,1.0,1.5,0.5,1.0,2.0,1.0,3.0,3.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,2.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,2.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.5,0.5,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,1.5,0.5,1.0,2.0,1.0,3.0,3.0,3.0,2.0,1.0,2.0,1.0,3.0,1.0,1.0,1.0,1.5,0.5,0.5,0.5,2.0,1.0,3.0,2.0,1.0,3.0,3.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.5,0.5,3.0,4.0,4.0,2.0,1.0,1.0,2.0,2.0,4.0,4.0,2.0,1.0,1.0,2.0,2.0,2.0,2.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,2.0,2.0,2.0,2.0,4.0]
a6[1]=[:A3,:A3,:A3,:A3,:D4,:A3,:A3,:A3]
b6[1]=[2.0,1.0,1.0,4.0,4.0,4.0,4.0,4.0]
c6=[180,100]
in_thread do
for i in 0..a6.length-1
use_bpm c6[i]
plarray(a6[i],b6[i],"Tenor Trombone",0,-0.4,0.5)
end
end

#p7 Trombone
a7=[]
b7=[]
a7[0]=[:r,:r,:r,:r,:A3,:A3,:A3,:A3,:E3,:C4,:C4,:C4,:G3,:D4,:D4,:D4,:A3,:F3,:E3,:A3,:A3,:A3,:G3,:C4,:B3,:C4,:B3,:A3,:G3,:A3,:G3,:F3,:E3,:D3,:C3,:r,:C4,:C4,:G3,:C4,:r,:r,:r,:r,:A3,:A3,:E3,:A2,:A2,:A2,:A2,:E3,:C3,:C3,:C3,:G3,:D3,:D3,:D3,:A3,:F3,:E3,:A2,:A3,:A3,:E3,:E3,:C3,:F3,:G3,:C3,:C4,:G3,:A3,:D3,:E3,:E3,:A2,:r,:r,:r,:r,:A2,:A2,:A2,:E3,:C3,:C3,:C3,:G3,:D3,:D3,:D3,:A3,:D3,:D3,:D3,:A2,:A3,:A3,:G3,:F3,:E3,:F3,:G3,:C3,:C4,:B3,:B3,:A3,:A3,:G3,:G3,:F3,:A3,:E3,:A2,:r,:A3,:E3,:B3,:E3,:r,:E4,:E4,:B3,:C4,:C4,:G3,:G3,:A3,:r,:C4,:C4,:E3,:F3,:D3,:A3,:A3,:D3,:r,:A3,:A3,:E3,:A2,:A3,:A3,:A3,:E3,:C4,:C4,:C4,:G3,:D4,:D4,:D4,:A3,:F3,:E3,:A3,:A3,:r,:F3,:F3,:F3,:F3,:F3,:C4,:r,:F3,:F3,:F3,:F3,:F3,:C4,:C4,:C4,:G3,:G3,:D4,:D4,:A3,:A3,:A3,:A3,:D3,:r,:D3,:D3,:r]
b7[0]=[4.0,4.0,4.0,4.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,2.0,3.0,1.0,1.0,1.0,1.5,0.5,0.5,0.5,1.5,0.5,0.5,0.5,3.0,1.0,2.0,2.0,1.0,1.0,1.0,1.0,2.0,1.0,3.0,3.0,3.0,3.0,1.0,2.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,2.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,2.0,1.0,3.0,1.0,1.0,1.0,3.0,3.0,3.0,3.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,2.0,1.0,2.0,1.0,2.0,1.0,2.0,1.0,3.0,1.0,2.0,3.0,3.0,3.0,1.0,2.0,3.0,3.0,1.0,1.0,1.0,1.5,0.5,0.5,0.5,2.0,1.0,1.0,1.0,1.0,1.5,0.5,0.5,0.5,3.0,3.0,3.0,1.0,2.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,2.0,3.0,4.0,4.0,2.0,1.0,1.0,2.0,2.0,4.0,4.0,2.0,1.0,1.0,2.0,2.0,2.0,2.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,2.0,2.0,2.0,2.0]
a7[1]=[:D4,:D4,:D4,:D4,:D4,:D4,:D3,:E3]
b7[1]=[2.0,1.0,1.0,4.0,4.0,4.0,4.0,4.0]
c7=[180,100]
in_thread do
for i in 0..a7.length-1
use_bpm c7[i]
plarray(a7[i],b7[i],"Tenor Trombone",0,0.4,0.5)
end
end

#p8 Eb Tuba
a8=[]
b8=[]
a8[0]=[:r,:r,:r,:r,:r,:Fs3,:Fs3,:Fs3,:Cs4,:A3,:A3,:A3,:E4,:B3,:B3,:B3,:Fs4,:D4,:Cs4,:Fs3,:r,:r,:r,:r,:r,:A4,:A4,:E4,:A4,:r,:A4,:A4,:Gs4,:Fs4,:Fs4,:E4,:D4,:Fs4,:Cs4,:Fs3,:r,:r,:Fs4,:Fs4,:Fs4,:Cs4,:A4,:A4,:A4,:E4,:B4,:B4,:B4,:Fs4,:D4,:Cs4,:Fs4,:r,:r,:r,:r,:r,:r,:r,:r,:A4,:E4,:Fs4,:B3,:Cs4,:Cs4,:Fs3,:Fs4,:Fs4,:Fs4,:Cs4,:A4,:A4,:A4,:E4,:B4,:B4,:B4,:Fs4,:D4,:Cs4,:Fs4,:r,:r,:r,:r,:r,:r,:r,:r,:r,:Fs4,:Fs4,:Cs4,:Fs3,:r,:Cs4,:Cs4,:Gs4,:Cs4,:r,:r,:Fs4,:Fs4,:Cs4,:D4,:D4,:A3,:A3,:B3,:r,:B3,:Fs3,:Cs4,:Fs3,:r,:r,:Fs3,:Fs3,:Fs3,:Cs4,:A3,:A3,:A3,:E4,:B3,:B3,:B3,:Fs4,:D4,:Cs4,:Fs3,:Fs3,:r,:D4,:D4,:D4,:D4,:D4,:A3,:r,:D4,:D4,:D4,:D4,:D4,:A3,:r,:A3,:E4,:E4,:B3,:B3,:Fs4,:Fs3,:Fs3,:Fs3,:B3,:B3,:B3,:r,:r]
b8[0]=[4.0,4.0,4.0,4.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,2.0,3.0,3.0,3.0,3.0,3.0,3.0,1.0,1.0,1.0,2.0,1.0,1.5,0.5,1.0,1.5,0.5,1.0,3.0,1.0,2.0,3.0,3.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,2.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,2.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,2.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,1.0,2.0,3.0,3.0,3.0,1.0,2.0,2.0,1.0,3.0,1.0,1.0,1.0,1.5,0.5,0.5,0.5,2.0,1.0,3.0,1.0,2.0,3.0,3.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,3.0,1.0,2.0,3.0,4.0,4.0,2.0,1.0,1.0,2.0,2.0,4.0,4.0,2.0,1.0,1.0,2.0,2.0,2.0,2.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,4.0,2.0,2.0,2.0,2.0,4.0]
a8[1]=[:B3,:B3,:B3,:B3,:B3,:B3,:B3,:Fs3]
b8[1]=[2.0,1.0,1.0,4.0,4.0,4.0,4.0,4.0]
c8=[180,100]
in_thread do
for i in 0..a8.length-1
use_bpm c8[i]
plarray(a8[i],b8[i],"Tuba sus",-9,0,0.5)
end
end

end #reverb
