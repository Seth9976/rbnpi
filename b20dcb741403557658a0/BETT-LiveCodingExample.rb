#Live coding example by Robin Newman, December 2014
#uncomment then run each of the five commented lines in the program below
#to add one by one the samples and play commands
#try altering the chords or synths chosen for further effects
#remember to press run to bring changes into effect


set_sched_ahead_time! 0.5
live_loop :d, auto_cue: false do
  #sample :bd_zome
  sleep 0.4
  #sample :bd_sone
  sleep 0.2
  #sample :bd_sone
  sleep 0.2
end

with_fx :reverb,room: 0.8 do
  live_loop :m,auto_cue: false do
    use_synth :supersaw
    #play chord(:c5,:maj11).choose,release: rrand(0.2,0.5),pan: [-1,0,1].choose,amp: [0.3,0.5,1].choose
    sleep rrand(0.2,0.4)
    use_synth :dsaw
    #play chord(:a5,:minor).choose,release: rrand(0.2,0.5),pan: [-1,0,1].choose,amp: [0.3,0.5,1].choose
    sleep rrand(0.2,0.4)
  end
end