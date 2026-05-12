#SP-KeyboardController2.rb
#experimental program to control Sonic Pi from the keyboard
#developed from an original program written by Robin Newman, April 2016
#you can play notes direct, or initiate any of 10 liveloops
#now updated to use OSC communiation from the key polling program

#set up hash to contain notes
notes=Hash.new
#list of notes
l=[:c4,:cs4, :d4, :ds4, :e4, :f4, :fs4, :g4, :gs4, :a4, :as4, :b4, :c5, :cs5, :d5, :ds5, :e5, :f5, :fs5,  :g5]
#list of associated keys (may have to alter depending on your keyboard layout)
n=["a", "w", "s", "e",  "d", "f",  "t", "g",  "y", "h",  "u", "j", "k",  "o", "l", "p",  ";", "'",  "]", "#"]
set :n,n
20.times do |i| #loop to create the hash
  notes[n[i].ord]=l[i]
end

live_loop :getkey do
  use_real_time
  b= sync "/osc/key" #kye pressed sent in an OSC message from 
  k=b[0]
  puts k
  ks=k.to_i.chr
  #check if key to play note or not
  if !["a", "w", "s", "e",  "d", "f",  "t", "g",  "y", "h",  "u", "j", "k",  "o", "l", "p",  ";", "'",  "]", "#"].include? ks
    #check for cued live_loop
    cue :one if ks == "1"
    cue :two if k.to_i.chr == "2"
    cue :three if ks == "3"
    cue :four if ks == "4"
    cue :five if ks == "5"
    cue :six if ks == "6"
    cue :seven if ks == "7"
    cue :eight if ks == "8"
    cue :nine if ks == "9"
    cue :zero if ks == "0"
  else
    #note to play
    play notes[k.to_i],sustain: 0.5,release: 0.05,amp: 0.3
    sleep 0.05
  end
end

define :pl do |tune,dur| #loop to play a tune held in a notes and a durations list
  tune.zip(dur).each do |n,d|
    play n,sustain: d*0.9,release: d*0.1
    sleep d
  end
end

live_loop :dr do #plays loop_amen_full
  sync :one
  l= (sample_duration :loop_amen_full)
  with_fx :level,amp: 1 do |v|
    control v,amp_slide: 2*l,amp: 0
    2.times do
      sample :loop_amen_full
      sleep l
    end
  end
end

live_loop :dr2 do #plays loop_tabla
  sync :two
  with_fx :level,amp: 3 do |v|
    control v,amp_slide: (sample_duration :loop_tabla),amp: 0
    sample :loop_tabla
  end
end

live_loop :melody do #plays notes using :pluck synth
  use_synth :pluck
  sync :three
  with_fx :level, amp: 1 do |v|
    control v, amp_slide: 9.6, amp: 0
    n=scale(:a1,:minor_pentatonic,num_octaves: 2)
    96.times do
      play n.choose if spread(5,8).tick
      sleep 0.1
    end
  end
end

live_loop :woosh do #plays misc_cineboom
  sync :four
  4.times do
    sample :misc_cineboom,start: 0,finish: 0.4,beat_stretch: 4
    sleep 1.6
    sample :misc_cineboom,start: 0.5,finish: 0.8, beatstretch: 4
    sleep 1.2
  end
end

live_loop :rhythm do #plays notes with :tb303
  use_synth :tb303
  sync :five
  with_fx :level, amp: 1 do |v|
    control v, amp_slide: 9.6, amp: 0
    f=  (note_range :c2, :c5, pitches: (scale :c, :minor))
    96.times do
      play f.choose,release: 0.1 if spread(5,8).tick
      play (f.choose - 12),release: 0.1 if !spread(5,8).look
      sleep 0.1
    end
  end
end

live_loop :frere do #plays frere jaques round
  sync :six
  sq=0.1
  q=2*sq
  c=2*q
  tune=[:c4,:d4,:e4,:c4]*2+[:e4,:f4,:g4]*2+[:g4,:a4,:g4,:f4,:e4,:c4]*2+[:c4,:g3,:c4]*2
  dur=[q,q,q,q,q,q,q,q,q,q,c,q,q,c,sq,sq,sq,sq,q,q,sq,sq,sq,sq,q,q,q,q,c,q,q,c]
  in_thread do
    use_synth :tri
    pl(tune,dur)
  end
  sleep 4*c
  in_thread do
    use_synth :saw
    pl(tune,dur)
  end
  sleep 4*c
  in_thread do
    use_synth :prophet
    pl(tune,dur)
  end
end

live_loop :fanfare do #plays a three chord fanfare
  sync :seven
  use_synth :tri
  ch1=[:c4,:e4,:g4,:c5]
  ch2=[:c4,:d4,:f4,:a4,:c5]
  ch3=[:e4,:g4,:c5,:g5]
  q=0.2
  c=2*q
  cd=3*q
  m=4*q
  dur=[c,q,q,q,q,cd,q,m]
  tune=[ch1,ch2,ch2,ch2,ch2,ch1,ch1,ch3]
  pl(tune,dur) #play using pl function
end

live_loop :boom do #drum roll and bass drum thump
  sync :eight
  puts sample_duration :drum_roll
  sample :drum_roll,finish: 0.32
  sleep 2
  sample :drum_bass_hard
  sleep sample_duration :drum_bass_hard
end

live_loop :slider do #slides two notes around
  sync :nine
  with_fx :level,amp: 0,amp_slide: 1 do|v|
    use_synth :tb303
    s=play :a2,sustain: 8,note_slide: 1 #start the two notes with 8 sec sustains
    r=play :a3,sustain: 8,note_slide: 1
    4.times do
      control v,amp: 1 #slide the volume up
      
      control s, note: :a3 #slide the ptiches
      control r, note: :a2
      sleep 1
      control v,amp: 0 #slide the volume down
      control s, note: :a1 #slide the ptiches
      control r, note: :a3
      sleep 1
    end
  end
end

live_loop :sampfrenzy do #plays all samples (except loops) fast
  sync :zero
  sample_groups.each do |g|
    if g !=:loop
    then
      sample_names(g).each do |n|
        if sample_duration(n) > 0.2
          sample n,beat_stretch: 0.2
        else
          sample n
        end
        sleep 0.2
      end
    end
  end
end
