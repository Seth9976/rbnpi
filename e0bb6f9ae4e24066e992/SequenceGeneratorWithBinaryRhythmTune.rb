#sequence generator by Robin Newman.
#Based on previous work on my percussiongenerator in Dec 2014,https://gist.github.com/rbnpi/f249905887f8eadff82b
#of which I was reminded of this by the sequencer written by Martin Butz at https://gist.github.com/mbutz/2ea7cdd19648c380a721

#requires sp 2.6dev as uses named tick, tick_set and note_range functions

#noise pulse,generates a burst of noise at the start and end of the piece, and is from my program whoosh.rb
#at https://gist.github.com/rbnpi/9f32fde76ac7990d83d2
#live_loop :rhythm details...
#rhythm parts generated from a 32 pulse grid for each instrument, although many repeat earlier than that eg after 2,4,8 or 16 pulses
#each pattern is held in a ring and elements are accessed using the tick function. When element is 1 the instrument is played when 0 it is not.
#The melody loop playnotes uses a ring consisting of 4 bit numbers 0-15 in binary placed end to end (64 bits)
#this loop uses notes from the note_range function with the tb303 synth. The inverse of the melody pattern...
#...is played using the beep synth and a note_range one octave higher.........
#....the two note streams are placed on opposite sides of the stereo spectrum
#The note_pattern is reversed half way throughsetuse_debug
#A separate ring called transpose_pattern is used to transpose the output effectively every 64 pulses

load_samples [:misc_rand_noise,:bd_haus,:drum_bass_soft,:drum_bass_hard,:drum_snare_hard,:elec_twang,:drum_cymbal_open,:elec_tick,:drum_cymbal_closed,:drum_snare_soft]
sleep 2
define :noisepulse do |t,pstart = 0| #t pulse duration, pstart starting pan position
  #function could now be rewritten utilising ticks, not available when it was written
  dur = sample_duration :misc_rand_noise
  settletime=0.03 #lengthen a bit if you hear clicks at start
  rt = dur/(t.to_f-settletime) #rate for sample adjusted for amp level settle time
  lptime=t.to_f-settletime #loop time for one iteration adjusted for amp level settle time
  #puts rt #for debugging
  with_fx :level do |amp| #control pulse amplitude
    control amp,amp: 0 #initial value set to 0
    sleep settletime #allow time for initial amp level to settle
    live_loop :l,auto_cue: false do |x| #this loop controls the amplitude
      if x < 80 then
        control amp,amp: x.to_f/80,amp_slide: lptime/200
      end
      if x > 120
        control amp,amp: (200 -x.to_f)/80,amp_slide: lptime/200
      end
      sleep lptime/200
      if x == 200 then stop #stops the loop when amp back to 0 again
      end
      inc x
    end
    p = sample :misc_rand_noise,rate: rt, pan: pstart #pan control loop
    control p,pan: (pstart * -1) ,pan_slide: t #sweep pan across spectrum for pstart to -pstart
  end
  sleep lptime #sets overall time of noisepulse to t
end

noisepulse(8)
sleep 0.125

live_loop :playnotes do
  transpose_pattern = (ring 0,5,7,-5)
  #note_pattern is numbers 0 to 15 as 4 bit binaries one after the other (just for fun!)
  note_pattern = (ring 0,0,0,0,0,0,0,1,0,0,1,0,0,0,1,1,0,1,0,0,0,1,0,1,0,1,1,0,0,1,1,1,1,0,0,0,1,0,0,1,1,0,1,0,1,0,1,1,1,1,0,0,1,1,0,1,1,1,1,0,1,1,1,1)

  tick_set :n64, tick+64 #start at 64 offset so following division works.
  #tick(:n64) will also address 1st element of all rings on 1st pass, as they are sub multiples of 64
  tick_set :n1,look(:n64)/64 - 1 #nb integer division initial value with be 0: 32/32 - 1
  use_transpose  transpose_pattern.look(:n1) #different entry will occur every 64 pulses
  note_pattern=note_pattern.reverse if look > 64*8
  puts "note pattern reversed" if look == 64*8
  v=1 #set to 0 to kill this section
  with_synth :tb303 do
    play (note_range :c3,:c5, pitches: chord(:c,:minor)).choose,release: 0.125,cutoff: rrand(70,120),amp: v,pan: -0.5 if note_pattern.look(:n64) == 0 #triggered on zeros
  end
  with_synth :beep do #notes an octave higher
    play (note_range :c4,:c6, pitches: chord(:c,:minor)).choose,release: 0.125,amp: v,pan: 0.5 if note_pattern.look(:n64) == 1 #triggered on ones
  end

  sleep 0.125 #set basic pulse length
  stop if look == 64*16 #look starts at 0, so will give 64*16 passes of the loop
end


live_loop :rhythm do
  ##### this generates the percussion.

  sync :playnotes #synced to note generation
  ### pattern grids. 32 note repeat. some repeat earlier
  hiht_pattern =      (ring 1,0) #repeat after 2
  beat_pattern =      (ring 1,0,0,0) #repeat after #4
  snare_pattern =     (ring 0,0,0,0,1,0,0,0) #repeat after #8
  base_pattern =      (ring 1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1) #repeat after #16
  base_syn_pattern =  (ring 1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0)
  shaker_pattern =    (ring 1,0,1,0,1,1,0,1,0,1,0,1,0,1,1,0)
  click_pattern =     (ring 0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0)
  c_hihat_pattern =   (ring 1,1,0,1,1,1,1,1,0,1,1,1,0,1,1,1)
  o_hihat_pattern =   (ring 0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0)
  snare_syn_pattern = (ring 0,0,0,0,0,1,1,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0) #32

  tick #clocks next entry
  rhythm=1 #used to switch on and off: 0 is off
  sample :bd_haus, amp: 2, rate: 1, attack: 0, sustain: 0.2, release: 1 if (beat_pattern.look == 1  and rhythm == 1)
  sample :drum_bass_soft, amp: 4, rate: 0.4, attack: 0.02, sustain: 1, release: 1, pan: 0.2 if (base_pattern.look == 1  and rhythm == 1)
  sample :drum_bass_hard, amp: 2, rate: 0.8, attack: 0, sustain: 1, release: 1, pan: -0.2 if (base_syn_pattern.look == 1  and rhythm == 1)
  sample :drum_snare_hard, amp: 1, rate: 1.5, attack: 0, sustain: 1, release: 0 if (snare_pattern.look == 1 and rhythm == 1)
  sample :elec_twang ,amp: 0.2, rate: 2,  attack: 0, sustain: 1, release: 0, pan: -0.25 if (shaker_pattern.look == 1  and rhythm == 1)
  sample :drum_cymbal_open , rate: 2, amp: 1,pan: 0.25 if (o_hihat_pattern.look == 1 and rhythm == 1)
  sample :elec_tick, rate: 1, amp: 3 if (click_pattern.look == 1 and rhythm == 1)
  sample :drum_cymbal_closed, rate: 2, amp: 2 if (hiht_pattern.look and rhythm == 1)
  sample :drum_snare_soft, amp: 1, rate: 1.7, attack: 0, sustain: 1, release: 0, pan: -0.25 if (snare_syn_pattern.look == 1  and rhythm == 1)

  sleep 0.125
  stop if tick == 64*16 #stops after 64*16 passes of the loop
end
sleep 64*16*0.125 #delay final noise burst till live loops have ended
noisepulse(8) #final noise burst to end