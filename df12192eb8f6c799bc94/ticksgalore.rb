#ticksgalore.rb by Robin Newman, July 2015
#features use of multiple ticks and the spread function
#requires 2.6dev commit 20b3b577de4ae33cff3fecae3f6462881c3a2d59 or later (July 8th)
use_cue_logging false
with_fx :level do |amp| #volume is faded up over 20 secs, and 160 secs later faded down to 0
  control amp,amp: 0
  sleep 0.1 #allow time to settle to 0

  live_loop :tune do
    tick_set :st, (tick+1)/13 #set a tick :st going at 1/6th loop rate
    tick_set :h, (look)/60 #set a tick :h going at 1/60th loop rate
    tick_set :p, (look)/120 #set a tick :p going at 1/120th loop rate
    use_synth (ring :piano,:fm,:supersaw,:tb303,:prophet).tick(:p)
    hchoose=range(0,4).tick(:h) #choose base note offset 0 to 3 every 60 passes of loop
    nt=ring(:c4,:f4,:g4,:g3)[hchoose] #choose new base note every 60 passes of loop
    st=(range 1,13).tick(:st) #choose new step 1-12 for spread every 6 passes of loop
    puts look.to_s+" "+ look(:st).to_s+" "+st.to_s+" "+hchoose.to_s
    play scale(nt,:minor_pentatonic,num_octaves: 2).choose,release: 0.25,pan: -1 if (spread 6,13).tick(:n,step: st)
    #next play command uses inverted spread, so sounds when first note doesn't
    play scale(nt+5,:minor_pentatonic,num_octaves: 2).choose,release: 0.25,pan: 1 if !(spread 6,13).look(:n)
    sleep 0.125
    if look == 960 then stop #stop after 120 seconds
    end
  end

  live_loop :beat do
    sync :tune
    sample :bd_haus,amp: 0.8 if (spread 6,13).tick
    sample [:drum_tom_mid_soft,:drum_tom_lo_soft,:drum_tom_hi_soft].choose,amp: 2 if !(spread 6,13).look
    sleep 0.25
    if look == 480 then stop #stop after 120 seconds
    end
  end
  #now deal with fading volume up at start, and down at the end
  200.times do #20 sec loop
    control amp,amp: tick.to_f/200
    sleep 0.1
  end
  sleep 80 #maintain full volume here
  tick_reset
  200.times do #20 sec loop
    control amp,amp: 1-tick.to_f/200
    sleep 0.1
  end
  #total time 120 secs
  #set up stops in live loops to suit
end