#Tribute to Pachabel coded for Sonic Pi by Robin Newman January 2015

define :ntosym do |n| #converts note number to symbol: no input error checking
  @note=n % 12
  @octave = n / 12 - 1
  lookup_notes = {
    0  => :c,
    1  => :cs,
    2  => :d,
    3  => :ds,
    4  => :e,
    5  => :f,
    6  => :fs,
    7  => :g,
    8  => :gs,
    9  => :a,
    10 => :as,
  11 => :b}
  return (lookup_notes[@note].to_s + @octave.to_s).to_sym
end

define :tr do |nv,sh| #transposes note nv by shift sh
  return ntosym(note(nv)+sh)
end

with_fx :reverb ,mix: 0.4 do
  #set up range of syths and bpm multipliers to use
  performance=[[:tri,1],[:pulse,1.2],[:saw,1.4],[:dsaw,1.6],[:fm,1],[:tb303,0.75]]
  performance.each do |p|
    with_synth p[0] do
      with_bpm 60 * p[1] do #from ver 2.3 use with_bpm_mul instead
        #define the chord progression
        c=[[:d4,:major],[:a3,:major],[:b3,:minor],[:fs3,:minor],[:g4,:major],[:d4,:major],[:g4,:major],[:a4,:major]]
        c.each do |c|
          play chord(c[0],c[1]),attack: 0.125,release: 0.875 #play the basic chord
          sleep 1
          8.times do #play arpeggio like accompaniment based on the chord
            #choose chord base from three octaves, and then choose note from that chord
            play chord([c[0],tr(c[0],-12),tr(c[0],+12)].choose,c[1]).choose,attack: 0.125,release: 0.125
            sleep 0.25
          end
        end
      end
    end
  end
  with_synth performance[-1][0] do #use last set of values in performance list
    with_bpm 60 * performance[-1][1] do #from ver 2.3 use with_bpm_mul instead
      play [:d4,:fs4,:a4,:d5],attack: 0.125,sustain: 1,release: 0.875
    end
  end
end