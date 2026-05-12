#Percussion track generator by Robin Newman, 4th December 2014 VERSION 2
#Inspired by an article http://www.soundonsound.com/sos/feb98/articles/rythm.html
#This program generates a percussion programme defined over two bars quantised to 32 pulses per bar
#up to 10 instruments can be incorporated
#any instrument can sound on any pulse
#one of three volumes can be chosen for each instrument for each pulse
#a variable p sets the pulse tempo for each programme
#a variable n sets the number of bars the track will play for in 2 bar increments
#In this example six drum programmes are defined num = 1 to num = 6. num=0 plays silence
#These can be chosen in a live_loop by changing the variable num
use_debug false
tr=Hash.new #define the hash array to contain all the information required
n=2 #number of 2 bar repeats to play
noplay="00000000000000000000000000000000" #no sound in the 2 bar cycle

slist=[:drum_bass_hard,:drum_bass_soft ,:drum_snare_hard,:drum_snare_soft,:drum_cymbal_open,:drum_cymbal_closed,:drum_cymbal_pedal,:drum_tom_lo_soft,:drum_heavy_kick]
load_samples slist #preload samples


define :sp do |s| #used to test a particular sample: amend and uncomment lines after definition to use
  sample s
  sleep sample_duration s
end
#sp(:drum_cymbal_hard)
#sleep 1000

lev=[1,0.6,0.3] #volume levels for h,m and s

live_loop :playdrums do
  num = 0 #select programme 0 (silence) or 1 to 3
  puts num #print program number at the start

  case num #use case statement to choose programme to play
  when 0 #play silence
    p=0.02 #pulse time for each element
    tr[[0,1]]=tr[[1,1]]=tr[[2,1]]=tr[[3,1]]=tr[[4,1]]=tr[[5,1]]=tr[[6,1]]=tr[[7,1]]=tr[[8,1]]=tr[[9,1]]=noplay
    tr[[0,0]]=tr[[1,0]]=tr[[2,0]]=tr[[3,0]]=tr[[4,0]]=tr[[5,0]]=tr[[6,0]]=tr[[7,0]]=tr[[8,0]]=tr[[9,0]]=:ambi_glass_rub

  when 1 #define program one
    p=0.15 #pulse time for each element
    #grid when instrument sounds, and volume it plays h,m or s 0 is silent
    # beats:    1   2   3   4   1   2   3   4
    tr[[0,1]]= "h0000000h0000s00h00000h000000000"
    tr[[1,1]]= "00000000000000000000000000000000"
    tr[[2,1]]= "0000h0000000h0000000h0000000h000"
    tr[[3,1]]= "0000s0000000s0000000s0000000s000"
    tr[[4,1]]= "000000000000000000000000000000h0"
    tr[[5,1]]= "h0s0h0s0h0s0h0s0h0s0h0s0h0s0h000"
    tr[[6,1]]= "00000000000000000000000000000sss"
    tr[[7,1]]= "m0000000000000000000000000000000"
    tr[[8,1]]= "00000000000000000000000000000000"
    tr[[9,1]]= "00000000000000000000000000000000"

    #define sample names to play for each track
    tr[[0,0]]= :drum_bass_hard
    tr[[1,0]]= :drum_bass_soft
    tr[[2,0]]= :drum_snare_soft
    tr[[3,0]]= :drum_cymbal_open
    tr[[4,0]]= :drum_cymbal_closed
    tr[[5,0]]= :drum_cymbal_pedal
    tr[[6,0]]= :drum_tom_hi_hard
    tr[[7,0]] =:drum_tom_lo_hard
    tr[[8,0]] =:drum_heavy_kick
    tr[[9,0]] =:drum_heavy_kick

  when 2 #define program two
    p=0.12 #pulse time for each element
    #grid when instrument sounds, and volume it plays h,m or s 0 is silent
    # beats:    1   2   3   4   1   2   3   4
    tr[[0,1]]= "h000000000h00000h0h000h000000000"
    tr[[1,1]]= "0h0000hh000h000h000000000h0h0000"
    tr[[2,1]]= "0000s0000s00s0s00000s00s00s0s0s0"
    tr[[3,1]]= "00000000000000000000000000000000"
    tr[[4,1]]= "h0h0hh00h000h00h0000h00h00h0h0h0"
    tr[[5,1]]= "00000000000000000000000000000000"
    tr[[6,1]]= "00000000000000000000000000000000"
    tr[[7,1]]= "00000000000000000000000000000000"
    tr[[8,1]]= "00000000000000000000000000000000"
    tr[[9,1]]= "00000000000000000000000000000000"

    #define sample names to play for each track
    tr[[0,0]]= :drum_bass_hard
    tr[[1,0]]= :drum_bass_soft
    tr[[2,0]]= :drum_snare_hard
    tr[[3,0]]= :drum_cymbal_open
    tr[[4,0]]= :drum_cymbal_pedal
    tr[[5,0]]= :drum_tom_hi_hard
    tr[[6,0]]= :drum_cymbal_closed
    tr[[7,0]] =:drum_heavy_kick
    tr[[8,0]] =:drum_heavy_kick
    tr[[9,0]] =:drum_heavy_kick

  when 3 #define program three
    p=0.16  #pulse time for each element

    #grid when instrument sounds, and volume it plays h,m or s 0 is silent
    # beats:    1   2   3   4   1   2   3   4
    tr[[0,1]]= "h00m0000h00h00smh0m0000sh0h00000"
    tr[[1,1]]= "0000000000000m00000000s000000m00"
    tr[[2,1]]= "0000m0000m0sh0000000m0000s00m000"
    tr[[3,1]]= "00m0000000000000m000000000000000"
    tr[[4,1]]= "00000000000000000000000000000000"
    tr[[5,1]]= "mh00m0m0m0s0sms000msm0m0s0mss0sm"
    tr[[6,1]]= "00000000000000000000000000000000"
    tr[[7,1]]= "00000000000000000000000000000000"
    tr[[8,1]]= "0000h0000000000000000h0000000000"
    tr[[9,1]]= "00000000000000000000000000000000"

    #define sample names to play for each track
    tr[[0,0]]= :drum_bass_hard
    tr[[1,0]]= :drum_snare_hard
    tr[[2,0]]= :drum_snare_soft
    tr[[3,0]]= :drum_cymbal_open
    tr[[4,0]]= :drum_cymbal_closed
    tr[[5,0]]= :drum_cymbal_pedal
    tr[[6,0]]= :drum_tom_hi_hard
    tr[[7,0]] =:drum_tom_lo_soft
    tr[[8,0]] =:drum_heavy_kick
    tr[[9,0]] =:drum_heavy_kick

  when 4 #define program three
    p=0.14  #pulse time for each element

    #grid when instrument sounds, and volume it plays h,m or s 0 is silent
    # beats:    1   2   3   4   1   2   3   4
    tr[[0,1]]= "h0000000h0s000s0h0000000h00000m0"
    tr[[1,1]]= "0000h0000000h0000000h0000000h000"
    tr[[2,1]]= "00000000000000000000000000000000"
    tr[[3,1]]= "h000h00s0h00h000h000h000m0sm0h00"
    tr[[4,1]]= "00000000000000000000000000000000"
    tr[[5,1]]= "00000000000000000000000000000000"
    tr[[6,1]]= "h0hm0hm0hmhmhmhhhm0hm0hm0hh0hmhm"
    tr[[7,1]]= "00000000000000000000000000000000"
    tr[[8,1]]= "00000000000000000000000000000000"
    tr[[9,1]]= "00m000s000m000s000m000s000m000s0"

    #define sample names to play for each track
    tr[[0,0]]= :drum_bass_hard
    tr[[1,0]]= :drum_snare_hard
    tr[[2,0]]= :drum_snare_soft
    tr[[3,0]]= :drum_cymbal_open
    tr[[4,0]]= :drum_tom_hi_hard
    tr[[5,0]]= :drum_cymbal_pedal
    tr[[6,0]]= :drum_cymbal_closed
    tr[[7,0]] =:drum_tom_lo_soft
    tr[[8,0]] =:drum_heavy_kick
    tr[[9,0]] =:elec_chime

  when 5 #define program three
    p=0.16  #pulse time for each element

    #grid when instrument sounds, and volume it plays h,m or s 0 is silent
    # beats:    1   2   3   4   1   2   3   4
    tr[[0,1]]= "hs0000m000hm000mh0h000h00m0s0000"
    tr[[1,1]]= "000000000h00h0s00000h0000000hmmm"
    tr[[2,1]]= "00000000000000000000000000000000"
    tr[[3,1]]= "00000000000000000000000000000000"
    tr[[4,1]]= "00000000000000000000000000000000"
    tr[[5,1]]= "h0h0hh00h000h00h0000h0s0h0s0h0s0"
    tr[[6,1]]= "00000000000000000000000000000000"
    tr[[7,1]]= "00000000000000000000000000000000"
    tr[[8,1]]= "00000000000000000000000000000000"
    tr[[9,1]]= "mshsmshsmshsmshsmshsmshshsmshsms"

    #define sample names to play for each track
    tr[[0,0]]= :drum_bass_hard
    tr[[1,0]]= :drum_snare_hard
    tr[[2,0]]= :drum_snare_soft
    tr[[3,0]]= :drum_cymbal_open
    tr[[4,0]]= :drum_cymbal_closed
    tr[[5,0]]= :drum_cymbal_pedal
    tr[[6,0]]= :drum_tom_lo_hard
    tr[[7,0]] =:drum_tom_lo_soft
    tr[[8,0]] =:drum_heavy_kick
    tr[[9,0]] =:elec_twip
  when 6 #define program three
    p=0.12  #pulse time for each element

    #grid when instrument sounds, and volume it plays h,m or s 0 is silent
    # beats:    1   2   3   4   1   2   3   4
    tr[[0,1]]= "h0000000m0000000s000m000h0000000"
    tr[[1,1]]= "0h0000000m0000000s000m000h000000"
    tr[[2,1]]= "00h0000000m0000000s000m000h00000"
    tr[[3,1]]= "000h0000000m0000000s000m000h0000"
    tr[[4,1]]= "0000h0000000m000000000000000h000"
    tr[[5,1]]= "00000h0000000m000000000000000h00"
    tr[[6,1]]= "000000000000000h0000000000000000"
    tr[[7,1]]= "0000000h00000000000000000000000h"
    tr[[8,1]]= "00000000000000000000000000000000"
    tr[[9,1]]= "00000000000000000000000000000000"

    #define sample names to play for each track
    tr[[0,0]]= :drum_tom_mid_soft
    tr[[1,0]]= :drum_tom_mid_hard
    tr[[2,0]]= :drum_tom_lo_soft
    tr[[3,0]]= :drum_tom_lo_hard
    tr[[4,0]]= :drum_tom_hi_soft
    tr[[5,0]]= :drum_tom_hi_hard
    tr[[6,0]]= :drum_splash_soft
    tr[[7,0]] =:drum_splash_hard
    tr[[8,0]] =:drum_heavy_kick
    tr[[9,0]] =:elec_twip

  end

  define :perc do |track,sn| #play a given track with sample sn
    track.to_s.split("").each do |pl| #extract each of the 32 values
      if pl!="0" #ignore if pl=0
        #puts sn #uncomment for testing
        #puts pl #uncomment for testing
        sample sn,amp: lev["hms".index(pl)] #lev array contains volume. "hms".index(pl) determines element to use
      end
      sleep p #sleep pulse value
    end
  end

  n.times do #repeat for number of 2 bars required
    0.upto(9) do |n| #set up required number of threads to play all the tracks.
      in_thread do
        perc(tr[[n,1]],tr[[n,0]])
      end
    end
    sleep p*32 #sleep for 2 bar duration
  end
end
