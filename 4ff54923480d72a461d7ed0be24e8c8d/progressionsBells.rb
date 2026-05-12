#This piece is developed from a chord progression tool written by theibbster on sonic-pi.net
#Robin Newman, December 2022

define :chrd do |deg, tonic, sca|
  n = 3
  if deg.match?('7')
    n = 4
    deg = deg.slice(0,deg.length-1).to_sym
  end
  
  return (chord_degree deg, tonic, sca, n)
end

p1 = [:i,:v,:vi,:iv]
p2 = [:i,:iv,:v,:iv]
p3 = [:ii7,:v7,:i7]
p4 = [:i,:i,:i,:i,:iv,:iv,:i,:i,:v,:iv,:i,:i]
p5 = [:i,:vi,:iv,:v]
p6 = [:i,:v,:vi,:iii,:iv,:i,:iv,:v]

with_fx :reverb, room: 0.5,mix: 0.6 do
  live_loop :chord_progs do
    use_synth :dpulse #synth for the quicker notes: bell like
    tick    
    progression = [p5,p1,p6,p2,p4,p3].look
    tonic = 64
    #select scale on which progressions are based
    myScale = [:harmonic_minor,:major,:minor_pentatonic,:major_pentatonic].choose
    bass=[tonic-24,tonic-12].look #bass drone alternates up and down an octave using FM synth
    synth :fm,note: bass,sustain: (0.6* progression.length),anp: 0.5,pan: -0.5
    stop if look == 35 #stops the program, leaving the final drone to play
    progression.each do |deg| #process the next progression
      
      v= (chrd deg, tonic, myScale) #get the notes
      #play the first note of the chord
      synth :fm,note: v.first - 12,sustain: 0.6,amp: 0.4,pan: 0.5
      v=v.shuffle #shuffle the order of teh ntoes
      density dice(2) do #vary the density on or two
        v.each do |n| #play the individual notes, panning them
          play n,sustain: 0.2,amp: 0.5,pan: [-0.8,0,0.8].choose
          sleep 0.2
        end
      end
    end
  end
end