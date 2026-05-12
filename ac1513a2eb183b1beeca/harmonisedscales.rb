#defining chord inversions, and using them to harmonise an ascending and descending scale
#by Robin Newman, November 2014
#the pattern is repeated at semitone intervals 12 times
#written by Robin Newman Nov 2014 using Sonic Pi 2.1
use_debug false
set_sched_ahead_time! 2 #set to about 55 to run on Pi!!!!!!

q=0.12 #note length used
use_synth :tri
with_fx :reverb,room: 0.8 do #add some reverb for interest
  use_merged_synth_defaults sustain: q*0.9,release: q*0.1 #set default sustain and release times

  define :inv1 do |ch| #define first inversion
    return ch[1..-1]+[ch[0]+12] #set to second and thrid note with 1st note raised an octave on top
  end

  define :inv2 do |ch|
    return inv1(inv1(ch)) #do inversion process twice
  end

  v=0.1 #set starting volume
  vi=0.9/8 #set increment to raise vol to 1 over 8 notes
  define :sv do #define set volume function
    v=v+vi
  end

  define :pl1 do |n,t,r=0| #define function to play 1st second and third inversion with reversible order
    if r==0
      play chord(n,t),amp: v
      sleep q
      play inv1(chord(n,t)),amp: v
      sleep q
      play inv2(chord(n,t)),amp: v
      sleep q
    else
      play inv2(chord(n,t)),amp: v
      sleep q
      play inv1(chord(n,t)),amp: v
      sleep q
      play chord(n,t),amp: v
      sleep q
    end
    sv
  end

  define :updown do |shift=0| #define main function to play scale up and down once. shift sets transposition
    use_transpose shift
    v=0.1 #reset v and vi and set starting volume
    vi=0.9/8
    sv
    in_thread do #play bass scale up and down use median volume values for these
      play_pattern_timed [:c3,:d3,:e3,:f3,:g3,:a3,:b3,:c4,:c3],[q*3]*9,sustain: 3*q*0.9,release: 3*q*0.1,amp: 0.5
      play_pattern_timed [:c3,:d3,:e3,:f3,:g3,:a3,:b3,:c4].reverse+[:c4],[q*3]*9,sustain: 3*q*0.9,release: 3*q*0.1,amp: 0.5
   end
    pl1(:c4,:major)#play chord inversions
    pl1(:d4,:minor)
    pl1(:e4,:minor)
    pl1(:f4,:major)
    pl1(:g4,:major)
    pl1(:a4,:minor)
    pl1(:b4,:dim)
    pl1(:c5,:major,1)#last chor inversions reverse order
    play [:c5,:e5,:g5,:c6,:e6,:g6],sustain: q*3*0.9,release: q*3*0.1,amp: v #play final chord
    sleep q*3
    vi=-vi #reverse vol change
    sv
    pl1(:c5,:major,1)#play chord inversions this time descending order
    pl1(:b4,:dim,1)
    pl1(:a4,:minor,1)
    pl1(:g4,:major,1)
    pl1(:f4,:major,1)
    pl1(:e4,:minor,1)
    pl1(:d4,:minor,1)
    pl1(:c4,:major)#last one ascending order
    play [:c4,:e4,:g4,:c5,:e5,:g5],sustain: q*3*0.9,release: q*3*0.1,amp: v #play final chord
    sleep 3*q
  end

  #start playing here======================
  12.times do |x| #do the updown function 12 times at semitone intervals
    puts "scale number " + (x+1).to_s
    updown(x)
  end
end