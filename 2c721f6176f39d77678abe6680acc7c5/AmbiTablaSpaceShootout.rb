use_random_seed 2468 #try different values
n= (sample_names :tabla).length
n2=(sample_names :ambi).length
#ramped volume change
vmap=[0,0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]
killit=0 #flag to kill live loops
with_fx :gverb,room: 25 do
  with_fx :level do |v| #fade volume in and out
    control v,amp: 0
    sleep 0.05 #settle time to prevent any initial click
    in_thread do
      20.times do |i| #increase volume phase
        puts i
        control v,amp: 4*vmap[i]
        sleep 1
      end
      sleep 40 #full volume phase
      20.times do |i| #decrease volume phase
        puts i
        control v,amp: 4*vmap[19-i]
        sleep 1
      end
      killit=1 #flag to stop live loops
    end
    
    live_loop :q do
      stop if killit==1
      k=rrand(1,5)
      sample "tabla_",range(0,n).choose.to_i,rate: -k,start: 0.1,sustain: 0.5/k,release: 0.3,pan: 1
      sleep 0.2+rrand(0,2)
    end
    live_loop :q2 do
      stop if killit==1
      k=rrand(1,5)
      sample "tabla_",tick,rate: -k,start: 0.1,sustain: 0.5/k,release: 0.3,pan: -1
      sleep 0.2+rrand(0,1)
    end
    live_loop :q3 do
      stop if killit==1
      k=rrand(1,5)
      sample "ambi_",range(0,n2).choose.to_i,rate: -k,start: 0.1,sustain: 0.5/k,release: 0.3,pan: [-1,0,1].choose
      sleep 0.2+rrand(0,1)
    end   
  end
end