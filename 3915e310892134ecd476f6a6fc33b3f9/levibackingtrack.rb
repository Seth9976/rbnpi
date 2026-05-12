#backingtrack inspired by Levi Niha's video https://youtu.be/QGLPinGZhfg
#developed by Robin Newman, March 2018
use_bpm 72
#next section of code deals with stopping the track cleanly
#"at" command used for timing
#triggering the final drums and chord
no_cycles=3 #adjust for length required
set :kill,false
sleep 0.5
at no_cycles*16 do
  play :b7,release: 0.1 #produces end warning cue 1
end
at 11.5+16*no_cycles do
  play :b7,release: 0.1 #produces end warning cue 2
end
at 14.50+16*no_cycles do #triggers end stage and stops live loops
  set :kill,true
  cue :final
end
#following based on Levi's video
live_loop :dr1 do
  stop if get(:kill)
  sample :drum_heavy_kick
  sleep 0.5
end

live_loop :dr2,delay: 0.5 do
  stop if get(:kill)
  sample :drum_snare_hard
  sleep 1
end

live_loop :dr3,delay: 0.25 do
  stop if get(:kill)
  sample :drum_cymbal_closed
  sleep 0.5
end

live_loop :dr4 do
  stop if get(:kill)
  sample :drum_cymbal_open,amp: 0.2
  sleep 4
end

live_loop :dr5,delay: 3.9 do
  stop if get(:kill)
  sample :drum_snare_soft
  sleep 4
end

with_fx :reverb do
  live_loop :chrodprogression do
    use_synth :saw
    play chord :Db4, :minor
    sleep 1.75
    play chord :Db4, :minor
    sleep 0.5
    play chord :Db4, :minor
    sleep 1.75
    play chord :B3, :major
    sleep 1.75
    play chord :B3, :major
    sleep 0.5
    play chord :B3, :major
    sleep 1.75
    #added further chord progressions
    play chord_invert chord(:e3,:minor),1    
    sleep 1.75
    play chord_invert chord(:e3,:minor),1    
    sleep 0.5
    play chord_invert chord(:e3,:minor),1    
    sleep 1.75
    play chord_invert chord(:b2,:major),2
    sleep 1.75
    play chord_invert chord(:b2,:major),2
    sleep 0.5
    play chord_invert chord(:b2,:major),2
    sleep 1.75
    stop if get(:kill)
  end
end

live_loop :bassline do
  use_synth :fm
  play :Db2
  sleep 1.75
  play :Db2
  sleep 0.5
  play :Db2
  sleep 1.75
  play :B1
  sleep 1.75
  play :B1
  sleep 0.5
  play :B1
  sleep 1.25
  play :b2,release: 0.4
  sleep 0.25
  play :b1,release: 0.4
  sleep 0.25
  #extended bassline
  play :g2
  sleep 1.75
  play :g2
  sleep 0.5
  play :g2
  sleep 1.75
  play :gb2
  sleep 1.75
  play :gb2
  sleep 0.5
  play :gb2
  sleep 1.2
  stop if get(:kill) #so that this loop stops at correct place
  puts "here"
  sleep 0.05
  play :gb3,release: 0.4
  sleep 0.25
  play :gb2,release: 0.4
  sleep 0.25
end

with_fx :gverb do
  with_fx :wobble do
    live_loop :lead do
      use_synth :chiplead
      #extended lead pattern used
      5.times do
        play_pattern_timed chord(:Db5,:minor),0.25,amp: 0.2,release: 0.25
      end
      sleep 0.25
      5.times do
        play_pattern_timed chord(:b4,:major),0.25,amp: 0.2,release: 0.25
      end
      sleep 0.25
      5.times do
        play_pattern_timed chord_invert( chord(:e4,:minor),1),0.25,amp: 0.2,release: 0.25
      end
      sleep 0.25
      5.times do
        play_pattern_timed chord_invert( chord(:b3,:major),2),0.25,amp: 0.2,release: 0.25
        stop if get(:kill)
      end
      sleep 0.25
    end
  end
end


with_fx :reverb,room: 0.8 do
  live_loop :endit,sync: :final do #end sequence
    4.times do
      sample:bd_haus,amp: 2
      sleep 0.125
    end
    sample :drum_heavy_kick
    use_synth :chiplead
    play chord(:b1,:major),sustain: 2,release: 2
    use_synth :fm
    play :b1,sustain: 2,release: 2
    sleep 4
    stop #loop stopped after first pass
  end
end
