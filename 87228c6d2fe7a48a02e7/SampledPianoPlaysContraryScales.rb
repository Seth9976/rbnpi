#Setup of sample based Piano Voice for Sonic Pi. Resultant voice illustrated playing contrary scales
#written by Robin Newman, March 2015
#covers range :c1 up to :c8
#samples from Sonatina Symphonic Orchestra CCL licence

#set_sched_ahead_time! 4 #may need to uncomment on Mac if Garbage Collection casues breaks in play
#user adjustable variables======================
#use_sample_pack '/Users/rbn/Desktop/samples/GrandPiano' #select and adjust as necessary
use_sample_pack '/home/pi/samples/GrandPiano'
pianotype= "piano_p_" #comment out ONE of these two choices for piano or forte piano samples
#pianotype="piano_f_"
#end of user adjustable variables===============

load_flag=0 #used to allow time for samples to load
s=0 #scale factor for tempo setting set as a global variable

define :setbpm do |n| #sets value of scale factor s according to bpm
  s = (1.0 / 8) *(60.0/n.to_f)
end

define :ntosym do |n| #converts note number to symbol
  note=n % 12
  octave = n / 12 - 1
  lookup_notes = {0 =>:c, 1 =>:cs,2 =>:d,3 =>:ds,4 =>:e,5 =>:f,6 =>:fs,7 =>:g,8 =>:gs,9 =>:a,10 =>:as,11 =>:b}
  return (lookup_notes[note].to_s + octave.to_s).to_sym #return the required note symbol
end

#range :ds1 to :c8
if sample_loaded? (pianotype+"c8").intern then #check if loaded and adjust load_flag
  load_flag = 1
end

slist=[] #array to hold sample info
(note(:c1)..note(:c8)).step 3 do |i| #samples spaced 3 semitones apart
  load_sample (pianotype+ntosym(i).to_s).to_sym #load current sammple
end
if load_flag==0 then #if load required then sleep
  sleep 7 #may need to increase on older Pi models
end

uncomment do #built into 2.5dev For earler versions leave uncommented, otherwise comment
  define :pitch_ratio do |n|
    return 2**(n.to_f/12)
  end
end

define :pl do |n,d=0.2,pan=0,v=0.8| #play a note n for duratio n
  #work out offset to get sample to play
  offset=note(n)%3 #sample every third semitone
  if offset==2 then
    offset=-1 #final offset of note from correct sample will be -1, 0 or +1
  end
  sample (pianotype+ntosym(note(n)-offset).to_s).to_sym,rate: pitch_ratio(offset),sustain: 0.95*d,release: 0.05*d,pan: pan,amp: v,start: 0
end

define :tr do |nv,shift| # for transpose if required
  return ntosym(note(nv)+shift)
end

define :plarray do |nt,dur,shift=0,vol=0.6,pan=0| #play associated array of notes and durations
  nt.zip(dur).each do |n,d|
    if n != :r then
      #puts n
      pl(tr(n,shift),d*s,pan)
    end
    sleep d*s
  end
end
#relative note durations
dsq = 1
sq = 2
q = 4
qd = 6
c = 8
cd = 12
m = 16
md = 24
#dynamic settings
p=0.15
mp=0.2
mf=0.4
f=0.8
ff=1.6

define :ct do |ptr,lev,slid,slp| #used to set dynamic levels
  #parameters ptr to control,lev required amp,
  #slid slide time to get there,slp sleep time before next change.
  control ptr,amp: lev,amp_slide: slid*s #adjusted with *s for tempo
  sleep slp*s
end
#=============end of voice definition bits=============

define :contrary do |nt| #define 3 octave contrary scale function
  down=([q]*6+[c])*3 #down
  up=[c]+down #up durations 26*q total
    down[-1]=m #having set up, now adjust last duration in down. down duration is 26*q
  with_fx :level,amp: p do |x| #used to adjust dynamic level
    in_thread do #set up crescendo and decrescendo as scales play
      ct(x,ff,q*26,q*26) #cresc over 26 quavers duration to ff, wait 26 quavers before the next command
      ct(x,p,q*26,q*26) #decresc over 26 quavers duration to mp, wait 26 quavers before the next command
    end
    in_thread do
      plarray(scale(nt,:major,num_octaves: 3),up) #right hand 3 octaves up
      plarray(scale(nt,:major,num_octaves: 3).reverse[1..-1],down) # then 3 octaves down
    end
    plarray(scale(note(nt)-36,:major,num_octaves: 3).reverse,up) #left hand 3 octaves down
    plarray(scale(note(nt)-36,:major,num_octaves: 3)[1..-1],down) #then 3 octaves up
  end
end

#===========play the scales============
setbpm(200) #setpbm sets s scale factor for note durations
lasttime_flag=false
note(:c4).upto(note(:c5)) do |x| #do an octave range of contrary scales
  puts ntosym(x)
  contrary(x)
end