#Ethereal guitars II by Robin Newman
#based on the 4 "guit" samples in Sonic Pi, together with ambi_lunar_land
#the piece starts very quietly, builds up to a cliamx and then dies away again
#this continues indefinitely until stop is pressed.
#the sample are "tuned' so that they fit together harmonically, the dominant note in each sample found by comparing it with a synth note
#these are then used as offsets when adjusting the pitch of each sample
#each sample is played forwards then backwards, at a pitch chosen from a c major arpeggio
#superimposed are samples played either a 4th or a 5th higher
#reverb is added to enhance the ethereal effect
#Individual volumes are set for each loop, and an overall level is superimosed by the :vol live_loop
#when played in reverse, the length is adjusted by settting the finish: parameter (which is in fact the start in reverse!)
#this way the same section of the sample is used in both directions forward and reverse.
#some global variables (preceded by a $) are used to allow info to be passed between the live loops
#other variables declared outside the loops like k and sl1...sl5 are available inside the loops
#the pitch_ratio function which has been introduced in version 2.5 dev is used, but is reproduced so that the program
#works with earlier versions.
#The piece really needs a Pi2 or Mac to do it full justice is it is fairly heavy on processing power.
#it will work on a B+, but you may have to remove the reverb and increase the sched ahead time.

set_sched_ahead_time! 5  #can be reduced on a Pi2

#prior to the release of version 2.5 you need the next function
#if you get an error message saying it exists then delete it or comment it out
uncomment do
  define :pitch_ratio do |n|
    return 2**(n.to_f/12)
  end
end

$a=1 #counter for level control
k=1 #direction flag for level changes
$vscale=[0,0.05,0.1,0.2,0.4,0.8,1.6,3.2] #levels, on a logarithmic scale
sl1= sample_duration :guit_e_fifths
sl2= sample_duration :guit_em9
sl3= sample_duration :guit_harmonics
sl4= sample_duration :guit_e_slide
sl5= sample_duration :ambi_lunar_land

with_fx :reverb, room: 0.8,mix: 0.5 do #may have to remove if on B+ 


  live_loop :sa do #main loop
    with_fx :level,amp: $vscale[$a] do
      v=0.6
      l=rrand(0.25,1.2)
      l2=rrand(0.25,1.2)
      l3=rrand(0.25,1.2)
      l4=rrand(0.25,1.2)
      $n=[:e4,:g4,:c5,:e5,:g5,:c6,:e6].choose#scale(:c5,:major).choose
      $shift=[4,7].choose
      #puts $n
      #puts $shift
      sample :guit_e_fifths,rate:(pitch_ratio note($n)-note(:fs4)), sustain: l,release: 1,amp: v,pan: -0.8
      sleep l
      sample :guit_e_fifths,rate:-(pitch_ratio note($n)-note(:fs4)), sustain: l,release: 1,finish: l/sl1,amp: v,pan: 0.8
      cue :em9
      sleep l
      sample :guit_em9,rate:(pitch_ratio note($n)-note(:d5)), sustain: l2,release: 1,amp: v,pan: 0.8
      sleep l2
      sample :guit_em9,rate:-(pitch_ratio note($n)-note(:d5)), sustain: l2,release: 1,finish: l2/sl2,amp: v,pan: -0.8
      cue :harmonics
      sleep l2
      sample :guit_harmonics,rate:(pitch_ratio note($n)-note(:b4)), sustain: l3,release: 1,amp: v,pan: -0.8
      sleep l3
      sample :guit_harmonics,rate: -(pitch_ratio note($n)-note(:b4)), sustain: l3,release: 1,finish: l3/sl3,amp: v,Pan: 0.8
      cue :slide
      sleep l3
      sample :guit_e_slide,rate:(pitch_ratio note($n)-note(:e5)), sustain: l4,release: 1,amp: v,pan: 0.8
      sleep l4
      sample :guit_e_slide,rate: -(pitch_ratio note($n)-note(:e5)), sustain: l4,release: 1,finish: l4/sl4,amp: v,pan: -0.8
      sleep l4
    end
  end


  live_loop :sa1,auto_cue: false  do #loop for extra guit_e_fiths
    with_fx :level,amp: $vscale[$a] do
      sync :sa
      v=0.5
      shift=[4,7].choose
      sleep rrand(0.5,1)
      l=rrand(0.25,1.2)
      sample :guit_e_fifths,rate:(pitch_ratio note($n)+$shift-note(:fs4)), sustain: l,release: 1,amp: v,pan: 0.5
      sleep l
      sample :guit_e_fifths,rate:-(pitch_ratio note($n)+$shift-note(:fs4)), sustain: l,release: 1,finish: l/sl1,amp: v,pan: -0.5
      sleep l
    end
  end

  live_loop :sa2,auto_cue: false do #loop for extra guit_em9
    with_fx :level,amp: $vscale[$a] do
      sync :em9
      v=0.3
      sleep rrand(0.5,1)
      l2=rrand(0.25,1.2)
      sample :guit_em9,rate:(pitch_ratio note($n)+$shift-note(:d5)), sustain: l2,release: 1,amp: v,pan: -0.5
      sleep l2
      sample :guit_em9,rate:-(pitch_ratio note($n)+$shift-note(:d5)), sustain: l2,release: 1,finish: l2/sl2,amp: v,pan: 0.5
      sleep l2
    end
  end

  live_loop :sa3,auto_cue: false do #loop for extra guit_harminics
    with_fx :level,amp: $vscale[$a] do
      sync :harmonics
      v=0.3
      sleep rrand(0.5,1)
      l3=rrand(0.25,1.2)
      sample :guit_harmonics,rate: (pitch_ratio note($n)+$shift-note(:b4)), sustain: l3,release: 1,amp: v,pan: 0.5
      sleep l3
      sample :guit_harmonics,rate: -(pitch_ratio note($n)+$shift-note(:b4)), sustain: l3,release: 1,finish: l3/sl3,amp: v,pan: -0.5
      sleep l3
    end
  end

  live_loop :sa4,auto_cue: false do #loop for extra guit_e_slide
    with_fx :level,amp: $vscale[$a] do
      sync :slide
      v=0.3
      sleep rrand(0.5,1)
      l4=rrand(0.25,1.2)
      sample :guit_e_slide,rate: (pitch_ratio note($n)+$shift-note(:e5)), sustain: l4,release: 1,amp: v,pan: -0.5
      sleep l4
      sample :guit_e_slide,rate: -(pitch_ratio note($n)+$shift-note(:e5)), sustain: l4,release: 1,finish: l4/sl4,amp: v,pan: 0.5
      sleep l4
    end
  end

  live_loop :swoosh,auto_cue: false do #loop for background swoosh
    with_fx :level,amp: $vscale[$a] do
      v=0.2
      sample :ambi_lunar_land,sustain: 2.8,release: 0.2,amp: v,pan: -0.7
      sleep 3
      sample :ambi_lunar_land,rate: -1,sustain: 2.8,release: 0.2,finish: 3.0/sl5,amp: v,pan: 0.7
      sleep 3
    end
  end

end #of fx reverb effect Remove this if you remove the effect on B+

live_loop :vol,auto_cue: false do #loop for level volume control
  if $a>=7 or $a<=0 then k = k*-1
  end
  sync :sa
  $a=($a+k).to_i
  puts 'level is '+$vscale[$a].to_s
  sleep 4
end