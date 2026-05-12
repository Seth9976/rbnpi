#Ripples by Robin Newman May 2015. Inspired by the invert_chord command added to SP2.6dev
#nogte this WILL work with version 2.5

#Two years ago I experimented with functions to produce 1st 2nd and 3rd triad inversions
#recently Joseph Wilk has added a function invert_chord to SP ver 2.6dev which does this much more elegently than my previous three functions.
#I have reproduced his code as a ruby function ic here to that you can use it with ver 2.5
#After the next release you can change ic to invert-chord and delete the ic Ruby function

#next function is Joseph Wilk's invert_chord renamed as ic
def ic(notes, shift)
  if(shift > 0)
    ic(notes[1..-1] + [notes[0]+12], shift-1)
  elsif(shift < 0)
    ic(notes[1..-1] + [notes[0]-12], shift+1)
  else
    notes.ring
  end
end

puts chord(:c5,:major)
puts ic(chord(:c4,:major),1)
puts ic(chord(:c4,:major),2)
puts ic(chord(:c4,:major),3)
puts ic(chord(:c4,:major),4)

#when invert_chord is added to release version of SP you can delete
#the definition of ic above and replace the function call as indicated in a comment

#The program uses three live_loop
#The first :ripple plays a total of 128 triads on each pass.
#triads are played in inversions 0,1,2 and 3 taking notes from pentatonic major
#and minor scales and choosing whether to use major, minor, augmented or diminished triads
#Four base notes set the scale tonic, and 8 differnt notes are selected from each scale
#from which the triads are generated
#
#To accompany this a second live_loop, synced to :ripple plays 4 low base notes
#chosen to fit harmonically with the scalebase ntoes
#These are played with a ixi_techno effect

#The third loop, :vol is used to adjust the audio level. It fades the volume in from 0
#over the first section of ripple, maintains it there for some complete cycles of ripple
#before fading out to zero volume again
#The loop then gives a message on the screen to press stop, and stops itself
#so no more output is heard. The user needs to press stop to stop the other two loops from running.

use_synth :beep
with_fx :level do |amp|
  control amp,amp: 0
  sleep 0.1
  live_loop :ripple do
    4.times do |k|
      base=[:c4,:e4,:g4,:c5]
      8.times do
        n=scale(base[k],:major_pentatonic).choose
        variant=[:major,:minor,:augmented,:diminished].choose
        4.times do |x|
          play ic(chord(n,variant),x),pan: -1+x%2 #spread the chords in the stereo spectrum
          #replace line above with play invert_chord(n,variant),x),pan: -1+x%2 when invert_chord function available
          sleep 0.1
        end
      end
    end
  end
  live_loop :bass do
    sync :ripple
    b=[:c2,:e1,:g1,:c1]
    with_synth :saw do
      4.times do |k|

        with_fx :ixi_techno,phase: 2 do
          play b[k],sustain: 3,release: 0.2
          sleep 3.2
        end
      end
    end
  end
  live_loop :vol do
    sync :ripple

    32.times do |x| #raise the volume from zero to 1
      control amp,amp: (x+1).to_f/32,amp_slide: 0.4
      sleep 0.4
    end
    4.times do #wait for 4 :ripple syncs
      sync :ripple
    end
    32.times do |x| #decrease the volume again to 0
      control amp,amp: 1-(x+1).to_f/32,amp_slide: 0.4
      sleep 0.4
    end
    puts "Press stop now to finish!"
    sleep 0.5
    stop #This will generate an error until ver2.6 is released, but it will still work
  end
end