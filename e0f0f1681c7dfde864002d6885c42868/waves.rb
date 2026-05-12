#Waves: a piece for Sonic Pi by Robin Newman, March 2018
set :kill,false;set :killmetro,false
live_loop :timing do
  use_bpm 60
  set :bpm,(ring 30,20,100,60,120,80).tick
  sleep 10
  if look==11
    set :kill,true
    stop
  end
end

with_fx :gverb, room: 25,mix: 0.6 do
  with_fx :level,amp: 0.05 do |v1|
    in_thread do
      loop do
        sync :metro
        stop if get(:kill)
        use_bpm get(:bpm)
        control v1,amp: 1,amp_slide: 4.5
        sleep 9
        control v1,amp: 0.1,amp_slide: 4.5
        sleep 4.5
      end
    end
    
    with_fx :level do |v|
      in_thread do
        loop do
          stop if get(:kill)
          sync :metro
          use_bpm get(:bpm)
          control v,amp: rrand(0.2,1)
          sleep 0.4
          
        end
      end
      live_loop :metro do
        use_bpm get(:bpm)
        sleep 0.2
        stop if get(:killmetro)
      end
      live_loop :x,sync: :metro do
        if get(:kill)
          set :killmetro,true
          stop
        end
        
        use_bpm get(:bpm)
        use_synth :tb303
        x=(range 1,24).choose
        t=x+35;t2=60-x
        sc=scale_names.choose
        k1=spread(5,8)
        k2=spread(8,13)
        k3=spread(7,11)
        k4=spread(11,17)
        s1=[k1,k2,k3,k4].choose
        s2=[k1,k2,k3,k4].choose
        18.times do
          n=(scale t,sc,num_octaves: 2)
          n2=(scale t2,sc,mu_octaves: 2)
          p=(-1)**dice(2)
          sample :bd_haus,amp: 0.6 if !s1.tick
          play n.choose,release: 0.125,cutoff: rrand(72,110),amp: 0.2,pan: p if s1.look
          sample :drum_cymbal_pedal,amp: 0.6 if s2.look
          play n2.choose,release: 0.125,cutoff: rrand(72,110),amp: 0.2,pan: -p if !s2.look
          sleep 0.125
        end
      end
    end
    
    live_loop :emphasis,sync: :metro do
      stop if get(:kill)
      use_bpm get(:bpm)
      sample :drum_heavy_kick,amp: 1.5
      sleep 2.25
    end
  end
end
