## The following two sections of code are utilites to clear and load all samples used in the program
## They should be used by uncopmmenting when running on a Pi as required, before using the main program
## The samples are required by live loop :sampfrenzy
##| sample_free_all
##| stop
##| sample_groups.each do |g|
##|   load_samples g.to_s   if g.to_s != "loop"
##| end
##| stop


#experimental program to control Sonic Pi from the keyboard
#written by Robin Newman, April 2016
#you can play notes direct, or initiate any of 10 liveloops
#keyboard polling routine by Alex Chaffee, http://stackoverflow.com/questions/174933/how-to-get-a-single-character-without-pressing-enter
#Some of the example live_loops used here require SP version 2.10,
#but with amended examples should work on earlier versions of SP
require 'socket'
use_synth :saw #used for directly played notes
#set up hash to contain notes
notes=Hash.new
#list of notes
l=[:c4,:cs4, :d4, :ds4, :e4, :f4, :fs4, :g4, :gs4, :a4, :as4, :b4, :c5, :cs5, :d5, :ds5, :e5, :f5, :fs5,  :g5]
#list of associated keys (may have to alter depending on your keyboard layout)
n=["a", "w", "s", "e",  "d", "f",  "t", "g",  "y", "h",  "u", "j", "k",  "o", "l", "p",  ";", "'",  "]", "#"]
20.times do |i| #loop to create the hash
  notes[n[i].ord]=l[i]
end
k=0 #set initial value of k, making it a global variable

live_loop :tcp do #loop to poll tcp input
  s = TCPSocket.new 'localhost', 2016 #create socket
  k= s.gets.to_f #get input
  s.close #close =socket
  cue :p if k !=0 # if value is not 0 cue play loop
  #puts k.to_i.chr
  cue :one if k.to_i.chr == "1"
  cue :two if k.to_i.chr == "2"
  cue :three if k.to_i.chr == "3"
  cue :four if k.to_i.chr == "4"
  cue :five if k.to_i.chr == "5"
  cue :six if k.to_i.chr == "6"
  cue :seven if k.to_i.chr == "7"
  cue :eight if k.to_i.chr == "8"
  cue :nine if k.to_i.chr == "9"
  cue :zero if k.to_i.chr == "0"
  sleep 0.075 #short sleep before repeating
end

live_loop :x do #loop to play the notes
  sync :p #wait for sync to say note is ready
  play notes[k.to_i],sustain: 0.5,release: 0.05,amp: 0.3 if k>0 #play note, looking up value from hash
  sleep 0.05 #short sleep
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


##| transmit program contained below for reference. It is normally downloadeed separately.
## Run this from a terminal window
##| then run SP program
##| then set focus to terminal and type in notes to play

##| #terminal ruby program to get and transmit key info
##| require 'io/wait'
##| require 'socket'

##| server = TCPServer.new 2016 #set up transmit tcp socket

##| def char_if_pressed #routine to scan for keyboard press (non-blocking)
##| begin

##| system("stty raw -echo") # turn raw input on
##| c = nil
##| if $stdin.ready?
##| c = $stdin.getc
##| end
##| c.chr if c
##| ensure
##| system "stty -raw echo" # turn raw input off
##| end
##| end

##| while true #main loop, runs until stoped by ctrl-c
##| k=0 #0 will be transmitted if no key pressed
##| c = char_if_pressed
##| k= "#{c}".ord if c #work out ascii value of key
##| client = server.accept    # Wait for a client to connect
##| client.puts k #transmit the keycode
##| client.close #close the client terminating input
##| sleep 0.02 #short gap
##| end


