











#    BETT 2015: TALK ON SONIC PI given by Robin Newman



























nc=0 ###################################
comment do
  #Sonic-Pi: What is it and what can it do?
  #you can make sounds with it, using a built in synthesizer

  play 72

  #or, you can play built in or external audio samples
  sleep 2
  sample :loop_amen_full
end
#nc=1 ###################################















  #If the sounds are nice, you might be playing music...
comment do
  # a chord
  play 72
  play 76
  play 79

  sleep 2
  # or  a sequence of notes
  play 72
  sleep 0.2
  play 74
  sleep 0.2
  play 76
  sleep 0.2
  play 77
  sleep 0.2
  play 79
end
#nc=2 ###################################







comment do
  #It is tedious to type so much, so Sonic-Pi has commands to help

  #  This plays a chord
  play [76,79,84]
  sleep 2
  # or this plays notes one after the other
  play_pattern_timed [79,77,76,74,72],[0.2]
end
#nc=3 ###################################














comment do
  #you can use symbolic notation instead of numbers

  play [:c5,:e5,:g5]
  sleep 2
  #or
  q = 0.2
  c = 0.4
  play_pattern_timed [:c5,:d5,:e5,:f5,:g5],[c,q,c,q,c]

  # here we use a variable q to hold the time for a quaver 0.2
  # and another c to hold the time for a crotchet 0.4
end
#nc=4 ###################################












comment do
  # You can change the instrument or synth used

  use_synth :tri
  c = 0.4
  play_pattern_timed [:c4,:d4,:e4,:c4],[c]
  sleep 2
  # and also the shape of the notes
  play_pattern_timed [:c4,:d4,:e4,:c4],[c],release: c
end
#nc=5 ###################################














comment do
  #We can build on the tune we have just started...
  #use the tri synth again
  use_synth :tri
  #first we define three note durations
  q = 0.2 #quaver
  c = 2 * q #crotchet
  m = 2 * c #minim
  #then we can play the existing first line twice
  play_pattern_timed [:c4,:d4,:e4,:c4]*2,[c],release: c
  #now add second line (plays twice)
  play_pattern_timed [:e4,:f4,:g4]*2,[c,c,m]*2,release: c
  #then the third line, again plays twice
  play_pattern_timed [:g4,:a4,:g4,:f4,:e4,:c4]*2,[q,q,q,q,c,c]*2,release: c
  #then the last line, again repeated
  play_pattern_timed [:c4,:g3,:c4]*2,[c,c,m]*2,release: c
end
#nc=6 ###################################






comment do
  #now we can use another feature in Sonic-Pi and define our tune
  #use the pulse synth this time
  use_synth :pulse
  #first we define three note durations
  q = 0.2 #quaver
  c = 2 * q #crotchet
  m = 2 * c #minim
  #now we define the tune: we enclose the commands inside define :tune do....end
  define :frere do
    play_pattern_timed [:c4,:d4,:e4,:c4]*2,[c],release: c
    play_pattern_timed [:e4,:f4,:g4]*2,[c,c,m]*2,release: c
    play_pattern_timed [:g4,:a4,:g4,:f4,:e4,:c4]*2,[q,q,q,q,c,c]*2,release: c
    play_pattern_timed [:c4,:g3,:c4]*2,[c,c,m]*2,release: c
  end
  #now we play the tune by typing the defined name
  frere
end
#nc=7 ###################################








comment do
  use_synth :pulse
  #first we define three note durations
  q = 0.15 #made it a bit quicker: quaver is shorter
  c = 2 * q
  m = 2 * c
  #now we define the tune
  define :frere do
    play_pattern_timed [:c4,:d4,:e4,:c4]*2,[c],release: c
    play_pattern_timed [:e4,:f4,:g4]*2,[c,c,m]*2,release: c
    play_pattern_timed [:g4,:a4,:g4,:f4,:e4,:c4]*2,[q,q,q,q,c,c]*2,release: c
    play_pattern_timed [:c4,:g3,:c4]*2,[c,c,m]*2,release: c
  end
  #start our round setup
  #play the first line of the tune
  play_pattern_timed [:c4,:d4,:e4,:c4]*2,[c],release: c
  #start playing the tune again: the second part
  #but put it inside a thread. This starts it playing and goes on
  #immediately to the next line of code following it
  #so they play at the same time
  in_thread do
    use_synth :saw #different synth to make it stand out
    frere
  end
  #meanwhile start the second line of the first part
  play_pattern_timed [:e4,:f4,:g4]*2,[c,c,m]*2,release: c
  #now start the third part in a thread
  in_thread do
    use_synth :prophet #change the synth again
    frere
  end
  #meanwhile start the third line of the first part
  play_pattern_timed [:g4,:a4,:g4,:f4,:e4,:c4]*2,[q,q,q,q,c,c]*2,release: c
  #when that finishes, start the forth part in a thread
  in_thread do
    use_synth :fm  #yet another synth
    frere
  end
  #finally play the last line of the first part
  play_pattern_timed [:c4,:g3,:c4]*2,[c,c,m]*2,release: c
end
#nc=8 ###################################
















#########################################################
#the actual programs run start here, in a case statement

set_sched_ahead_time! 1
case nc
when 1
  play 72
  sleep 2
  sample :loop_amen_full
when 2
  play 72
  play 76
  play 79
  sleep 2
  play 72
  sleep 0.2
  play 74
  sleep 0.2
  play 76
  sleep 0.2
  play 77
  sleep 0.2
  play 79
when 3
  play [76,79,84]
  sleep 2
  play_pattern_timed [79,77,76,74,72],[0.2]
when 4
  play [:c5,:e5,:g5]
  sleep 2
  q=0.2
  c=0.4
  play_pattern_timed [:c5,:d5,:e5,:f5,:g5],[c,q,c,q,c]
when 5
  use_synth :tri
  q = 0.2
  c = 2 * q
  m = 2 * c
  play_pattern_timed [:c4,:d4,:e4,:c4],[c]
  sleep 2
  play_pattern_timed [:c4,:d4,:e4,:c4],[c],release: c
when 6
  use_synth :tri
  q=0.2
  c =2*q
  m=2*c
  play_pattern_timed [:c4,:d4,:e4,:c4]*2,[c],release: c
  play_pattern_timed [:e4,:f4,:g4]*2,[c,c,m]*2,release: c
  play_pattern_timed [:g4,:a4,:g4,:f4,:e4,:c4]*2,[q,q,q,q,c,c]*2,release: c
  play_pattern_timed [:c4,:g3,:c4]*2,[c,c,m]*2,release: c
when 7
  use_synth :pulse
  q = 0.2
  c = 2 * q
  m = 2 * c
  define :frere do
    play_pattern_timed [:c4,:d4,:e4,:c4]*2,[c],release: c
    play_pattern_timed [:e4,:f4,:g4]*2,[c,c,m]*2,release: c
    play_pattern_timed [:g4,:a4,:g4,:f4,:e4,:c4]*2,[q,q,q,q,c,c]*2,release: c
    play_pattern_timed [:c4,:g3,:c4]*2,[c,c,m]*2,release: c
  end
  frere
when 8
  #set_sched_ahead_time! 3 #needed on Pi because of processing demands with 4 synths and reverb
  #with_fx :reverb,room: 0.8 do
  use_synth :pulse
  #first we define three note durations
  q = 0.15
  c = 2 * q
  m = 2 * c
  #now we define the tune
  define :frere do
    play_pattern_timed [:c4,:d4,:e4,:c4]*2,[c],release: c
    play_pattern_timed [:e4,:f4,:g4]*2,[c,c,m]*2,release: c
    play_pattern_timed [:g4,:a4,:g4,:f4,:e4,:c4]*2,[q,q,q,q,c,c]*2,release: c
    play_pattern_timed [:c4,:g3,:c4]*2,[c,c,m]*2,release: c
  end
  #play the first line of the tune
  play_pattern_timed [:c4,:d4,:e4,:c4]*2,[c],release: c
  #start playing the tune again: the second part
  #but put it inside a thread
  in_thread do
    use_synth :saw
    frere
  end
  #meanwhile start the second line of the first part
  play_pattern_timed [:e4,:f4,:g4]*2,[c,c,m]*2,release: c
  #now start the third part in a thread
  in_thread do
    use_synth :prophet
    frere
  end
  #meanwhile start the third line of the first part
  play_pattern_timed [:g4,:a4,:g4,:f4,:e4,:c4]*2,[q,q,q,q,c,c]*2,release: c
  #when that finishes, start the forth part in a thread
  in_thread do
    use_synth :fm
    frere
  end
  #finally play the last line of the first part
  play_pattern_timed [:c4,:g3,:c4]*2,[c,c,m]*2,release: c
  #end
end
set_sched_ahead_time! 1 #reset to usual value
################################################################################

############################# RESOURCES #########################################
#                                                                               #
# A synopsis of this talk, including download links to Sonic Pi resources is at #
#                                                                               #
#                                                                               #
#                                                                               #
#                        http://goo.gl/Ze8unz                                   #
#                                                                               #
#                                                                               #
#                                                                               #
#################################################################################
