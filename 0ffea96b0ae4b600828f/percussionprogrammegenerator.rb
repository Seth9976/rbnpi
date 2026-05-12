#Percussion track generator by Robin Newman, 1st December 2014 for Sonic-Pi 2.1
#Inspired by an article http://www.soundonsound.com/sos/feb98/articles/rythm.html
#This program generates a percussion programme defined over two bars quantised to 32 pulses per bar
#up to 10 instruments can be incorporated
#any instrument can sound on any pulse
#one of three volumes can be chosen for each instrument for each pulse
#a variable p sets the pulse tempo for each programme
#a variable n sets the number of bars the track will play for in 2 bar increments
#In this example three drum programmes are defined num = 1 to num = 3. num=0 plays silence
#These can be chosen in a live_loop by changing the variable num
use_debug false
tr=Hash.new #define the has array to contain all the information required
n=2 #number of 2 bar repeats to play
noplay="00000000000000000000000000000000" #no sound in the 2 bar cyucle
quiet="ssssssssssssssssssssssssssssssss" #all sounds quiet

slist=[:drum_bass_hard,:drum_bass_soft ,:drum_snare_hard,:drum_cymbal_open,:drum_cymbal_closed,:drum_cymbal_pedal,:drum_tom_lo_soft,:drum_heavy_kick]
load_samples slist #preload samples


define :sp do |s| #used to test a particular sample: amend and uncomment lines after definition to use
    sample s
    sleep sample_duration s
  end
  #sp(:drum_cymbal_hard)
  #sleep 1000

  define :lev do |x| #convert the sound level h,m or s to a number 1, 0.6 or 0.3
    case x
    when "h"
      return 1
    when "m"
      return 0.6
    when "s"
      return 0.3
    end
  end

live_loop :playdrums do 
  num = 0 #select programme 0 (silence) or 1 to 3
  puts num #print program number at the start
  case num #use case statement to choose programme to play
  when 0 #play silence
  tr[[0,1]]=tr[[0,1]]=tr[[0,1]]=tr[[0,1]]=tr[[0,1]]=tr[[0,1]]=tr[[0,1]]=tr[[0,1]]=noplay
  tr[[1,1]]=tr[[1,1]]=tr[[1,1]]=tr[[1,1]]=tr[[1,1]]=tr[[1,1]]=tr[[1,1]]=tr[[0,1]]=:ambi_glass_rub
  tr[[2,1]]=tr[[2,1]]=tr[[2,1]]=tr[[2,1]]=tr[[2,1]]=tr[[2,1]]=tr[[2,1]]=tr[[2,1]]=quiet
  p=0.01 #repaid turnaround: quick tempo
 
  when 1 #define program one
    #define when instrument sounds 1 and when it is silent 0
    #leave unused tracks all set to 0
    # beats:    1   2   3   4   1   2   3   4
    tr[[0,1]]= "10000000100000001000001000000000"
    tr[[1,1]]= "00000000000001000000000000000000"
    tr[[2,1]]= "00001000000010000000100000001000"
    tr[[3,1]]= "00001000000010000000100000001000"
    tr[[4,1]]= "10001000100010001000100010001000"
    tr[[5,1]]= "00100010001000100010001000100000"
    tr[[6,1]]= "00000000000000000000000000000010"
    tr[[7,1]]= "00000000000000000000000000000000"
    tr[[8,1]]= "00000000000000000000000000000000"
    tr[[9,1]]= "00000000000000000000000000000000"

    p=0.2
    #define sample names to play for each track
    tr[[0,0]]= :drum_bass_hard
    tr[[1,0]]= :drum_bass_soft
    tr[[2,0]]= :drum_snare_hard
    tr[[3,0]]= :drum_cymbal_open
    tr[[4,0]]= :drum_cymbal_closed
    tr[[5,0]]= :drum_cymbal_pedal
    tr[[6,0]]= :drum_cymbal_closed
    tr[[7,0]] =:elec_triangle
    tr[[8,0]] =:drum_heavy_kick
    tr[[9,0]] =:drum_heavy_kick
    
    #define volume for each beat for each track
    tr[[0,3]]="hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
    tr[[1,3]]="hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
    tr[[2,3]]="ssssssssssssssssssssssssssssssss"
    tr[[3,3]]="ssssssssssssssssssssssssssssssss"
    tr[[4,3]]="hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
    tr[[5,3]]="hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
    tr[[6,3]]="hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
    tr[[7,3]]="hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
    tr[[8,3]]="hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
    tr[[9,3]]="hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"

  when 2
    #define when instrument sounds 1 and when it is silent 0
    #leave unused tracks all set to 0
    # beats:    1   2   3   4   1   2   3   4
    tr[[0,1]]= "10000000001000001010001000000000"
    tr[[1,1]]= "01000011000100010000000001010000"
    tr[[2,1]]= "00001000010010100000100100101010"
    tr[[3,1]]= "00000000000000000000000000000000"
    tr[[4,1]]= "10101100100010010000100100101010"
    tr[[5,1]]= "00000000000000000000000000000000"
    tr[[6,1]]= "00000000000000000000000000000000"
    tr[[7,1]]= "00000000000000000000000000000000"
    tr[[8,1]]= "00000000000000000000000000000000"
    tr[[9,1]]= "00000000000000000000000000000000"

    p=0.12 #set tempo
    #define sample names to play for each track
    tr[[0,0]]= :drum_bass_hard
    tr[[1,0]]= :drum_bass_soft
    tr[[2,0]]= :drum_snare_hard
    tr[[3,0]]= :drum_cymbal_open
    tr[[4,0]]= :drum_cymbal_closed
    tr[[5,0]]= :drum_cymbal_pedal
    tr[[6,0]]= :drum_cymbal_closed
    tr[[7,0]] =:drum_heavy_kick
    tr[[8,0]] =:drum_heavy_kick
    tr[[9,0]] =:drum_heavy_kick

    #define when instrument sounds 1 and when it is silent 0
    #leave unused tracks all set to 0
    tr[[0,3]]="hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
    tr[[1,3]]="hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
    tr[[2,3]]="ssssssssssssssssssssssssssssssss"
    tr[[3,3]]="ssssssssssssssssssssssssssssssss"
    tr[[4,3]]="hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
    tr[[5,3]]="hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
    tr[[6,3]]="hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
    tr[[7,3]]="hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
    tr[[8,3]]="hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
    tr[[9,3]]="hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"

  when 3
    #define when instrument sounds 1 and when it is silent 0
    # beats:    1   2   3   4   1   2   3   4
    tr[[0,1]]= "10000000100000001000001000000000"
    tr[[1,1]]= "0010000000100000001000001000000"
    tr[[2,1]]= "00001000000010000000100000001000"
    tr[[3,1]]= "00001000000010000000100000001000"
    tr[[4,1]]= "10001000100010001000100010001000"
    tr[[5,1]]= "00100010001000100010001000100000"
    tr[[6,1]]= "00000000000000000000000000000010"
    tr[[7,1]]= "01000100010001000100010001000101"
    tr[[8,1]]= "00001000000000000000010000000000"
    tr[[9,1]]= "00000000000000000000000000000000"

    p=0.15 #set tempo
    #define sample names to play for each track
    tr[[0,0]]= :drum_bass_hard
    tr[[1,0]]= :drum_bass_soft
    tr[[2,0]]= :drum_snare_hard
    tr[[3,0]]= :drum_cymbal_open
    tr[[4,0]]= :drum_cymbal_closed
    tr[[5,0]]= :drum_cymbal_pedal
    tr[[6,0]]= :drum_cymbal_closed
    tr[[7,0]] =:drum_tom_lo_soft
    tr[[8,0]] =:drum_heavy_kick
    tr[[9,0]] =:drum_heavy_kick

    #define when instrument sounds 1 and when it is silent 0
    tr[[0,3]]="hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
    tr[[1,3]]="hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
    tr[[2,3]]="ssssssssmmmmmmmmssssssssmmmmmmmm"
    tr[[3,3]]="mmmmmmmmssssssssmmmmmmmmssssssss"
    tr[[4,3]]="hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
    tr[[5,3]]="hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
    tr[[6,3]]="hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
    tr[[7,3]]="hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
    tr[[8,3]]="hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
    tr[[9,3]]="hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
  end
  
  define :perc do |track,sn,vol| #play a given track with sample sn
    track.to_s.split("").zip(vol.to_s.split("")).each do |pl,v| #extract each of the 32 values
      if pl=="1" #play if 1
        sample sn,amp: lev(v) #use lev function to set volume
      end
      sleep p #sleep pulse value
    end
  end
  
  n.times do #repeat for number of 2 bars required
    0.upto(9) do |n| #set up required number of threads to play all the tracks.
      in_thread do
        perc(tr[[n,1]],tr[[n,0]],tr[[n,3]])
      end
    end
    sleep p*32 #sleep for 2 bar duration
  end
end
