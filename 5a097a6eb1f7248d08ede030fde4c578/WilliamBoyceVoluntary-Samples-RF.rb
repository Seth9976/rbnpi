#William_Boyce_Voluntary_in_D-Major-samples-RF.rb arranged by Robin Newman Sep 2016
#samples version using samples from Sonatina Symphonic Library
#This should be installed from http://sso.mattiaswestlund.net/
#I put my copy on the desktop
use_debug false
#path to library samples folder (including trailing /)
path="~/Desktop/Sonatina Symphonic Orchestra/Samples/"


#create array of instrument details
# each entry: name,folder name,sample prefix,offsetclass type,lowest note, highest note
voices=[
        ["Tenor Trombone","Tenor Trombone","tenor_trombone-",1,:ds2,:b4],\
        ["Trumpet","Trumpet","trumpet-",1,:e3,:f6],\
        ["Horn","Horn","horn-",1,:e2,:e5],\
        ['Timpani f rh','Percussion','timpani-f-rh-',0,:c1,:c2]]

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
  
  for i in (0..3) do
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
  
  
with_fx :reverb,room: 0.85 do
#use_synth :blade #not used in samples version
a1=[]
b1=[]
a1[0]=[:E4,:E4,:E4,:r,:A4,:B4,:Cs5,:D5,:Cs5,:r,:E5,:Fs5,:r,:Fs5,:E5,:D5,:Cs5,:B4,:A4,:E5,:D5,:r,:Cs5,:B4,:Cs5,:D5,:B4,:r,:r,:E5,:Fs5,:Gs5,:A5,:Fs5,:Gs5,:r,:A5,:Gs5,:Fs5,:E5,:Ds5,:r,:r,:r,:D5,:E5,:B4,:r,:A4,:Gs4,:A4,:Gs4,:E5,:E5,:r,:r,:B4,:Cs5,:Ds5,:E5,:E5,:E5,:r,:r,:Cs5,:B4,:r,:Cs5,:Ds5,:E5,:Ds5,:E5,:r,:r,:r,:r,:A4,:D5,:r,:r,:r,:r,:E5,:Fs5,:r,:Fs5,:E5,:D5,:Cs5,:B4,:A4,:E5,:D5,:r,:Cs5,:B4,:Cs5,:D5,:B4,:r,:r,:r,:B4,:B4,:B4,:r,:E5,:Fs5,:Gs5,:A5,:Gs5,:r,:r,:r,:r,:r,:r,:Cs5,:B4,:A4,:D5,:Cs5,:B4,:r,:r,:r,:r,:r,:r,:r,:Cs5,:B4,:Cs5,:B4,:r,:r,:r,:E5,:D5,:E5,:Cs5,:B4,:Cs5,:B4,:A4,:E5,:E5,:E5,:A5,:E5,:E5,:E5,:Cs5,:A4,:A4,:A4,:A4,:E4,:E4,:E4,:E4]
b1[0]=[1.0,1.0,1.0,0.5,0.5,0.5,0.5,1.0,1.0,0.5,0.5,1.0,0.5,0.5,0.25,0.25,0.25,0.25,0.5,0.5,0.5,0.0625,0.1875,0.25,0.5,0.5,1.0,1.0,2.0,0.5,0.25,0.25,0.5,0.5,0.5,0.0625,0.1875,0.25,0.5,0.5,1.0,1.0,2.0,0.5,0.5,1.0,0.5,0.0625,0.1875,0.25,1.0,1.0,1.0,1.0,1.0,0.5,0.5,0.5,0.5,1.0,1.0,1.0,1.0,1.0,1.0,1.0,0.5,0.25,0.25,1.0,1.0,1.0,1.0,4.0,4.0,0.5,0.5,1.0,2.0,2.0,1.0,0.5,0.5,1.0,0.5,0.5,0.25,0.25,0.25,0.25,0.5,0.5,0.5,0.0625,0.1875,0.25,0.5,0.5,1.0,1.0,4.0,4.0,1.0,1.0,1.0,0.5,0.5,0.5,0.5,1.0,1.0,1.0,4.0,4.0,2.0,1.0,0.5,0.5,0.5,0.5,0.5,0.5,1.0,1.0,4.0,4.0,4.0,2.0,1.0,0.5,0.5,1.0,1.0,1.0,1.0,2.0,1.0,2.0,1.5,0.5,0.5,0.5,1.0,1.0,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,2.0]
c1=[104]
in_thread do
for i in 0..a1.length-1
use_bpm c1[i]
plarray(a1[i],b1[i],"Trumpet",5,0.8,0.6) #notes,durations,transpose,pan,amplitude
#for j in 0..a1[i].length-1
#play a1[i][j]+5,sustain: b1[i][j]*0.9,release: b1[i][j]*0.1
#sleep b1[i][j]
#end
end
end

a2=[]
b2=[]
a2[0]=[:Fs4,:Fs4,:Fs4,:r,:r,:A4,:Cs5,:D5,:r,:r,:D5,:G5,:r,:r,:Fs5,:E5,:D5,:Cs5,:r,:E5,:A5,:A5,:A5,:r,:r,:E5,:E5,:A4,:B4,:Cs5,:D5,:Cs5,:B4,:Cs5,:r,:D5,:Cs5,:r,:B4,:A4,:B4,:A4,:r,:r,:A5,:A5,:r,:r,:E5,:Fs5,:D5,:E5,:E5,:E5,:r,:D5,:Cs5,:D5,:E5,:Cs5,:D5,:B4,:A4,:r,:A4,:A4,:A4,:r,:D5,:E5,:Fs5,:G5,:Fs5,:r,:A5,:B5,:r,:B5,:A5,:G5,:Fs5,:E5,:D5,:A5,:G5,:r,:Fs5,:E5,:Fs5,:G5,:E5,:r,:r,:D5,:G5,:r,:r,:D5,:D5,:D5,:r,:G5,:A5,:B5,:C6,:C6,:B5,:r,:r,:r,:E5,:E5,:r,:r,:r,:r,:r,:r,:A4,:B4,:Cs5,:D5,:Cs5,:r,:Fs5,:E5,:D5,:G5,:Fs5,:E5,:r,:r,:r,:r,:r,:r,:A4,:A4,:A4,:A4,:r,:r,:r,:r,:Cs5,:D5,:Cs5,:D5,:D5,:Cs5,:D5,:Fs5,:Fs5,:Fs5,:A5,:Fs5,:Fs5,:Fs5,:D5,:A4,:A4,:A4,:A4,:Fs4,:Fs4,:Fs4,:Fs4]
b2[0]=[1.0,1.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,0.5,0.5,1.0,1.0,0.5,0.5,1.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,1.0,2.0,1.0,0.5,0.5,0.5,0.5,0.5,0.25,0.25,1.0,0.5,0.5,0.5,0.0625,0.1875,0.25,1.0,1.0,1.0,1.0,1.0,1.0,1.0,0.5,0.5,0.5,0.5,1.0,1.0,0.5,0.0625,0.1875,0.25,1.5,0.5,0.5,0.5,2.0,1.0,1.0,1.0,1.0,1.0,0.5,0.5,0.5,0.5,1.0,1.0,0.5,0.5,1.0,0.5,0.5,0.25,0.25,0.25,0.25,0.5,0.5,0.5,0.0625,0.1875,0.25,0.5,0.5,1.0,1.0,0.5,0.5,1.0,2.0,4.0,1.0,1.0,1.0,0.5,0.5,0.5,0.5,0.875,0.125,1.0,1.0,4.0,1.0,1.0,1.0,1.0,4.0,4.0,2.0,1.0,0.5,0.5,1.0,0.5,0.5,1.0,0.5,0.5,0.5,0.5,0.5,0.5,1.0,1.0,4.0,4.0,2.0,1.0,0.5,0.5,1.0,1.0,1.0,1.0,2.0,1.0,0.5,0.5,2.0,1.0,1.0,1.0,1.0,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,2.0]
c2=[104]
in_thread do
for i in 0..a2.length-1
use_bpm c2[i]
plarray(a2[i],b2[i],"Trumpet",0,-0.8,0.6) #notes,durations,transpose,pan,amplitude
#for j in 0..a2[i].length-1
#play a2[i][j],sustain: b2[i][j]*0.9,release: b2[i][j]*0.1
#sleep b2[i][j]
#end
end
end

a3=[]
b3=[]
a3[0]=[:D4,:D4,:D4,:r,:r,:D4,:A3,:A3,:D4,:D4,:r,:D4,:r,:A3,:A3,:A3,:r,:E4,:Fs4,:E4,:D4,:Cs4,:D4,:Gs3,:A3,:A3,:B3,:A3,:G3,:r,:D4,:E4,:A3,:Gs3,:A3,:Cs4,:Fs4,:E4,:Fs4,:E4,:D4,:Cs4,:r,:A3,:A3,:A3,:Cs4,:D4,:B3,:A3,:A3,:Gs3,:r,:E3,:r,:D4,:Cs4,:r,:Fs3,:A3,:D4,:r,:A3,:A3,:A3,:A3,:D4,:A3,:B3,:r,:D4,:r,:A3,:A3,:A3,:Cs4,:D4,:B3,:r,:D4,:r,:A3,:A3,:A3,:Cs4,:D4,:r,:D3,:B3,:G3,:Fs3,:r,:r,:D4,:D4,:r,:r,:Gs3,:A3,:Fs3,:Gs3,:r,:r,:r,:Fs3,:G3,:A3,:D4,:Cs4,:B3,:A3,:G3,:A3,:Fs4,:E4,:Fs4,:E4,:D4,:r,:D4,:E4,:Fs4,:E4,:r,:A3,:B3,:Cs4,:D4,:Cs4,:Fs3,:G3,:A3,:D4,:r,:E4,:D4,:Cs4,:D4,:Cs4,:B3,:Cs4,:B3,:A3,:B3,:A3,:G3,:A3,:Fs4,:E4,:Fs4,:E4,:D4,:r,:r,:r,:r,:Fs3,:E3,:Fs3,:E3,:r,:A3,:Fs3,:A3,:Fs3,:A3,:E3,:Fs3,:r,:D4,:r,:A3,:r,:Fs3,:r,:D4]
b3[0]=[1.0,1.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,0.5,0.25,0.25,0.5,0.5,1.0,1.0,1.0,1.0,2.0,1.0,0.5,0.5,1.0,1.0,1.0,0.5,0.5,0.5,0.5,0.5,0.5,1.0,1.0,1.0,1.0,0.5,0.5,0.5,0.5,1.0,1.0,1.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,1.0,1.0,0.5,0.5,1.5,0.5,0.5,1.0,0.5,1.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,1.0,1.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,1.0,0.5,0.5,0.5,0.5,1.0,1.0,1.0,1.0,1.0,1.0,0.5,0.5,0.5,0.5,1.0,1.0,2.0,0.5,0.5,0.5,0.5,1.0,1.0,1.0,1.0,2.5,0.5,0.5,0.5,1.0,1.0,1.0,1.0,1.0,0.5,0.5,1.0,0.5,0.5,1.0,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.0625,0.1875,0.25,0.5,0.25,0.25,0.5,0.25,0.25,0.5,0.25,0.25,2.5,0.5,0.5,0.5,1.0,1.0,1.0,1.0,2.0,1.0,0.5,0.5,1.0,1.0,1.0,0.5,0.5,2.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,2.0]
c3=[104]
in_thread do
for i in 0..a3.length-1
use_bpm c3[i]
plarray(a3[i],b3[i],"Tenor Trombone",0,0.4,0.6) #notes,durations,transpose,pan,amplitude
#for j in 0..a3[i].length-1
#play a3[i][j],sustain: b3[i][j]*0.9,release: b3[i][j]*0.1
#sleep b3[i][j]
#end
end
end

a4=[]
b4=[]
a4[0]=[:D3,:Fs3,:A3,:Fs3,:G3,:Fs3,:E3,:D3,:Fs3,:G3,:r,:Fs3,:r,:E3,:D3,:A2,:Cs3,:D3,:B2,:Cs3,:A2,:D3,:B2,:Cs3,:r,:E3,:A3,:D3,:E3,:Cs3,:D3,:B3,:A3,:E3,:Fs3,:D3,:E3,:E2,:A2,:Fs3,:E3,:D3,:Cs3,:D3,:Cs3,:B2,:A2,:r,:r,:Cs3,:D3,:B2,:Cs3,:A2,:A3,:Gs3,:Fs3,:D3,:E3,:A3,:r,:E3,:A3,:G3,:Fs3,:E3,:D3,:Fs3,:A3,:Fs3,:G3,:Fs3,:E3,:D3,:Fs3,:G3,:r,:Fs3,:r,:E3,:D3,:A2,:Fs3,:G3,:r,:Fs3,:r,:E3,:D3,:A2,:G3,:Fs3,:E3,:Fs3,:r,:r,:D3,:B3,:C4,:B3,:A3,:G3,:F3,:E3,:r,:r,:E3,:Cs4,:D4,:Cs4,:B3,:A3,:r,:B3,:A3,:G3,:Fs3,:E3,:D3,:Cs3,:B2,:A2,:D3,:A3,:A2,:D3,:r,:D3,:G3,:Fs3,:E3,:D3,:A3,:r,:D3,:G3,:Fs3,:E3,:D3,:A3,:r,:B3,:r,:Cs4,:B3,:A3,:B3,:A3,:G3,:A3,:G3,:Fs3,:G3,:Fs3,:E3,:D3,:Cs3,:B2,:A2,:D3,:A3,:A2,:D3,:r,:D3,:A3,:D3,:A3,:r,:D3,:A2,:D3,:A2,:r,:A2,:B2,:A2,:D3,:A2,:A2,:D3,:r,:D3,:r,:D3,:r,:D2,:r,:D2]
b4[0]=[1.0,1.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,1.0,0.5,0.5,1.0,1.0,1.0,1.0,1.0,1.0,0.5,0.5,0.5,0.5,1.0,1.0,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,1.0,1.0,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,1.5,0.5,1.0,1.0,1.0,1.0,0.5,0.5,0.5,0.5,1.0,1.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,0.5,0.5,0.5,0.5,1.0,1.0,0.5,0.5,1.0,0.5,0.5,1.0,1.0,1.0,1.0,1.0,0.5,0.5,1.0,0.5,0.5,1.0,1.0,1.0,1.0,1.0,1.0,1.0,0.5,0.5,0.5,0.5,1.0,1.0,1.0,1.0,1.0,0.5,0.5,0.5,0.5,0.5,0.5,1.0,0.5,0.5,0.5,0.5,0.5,0.5,1.0,1.0,0.5,0.0625,0.1875,0.25,0.5,0.25,0.25,0.5,0.25,0.25,0.5,0.25,0.25,0.5,0.5,0.5,0.5,1.0,1.0,1.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,0.5,0.5,2.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,2.0]
c4=[104]
in_thread do
for i in 0..a4.length-1
use_bpm c4[i]
plarray(a4[i],b4[i],"Tenor Trombone",0,-0.4,0.6) #notes,durations,transpose,pan,amplitude
#for j in 0..a4[i].length-1
#play a4[i][j],sustain: b4[i][j]*0.9,release: b4[i][j]*0.1
#sleep b4[i][j]
#end
end
end

a5=[]
b5=[]
a5[0]=[:D3,:D3,:D3,:r,:D3,:A2,:r,:D3,:r,:r,:r,:A2,:A2,:A2,:r,:A2,:D3,:r,:r,:r,:A2,:r,:A2,:r,:A2,:r,:A2,:A2,:A2,:r,:r,:r,:D3,:D3,:D3,:r,:D3,:A2,:r,:D3,:r,:r,:r,:D3,:A2,:r,:r,:r,:D3,:D3,:D3,:r,:r,:r,:r,:D3,:A2,:r,:A2,:D3,:r,:A2,:D3,:r,:r,:A2,:D3,:A2,:A2,:D3,:r,:r,:r,:r,:r,:A2,:D3,:D3,:A2,:D3,:A2,:r,:A2,:D3,:A2,:A2,:D3,:r,:D3,:A2,:D3,:A2,:r,:D3,:A2,:D3,:A2,:r,:r,:r,:D3,:A2,:A2,:D3,:r,:D3,:r,:D3,:A2,:D3,:r,:D3]
b5[0]=[1.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,1.0,4.0,4.0,1.0,1.0,1.0,1.0,1.0,1.0,2.0,4.0,2.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,4.0,4.0,1.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,1.0,4.0,1.0,1.0,1.0,1.0,4.0,4.0,1.0,1.0,1.0,1.0,4.0,4.0,1.0,1.0,1.0,0.5,0.5,1.0,0.5,0.5,1.0,1.0,2.0,1.0,1.0,1.0,1.0,1.0,1.0,4.0,2.0,1.0,0.5,0.5,0.5,0.5,1.0,1.0,1.0,2.0,1.0,1.0,1.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,1.0,2.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,2.0]
c5=[104]
in_thread do
for i in 0..a5.length-1
use_bpm c5[i]
plarray(a5[i],b5[i],"Timpani f rh",-12,0,0.6) #notes,durations,transpose,pan,amplitude
#for j in 0..a5[i].length-1
#play a5[i][j],sustain: b5[i][j]*0.9,release: b5[i][j]*0.1
#sleep b5[i][j]
#end
end
end

end #reverb