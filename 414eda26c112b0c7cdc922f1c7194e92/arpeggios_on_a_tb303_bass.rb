#Arpeggios on a tb303 bass by Robin Newman, April 2018
#I first wrote the percussion live loops, liked them, and then thought it would be nice to have a melody on top of this.
#I found a list of chord progressions in :c at https://www.secretsofsongwriting.com/2012/04/10/creating-chord-progressions-that-always-work-in-any-key/
#and started to play with them, ending up with the program below. The triad chords in each progression are played as arpeggios
#with the first note added as a fourth note an octave below throughout the duration of the arpeggio.
#Each progression has a transpose offset applied in a sequence of 0,5,7,-5 and the tonic note of the sequence
#is played an octave lower using :tb303 synth acting as a pedal note. To add interest, the cuttoff value
#is cycled 4 times during the progress of each chord progression.
#The sequence is repeated 5 times with the volume faded up or down in each sequence.

#two drum loops work together and in opposition
set :sequence,0 #keeps count of current sequence

set :kill,false
at 51.2*5 do
  set :kill,true  #used to stop drum loops
end

with_fx :level,amp: 0 do |v|
  control v,amp: 1,amp_slide: 51.2 #initial fade up of volume
  at [51.2,102.4,153.2,204.8],[0.5,1,0.4,1] do |t|#control volume on subsequent sequences
    control v,amp: t,amp_slide: 51.2 #51.2 is the duration of a complete sequence
  end
  
  live_loop :dr do
    stop if get(:kill) #stop at the end
    p=(bools 1,0,0,1,0,1,1,1)
    x=0.8*(-1)**dice(2)
    sample :bd_haus,amp: 0.8,pan: x if p.tick
    sample :bd_zome,amp: 0.8,pan: -x if !p.look
    sleep 0.2
  end
  
  live_loop :dr2 do
    stop if get(:kill) #stop at the end
    p=(bools 1,0,0,0,0,1,1,0)
    x=0.8*(-1)**dice(2)
    sample :bd_zome,amp: 0.8,pan: -x if p.tick
    sample :bd_haus,amp: 0.8,pan: x if !p.look
    sleep 0.2
  end
  
  
  with_fx :reverb,room: 0.8,mix: 0.6 do
    live_loop :pchord do
      use_synth :tri
      #generate 5 different chord progressions
      clist1=(ring chord(:c,:major),chord(:a,:minor),chord(:e,:minor), chord(:a,:minor),chord(:d,:minor),chord(:g,:major)) #9.6
      
      clist2=(ring chord(:c,:major),chord(:f,:major),chord(:d,:minor),chord(:g,:major),chord(:e,:minor), chord(:a,:minor),chord(:d,:minor),chord(:g,:major)) #12.8
      
      clist3=(ring chord(:c,:major),chord(:g,:major),chord(:d,:minor),chord(:a,:minor),chord(:d,:minor),chord(:f,:major)) #9.6
      
      clist4=(ring chord(:c,:major),chord(:e,:minor),chord(:a,:minor),chord(:d,:minor),chord(:g,:major),chord(:f,:major)) #9.6
      
      clist5=(ring chord(:c,:major),chord(:d,:minor),chord(:c,:major),chord(:f,:major),chord(:d,:minor),chord(:g,:major)) #9.6
      
      clchoose=(ring clist1,clist2,clist3,clist4,clist5).tick(:ch) #choose the progression to use one by one
      set :sequence,get(:sequence)+1 if look(:ch)%5==0 #holds number of the current sequence
      if look(:ch)==25 #stop after 5 sequences
        puts "finished!"
        stop
      end
      
      clchoose=clchoose.mirror #mirror it
      offset =(ring 0,4,7,-5).look(:ch)
      puts "sequence #{get(:sequence)}, progression #{1+look(:ch)%5} with offset #{offset}" #print current position
      use_transpose offset #ranspose each progression with a differnt offset
      cl=clchoose.length #get number of chords in current progression
      k=synth :tb303,note: :c2,sustain: cl*0.8,amp: 0.2,cutoff: rrand(50,90) #add a bass pedal note using tb303, modifying the cutoff
      in_thread do #control and modify the cutoff 4 times as the note plays
        loop do
          control k,cutoff: rrand(50,90),cutoff_slide: cl/4.0 # use slide 1/4 duration of currrent progression
          sleep cl/4.0
        end
      end
      
      tick_reset #basic tick used to go through each chord progression
      cl.times do #cycle through each chord in the progression
        ch=clchoose.tick #get next chord
        synth :saw,note: ch[0]-12,release: 0.8 #add first note of arpeggio as a base note using :saw synth
        sleep 0.2
        ch.each do |n| #play each chord as an arpeggio #interesting variation is to change to ch.shuffle.each do |n|
          play n,release: 0.2
          sleep 0.2
        end
      end
    end
  end
end
