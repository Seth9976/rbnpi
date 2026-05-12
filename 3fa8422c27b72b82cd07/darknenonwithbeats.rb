#a piece using Sam Aaron's Dark_Neon combined with my Beats

v = version.to_s #get version as a string
puts "Running on version " + v

if (v.include? "2.7") != true then #check if version 2.7 or 2.7dev and define rato_to_pitch if not
  define :ratio_to_pitch do |r| #remove this definition once ratio_to_+pitch is included in SP
    return 12.0 * Math.log2(r.to_f)
  end
end

#Dark_Neon
# Coded by Sam Aaron

live_loop :foo do
  sample :bd_haus, amp: 5, cutoff: 50, amp: 5, release: 0.1
  sleep 0.5
end

live_loop :mel do
  with_fx :wobble, phase: 1, invert_wave: 1, wave: 0, cutoff_max: 80, cutoff_min: 60 do
    synth :blade, note: :cs1, release: 4, cutoff: 110, amp: 1, pitch_shift: 0
  end
  with_fx :reverb, room: 1 do
    with_fx :bitcrusher, mix: 0.4 do
      sample :bass_trance_c, rate: 0.5, pitch: 0, window_size: 0.125, time_dis: 0.125, amp: 8, release: 0.2
    end
  end
  sleep 4
end

#following code Beats coded by Robin Newman

sleep 4 if (v.include? "2.7") != true #sleep if version <2.7
live_loop :beats ,delay: 4 do  #use new delay param in 2.7dev: ignored if not active
  #use_synth [:dsaw,:prophet,:tb303].choose
  use_synth :sine
  puts "beats start"
  with_fx :reverb,room: 0.4 do
    b= (ring :c3,:c4).tick
    s=play b,attack: 0.04,sustain: 24,release: 1,amp: 8 #start two identical notes
    p=play b,attack: 0.04,sustain: 24,release: 1,amp: 8 #each lasts about 24 seconds

    120.times do |i| #raise pitches by 12 (1 octave) over 120 steps
      control s,note: (note(b)+ratio_to_pitch(1+i.to_f/120)),note_slide: 0.1 #control with ratio_pitch
      control p,note: (note(b)+12*i.to_f/120),note_slide: 0.1 #linear control
      sleep 0.1
    end
    120.times do |i| #reduce pitches back to starting values
      control s,note: (note(b)+ratio_to_pitch(1+(120-i).to_f/120)),note_slide: 0.1
      control p,note: (note(b)+12*(120-i).to_f/120),note_slide: 0.1
      sleep 0.1
    end
  end
  puts "beats end"
  sleep 4
end