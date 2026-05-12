#Beserk Scales by Robin Newman Jan 2015 REQUIRES VERSION 2.3dev OR LATER
#This piece explores the use of the with_bpm_mul command introduced in version 2.3
#also featreus the with_transpose command
#it plays two sequences of scales, at the same time
#The first plays the scales ascending, slowly increasing in speed each time, then plays the same scales in reverse
#slowly decreasing in spead as it does so.
#The second sequence, played with a different synth, plays descending scales which decrease in speed, followed by the same scales
#in reverse, speeding up as they ascend.3The two sequences end abrubtly together, and the piece ends with a large chord
#in the starting key.

#Lots of parameters used to allow for experimentation
#sc is list of notes produced by scale command
#steps no of times speed increases and scale is changed in pithc by 1 semitone
#multiplier is rate of change of speed per interation
#elementtime is time each note plays for (at 60 bpm)
#tonic is starting note forscale
#numoctaves is number of octaves in the scale
#reverse (0 or 1) choose whether up or down is used first when playing the scales

define :up do |sc,steps,multiplier,elementtime|
  1.upto(steps)do |i|
    puts i
    with_bpm_mul multiplier**i do
      with_transpose i-1 do
        play_pattern_timed sc,elementtime,release: elementtime
      end
    end
  end
end

define :down do |sc,steps,multiplier,elementtime|
  steps.downto(1) do |i|
    puts i
    with_bpm_mul multiplier**i do
      with_transpose i-1 do
        play_pattern_timed sc.reverse,elementtime,release: elementtime
      end
    end
  end
end

define :swirl do |tonic,numoctaves,startrate,steps,multiplier,elementtime,reverse=0|
  sc=scale(tonic,:major,num_octaves: numoctaves)
  use_bpm startrate
  if reverse==0 then
    up(sc,steps,multiplier,elementtime)
    down(sc,steps,multiplier,elementtime)
  else
    down(sc,steps,multiplier,elementtime)
    up(sc,steps,multiplier,elementtime)
  end
end
################## start playing here ###################
with_fx :reverb, room: 0.6, mix: 0.4 do #apply some reverb
  in_thread do # play first scale pattern in thread
    use_synth :fm
    swirl(:g3,2,20,12,1.15,0.1) #:g3 2 octaves, starting bpm 20, 12 scales, 1.15 multiplier,0.1 noteduration, "up" first
  end
  #set up and play second scale pattern
  use_synth :prophet
  swirl(:g3,2,20,12,1.15,0.1,1) #reverse pattern: #:g3 2 octaves, "starting" bpm 20, 12 scales, 1.15 multiplier,0.1 noteduration, "down" first
  #set up and play final chord
  use_bpm 60
  use_synth :tri
  play [:g3,:b3,:d4,:g4,:b4,:d4,:g5],attack: 0.05,attack_level: 1,decay: 0.1,sustain_level: 0.7,sustain: 2,release: 1,amp: 0.9
end
