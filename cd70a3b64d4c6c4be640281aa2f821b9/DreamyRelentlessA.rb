#DreamyRelentlessA by Robin Newman, February 2019
#In this piece I started by experimenting with two streams of notes
#of varying frequencies intially almost identical. This built up with the addition
#of several similar notes varying in the opposite sense, ie decreasing in frequency
#as the first set increased. The resulting rather dreamy sound was pleasing,
#especially when it resolves to the notes being perfectly in tune.
#I then experimented with adding an insistant repetitive beat, using two
#tones played with :tb303 and :chiplead. Rhythm was added using the spread function
#and I also added some percussion, and repetitively faded between the two streams
#of dreamy notes. Finaly I slowed the whole thing down, and it sounded much better
#and more relentless at 30bpm.
#The piece could go on for ever, but I have arranged it to complete two complete
#cycles of the dreamy note variations, and then fade out.
#I used a /stop-all-jobs OSC command to the Sonic Pi server port 4557 to stop it.
use_debug false
use_cue_logging false
use_bpm 30

use_synth :sine
with_fx :level, amp: 0 do |master|
  control master,amp: 4,amp_slide: 10 #inital fade in at start
  with_fx :reverb,room: 0.8,mix: 0.7 do
    with_fx :level,amp: 0 do |v1| #controlled volume for progress1
      set :v1,v1
      live_loop :progress1 do
        #play insistant chiplead note
        synth :chiplead, note: :a4,release: 0.1,amp: 0.2
        #set up steps for first progression
        p=(line 0,110,inclusive: true,steps: 111)
        p=p.mirror #mirror the steps so it goes up them down
        tick
        #set up two related close frequencies
        n1=440 + p.look
        n2=440 - p.look
        puts n1-440 #print current step value
        #play series of 4 closely related notes, with different rhythms
        play hz_to_midi(n1),attack: 0.1,release: 0.1,pan: -0.6,amp: 0.4 if spread(8,13).look
        sleep 0.05
        play hz_to_midi(n2),attack: 0.1,release: 0.1,pan: 0.6,amp: 0.4 if !spread(8,13).look
        sleep 0.05
        play hz_to_midi(n2),attack: 0.1,release: 0.1,pan: -0.3,amp: 0.4 if spread(8,13).look
        sleep 0.05
        play hz_to_midi(n1),attack: 0.1,release: 0.1,pan: 0.3,amp: 0.4 if !spread(8,13).look
        sleep 0.05
      end
      with_fx :level, amp: 0.4 do #balance volume of percussion
        live_loop :perc1 do
          tick
          sample :bd_sone,pan: -0.8 if spread(8,13).look
          sample :bd_zum,pan: 0.8 if !spread(8,13).look
          sleep 0.2
        end
      end
    end
    
    
    with_fx :level,amp: 0.7 do |v2| #controlled volume for progress2
      set :v2,v2
      live_loop :progress2 do
        #play insistant ;tb303 note
        synth :tb303,note: :a1,release: 0.1,cutoff: rrand(100,110),amp: 0.4
        #setup up frequency steps for second progression. Reverse of firset one
        q=(line 110,0,inclusive: true,steps: 111)
        q=q.mirror #mirror the steps so they go down then up again
        q1=440 + q.look #set up two differing frequencies
        q2=440 - q.look
        tick
        #play series of 4 closely related notes, with different rhythms
        play hz_to_midi(q1),attack: 0.1,release: 0.1,pan: -0.8,amp: 0.4 if spread(5,11).look
        sleep 0.05
        play hz_to_midi(q2),attack: 0.1,release: 0.1,pan: 0.8,amp: 0.4 if !spread(5,11).look
        sleep 0.05
        play hz_to_midi(q2),attack: 0.1,release: 0.1,pan: -0.4,amp: 0.4 if spread(5,11).look
        sleep 0.05
        play hz_to_midi(q1),attack: 0.1,release: 0.1,pan: 0.4,amp: 0.4 if !spread(5,11).look
        sleep 0.05
      end
      with_fx :level, amp: 0.4 do #balance volume of percussion
        live_loop :perc2 do
          tick
          sample :bd_haus,pan: -0.5 if spread(5,11).look
          sample :bd_klub,pan: 0.5 if !spread(5,11).look
          sleep 0.2
        end
      end
    end
  end
end
live_loop :vadjust do
  #fade the two progession volumes up and down, out of phase with each other
  #by controlling the fx level wrappers round each one
  tick
  puts "A",look #for debugging to check progress
  control get(:v1),amp: 0.7,amp_slide: 4.44
  control get(:v2),amp: 0,amp_slide: 4.44
  sleep 4.44
  puts "B",look #for debugging to check progress
  control get(:v1),amp: 0,amp_slide: 4.44
  control get(:v2),amp: 0.7,amp_slide: 4.44
  sleep 4.44
  if look==8 #control stop time for last fade
    control get(:v1),amp: 0.7,amp_slide: 4.44
    control get(:v2),amp: 0,amp_slide: 4.4
    sleep 4.4
    control get(:v1),amp: 0,amp_slide: 4.4 #final fade out, (dont fade :v2 in)
    sleep 4.4
    osc_send "localhost",4557,"/stop-all-jobs" #stop everything
    sleep 1 #make sure nothing starts again before stop-all takes effect
  end
end
