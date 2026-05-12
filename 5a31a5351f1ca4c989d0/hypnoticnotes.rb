# Hypnotic notes by Robin Newman
# illustrating parameter passing using cue and sync
# also features the density function
use_debug false

duration=120 #Total duration of piece (min 10 seconds). Adjust as required

last_bn=:c4 #prime an initial value
kill=0 #used to kill program after required time
duration=duration-10 #allow for fadeout

with_fx :reverb,room: 0.8,mix: 0.5 do #wrap with some reverb
  with_fx :level do |vol| #used to fade out piece during last 10 seconds
    control vol,amp: 1 #set initial level
    
    live_loop :audio do #this loop does the fade and sets kill at end to 1
      tick
      if look > duration #see if time to start the fade yet
        control vol,amp: 1-(look-duration).to_f/10 #fade over 10 seconds
        if look==(duration+10) #check if finished fade and if so stop
          kill=1 #used by conduct live_loop to stop all other loops
          stop
        end
      end
      sleep 1
    end
    
    live_loop :conduct do
      tick
      
      if look%4==0 #change base note every 4 passes
        base_note=rrand_i(note(:c3),note(:c6))
        puts "New base note: "+base_note.to_s
        last_bn=base_note
      else
        base_note=last_bn
      end
      
      s=scale_names.look #iterate around scale types
      puts "Scale type: "+s.to_s
      sc=scale(0,s) #get notes
      sc=sc.reverse if (look%3) == 0 #alter order or shuffle for interest
      sc=sc.shuffle if (look%2) == 0
      puts "Note offsets played: "+sc.to_s #show note offsets for scale 0
      puts "Extra notes triggered for offsets 0,4,7 and 12"
      
      density_num=1
      density_num=2 if  (look%6)<2 #choose density 2 for 2 out of 6 passes
      density density_num do
        sc.length.times do #send cues with notes for current scale, also base_value and kill value
          cue :go, link: sc.tick(:notes),bn: base_note,kvalue: kill
          sleep 0.2 #adjust
        end
      end
      stop if kill==1 #note this loop only stops after it has sent cue to stop the others
    end
    
    live_loop :t0 do #this loop plays all the notes in the scale
      use_synth :piano
      v=sync :go
      stop if v[:kvalue]==1 #check if told to stop
      play note(v[:bn]) + v[:link]
      sleep 0.1 #time shorter than gap usually set by sync
    end
    
    #the following 4 loops are identical apart from the offset used and the synth selected
    
    live_loop :t1 do
      offset=0
      use_synth :saw
      p=2*(tick%2) - 1 #pan multiplier 1 or -1
      v=sync :go
      stop if v[:kvalue]==1
      play note(v[:bn])+offset,amp: 0.8,release: 0.45,pan: 0.8*p if v[:link]==offset #plays if note offset is 0
      sleep 0.1 #sets min loop time: usually the sync interval is greater
    end
    
    live_loop :t2 do
      offset=4
      use_synth :zawa
      p=2*(tick%2) - 1 #pan multiplier 1 or -1
      v=sync :go
      stop if v[:kvalue]==1 #check if told to stop
      play note(v[:bn])+offset,amp: 0.8,release: 0.45,pan: 0.8*p if v[:link]==offset #plays if note offset is 4
      sleep 0.1
    end
    
    live_loop :t3 do
      offset=7
      use_synth :prophet
      p=2*(tick%2) - 1 #pan multiplier 1 or -1
      v=sync :go
      stop if v[:kvalue]==1
      play note(v[:bn])+offset,amp: 0.8,release: 0.45,pan: 0.8*p if v[:link]==offset #plays if note offset is 7
      sleep 0.1
    end
    
    live_loop :t4 do
      offset = 12
      use_synth :tb303
      p=2*(tick%2) - 1 #pan multiplier 1 or -1
      v=sync :go
      stop if v[:kvalue]==1
      play note(v[:bn])+offset,amp: 0.8,release: 0.45,pan: 0.8*p if v[:link]==offset #plays if note offset is 12
      sleep 0.1
    end
    
  end #end fx level control
end #end fx reverb loop
