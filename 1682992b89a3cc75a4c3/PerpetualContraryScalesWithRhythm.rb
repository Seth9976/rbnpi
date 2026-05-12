#Perpetual contrary scales with rhythm! by Robin Newman Feb 2016
#chooses a scale type and plays an octave twice against itself backwards
#The twist is that each scale has a different rhythm imposed
#also the starting note has an offset applied
#By changing the rhythms, offsets, scale types and synths a rather haunting
#repeating structure is played.
use_random_seed(1010101)#adjust number for a different sequence
use_debug false #switch off messages

#Set repetitions to number of repeats required or 0 for continous
repetitions=36

#set initial state for first run
n=:minor_pentatonic #scale name
s1=scale(0,n) #get new scale notes (octave zero)
s2=s1.reverse #s2 always reverse of s1
offset1=0 #offsets to add to scale notes for s1
offset2=0 #offsets to add to scale notes for s2
p=[5,8] #starting rhythm s1
q=[5,13] #starting rhythm s2
countnumber=1 #starting displayed countnumber
fade=0 #flag for fading audio on last repetition
ppos=0.8 #pan position
startlevel = 0.7 #starting level for with_fx :level
if repetitions!=0 then #limitreps printed in description: adjust it here
  limitreps=" of "+repetitions.to_s+" repetitions"
else
  limitreps=""
end
#print first time message
puts "First repetion minor_pentatonic scale, with rhythm spreads 5,8 and 5,13"


with_fx :level do |lev| #controls audio level for fade at the end
  control lev,amp: startlevel
  with_fx :reverb,room: 0.8,mix: 0.3 do #add some reverb

    #start the loop running
    live_loop :doodle, auto_cue: false do
      tick #used to iterate through scale notes

      #next section changes scale and parameters each time s1 has played twice
      if look(:s1tick)>=2*scale(0,n).length #see if played scale notes twice
        # NB >= in last line rather than == or rerun of program can cause problems
        stop if repetitions == 1  #stop after  required number of repeats
        repetitions -=1 #reduce number of repeats
        countnumber +=1 #used to display current repetiion
        tick_set :s1tick,0 #reset the scale note counters
        tick_set :s2tick,0
        syn=[:tri,:piano,:beep,:saw].choose #choose next synth
        use_synth syn
        n=scale_names.choose #choose new scale name
        s1=scale(0,n) #get new scale notes
        s1=[s1,s1.reverse].choose #sometimes reverse them
        s2=s1.reverse #s2 always reverse of s1
        offset1=(ring 0,4,7,12).tick(:offset) #next offsets selected
        offset2=(ring 0,-3,-5,-12).look(:offset)
        p=[[5,8],[5,13],[7,11],[13,18],[15,23]].choose #choose next rhythms
        q=[[5,8],[5,13],[7,11],[13,18],[15,23]].choose
        until q!=p #make sure q and p differ
          q=[[5,8],[5,13],[7,11],[13,18],[9,15]].choose
        end
        ppos=ppos*(-1) #reverse pan setting
        if repetitions==1 then #last time reset first values
          n=:major #scale name
          s1=scale(0,n) #get new scale notes (octave zero)
          s2=s1.reverse #s2 always reverse of s1
          offset1=0 #offsets to add to scale notes for s1
          offset2=0 #offsets to add to scale notes for s2
          p=[5,8] #starting rhtyhm s1
          q=[5,13] #starting rhythm s2
        end

        #print out settings for next scale
        puts "current sequence number "+countnumber.to_s+limitreps
        puts "Using synth :"+syn.to_s
        puts "Scale: "+n.to_s
        puts "offset1 "+offset1.to_s
        puts "offset2 "+offset2.to_s
        puts "scale notes s1 "+s1.to_s
        puts "scale notes s2 "+s2.to_s
        puts "Rhythm spread for s1 "+p.to_s
        puts "Rhythm spread for s2 "+q.to_s
        puts "Pan setting for s1 is: "+ppos.to_s
      end
      if repetitions==1 then #switch on fade for last repetition
        fade=1
        acount=(2*scale(0,n).length) #store number of notes
      end
      #control audio level if fade==1
      control lev,amp: startlevel*(1-(tick(:dim)).to_f/acount) if spread(p[0],p[1]).look and fade==1 and look(:dim) !=acount

      #play the next scale note from s1
      play 60+offset1+(s1.tick(:s1tick)),release: 0.4,pan: ppos if spread(p[0],p[1]).look
      #play the next scale note from s2
      play 72+offset2+(s2.tick(:s2tick)),release: 0.4,pan: ppos*(-1) if spread(q[0],q[1]).look

      sleep 0.12 #sets time between notes
    end #live_loop
  end#reverb
end#level
