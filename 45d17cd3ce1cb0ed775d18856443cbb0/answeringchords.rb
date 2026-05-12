#answeringchords.rb by Robin Newman, June 2018
#I was playing around with some chords and hit on a sequence I really liked
#It developed into this piece which I find somewhat hypnotic
#I love the thick textures which worked well with the blade synth
#The sequence is repetitive, moving to differnt pitches
#I used my Sonic Pi polysynth program with a keyboard to compose this.
use_synth :blade
use_bpm 120
with_fx :level,amp: 0 do |v|
  control v,amp: 1, amp_slide: 8 #fade in at start
  #right hand chord sequence
  rn= [:r,[:c4,:g4,:b4],[:c4,:f4,:a4],[:d4,:f4,:a4,:c5],
       [:c4,:f4,:a4],[:c4,:f4],[:c4,:f4,:a4],
       [:b3,:g4],[:c4,:e4,:g4]]
  rn2=[:r]*7+[:f4,:d4]
  rd=[2,2,2,2,2,2,2,4,4]
  rd2=[2,2,2,2,2,2,2,2,2]
  #left hand chord sequence
  ln=[:r,[:c3,:g3],[:c3,:f3],[:c3,:d3],[:c3,:f3],
      [:c3,:f3,:a3],[:c3,:f3],[:c3,:g3],[:c2,:c3,:e3]]
  ld=[2,2,2,2,2,2,2,4,4]
  #held bass note
  bn=[:c2]
  bd=[22]
  #answering sequence tune 1
  rn3=[:r, :c4,:e4,:g4,:e4,:c4,:e4, :d4,:f4,:a4,:f4,:d4,:f4,
       :g4,:b4,:a4,:f4,:d4,:b3, [:c4,:e4,:g4,:c5]]
  #answering sequenjce tune 2
  rn4=[:r, :c3,:g3,:c4,:e4,:d4,:c4, :d4,:a4,:d5,:f5,:e5,:d5,
       :g5,:d5,:b4,:g4,:a4,:b4,[:c4,:e4,:g4,:c5]]
  rd3=[2]+[0.5]*18+[2]
  #answering sequence left hand
  ln2=[:r,[:c3,:e3],[:c3,:d3,:f3],[:c3,:d3,:g3],[:c3,:e3,:g3,:c4]]
  ld2=[2,3,3,3,3]
  ln3=[:r,:g3,:r,:a3,:r,[:f3,:b3]]
  ld3=[3,2,1,2,1,2]
  #held bass note
  bn2=[:c2]
  bd2=[13]
  #play linked notes,duration sequence
  define :pl do |notes,dur,pan=0|
    notes.zip(dur).each do |n,d|
      if n.respond_to? :each #allow for chords
        n.each do |n2|
          play n2,sustain: d*1,release: d*0.1,pan: pan
        end
      else
        play n,sustain: d*0.9,release: d*0.1,pan: pan
      end
      sleep d
    end
  end
  #put answerinng tune into a function
  define :tunebit do |shift,pan=0,part=0|
    use_transpose shift
    in_thread do
      pl(rn3,rd3,pan) if part==0 # part selects which tune is played
      pl(rn4,rd3,pan) if part==1
    end
    #left hand parts in threads
    in_thread do
      pl(ln2,ld2,pan)
    end
    in_thread do
      pl(ln3,ld3,pan)
    end
    #bass note
    pl(bn2,bd2,pan)
  end
  
  
  with_fx :gverb,room: 20,mix: 0.8 do
    with_fx :normaliser do
      #outer sequnce 4 times at different ptiches
      4.times do |k|
        shift =[0,7,-5,0][k]
        #inner sequence 4 times moving parts up/down octaves
        4.times do |i|
          tick
          puts "Pass #{i+1+4*k} of 16"
          puts "Chord progression"
          pan=(ring -1,0,1,0).look
          use_transpose [12,24,0,12][i]+shift
          in_thread do
            pl(rn,rd,pan)
          end
          use_transpose [0,12,0,0][i]+shift
          in_thread do
            pl(rn2,rd2,pan)
          end
          in_thread do
            pl(ln,ld,pan)
          end
          pl(bn,bd,pan)
          puts "Answering sequence"
          #change tune for different values of i
          tunebit([12,0,0,0][i]+shift,-pan,0) if i==0 or i==2
          
          tunebit([0,12,0,0][i]+shift,-pan,1) if i==1 or i==3
        end
        shift=7
      end
      #exit chords, with fade out
      puts "end phase fade out"
      control v,amp: 0,amp_slide: 18 # start fade out
      play :c2,sustain: 12+4*0.9,amp: 0.5 #bass note
      4.times do |i| #four rising chord inversions
        pan=(ring -1,0,1,0).tick
        play chord_invert(chord(:c4,:major),i+1),sustain: 4*0.9,pan: pan
        sleep 4
      end
    end
  end
end