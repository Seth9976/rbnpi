#chordfrazzle by Robin Newman, March 2017
#This piece generates the notes in a randomly selected chord type, and then plays them ascending....
#interspersed with the same sequence rising
#The base note, synth, volume and pan positions of the notes are selected at random for each chord
#certain synths are excluded (mainly "noise" types)
#In this version the live loop is faded out after 110 seconds and then stopped.
use_debug false
duration=110
killit=0
with_fx :level do |fade|
  control fade,amp: 1
  in_thread do
    sleep duration
    100.times do |f|
      control fade,amp: 1-0.01*f
      sleep 0.1
    end
    #leave last chord sequence to complete at amp: 0.01
    killit=1
  end
  
  with_fx :gverb,room: 20,mix: 0.4 do #to give a bit of depth
    live_loop :chordfrazzle do
      stop if killit==1 #stops cleanly when flag is set before next chord group starts
      syn=synth_names.choose #choose synth excluding some (noise related, or very quiet ones)
      while [:chipnoise,:noise,:bnoise,:cnoise,:gnoise,:pnoise,:growl,:dark_ambience,:sound_in,:sound_in_stereo].include? syn
        syn=synth_names.choose
      end
      puts "Current synth "+syn.to_s
      use_synth syn
      currentchord=chord_names.choose
      puts "Current chord "+currentchord.to_s
      notes=chord(currentchord) #choose chord type
      notes2=notes.reverse #save reverse sequence
      
      l=notes.length
      puts "chord length="+l.to_s
      
      basenote=rrand_i(48,72) #choose base note for chord
      puts "basenote="+basenote.to_s
      
      use_bpm [50,80,80,90,90].choose #vary tempo...
      puts "Current bpm "+current_bpm.to_s
      
      vol=[0.2,0.2,0.3,0.5,0.5,0.7,0.7,1.0].choose #and volume
      puts "amp: "+vol.to_s
      
      panshift=[-0.67,-0.3,0.3,0.67].choose
      puts "panshift="+panshift.to_s
      
      tick_reset
      (2*l).times do #play through notes twice
        tick
        play basenote+notes.look,sustain: 0.1,release: 0.1,cutoff: 100,pan: panshift-0.2,amp: vol
        sleep 0.1
        play basenote+notes2.look,sustain: 0.1,release: 0.1,cutoff: 100,pan: panshift+0.2,amp: vol
        sleep 0.1
      end
    end
    
  end #fx
end #level