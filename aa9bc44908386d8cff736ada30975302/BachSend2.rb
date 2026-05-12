#experimental program two to send notes to
#SP running on a second computer, using OSC sync
#this example processes chords by sending separate notes in quick succession
#altered from original example. See ReadMe.md file
use_osc "localhost", 8000
sleep 1.5 #allow OSC time to set up
use_synth :piano
with_fx :reverb,room: 0.6 do
  a1=[]
  b1=[]
  a1[0]=[[:Bf3,:D4],[:C4,:G4],[:C4,:A4],[:D4,:Bf4],[:Ef4,:C5],[:D4,:A4],[:D4,:Fs4],[:C4,:Fs4],[:Bf3,:G4],[:D4,:G4],[:Ef4,:A4],[:D4,:A4],[:Bf3,:D4],[:Ef4,:D5],[:A4,:C5],[:D4,:Bf4],[:Ef4,:Bf4],[:C4,:A4],[:D4,:Bf4],[:D4,:A4],[:D4,:Bf4],[:F4,:C5],[:Bf4,:D5],[:Bf4,:D5],[:F4,:C5],[:F4,:A4],[:Ef4,:A4],[:D4,:A4,:Bf4],[:C4,:Ef4,:A4],[:D4,:G4],[:Ef4,:G4],[:Ef4,:A4],[:D4,:F4],[:Ef4,:G4],[:F4,:A4],[:D4,:G4],[:D4,:F4],[:Ef4,:G4],[:C4,:Ef4],[:Bf3,:D4],[:C4,:Ef4],[:D4,:F4],[:Ef4,:G4],[:Ef4,:G4],[:D4,:G4],[:D4,:Fs4],[:D4,:G4]]
  b1[0]=[1.0,1.0,1.0,1.0,1.0,2.0,1.0,1.0,1.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,1.0,1.0,2.0,1.0,1.0,1.0,1.0,1.0,0.25,0.25,0.25,0.25,1.0,1.0,0.5,0.5,1.0,0.25,0.25,0.25,0.25,1.0,1.0,1.0,4.0]
  c1=[80]
  in_thread do
    for i in 0..a1.length-1
      use_bpm c1[i]
      for j in 0..a1[i].length-1
        play a1[i][j],sustain: b1[i][j]*0.9,release: b1[i][j]*0.1
        sleep b1[i][j]
      end
    end
  end
end


a2=[]
b2=[]
a2[0]=[[:G2,:G3],[:Ef2,:G3],[:D2,:Fs3],[:G2,:G3],[:C3,:G3],[:D3,:Fs3],[:D3,:A3],[:Gf3,:A3],[:Ef3,:Bf3],[:Ef2,:Bf3],[:A2,:C4],[:D3,:C4],[:G2,:G3],[:Bf2,:F3],[:A2,:Ef3],[:G2,:G3],[:Ef2,:G3],[:F2,:F3],[:G2,:D3],[:Fs2,:D3],[:Ef2,:G3],[:F2,:A3],[:F2,:Bf3],[:Bf2,:Bf3],[:F2,:A3],[:F2,:C4],[:A2,:C4],[:Bf2,:F3],[:G2,:G3],[:A2,:A3],[:G2,:Bf3],[:Ef3,:Bf3,:C4],[:F2,:F3,:C4],[:G2,:Bf2,:C4],[:F2,:Bf3],[:Ef2,:A3],[:F2,:A3],[:G2,:G3],[:C3,:G3],[:G2,:A3],[:G2,:Bf3],[:D3,:A3],[:G2,:Bf3]]
b2[0]=[1.0,1.0,1.0,1.0,1.0,2.0,1.0,1.0,1.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,1.0,1.0,2.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,1.0,0.5,0.5,1.0,1.0,1.0,0.5,0.5,1.0,1.0,4.0]
c2=[80]
in_thread do
  for i in 0..a2.length-1
    use_bpm c2[i]
    for j in 0..a2[i].length-1
      if a2[i][j].respond_to?(:each) #detect chord inside [..]
        a2[i][j].each do |nv| #process each note in chord in succession
          osc "/waitforit",nv.to_s,b2[i][j],c2[i] #no gaps between notes
        end
      else
        osc "/waitforit",a2[i][j].to_s,b2[i][j],c2[i]
      end
      sleep b2[i][j] #gap after single note or chord is processed
    end
  end
end