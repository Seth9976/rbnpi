#JazzedupInversions by Robin Newman, August 2020
#started playing with chord inversions and ended up with this.
#corrected for current with_merged_synth_defaults bug in ver 3.2.2
use_bpm 60 #initial tempo
with_fx :reverb, room: 0.8,mix: 0.7 do
  with_fx :ixi_techno,mix: 0.4 do
    live_loop :arps do
      #code to speed up and slow down tempo again
      bpmchange=((knit 2,20)+(knit -4,10)).tick(:speed)
      use_bpm current_bpm + bpmchange
      #choose transposition for next sequence 3rd,4th,5th, or down a 5th
      use_transpose [0,4,5,7,-5].choose
      #choose synth for next chord sequence
      sn=[:tri,:beep,:saw,:pulse,:blade,:sine].choose
      #set up base note sequence
      l=[:c4,:f4,:g4,:c4]
      l=l.reverse if dice(2)==1 #randomly reverse sequence
      #puts l
      #choose chord type major, minor or open 5th
      ct=['M','m','5'].choose
      #play 4 note sequence based on values in l
      4.times do |p|
        z =[0,1].choose
        n=l[p] #choose base note
        #play bass note with FM synth duration 1.6
        synth :fm,note: n-12,release: 1.6,amp: 0.75
        #alternate pan of chord notes -1,1
        tick(:p)
        #initialise total time of notes
        total=0
        #play four inversions from chord
        4.times do |i|
          k=i #k holds inversion value
          k=4-i if p==3 #4th chord inversions played in reverse sequence (when p=3)
          #play arpegion of chord inversions
          #if z is 1 play all the inversions
          #if z is 0 select which to play with spread function
          puts "Base #{n} chord type #{ct} inversion #{k} z value #{z} bpm #{current_bpm}"
          synth sn,note: chord_invert(chord(n,ct),k),amp: z,pan: (-1)**look(:p)
          synth sn,note: chord_invert(chord(n,ct),k),amp: 1-z,pan: (-1)**look(:p) if spread(5,8).tick
          #select note timing 0.2 or 0.4
          st= [0.2,0.4].choose
          total+=st #update total time
          sleep st #sleep selected time
        end
        #puts total
        #sleep time to make up total to 1.6
        sleep 1.6-total
      end
      #puts current_bpm
      stop if current_bpm <62 #stop when bpm falls below 62
    end
  end
end