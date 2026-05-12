#Fibonacci Momentum by Robin Newman May 2018
#This piece generates number in the Fibonacci Sequence where each new number
#is the sum of the previous two. The numbers are converted to binary
#using a recursive function and then these are then used to control the playing of two notes.
#The binary digits are read progressively from each end of the binary number.
#If the digits are the same the first note plays, if they are different the second note plays.
#The pitch of the first note is controlled by its position from the start of the number.
#The pitch of the 2nd note is controlled by its position from the end of the number.
#In each case the pitches are taken from a ring based on notes from either
#the :e2 :minor_pentatonic or :harmonic_minor scales.
#Further differences are introduced for the pan position and cutoff of each note,
#and one note has a random +/- 1 octave shift applied.
#The piece cycles through the first 50 Fibonacci numbers twice before stopping.
#A regular rhythmic drum and cymbles reinforce the relentless momentum.

use_bpm 90
use_debug false
use_cue_logging false
define :to_binary do |d| #recursive decimal to binary converter
  binary = (d % 2).to_s
  if d == 0
    return binary
  elsif d == 1
    return 1.to_s
  else
    return binary = to_binary(d/2).to_s + binary
  end
  return binary.to_i
end

use_synth :tb303

set :nminus2,0 #first two fibonnaci numbers
set :nminus1,1
set :kill,false # used for stopping the piece
set :cyclesleft,2 # sets the number of cycles

with_fx :level, amp: 0 do |v| # used to fade in and fade out the volume
  
  at [0,rt(232.4)],[2,0] do |vol| # controls fade in and fade out
    control v,amp: vol,amp_slide: 7
  end
  
  with_fx :gverb,room: 20,mix: 0.4 do #apply gverb
    
    live_loop :fibBinPlay do #generate fibonnaci numbers, then convert to binary
      #choose 2,3,6,8 notes from the scale
      scname=[:minor_pentatonic,:harmonic_minor].choose
      sc=(scale :e2,scname,num_octaves: 3).pick [2,4,8,16].choose
      if tick==0 #0 dealt with as a special case
        set :cyclesleft,get(:cyclesleft)-1
        set :nminus2,0  # set intial values for last two numbers
        set :nminus1,1
        puts  "Fibonacci number #{look} is #{look}"
        play sc[0],release:0.2,amp: 0.4
        puts"Binary 0"
        sleep 0.2
      else
        n=get(:nminus2)+get(:nminus1) #gnerate next fibonnaci number
        puts "Fibonacci number #{look} is  #{n}"
        b=to_binary(n) #convert to binary
        puts "binary #{b}"
        puts "binary length is #{b.length}"
        puts "pick #{sc.length} notes from #{scname} scale" #number of notes available for this pass
        b.length.times do |i| #travrse binary number
          #read from both ends and play pitch if digits are equal
          play sc[i]+[12,-12].choose,release: 0.2,amp: 0.2,cutoff: rrand(60,100),pan: -1 if b[i]==b[b.length-i]
          #play second pitch if digits are different
          play sc[b.length-i],release: 0.2,amp: 0.2,cutoff: rrand(60,100),pan: 1 if b[i]!=b[b.length-i]
          sleep 0.2
        end
        set :nminus2,get(:nminus1) # update minus1, minus2 for next pass
        set :nminus1,n
      end
      if look==50 and get(:cyclesleft)==0 #finish after 2 complete cycles
        set :kill,true
        puts "stopping"
        stop
      end
      tick_reset   if look==50 #after 50 passes reset to first number for nect cycle
    end #live_loop fibBinPlay
    
    
    live_loop :tb,auto_cue: false do #accompanying percussion rhtym
      sample :bd_sone,amp: 1.5 if spread(3,4).tick
      sample :drum_cymbal_closed,amp: 2 if !spread(3,4).look
      sleep 0.4
      sample :drum_cymbal_closed,amp: 1.5 if !spread(3,4).look
      sleep 0.4
      stop if get(:kill)
    end #live_loop tb
  end #fx gverb
end #fx level
