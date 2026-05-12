#streamlined program to produce sample voices, by Robin Newman , March 2015
#uses two built in samples :ambi_glass_rub, and :ambi_glass_hum as examples

inst=[] #array of instruments
samplepitch=[] #array of natural pitches of the samples
inst[0]=:ambi_glass_rub#first chosen instrument
samplepitch[0]=:fs5 #natural pitch of the sample instrument
inst[1]= :ambi_glass_hum #second chosen instrument
samplepitch[1]=:a3 #natural pitch of second instrument


#prior to the release of version 2.5 you need the next function
#if you get an error message saying it exists then delete it or comment it out
comment do
  define :pitch_ratio do |n|
    return 2**(n.to_f/12)
  end
end

#this function plays the sample at the relevant pitch for the note desired
#the note duration is used to set up the envelope parameters
define :pl do |inst,samplepitch,nv,dv|
  shift=note(nv)-note(samplepitch)
  sample inst,rate: (pitch_ratio shift),sustain: 0.8*dv,release: 0.2*dv
end

#this function plays an array of notes and associated array of durations
#Uses sample name (inst), sample (normal) pitch, and shift (transpose) parameters
define :plarray do |inst,samplepitch,narray,darray,shift=0|
  narray.zip(darray) do |nv,dv|
    if nv != :r
      pl(inst,samplepitch,note(nv)+shift,dv)
    end
    sleep dv
  end
end

#this function will play a list of notes as a chord for the duration d specified. Optional transpose shift
define :plchord do |inst,samplepitch,nlist,d,shift=0|
  nlist.each do |n|
    pl(inst,samplepitch,note(n)+shift,d)
  end
  sleep d
end
#to illustrate the use of the voice we will play the round Row, Row,Row the Boat, and finish it with a chord
#first create some variable containing note durations
q=0.15 #quaver.  Adjust value to change tempo
c=2*q  #crotchet
cd=c*1.5 #dotted crotchet
b=4*c #breve

#set up a list of notes and of durations for the tune
notes=[:c4,:c4,:c4,:d4,:e4,:e4,:d4,:e4,:f4,:g4,:c5,:c5,:c5]
notes.concat [:g4,:g4,:g4,:e4,:e4,:e4,:c4,:c4,:c4,:g4,:f4,:e4,:d4,:c4]
dur=[cd,cd,c,q,cd,c,q,c,q,cd*2,q,q,q,q,q,q,q,q,q,q,q,q,c,q,c,q,cd*2]
0.upto(1) do |i|
2.times do #play the round twice. Put one part up an octave to make it stand out
  in_thread {plarray(inst[i],samplepitch[i],notes,dur,5)} #transposed up 5 semitones
  sleep 4*cd #round part separation
  in_thread {plarray(inst[i],samplepitch[i],notes,dur,17)} #transposed up 5 semitones plus an octave
  sleep 4*cd #round part separation
  in_thread {plarray(inst[i],samplepitch[i],notes,dur,5)} #transposed up 5 semitones
  sleep 4*cd #round part separation
end
sleep 12*cd #allows fina part to finish

#play four chords
plchord(inst[i],samplepitch[i],[:c4,:e4,:g4,:c5],c,5) #all transposed up 5 semitones to match the tune
plchord(inst[i],samplepitch[i],[:e4,:g4,:c5,:e5],c,5)
plchord(inst[i],samplepitch[i],[:g4,:c5,:e5,:g5],c,5)
plchord(inst[i],samplepitch[i],[:c5,:e5,:g5,:c6],b,5)
end
#from this starter program I have developed one which sets up 5 voices and which plays 25 different rounds!