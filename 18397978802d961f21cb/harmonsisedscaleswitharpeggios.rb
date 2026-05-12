#harmonised scales by Robin Newman June 2015 utilising invert_chord and note_range and tick functions from 2.6dev

mult=0;flag = 0 #flags to enable final rit
with_fx :reverb ,room: 0.7 do
  12.times do |m|# traverse 12 semitones as tonic
    with_transpose m do
      t=0.8 #basic note duration NB set as a real so division works later
      #lists for ascending and descending invert_chord sequences
      l1=[[:c4,:major,1],[:g4,:major,0],[:c4,:major,2],[:f4,:major,1],[:e4,:minor,2],[:f4,:major,2],[:g4,:major,2],[:c5,:major,1]]
      l2=[[:c5,:major,1],[:g4,:major,2],[:f4,:major,2],[:e4,:minor,2],[:f4,:major,1],[:c4,:major,2],[:b3,:dim,2],[:c4,:major,1]]
      use_synth :tri #synth for note emphasis and base parts
      in_thread do #scale note emphasis
        play_pattern_timed scale(:c4,:major),t,amp: 0.8,sustain:0.9*t,release: 0.1*t,pan: 0.7
      end
      with_synth :saw do #synth for arpeggio accompaniment
        in_thread do
          8.times do |k| #ascending chords
            8.times do #8 notes to fit so make durations 1/8th of basic pulse t
              play (note_range :c4,:c6, pitches: invert_chord(chord(l1[k][0],l1[k][1]),l1[k][2])).tick,amp: 0.6,sustain:0.9*t/8,release: 0.1*t/8
              sleep t/8
            end
          end
        end
      end
      #bass note
      play_pattern_timed [:c3,:g2,:c3,:a2,:e2,:f2,:g2,:c3],t,amp: 0.9,sustain:0.9*t,release: 0.1*t,pan: -0.7
      #trigger rit on arpeggio part on last time (m will be 11)
      if m == 11 then mult=1
      end
      in_thread do #descending scale note emphasis
        play_pattern_timed scale(:c4,:major).reverse,t,amp: 0.8,sustain: 0.9*t,release: 0.1*t,pan: 0.7
      end

      with_synth :saw do
        in_thread do #descending chords
          8.times do |k|
            8.times do |p|
              if mult == 1 and k == 7 then #trigger rit for last chord (when mult == 1 and k == 7)
                flag = 1
              end

              play (note_range :c4,:c6, pitches: invert_chord(chord(l2[k][0],l2[k][1]),l2[k][2])).tick,amp: 0.6,sustain: 0.9*(t/8+flag*p*t/48),release: 0.1*(t/8+flag*p*t/48)
              sleep (t/8+flag*p*t/48)
            end
          end
        end
        #descending scale bass notes
      end
      play_pattern_timed [:c3,:g2,:a2,:e2,:f2,:g2,:g2,:c3],t,amp: 0.9,sustain:0.9*t,release: 0.1*t,pan: -0.7
    end
  end
end