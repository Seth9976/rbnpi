#rhythmicdoodles by Robin Newman October 2015
#playing with chord progressions and rhthmic patterns Needs SP 2.7 or later

t=0.125 #set basic unit time
use_synth_defaults attack: t/3,sustain: t/3,release: t/3,amp: 0.4 #amp setting adjusts fast notes

#set up 5 chords sequences and associated base notes

chords1 = [
  chord(:d,:minor),
  chord(:g,:minor),
  chord(:d,:minor),
  chord(:c,:major),
  chord(:d,:minor),
  chord(:eb,:minor),
  chord(:bb,:major),
  chord(:c,:major)
]
n1= (ring :d3,:g2,:d3,:c3,:d2,:eb2,:bb1,:c2)
n2= (ring :f3,:g3,:d3,:c3,:f2,:g2,:d2,:c2)
chords2 = [
  chord(:f,:major),
  chord(:g,:minor),
  chord(:d,:minor),
  chord(:c,:major),
  chord(:f,:major),
  chord(:g,:minor),
  chord(:d,:minor),
  chord(:c,:major)
]
chords3 = [
  chord(:c,:major),
  chord(:eb,:major),
  chord(:f,:major),
  chord(:g,:major),
  chord(:a,:minor),
  chord(:g,:minor7),
  chord(:f,:major),
  chord(:g,:major)
]
n3=(ring :c3,:eb3,:f3,:g3,:a3,:g3,:f3,:g3)
n4=(ring :c3,:f3,:c3,:g3,:a3,:f3,:c3,:g3)
chords4 = [
  chord(:c,:major),
  chord(:f,:major),
  chord(:c,:major),
  chord(:g,:major),
  chord(:a,:minor),
  chord(:f,:major),
  chord(:c,:major),
  chord(:g,:major)
]
chords5 = [
  chord(:c,:major),
  chord(:d,:minor),
  chord(:b, :dim),
  chord(:c, :major),
  chord(:a, :minor),
  chord(:g, :major),
  chord(:c, :major),
  chord(:g, :major)
]
n5 = (ring :c3,:d3,:b2,:c3,:a2,:g2,:c3,:g3)

with_fx :reverb,mix: 0.4,room: 0.6 do #use reverb wrap on live loop

  live_loop :c do
    puts tick #print and advance tick value: advances each pass of the loop
    if look == 160 then#stop after 4 complete cycles of the chord progressions
      #play final chord and then stop
      play :c3,release: 8*t
      play invert_chord(chord(:c,:major),1), release: 8*t,amp: 0.8
      stop
    end
    tick_set :ch, look/8 %5 #advances every 8 passes, cycles range 0 to 4
    if look%16 == 0 #select a different synth every 16 passes round the loop

      sy=(ring :tb303,:fm,:tri,:prophet,:saw) #ring with sythn list
      use_synth sy.tick(:s) #use a separate named tick to select nect synth
      puts sy.look(:s) #print the selection
    end

    noteamp = 0.3 #adjust to taste for bass notes
    case look(:ch) #select a chord/bass sequence depending on look(:ch) value (it cycles 0 to 4)
    when 0
      notes= chords1[look%8]
      play n1[look%8],sustain: t*3,amp: noteamp #nb default synt settings at start of program: can override
    when 1
      notes= chords2[look%8]
      play n2[look%8],sustain: t*3,amp: noteamp
    when 2
      notes= chords3[look%8]
      play n3[look%8],sustain: t*3,amp: noteamp
    when 3
      notes= chords4[look%8]
      play n4[look%8],sustain: t*3,amp: noteamp
    when 4
      notes= chords5[look%8]
      play n5[look%8],sustain: t*3,amp: noteamp
    end #case look(:ch)
    puts look(:ch) #print current look(:ch) to show current chord sequence
    k=rand_i(4) #choose random k 0 to 3
    puts k #print current k value which determines rhythm for play notes
    8.times do #play 8 beat rhythm pattern using k selection case statement
      tick(:pl)
      case k
      when 0
        play notes.choose #all 8 notes played
      when 1
        play notes.choose if spread(13,16).look(:pl) #play 13 out of 16
      when 2
        play notes.choose if spread(5,8).look(:pl) #play 5 out of 8
      when 3
        play notes.choose if spread(9,16).look(:pl) #play 9 out of 16
      end #end case k
      sample :bd_haus,beat_stretch: t*0.75,amp: 0.4 if spread(1,4).look(:pl) #play :bd_haus on main beat
      sample :drum_snare_soft,beat_stretch: t*0.75,amp: 0.7 if spread(5,8).look(:pl) #play snare on 5 out of 8
      sleep t #sleep for basic note length
    end #end play notes loop
  end #live_loop :c
end #with_fx :reverb
