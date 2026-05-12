#ambiglassrhythms.rb by Robin Newman, July 2015
#further exploration into using the spread and tick functions to generate rhythms and note patterns

live_loop :beat do
  #first set up data values for the loop

  num=1 #number of loop passes before stopping: adjust as desired

  d = 0.2 #sets the overall pulse speed

  offset=ring(0,2,4,5,7,9,11,12) #semitone offsets for a major scale which produces the tune
  offset2 =ring(0,-5,0,-3,-8,-7,-5,0) #semitone offsets for accompanying part to the scale
  #The pitch_to_ratio function will be used to generate the notes using :ambi_glass_rubbed sample

  c=(ring [3,5],[7,15],[7,10],[9,20],[11,15]) #choice of spread patterns sected in the pice
 #you can try differnt values. I made all the second numbers a mutliple of 5 
tr=(ring 0,5,7,-5,0) #transposition offsets used in the piece

  tick(:num_loop_passes) #increment the counter for number of loop passes (first call gives 0)
  tick_reset #reset main tick each time round live_loop

  #now start doing things. Use three nested loops
  #the out loop controls transposition of the melody and accompaniment
  #The middle loop selects the next sporead function to be used from ring c
  #The inner loop traverses the current spread and plays the percussion and notes accordingly

  print "Start of live_loop pass number "+(look(:num_loop_passes)+1).to_s+"\n"
  5.times do #this loop controls the transpostion offset 
    tick #increments the next transpose setting
    trans=tr.look #select the next setting from the transpose ring


    #
    tick_set :spchoose,0 #initialise :spchoose tick to select spreads data
    c.length.times do #loop round the different spread setting in this loop

      inv = 0 #variable to control inversion of the spread output

      tick(:spchoose) #bump tick for next spread choice
      k=c.look(:spchoose)[0] #select two parameters for next spread eg spread(k,l)
      l=c.look(:spchoose)[1]
      puts "spread("+k.to_s+","+l.to_s+") transpose "+trans.to_s #print current settings

      tick_set :spvalue,0 #initialise :spvalue tick to get next true/false from current spread and next note to play


      (2*l).times do
        tick(:spvalue)
        print "spread invert off" if (look(:spvalue) == 1)
        inv = 1 if (look(:spvalue) == l) #used to invert spread values after first l passes through the loop and repeat another l times
        print "spread invert on" if ( look(:spvalue) == l)

        #rhythm section

        sample :bd_haus if spread(k,l).look(:spvalue) #play drum according to current spread
        sample :drum_cymbal_closed if !spread(k,l).look(:spvalue) #play cymbal using inverted current spread

        #notes section
        #if inv == 0 then following lines apply

        #Select next melody note using offset and current transpose value. Pitch calculated with pitch_to_ratio function...
        #...play it according to current spread value.
        sample :ambi_glass_rub,rate: pitch_to_ratio(offset.look(:spvalue)+trans),sustain: d,release: d if spread(k,l).look(:spvalue) and inv == 0
        #select next harmony note using offset2 and current transpose value. Pitch calculated with pitch_to_ratio function...
        #...play it according to current spread value. (it is played an octave low)
        sample :ambi_glass_rub,rate: pitch_to_ratio(offset2.look(:spvalue)-12+trans),sustain: d,release: d if spread(k,l).look(:spvalue) and inv == 0

        #if inv == 1 then the following lines apply, identical to the inv == 0 lines except that .....
        #the spread values are inverted eg using !spread(k,l) instead of spread(k,l)

        sample :ambi_glass_rub,rate: pitch_to_ratio(offset.look(:spvalue)+trans),sustain: d,release: d if !spread(k,l).look(:spvalue) and inv == 1
        sample :ambi_glass_rub,rate: pitch_to_ratio(offset2.look(:spvalue)-12+trans),sustain: d,release: d if !spread(k,l).look(:spvalue) and inv == 1

        sleep d #sleep for basic pulse length
      end
    end
  end
  sample :bd_haus
  sample :ambi_glass_rub,sustain: 4*d,release: d
  sleep 10*d
  puts "finish pattern "+(look(:num_loop_passes)+1).to_s
  sleep 5*d

  stop if look(:num_loop_passes)+1 == num #otherwise restart loop
end