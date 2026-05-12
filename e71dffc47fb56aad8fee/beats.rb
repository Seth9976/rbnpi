#beats by Robin Newman August 2015. Runs on SP 2.6 or later
#in the development version for Sonic Pi 2.7 Sam Aaron has introduced a very short command
#which does the opposite of the pitch-to_ratio command. In other words, if r is a ratio like 2,
#then puts ratio_to_pitch(2) will return 12, the pitch shift in midi notes which will occur
#if a sample is played at this rate. (It will play up an octave). puts ratio_to_pitch(1) will give 0,
#as playing a sample at rate 1 will play it at its normal pitch.

#I decided to play with this and caculate the pitch shifts as r ranged from 1 to 2 in 120 equal steps
#I used these calcuated values to alter the pitch of a note which was already playing, causing it
#to slide up an octave.
#At the same time I played a second note, and controlled its pitch by sliding it up an octave again in 120 steps
#but this time the steps were each equal to 1/120, so that the pitch increased linearly.
#Playing the two notes together gives a nice "beat" pattern becuase of the slight differences
#in their pitches.
#The live_loop :beats first starts two notes playing :c3, and lasting for 24.2 seconds
#It then raises their pitches using a control function with 120 increments (the first time round the loop i=0)
#It then lowers the two pitches over a further 120 increments back to :c3
#To give a "performance" the whole is subject to a level control which is adjusted by the live_loop :audio
#This raises the level from 0 to 1 as the first upward slide take place, and then lowers it
#back down to 0 after 2.5 complete cycles of the beats loop, before stopping both loops

#in order that this program can run on version 2.6 I have placed the definition of ratio_to_pitch
#at the start of the program. Once the new function is released this definition can be removed.

define :ratio_to_pitch do |r| #remove this definition once ratio_to_pitch is included in SP
  return 12.0 * Math.log2(r.to_f)
end

with_fx :reverb,mix: 0.4 do #add a little reverb
  with_fx :level do |amp| #used to control the volume, adjusted by live_loop :audio
    control amp,amp: 0 #set initial level
    sleep 0.05 #allow level to settle without a click

    live_loop :beats do
      tick #usad to count complete cycles of the beats loop. (starts from 0 on first pass)
      s=play :c3,attack: 0.04,sustain: 24.2,release: 0.04 #start two identical notes
      p=play :c3,attack: 0.04,sustain: 24.2,release: 0.04 #each lasts just over 24.2 seconds
      121.times do |i| #raise pitches by 12 (1 octave) over 120 steps
        puts note(:c3)+ratio_to_pitch(1+i.to_f/120) #print midi "pitches" for first note
        puts note(:c3)+12*i.to_f/120 #print midi "pitches" for second note
        control s,note: (note(:c3)+ratio_to_pitch(1+i.to_f/120)),note_slide: 0.1 #control with ratio_pitch
        control p,note: (note(:c3)+12*i.to_f/120),note_slide: 0.1 #linear control
        sleep 0.1
      end
      121.times do |i| #reduce ptiches back to starting values
        puts note(:c3)+ratio_to_pitch(1+(120-i).to_f/120) #print values for each note
        puts note(:c3)+12*(120-i).to_f/120
        control s,note: (note(:c3)+ratio_to_pitch(1+(120-i).to_f/120)),note_slide: 0.1
        control p,note: (note(:c3)+12*(120-i).to_f/120),note_slide: 0.1
        sleep 0.1
      end
      stop if look >= 2 #check how many cycles have completed and stop after 3 (first pass 0)
    end

    live_loop :audio do
      tick #counter for this loop. Starts at 0
      #increase volume over the first 121 ticks
      control amp,amp: ( (look.to_f)/121) if look <= 121 #control raises amp
      #decrease volume after 2.5 complete cycles
      #use a separate tick named tick(:stop)
      control amp,amp: (1- (tick(:stop).to_f)/121) if look >= 242*2+121 #decrease amp again
      stop if look(:stop) >= 121 #stop loop after volume is zero (121 tick(:stop))
      sleep 0.1
    end

  end #fx :level
end #fx :reverb