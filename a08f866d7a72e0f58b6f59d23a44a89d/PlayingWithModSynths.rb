#fun with mod synths by Robin Newman, December 2016
with_fx :level do |vol|  #extra section to give 2 minute "performance"
  killit=0 #used to stop live_loop after 2 minutes
  control vol,amp: 0
  sleep 0.1 #settle time to prevent clicks
  in_thread do #fade in at start and out at the end
    control vol,amp: 1,amp_slide: 2
    sleep 117.9
    control vol,amp: 0,amp_slide: 2
    killit=1 #flag live_loop to stop
  end
  with_fx :reverb, room: 0.8,mix: 0.8 do
    live_loop :wow do
      d=2*rrand_i(1,5) #set duration of live loop (2* makes sure d/0.2 works later on)
      use_bpm rrand_i(40,120) #choose tempo
      with_fx :level do |v| #prevents clicks as liveloop replays
        in_thread do
          control v,amp: 0
          sleep 0.1
          control v,amp: 1,amp_slide: 1
          sleep d-0.1
          control v,amp: 0,amp_slide: 1 #cross fades give smooth transition as loop restarts
        end
        #set up note to be controlled, choosing one of the mod synths
        sy=[:mod_beep,:mod_dsaw,:mod_fm,:mod_pulse,:mod_saw,:mod_tri].choose
        basenote=scale(:c,:minor_pentatonic).tick
        s=synth sy,note: basenote ,mod_phase: 1, mod_range: 1,mod_range_slide: 0.1,mod_wave: 3,sustain: d,pan: (-1)**look
        puts "synth: "+sy.to_s+" basenote: "+basenote.to_s
        (d/0.2).times do #control range parameter, and its slide time
          control s,mod_range: rrand(0,24),mod_range_slide: rrand(0.1,0.2)
          sleep 0.2
          stop if killit==1 #check if time to stop live_loop
        end #times loop
      end #live_loop level fx
    end #live_loop
  end #reverb fx
end #overall fx :level vol envelope for "2 min performance"