#sparkling tom-toms by Robin Newman June 2015
#A couple of live loops one producing rhythms based on tom-toms using Xav Riley's binary pattern idea
#see https://gist.github.com/xavriley Binary Rhythms
#the other producing a sparkling range of notes utilising Xav's note_range function (in 2.6dev)
#note_range function included explicitly in code here so it works on sp 2.5 Remove def note_range if run on 2.6

#remove next function if running on sp 2.6dev or later
def note_range(low_note, high_note, options={})
  low_note = Note.resolve_midi_note(low_note)
  high_note = Note.resolve_midi_note(high_note)
 
  potential_note_range = Range.new(low_note, high_note)
 
  if options[:pitches]
    pitch_classes = options[:pitches].map {|x| Note.resolve_note_name(x) }
 
    note_pool = potential_note_range.select {|n|
      pitch_classes.include? Note.resolve_note_name(n)
    }
  else
    note_pool = potential_note_range
  end
 
  (ring *note_pool)
end


live_loop :rhythm do
  rng=[[8,12],[12,16],[8,16],[1,16]] #range selections for num
  n=rrand_i(0,2) #choose a range
  16.times do #use selected range 16 times
    num =range(rng[n][0],rng[n][1]).choose #choose num from selected range

    pattern = sprintf("%b", num).rjust(4, '0').chars.map(&:to_i) #convert to pattern of 4 1-0 numbers
    rate = (ring 0.8,3.2,6.4,1.2,1.6).choose #choose rate to play samples

    puts num #print number and pattern on screen
    puts pattern

    sample :bd_haus,amp: 2 #play main beat
    pattern.each do |b| #play a selected tom-tom when pattern has a "1"
      sample ring(:drum_tom_lo_hard,:drum_tom_hi_hard,:drum_tom_mid_hard).choose, rate: rate if b == 1
      sleep 0.125
    end
  end
end
with_fx :reverb do
  live_loop :notes do
    sync :rhythm #sync to rhythm
    base=scale(:c,:major).choose #choose root note
    8.times do #use selected root note 8 times
      num=rrand_i(1,7) #choose chord degree number (1-7)
      8.times do #play 8 notes from selected chord degree within note range (2 octaves)
        play (note_range base,base+24, pitches: chord_degree(num,base,:major)).choose,release: 0.125,pan: [-0.5,0,0.5].choose
        sleep 0.125
      end
    end
  end
end