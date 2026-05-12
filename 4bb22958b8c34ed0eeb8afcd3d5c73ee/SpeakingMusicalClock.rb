#Sonic Pi playing and speaking clock by Robin Newman version 0.8
#requires samples saying zero,1-20,30,40 and 50 saved in that order in a folder
#uses Ruby Time.now function to get time info. This is split up by functions
#hours, mins and secs to give three integer values (24 hour clock)
use_debug false
use_sched_ahead_time 0 #important no delays for a clock!
#adjust next four lines to select options
set :enabletenths,true
set :enablesecs,true
set :enablespeech,true
set :enablechimes,true

path ="~/Desktop/count2" #path to samples
load_samples path
load_sample :ambi_glass_rub

use_synth :saw #synth to play notes
#first section defines data for quarter,half,three quarters and hour chimes
quarter= [:a3,:g3,:f3,:c3]
k=0.629 #intetchime gap (from Westminster Clock)
qd=[k]*4 #durations for quarter chimes
rv=[0.822] #gap between groups of four chimes
half=[:f3,:a3,:g3,:c3,  :r,  :c3,:g3,:a3,:f3]
hd=[k]*4+ rv +[k]*4 #durations for half chimes
hrv=5 #gap between hour chimes and first "bong" for the hour
threequarters=[:a3,:f3,:g3,:c3,  :r,  :c3,:g3,:a3,:f3,  :r,  :a3,:g3,:f3,:c3]
tqd=[k]*4+rv+[k]*4+rv+[k]*4 #durations for threequarter chimes
hour=[:f3,:a3,:g3,:c3,  :r,  :f3,:g3,:a3,:f3,  :r,  :a3,:f3,:g3,:c3,  :r,  :c3,:g3,:a3,:f3]
hd=[k]*4+rv+[k]*4+rv+[k]*4+rv+[k]*4 #durations for hour chimes
anticipate=16*k+3*rv[0]+hrv #start hour chimes this time BEFORE the hour
anticipateInt=anticipate.to_int #int part of anticipate
anticipateFrac=anticipate-anticipateInt #fractional part of anticipate
#puts anticipateInt, anticipateFrac
bong=:c3 #pitch for "bongs"  also an octave higher

define :playsamp do |n,k| #function to play sample for chimes and "bong"
  mutechimes=0
  mutechimes=1 if get(:enablechimes)
  sample :ambi_glass_rub,start: 0.09,sustain: 0.1*k,release: 0.9*k,amp: 0.6*mutechimes,rpitch: note(n)-note(:fs4)
end

define :playchimes do |notes,durations| #function to play series of notes with sample
  notes.zip(durations).each do |n,d|
    playsamp n,d if n !=:r
    sleep d
  end
end

define :playbongs do |n|
  #function to play bongs with gverb
  n=12 if n==0 #play 12 "bongs" at midnight not zero
  n=n-12 if n>12
  n.times do
    playsamp bong, k
    playsamp note(bong+12),k
    sleep 1
  end
end
#end of chimes setup

define :speak do |n,hm=0| #n is integer 0...59, v allows volums change if required
  mutesample=0
  mutesample=1 if get(:enablespeech) #don't mute whole live loop so still get printout
  f=n/10 #first digit
  s=n%10  #second digit
  if n < 21 #up to 20 recorded as a single sample
    puts "Number to speak is #{n}"
    sample path,n ,amp: mutesample
    sleep 0.75 #gap before next sample
  else #above 20 may require two samples to speak
    puts "Two samples to speak: #{f*10}, #{s}" if s>0
    puts "Number to speak is  #{f*10}" if s==0
    sample path,[20,21,22,23][f-2],amp: mutesample #f-2 gives offset to required sample
    sleep 0.75 #gap between speaking samples
    sample path,s ,amp: mutesample if s>0
    sleep 0.75 if s > 0 #extra gap if two samples used
  end
  if get(:enablespeech) #only add further speech if enabled
    sample path,24 if hm==0  #add "seconds"
    sample path,25 if hm==1 and mins != 1#add "minutes"
    sample path,25,finish: 0.58 if hm==1 and mins ==1 #cut the s at the end of minute
    sample path,26 if hm==2 #add "hours"
  end
  sleep 0.75 #allows for different sections in the loop to have completed before next pass
end

define :hours do #returns hours as an integer 0-23
  return Time.now.hour
end

define :mins do #returns minutes as an integer 0-59
  return Time.now.min
end

define :secs do #returns seconds as an integer 0-59 (I have not catered for "60" leap seconds)
  return (Time.now.sec)%60
end

###### The following live loops produce the output in speech,notes and chimes

set :inhibit,false #inhibts on the hour when hour "bongs" are played
live_loop :announce,sync: :go do #speaks the time every minute in full (apart from when hour is "bonged")
  if secs == 0 and !get(:inhibit)
    speak hours,2
    #sleep 0.75
    speak mins,1
  end
  sleep 0.6
end

live_loop :playtime,sync: :go do #play notes for the minutes and announce seconds every 15 seconds
  cue :chimetest
  n=scale :c3,:major,num_octaves: 5 #notes to play
  muteflag=0;muteflag1=0
  muteflag=1 if get(:enablesecs)
  muteflag1=1 if get(:enabletenths)
  if secs < 30
    offset = secs
  else
    offset = 60-secs
  end
  puts "#{secs} seconds"
  play n[offset],amp: 0.03*muteflag,release: 1
  in_thread do #play tenths of seconds
    use_synth :beep
    9.times do |z|
      play n[offset]+z,amp: 0.05*muteflag1,release: 0.08
      sleep 0.1
    end
    play n[offset]+9,amp: 0.05*muteflag1,release: 0.08 #no sleep last time makes thread a bit shorter
  end
  in_thread do  #announce quarter minutes
    speak 15 if secs == 15
    speak 30 if secs == 30
    speak 45 if secs == 45
  end
  sleep 1 #loop takes 1 second to complete.
end

#section to play chimes and hour "bongs" Use separate live_loop for each to try and minimise timeouts. cue from playtime loop
with_fx :gverb,room: 15,mix: 0.8 do
  live_loop :chimesQ,sync: :go do
    sync :chimetest
    if mins==25 and secs==0 #check for 15 mins past hour
      playchimes quarter,qd #play quarter chimes
      sleep 12 #allow time for chimes to finish
    end
  end
  live_loop :chimesH,sync: :go do
    sync :chimetest
    if mins==30 and secs==0 #check for 30 mins past hour
      playchimes half,hd #play half hour chimes
      sleep 12 #allow time for chimes to finish
    end
  end
  live_loop :chimesT,sync: :go do
    sync :chimetest
    if mins==45 and secs==0 #check for 45 mins past hour
      playchimes threequarters,tqd #play three quarters chimes
      sleep 12 #allow time for chimes to finish
    end
  end
  live_loop :chimesF,sync: :go do
    sync :chimetest
    if mins==59 and secs==60-anticipateInt #anticipate the hour to allow chimes to fimihsh
      set :inhibit,true
      sleep anticipateFrac
      playchimes hour,hd #play chimes for thr hour (in advnace of thr actual hour)
      sleep 12 #allow time for chimes to finish
    end
  end
  live_loop :chimesB,sync: :go do
    sync :chimetest
    if mins== 28 and secs==0 #play a "bong" for each hour at second intervals
      playbongs hours
      set :inhibit,false
      sleep 12 #allow time for chimes to finish
    end
  end
end

######## following code sycs and starts the live loops
sleep 2 #wait 2 secs to allow loops and sample loads to settle
set :t,secs #store current secs in time state
until secs>get(:t)
  sleep 0.05
end
cue :go #trigger loops on a secs change
