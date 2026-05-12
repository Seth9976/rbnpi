#program to investigate the new pitch_shift effect
#You can use external or internal samples
#you need to know, (or find by experiment) the native pitch of the sample#

#use_sample_pack '/Users/rbn/Desktop/Samples/clarinet'

inst=:ambi_glass_rub #sets the sample to use
samplepitch=:fs5 #native pitch of the sample: find by experiment by playing a synth to get the same pitch

#np lets you play a note at the required pitch for the sample
#it calculates the offset and plays the sample using fx :pitch_shift
#paramters ws (window_shift) and env (whether or not you add an envelope) are adjusted for best effect
define :np  do |nv,dv,ws=0.2,env=1|
  if nv != :r then
    sh=note(nv)-note(samplepitch)
    puts nv
    puts sh
    with_fx :pitch_shift,window_size: ws  do |ps|
      control ps, pitch: sh
      if env == 1 then
        sample inst,sustain: 0.9*dv,release: 0.1*dv
        puts "with env"
      else
        sample inst
        puts "no env"
      end
    end
  end
  sleep dv
end

#plarray uses an array of notes and corresponding array of durations to play a tune
define :plarray do |notes,durations,ws=0.1,env=1,shift=0|
  notes.zip(durations).each do |n,d|
    if n!= :r then #doesn't play if note is a rest
      np(note(n)+shift,d,ws,env)
    else
      sleep d
    end
  end
end

#music bits below

#below we have the tune for frere jaques
#first the notes
n=[:c4,:d4,:e4,:c4]*2
n.concat [:e4,:f4,:g4]*2
n.concat [:g4,:a4,:g4,:f4,:e4,:c4]*2
n.concat [:c4,:g3,:c4]*2
#these variables set the durations for quaver, crotchet and minum
q=0.2
c=2*q
m=2*c

#now the duration array
d=[c]*8
d.concat [c,c,m]*2
d.concat [q,q,q,q,c,c]*2
d.concat [c,c,m]*2
#play it
plarray(n,d,0.2,1) #adjust ws (third parameter) and env (fourth parameter) for best sound



define :round do
  oct=[12,0,-12,0]
  0.upto(3) do |i|
    in_thread {plarray(n,d,0.2,1,oct[i])}
    sleep c*8
  end
  sleep c*8*3 #let last thread complete
end

round