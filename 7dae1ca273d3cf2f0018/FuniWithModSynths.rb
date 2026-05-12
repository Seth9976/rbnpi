#exploring "mod" synths by Robin Newman March 2015
#This short program explores the use of the "mod" sysnths in Sonic Pi
#These synths mod_+sime, mod_pulse, mod_fm etc generate a note that oscillates between two different pitches
#You can control the separation of these pitches (mod_range:) the rate at which you switch between them (mod_phase:)
#and the wave shape (mod_wave:) saw,pulse,triangle and sine of the oscillation. You can also switch whether the modulation
#starts on the upper or lower note using mod_invert_wave

#This program defines windupdown which starts a note playing and then raises both its pitch over two octaves and mod_phase rate range 0.76 down to 0.04,
#before changing them bakc again. The start note pitch and step times are used as parameters, and pan position and amplitude can also be set.
#perform is then defined to play three simultaneous windupdowns doing respctively 1,2 and 3 cycles, each adjusted for an overall time dur
#Three sample runs are then played using different parameters for each one.

#a separate phaseslide sets up one modulation cycle for the specified synth
#the demo of perform is wrapped between two chords and a single phaseslide sequnce
#using threads, timings are adjusted to give slight overlaps for a smooth performance.

define :windupdown do |nt,t,p=0,a=0.6|
  n=play nt,mod_wave: 3,mod_phase: 1,mod_invert_wave: 0,mod_range: 12,sustain: 24*t,amp: a,pan: p
  1.upto(12) do |x|
    control n, mod_phase: 1.0/1.3**x,mod_phase_slide: t,note: nt+2*x,note_slide: t,amp: a*x.to_f/12
    sleep t
  end
  12.downto(1) do |x|
    control n, mod_phase: 1.0/1.3**x,mod_phase_slide: t,note: nt+2*x,note_slide: t,amp: a*x.to_f/12
    sleep t
  end
end

define :perform do |nt,dur,a=0.6|
  in_thread do
    2.times do
      windupdown(note(nt),dur.to_f/48,-1,a)
    end
  end
  in_thread do
    windupdown(note(nt)+7,dur.to_f/24,0,a)
  end
  3.times do
    windupdown(note(nt)+4,dur.to_f/72,1,a)
  end
end

define :phaseslide do |nt,t,a=1| #do one cycle with mod synth
  play nt,mod_wave: 3,mod_phase: t,mod_invert_wave: 0,mod_range: 12,sustain: t*0.7,release: t*0.3,amp: a
end

#start playing here===========================
#play an intro chord
with_synth :dsaw do
  play [40,44,47,52],attack: 1,sustain: 2,release: 3
  sleep 5 #short to give slight overlap with following sounds
end

in_thread do #start final sequence in thread to overlap end of perform sequence
  sleep 29 #set time for required overlap just before end of second "perform"
  with_synth :mod_dsaw do
    phaseslide(40,10,0.5)
    sleep 9 #less than total length to give overlap with following chord
  end
  with_synth :dsaw do

    play [40,44,47,52],attack: 1,sustain: 2,release: 3
  end
end
with_synth :mod_saw do
  perform(:c3,12)
end
with_synth :mod_tri do
  perform(:c4,20)
end
with_synth :mod_sine do #this overlaps with final sequence
  perform(:c6,8,0.3)
end