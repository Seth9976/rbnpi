#rhythmicTB303 by Robin Newman, July 2017. (Requires SP 3)
#based on an idea by Xav Riley https://gist.github.com/xavriley/44b4908dc3573744928b099f51af772e

nv="/nv" #set up to use nv to transfer note using get and set
killit="/killit" #set up to use killit to transfer true or false using get and set
set killit,false #used to stop live_loops at the end
duration = 120 #desired duration for whole piece (min 20)
with_fx :level,amp: 0 do  |vl| #control volume level during the piece (max 0.5)
  at 0 {control vl,amp: 0.5,amp_slide: 10} #10second increase of volume 0 -> 0.5
  at duration-10 {control vl,amp: 0,amp_slide: 10}#start fade out 10 secs before end
  at duration-0 {set killit,true} #trigger stop loops (duration-0 forces it to evaluate)
  
  with_fx :reverb, room: 0.8,mix: 0.6 do
    live_loop :rightdrum do
      use_bpm 100
      bars = 2
      n= scale(:c4,:minor_pentatonic,num_octaves: 2).choose
      #adjust map contents to taste
      no_of_beats = [0.5,1.5,3,1.5].map {|x|
        [x, (4 * x.to_f)*bars]
      }.flatten
      count = (knit *no_of_beats).tick
      puts "count1",count
      sample  :elec_tick,pan: 1,rate: [0.5,1,2].choose,amp: 1
      synth :tb303,note: n,release: (1/count.to_f),cutoff: rrand(80,110),amp: 0.05,pan: -0.5
      set nv,n #save note for transfer to other live_loop
      sleep (1/count.to_f)
      stop if get(killit) #stop loop at the end
    end
    live_loop :leftdrum do
      use_bpm 200 #twice tempo of other live loop
      bars = 4 #double number of bars, so changes occur at same time as other loop
      #adjust map contents to taste
      #making the two maps differnt lengths allows progression
      no_of_beats = [1,1.125,0.25].map {|x|
        [x, (4 * x.to_f)*bars]
      }.flatten
      count = (knit *no_of_beats).tick
      puts "count2",count
      sample  :elec_tick,pan: -1,rate: [0.5,1,2].choose,amp: 1
      #retrieve and play current note from other live_loop using get. Play down an octave
      synth :tb303,note: get(nv)-12,release: (1/count.to_f),cutoff: rrand(70,100),amp: 0.05,pan: 0.5
      sleep (1/count.to_f)
      stop if get(killit) #stop loop at the end
    end
  end
end