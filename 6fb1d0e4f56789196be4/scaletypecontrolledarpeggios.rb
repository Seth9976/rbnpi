#loading...#scaletypecontrolledarpeggios.rb by Robin Newman, July 2015. Requires sp2.6

#A study using arpeggios with different scale formats. Also utilising rings and ticks
#This was a great exercise to explore different Sonic Pi (and Ruby) commands
#eg tick, look, ring, note_range for SP and string manipulation commands and eval for Ruby to mention some.
#First of all in the defined procedures which enable you to extract info about different scale types
#and to generate the rings required for the piece to work.

#Basically the code generates a pool of notes for three separate chords and then transposes those notes
#using notes 0,3,4 and 4 (down an octave) for each of the distinct 8 note scales supported in Sonic Pi
#The analysis finds there are 5 distinct ones, although there are some duplicate scaletypes that give the same notes
#The notes from each chord in the range :c3 to :b4 are selected using the notes_range command added to SP2.6
#IN each case there will be 6 and they are played as an arpeggio using a look command to extract each one in turn.

#These 6 notes are repeated applying each of the 4 transpositions for each of the 5 scale types in turn for each chord.
#This gives a total of 6 * 4 * 5 * 3 = 180 notes for the complete cycle
#The code lets you specify how many cycles to play.
#The last time through an "endgame" coda is played consisting of the first chord with the diatonic transpositions applied
#followed by the starting note :c3
#To add a little interest, the initial note of each 6 is played at a louder amplitude and for a longer duration
#Also a decrescendo is applied during the first half (180) notes of each cycle followed by a crescendo
#over the following 180 notes in the second half of the cycle

#I have enjoyed the maths and the anaylsis of this piece and devising the code to perform it. I hope you like it!

#play it with a wide log window to see a printout of what is happening.

use_synth :piano #use the piano synth throughout

define :snames do #Get ring of all scale types containing 8 notes
  snames="(ring "
  scale_names.each do |s|
    snames += ":"+s.to_s+"," if scale(:c,s).length == 8
  end
  snames=snames[0..-2]+")"
  return eval(snames)
end
puts "typical outputs of the 4 functions defined are shwon below for interest:"
puts snames #output

define :offsets do |s| #create a ring for a scale type consisting of notes numbers 0,3,4,4( down an octave)
  return (ring 0,s[3]-s[0],s[4]-s[0],s[4]-s[0]-12)
end

puts offsets(scale(:c,:major)) #output

define :selectednames do #create a ring of all scales in snames with a unique offsets
  test=[]
  selectednames="(ring "
  snames.each do |s|
    if !test.include? offsets(scale(:c,s)) then #check offset isn't included already
      test.concat [offsets(scale(:c,s))] #if not add it to test list
      selectednames +=":"+s.to_s+","#and add scale to selectednames
    end
  end
  selectednames=selectednames[0..-2]+")" #omit last comma and add final clsoig bracket
  return eval(selectednames) #eval to generate ring and return it
end

puts selectednames #output

define :sring do #create a ring of the offs produces by the scales which are in selectednames
  test=[]
  sring="(ring "
  selectednames.each do |s|
    sring +=offsets(scale(:c,s)).to_s+","
  end
  sring=sring[0..-2]+")"
  return eval(sring)
end

puts sring #output
sleep 6 #to allow function putputs to be looked at

#start the main program here
with_fx :level do |amp| #use level control to fade out at the end, using live_loop :audiocontrol
  control amp,amp: 1 #set intial levl to amp: 1

  live_loop :arpeggios do
    t=0.12 #set main note duration and loop sleep time
    tick #use ticks and looks for selection
    tick_set :tr,look/6 #this tick controls transpose setting trans NB these must all be integer division to work
    tick_set :sr,look/24 #this tick controls currentring selection
    tick_set :ch,look/120 #this tick controls chord ch selection
    tick_set :finished,look/360 #this increases each time the music sequence starts

    numberofplays = 2 #set to the number of complete tune "plays" required

    ####### next section deals with endgame after required number of complete "plays" of the tune ##########
    if look(:finished) == numberofplays and (look % 360 == 0) then       #set up endgame
      tick_set :end, 1
      tick_set :num, look(:sr)
    end
    #loop continues for one more play of first chord with first ring (:diatonic)
    #i.e. until look(:sr) increases by 1
    if look(:end) == 1 and (look(:sr)-look(:num)) == 1 then #do endgame
      puts "Play final note: 48"
      play :c3, sustain: 4*t,release: 2*t,amp: 1.5 #play final note
      sleep 6*t #sleep for duration of note
      stop
    end
    ######## end of endgame section #####################

    currentring = sring.look(:sr) #select the ring to use
    currentname=selectednames.look(:sr) #select the current scale name
    trans=currentring.look(:tr) #select the current transpostion from the selected offset
    ch=(ring [:c,:e,:g],[:c,:f,:ab],[:c,:g,:bb]).look(:ch) #select the chord to use
    with_transpose trans do #set the transpostion
      notes=note_range(:c3,:bb4,pitches: ch).look #get the next note
      #next line prints the data for the next note to play
      puts "chord: "+ch.to_s+" scale: "+currentname.to_s+" ring: "+currentring.to_s+" trans "+trans.to_s+" note: "+notes.to_s
      #notes 2 to 6 using the current settings played by the enxt line
      play notes,amp: 0.8,sustain: t*0.9,release: t*0.1  if (bools 0,1,1,1,1,1)
      #first note of the current setting played with greater volume and duration for emphasis
      play notes,amp: 1.5,sustain: t*1.2,release: t*0.5  if !(bools 0,1,1,1,1,1)
    end #finish transposition
    sleep t #sleep before next loop pass
  end

  live_loop :audiocontrol do #fades the audio level down to 20% and up to 100% during each "play" of the tune
    t=0.12 #set loop sleep time
    180.times do #tune lasts 360 ticks, so 180 takes you half way
      control amp,amp: 1 - (tick%180).to_f/225 #reduce amp: to 0.20 over this loop NB floating point division needed here
      sleep t
    end
    180.times do
      control amp,amp: 0.2 + (tick%180).to_f/225 #increase amp: from 0.20 to 1 over this loop NB floating point needed
      sleep t
    end
  end
end