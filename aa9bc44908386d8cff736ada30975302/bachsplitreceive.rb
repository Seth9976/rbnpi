#experimental program to receive and play notes from SP on another machine
#using parameters attached to an OSC sync command.
#amended version removing accommodation of chord sending
#as this involves un-safe use of eval with a string argument.
#instead, chords can be processed at the sending end
#as per the second example BachSend2.rb

use_synth :piano
with_fx :reverb,room: 0.6 do
  live_loop :receive do
    s=sync "/waitforit"
    v=s[2]
    use_bpm v
    puts s[0] #received note data
    #if s[0].length > 3 #more than one note to play together
    #play eval(s[0]),sustain: s[1]*0.9,release: s[1]*0.1
    #else
    if s[0]!= "r"
      
      play s[0],sustain: s[1]*0.9,release: s[1]*0.1
    end
    #end
  end
end