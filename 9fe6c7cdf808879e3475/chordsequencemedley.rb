#a medley of routines all connected with sequences of chords by Robin Newman May 2015

#first up a routine to play harmonised scales. It can handle up to 3 octaves, ascending or descending
#range depends on the starting note as the notes for a one octave scale cover 2 octaves with the harmony
#lowest starting note is about :c2. Highest for 1 octave about :c6. Reduce for more octaves.
#There is no error checking for exceeding limits.

use_synth :tri
define :playharmonyscale do |n,d,up=1,octave=1,finish=0|
  scaleup=[[:c3,:e3,:g3,:c4],[:b2,:g3,:b3,:d4],[:c3,:g3,:c4,:e4],[:d3,:b3,:d4,:f4],[:e3,:c4,:e4,:g4],[:f3,:c4,:f4,:a4],[:d3,:d4,:g4,:b4],[:c3,:e4,:g4,:c5]]
  scaledown=[[:c3,:e4,:g4,:c5],[:e3,:d4,:g4,:b4],[:f3,:c4,:f4,:a4],[:e3,:c4,:e4,:g4],[:d3,:b3,:d4,:f4],[:c3,:g3,:c4,:e4],[:g2,:g3,:b3,:d4],[:c3,:e3,:g3,:c4]]
  use_synth_defaults sustain: 0.9*d,release: 0.1*d
  if up==1 then
    octave.times do |oct|
      with_transpose note(n)-note(:c4)+12*(oct) do
        7.times do |x|
          play scaleup[x]
          sleep d
        end
      end
    end
    with_transpose note(n)-note(:c4)+12*(octave-1) do
      if finish != 0 then #allow for smooth finish
        play scaleup[7],sustain: 0.9*d,release: d
      else
        play scaleup[7]
      end
      sleep d
    end
  else
    octave.times do |oct|
      with_transpose note(n)-note(:c4)+12*(octave-1-oct) do
        7.times do |x|
          play scaledown[x]
          sleep d
        end
      end
    end
    with_transpose note(n)-note(:c4) do
      if finish != 0 then #allow for smooth finish
        play scaledown[7],sustain: 0.9*d,release: d
      else
        play scaledown[7]
      end
      sleep d
    end
  end
end
#three octaves up and down again
playharmonyscale(:g3,0.3,1,3)
playharmonyscale(:g3,0.3,0,3)

#up and down 12 times with chromatic rise in start note
11.times do |x|
  playharmonyscale(note(:c4)+x,0.2,1,1)
  playharmonyscale(note(:c4)+x,0.2,0,1)
end
playharmonyscale(note(:c4)+12,0.2,1,1) #last time finish set to 1 for smooth end
playharmonyscale(note(:c4)+12,0.2,0,1,1)


sleep 2
#second function explores the use of the chord_degree function
#function degprogress is defined to enable progressions to be played
#If the finish parameter is not 0 then it enables a smooth end to the last chord

use_synth :tri

define :degprogress do |n,type,num,d,finish=0|
  if not d.kind_of?(Array) then
    d=[d]*num
  end
  with_transpose (note(n)-note(:c4)) do
    (num).times do |x|
      if ((finish != 0) and (x == (num-1))) then
        play chord_degree(x+1, :f4, type),sustain: d[x]*0.9,release: d[x]*2
      else
        play chord_degree(x+1, :f4, type),sustain: d[x]*0.9,release: d[x]*0.1
      end
      sleep d[x]
    end
  end
end

#first 8 degree chords are played for c minor
degprogress(:c3,:minor,8,0.2,1)
sleep 2
#next 4 degree chords from differnt pentatonic scales are explored
degprogress(:c3,:minor_pentatonic,4,0.3)
degprogress(:a3,:major_pentatonic,4,0.3)
degprogress(:f4,:minor_pentatonic,4,[0.3]*2+[0.4,0.6])
play chord(:c4),release: 1

sleep 3
#The next function progress explores a circle progression of chords
#The starting note and duration of each chord can be specified
# The latter can be expressed as a single value or as an array of 8 values
define :progress do |n,d|
  if not d.kind_of?(Array) then
    d=[d]*8
  end
  with_transpose (note(n)-note(:c4)) do
    play [:c4,:g4,:c5,:e5],sustain: d[0]*0.9,release: d[0]*0.1
    sleep d[0]
    play [:f3,:a4,:c5,:f5],sustain: d[1]*0.9,release: d[1]*0.1
    sleep d[1]
    play [:b3,:f4,:b4,:d5],sustain: d[2]*0.9,release: d[2]*0.1
    sleep d[2]
    play [:e3,:g4,:b4,:e5],sustain: d[3]*0.9,release: d[3]*0.1
    sleep d[3]
    play [:a3,:e4,:a4,:c5],sustain: d[4]*0.9,release: d[4]*0.1
    sleep d[4]
    play [:d4,:f4,:a4,:d5],sustain: d[5]*0.9,release: d[5]*0.1
    sleep d[5]
    play [:g3,:d4,:g4,:b4],sustain: d[6]*0.9,release: d[6]*0.1
    sleep d[6]
    play [:c3,:e4,:g4,:c5],sustain: d[7]*0.9,release: d[7]*0.1
    sleep d[7]
  end
end

# in the example using the progress function the starting note is changed
# using the scale of c major up and then down again
# The rhythm of each sequence is varied as it progresses

sc=[0,2,4,5,7,9,11,12] #scale intervals
7.times do |x|
  progress(note(:c3)+sc[x],[0.3,0.2]*4)
end
progress(note(:c4),[0.2]*5+[0.3,0.4,0.8])
6.times do |x|
  progress(note(:c3)+sc[6-x],[0.2,0.3]*4)
end
progress(note(:c3),[0.2]*5+[0.3,0.4,0.8])

sleep 2
#The final example which in fact inspired this work, uses triad inversions.
#Two years ago I experimented with functions to produce 1st 2nd and 3rd triad inversions
#recently Joseph Wilk has added a function invert_chord to SP ver 2.6dev which does this much more elegently than my previous three functions.
#I have reproduced his code as a ruby function ic here to that you can use it with ver 2.5
#After the next release you can change ic to invert-chord and delete the ic Ruby function

#Ripples by Robin Newman May 2015. Inspired by the invert_chord command added to SP2.6dev
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