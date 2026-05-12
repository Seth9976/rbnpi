#Sonic Pi playing with beats by Robin Newman January 2016
#tested on SP 2.9 on Pi2 and Mac.
#will work on SP2.7 but will have to remove some synths which are not available there
#on SP 2.10dev can add synth dtri
use_random_seed 9999 #try changing seed for different versions

#can run continuously, but set to fade out and stop after 40 iterations here
define :beats do |f,shift,t|
  pan=rrand(-0.9,0.9)
  p=play hz_to_midi(f),attack: t*0.05, sustain: t*0.9,release: t*0.04,pan: pan
  play hz_to_midi(f),attack: t*0.05, sustain: t*0.9,release: t*0.04,pan: pan
  in_thread do  #do in thread so function duration is effectively 0
    control p,note: hz_to_midi(f+shift),note_slide: t.to_f/2
    sleep t.to_f/2
    control p,note: hz_to_midi(f),note_slide: t.to_f/2
  end
end

#beatsym varies two frequencies symmetrically from f, up and down by shift
define :beatsym do |f,shift,t|
  pan=rrand(-0.9,0.9)
  p=play hz_to_midi(f),attack: t*0.05, sustain: t*0.9,release: t*0.04,pan: pan
  s=play hz_to_midi(f),attack: t*0.05, sustain: t*0.9,release: t*0.04,pan: pan
  in_thread do  #do in thread so function duration is effectively 0
    control p,note: hz_to_midi(f-shift),note_slide: t.to_f/2
    sleep t.to_f/2
    control p,note: hz_to_midi(f),note_slide: t.to_f/2
  end
  in_thread do #do in thread so function duration is effectively 0
    control s, note: hz_to_midi(f+shift),note_slide: t.to_f/2
    sleep t.to_f/2
    control s, note: hz_to_midi(f),note_slide: t.to_f/2
  end
end

with_fx :reverb,room: 0.8 do
  with_fx :level do |v|
    control v, amp: 1#set starting volume

    live_loop :beating do
      #beats keeps one freq fixed at f, and varies the other up and down by shift

      #choose f,shift,t and the synth on each pass

      tick
      syn= [:blade,:dpulse,:pulse,:sine,:tri,:saw,:dsaw].choose
      use_synth syn

      f=[440,880,220].choose
      tr= [-5,0,0,7].choose #transpose in semitones
      f=f*pitch_to_ratio(tr) #select required frequency using pitch_to_ratio
      shift=[-10,10,20,-20,40,-40].choose #beats shift
      t=[1.5,3,5].choose #choose next duration
      beats(f,shift,t) if look%2 == 0 #choose beats or beatsym in turn
      beatsym(f,shift,t) if look%2 == 1
      sleep t #allow time for tones initiated in the function calls to complete
      if look >= 20 #start fading out after 20 passes
        control v, amp: (30-look).to_f/10
      end
      stop if look == 30 #stop when faded out
    end
  end
end