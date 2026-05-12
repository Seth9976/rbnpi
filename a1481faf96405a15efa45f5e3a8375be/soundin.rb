with_fx :reverb,room: 0.8 do
  live_loop :playback do
    with_fx :gverb do
      with_fx :panslicer do
        synth :sound_in,sustain: 4,amp: 2
        sleep 4
      end
    end
  end
end