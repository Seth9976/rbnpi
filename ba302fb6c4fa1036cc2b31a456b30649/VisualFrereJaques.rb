#Frere jaques with visualization in Processing
#written by Robin Newman, December 23rd 2017
#info from Sonic Pi transmitted in OSC messages to drive the processing sketch
#A 4 part round is played, and each part is represented by a separate column
#the colour of each part varies with pitch as does the vertical postion of each note
#The radius of each "note" depends on its duration.
nmax=2 #number of iterations of Frère Jaques played
use_osc_logging true
#note and duration data for Frère Jaques
nf=[:c4,:d4,:e4,:c4]*2+[:e4,:f4,:g4]*2+[:g4,:a4,:g4,:f4,:e4,:c4]*2+[:c4,:g3,:c4]*2
df=[1,1,1,1,1,1,1,1,1,1,2,1,1,2,0.5,0.5,0.5,0.5,1,1,0.5,0.5,0.5,0.5,1,1,1,1,2,1,1,2]
use_bpm 180
with_fx :reverb,room: 0.8,mix: 0.6 do #add reverb for interest
  use_osc "localhost",8000 #link to processing sketch on same machine. Can be on external machine too
  live_loop :notes do #first part
    use_synth :pulse #differnt synth for each part
    use_bpm 180
    nv = nf.ring.tick #select each note in turn
    rel=df.ring.look #select corresponding duration
    play nv,release: rel,amp: 0.2 #play note with release set by duration
    osc "/chana",-18 #send channel position
    osc "/na",(note(nv)-48)*16 #send scaled note info to set vertical pos
    osc "/rada",rel.to_f #send rel value to set radius
    osc "/colora",128,(note(nv)-48)*16,0 #send colour info related to pitch
    sleep df.ring.look #sleep for durtation of note
    stop if look >= (df.length*nmax-1)
  end
  #subesequent parts identical apart from synth, channel, color setting
  live_loop :notes2,delay: 8 do #secnd part delayed 8 beats
    use_synth :tri
    use_bpm 180
    nv = nf.ring.tick
    rel=df.ring.look
    play nv,release: rel,amp: 0.2
    osc "/chanb",-6
    osc "/nb",(note(nv)-48)*16
    osc "/radb",rel.to_f
    osc "/colorb",0,128,(note(nv)-48)*16
    sleep df.ring.look
    stop if look >= (df.length*nmax-1)
  end
  
  live_loop :notes3,delay: 16 do #third part delayed 16 beats
    use_synth :prophet
    use_bpm 180
    nv = nf.ring.tick
    rel=df.ring.look
    play nv,release: rel,amp: 0.2
    osc "/chanc",6
    osc "/nc",(note(nv)-48)*16
    osc "/radc",rel.to_f
    osc "/colorc",(note(nv)-48)*16,0,128
    sleep df.ring.look
    stop if look >= (df.length*nmax-1)
  end
  
  live_loop :notes4,delay: 24 do #fourth part delayed 24 beats
    use_synth :saw
    use_bpm 180
    nv = nf.ring.tick
    rel=df.ring.look
    play nv,release: rel,amp: 0.2
    osc "/chand",18
    osc "/nd",(note(nv)-48)*16
    osc "/radd",rel.to_f
    osc "/colord",(note(nv)-48)*16,128,0
    sleep df.ring.look
    stop if look >= (df.length*nmax-1)
  end
end
