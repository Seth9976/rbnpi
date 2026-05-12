#Rotating binary rhythms by Robin Newman, January 2016
#This piece was inspired by an article I read at http://bernhardwagner.net/musings/RPABN.html
#I played with the idea and extended it to give the current piece.
#set_sched_ahead_time! 4 #I set this when recording on a Pi2 to prevent errors
use_debug false

######### three user settings below ###########
rvol=0.6 #balance these two vol settings to taste (0-1)
lvol=1
numpasses=4 #set for number of passes required (pattern repeats after 4 passes)
##############################################

#I started with 4 16 bit rhythm patterns based on the binary numbers 0-15
#set up binary rhythms r1 0-3,r2 4-7,r3 8-11,r4 12-15
r1="0000000100100011"
r2="0100010101100111"
r3="1000100110101011"
r4="1100110111101111"

#now convert to rings
r1= r1.split('').map(&:to_i).ring
r2= r2.split('').map(&:to_i).ring
r3= r3.split('').map(&:to_i).ring
r4= r4.split('').map(&:to_i).ring

#make 4 selection rings, each one with a different starting point
#Each selection ring will control one of 4 live_loops
rl1=ring(r1,r2,r3,r4)
rl2=rl1.rotate
rl3=rl2.rotate
rl4=rl3.rotate

#define function to rotate ring entries dir defaults to 1, but can be -1 for reverse rotate
#This will rotate each of the four binary rings in a given selection ring
define :rv do |r,dir=1| #if dir = -1 then the rotation is backwards or anticlockwise
  return (ring r[0].rotate(dir),r[1].rotate(dir),r[2].rotate(dir),r[3].rotate(dir))
end

#The piece is played inside a symmetric rising (and then falling) fm note.
#play intro: growling fm note rises to key pitch of the piece
use_synth :fm
p=play 12,sustain: 8,divisor: 12,amp: 0.5
control p,note_slide: 5,note: 84,divisor_slide: 4,divisor: 4
sleep 5

#set up 4 live loops. Each plays rhythms from a different "selection ring"
#ring entries rotate forwards for loops 1 and 3 and backwards for loops 2 and 4
#each loop has a different synth
#the note range alters for each loop based on sequence :c3,:g3,:g2,:c3 (or the same up two octaves)
#pattern takes 102.4 seconds for one complete repeat (4 passes)

with_fx :level do |v| #uses to fade out rhythms at the end
  control v,amp: 1 #set initial level
  with_fx :reverb do
    live_loop :audio do #controls audio level
      tick
      if look >= (numpasses-1)*256 #start fading on last pass
      then
        control v,amp: 1.0-0.5*(look-(numpasses-1)*256).to_f/256 #fade to 50%
      end
      sleep 0.1
      stop if look==numpasses*256
    end

    live_loop :x1 do
      use_synth :square
      tick
      tick_set :rc1,look/256 #used to select current ring from selection ring
      tick_set :bs1,look/64 #used to select base note pitch
      base=(ring :c3,:g3,:g2,:c3).look(:bs1) #get base note
      r=rl1.look(:rc1) #get current ring
      puts look(:rc1) if look%256==0 #print current cycle on the screen
      play scale(note(base)+24,:minor_pentatonic).choose,amp: rvol,release: 0.1,pan: 0.8 if r.look == 1
      play scale(note(base),:minor_pentatonic).choose,amp: lvol,release: 0.1,pan: -0.8 if r.look != 1
      sleep 0.1
      rl1=rv(rl1) if look%16==0 #rotate all the rings in the selection ring
      stop if look(:rc1)==numpasses #stop after required number of passes
    end

    live_loop :x2 do
      use_synth :pulse
      tick
      tick_set :rc2,look/256
      tick_set :bs2,look/64
      base=(ring :c3,:g3,:g2,:c3).look(:bs2)
      r=rl2.look(:rc2)
      #puts r if look%256==0
      play scale(note(base)+24,:minor_pentatonic).choose,amp: rvol,release: 0.1,pan: 0.6 if r.look == 1
      play scale(note(base),:minor_pentatonic).choose,amp: lvol,release: 0.1,pan: -0.6 if r.look != 1
      sleep 0.1
      rl2=rv(rl2,-1) if look%16==0
      stop if look(:rc2)==numpasses
    end

    live_loop :x3 do
      use_synth :saw
      tick
      tick_set :rc3,look/256
      tick_set :bs3,look/64
      base=(ring :c3,:g3,:g2,:c3).look(:bs3)
      r=rl3.look(:rc3)
      #puts r if look%256==0
      play scale(note(base)+24,:minor_pentatonic).choose,amp: rvol,release: 0.1,pan: 0.8 if r.look == 1
      play scale(note(base),:minor_pentatonic).choose,amp: lvol,release: 0.1,pan: -0.8 if r.look != 1
      sleep 0.1
      rl3=rv(rl3) if look%16==0
      stop if look(:rc3)==numpasses
    end

    live_loop :x4 do
      use_synth :tri
      tick
      tick_set :rc4,look/256
      tick_set :bs4,look/64
      base=(ring :c3,:g3,:g2,:c3).look(:bs4)
      r=rl4.look(:rc4)
      #puts r if look%256==0
      play scale(note(base)+24,:minor_pentatonic).choose,amp: rvol,release: 0.1,pan: 0.6 if r.look == 1
      play scale(note(base),:minor_pentatonic).choose,amp: lvol,release: 0.1,pan: -0.6 if r.look != 1
      sleep 0.1
      rl4=rv(rl4,-1) if look%16==0
      stop if look(:rc4)==numpasses
    end
  end
  #end piece.....fm note falls from pitch of piece to a growling note to finish.
  sleep numpasses*256*0.1-2 #start hjust before rhythms finish
  p=play 84,sustain: 8,divisor: 4
  sleep 2 #sustain for 2 secs before changing
  control p,note_slide: 5,note: 12,divisor_slide: 4,divisor: 8
  sleep 6
end
puts "finished! Adjust numpasses for different lengths"