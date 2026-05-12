#Sample Symphony for Sonic Pi by Robin Newman, May 2015
#This program splits the internal samples in Sonic Pi up into their constituent groups or familes
#eg :bass_drums, :elec, :bass, :guit etc and then gradually introduces each group, with samples chosen at random
#from within them. Each group is started in a separate live_loop,separated by a sleep delay, so that they
#can be started in sequence. The sounds gradually build up as more and more groups are introduced.
#This is implemented by an fx :level command, which allows the volume to slowly build up to a maximum.
#The various live_loops are then killed off in the reverse sequence, and at the same time
#the level volume is reduced allowing the sound to die away again.
#The timings are carefully calculated for each loop using an iteration counter.
#The program uses all groups except :misc and :loop. The former is not vey musical! and the latter
#doesn't really fit. I added it initially but it didn't enhance things.

#Note prior to ver 2.6dev you will get an error when each live_loop is stopped. This is because the stop command has been altered
#in ver 2.6dev. Although it doesn't look neat, the desired action (stopping the loop) is achieved, although an error is raised.
#In ver 2.6dev the error does not occur.


#set_sched_ahead_time! 2 #may need this on slower Pi or even on Mac if thread timeing delays occur

use_random_seed 12345#try different values
multiplier=2 #gives duration 140 seconds (plus 1 sec initialise) . Scale as an integer for longer or shorter performances.
verbose=false #set to true to see samples played
delay=5*multiplier #delay time between each successive group starting
#Setup loop count values before each loop is stopped
llnum=multiplier*70.0/0.2 #mult times total time required / loop time
lnum1=multiplier*60.0/0.2
lnum2=multiplier*50.0/0.2
lnum3=multiplier*40.0/0.8
lnum4=multiplier*30.0/0.4
lnum5=multiplier*20.0/2
lnum6=multiplier*10.0/2

with_fx :level do |amp| #control overall volume with an fx level wrapper
  control amp,amp: 0.1 #set starting volume level
  sleep 1 #allow initial amp to stabilise with no glitches.

  live_loop :level, auto_cue: false do |count| #fades in at start out at end
    puts "Count is "+count.to_s
    if count < 30 #fade in over first 30 iterations
      control amp,amp: 0.1+count.to_f/30,amp_slide: 1
    end
    if count > 40 #fade out from 40-70 iterations
      control amp,amp: 0.1+(70-count).to_f/30,amp_slide: 1
    end
    sleep multiplier
    if count >= 70 then
      stop #stops THIS loop from running after 70 iterations
    end
    inc count
  end

  live_loop :bd do |i| #start the bass drums loop
    if i>= llnum then stop #stop it after the required number of iterations
    end
    ch1=(sample_names :bass_drums).choose #coose sample at random from the group
    if verbose then puts "sample name :"+ch1.to_s
    end
    sample ch1,pan: rrand(-1,1) #play it with random pan value
    sleep 0.2
    inc i
  end

  sleep delay

  live_loop :elec,auto_cue: false do |l1| #start the elec loop
    sync :bd
    if l1 > lnum1 then stop #stop it after the required number of iterations
    end
    ch2=(sample_names :elec).choose
    if verbose then puts "sample name :"+ch2.to_s
    end
    sample ch2,pan: rrand(-1,1)
    sleep 0.2
    inc l1
  end


  sleep delay

  live_loop :drum,auto_cue: false do |l2| #start the drum loop
    if l2 > lnum2 then stop #stop it after the required number of iterations
    end
    ch3=(sample_names :drum).choose
    if verbose then puts "sample name :"+ch3.to_s
    end
    sample ch3,pan: rrand(-1,1)
    sleep 0.2
    inc l2
  end


  sleep delay

  live_loop :guit,auto_cue: false do |l3| #start the guitars loop
    sync :bd
    if l3 > lnum3 then stop #stop it after the required number of iterations
    end
    ch4=(sample_names :guit).choose
    if verbose then puts "sample name :"+ch4.to_s
    end
    sample ch4,pan: rrand(-1,1)
    sleep 0.8
    inc l3
  end


  sleep delay

  live_loop :perc_sn,auto_cue: false do |l4| #start the percussive/snares loop
    sync :bd
    if l4 > lnum4 then stop #stop it after the required number of iterations
    end
    ch5=((sample_names :perc)+(sample_names :snares)).choose
    if verbose then puts "sample name :"+ch5.to_s
    end
    sample ch5,pan: rrand(-1,1)
    sleep 0.4
    inc l4
  end


  sleep delay

  live_loop :bass,auto_cue: false do |l5| #start the bass loop
    sync :bd
    if l5 > lnum5 then stop #stop it after the required number of iterations
    end
    ch6=(sample_names :bass).choose
    if verbose then puts "sample name :"+ch6.to_s
    end
    sample ch6,pan: rrand(-1,1)
    sleep 2
    inc l5
  end

  sleep delay

  live_loop :ambi,auto_cue: false do |l6| #start the ambi loop
    sync :bd
    if l6 > lnum6 then stop #stop it after the required number of iterations
    end
    ch7=(sample_names :ambi).choose
    if verbose then puts "sample name :"+ch7.to_s
    end
    sample ch7,pan: rrand(-1,1)
    sleep 2
    inc l6
  end
end