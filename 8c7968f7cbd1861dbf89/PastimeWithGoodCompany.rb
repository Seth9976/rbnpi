# Pastime with good company, by Henry Eighth, set for Sonic Pi by Robin Newman, Sept 2015
# score from http://petrucci.mus.auth.gr/imglnks/usimg/d/d3/IMSLP284506-PMLP374521-02-pastime---0-score.pdf
s=1 #(global) variable to hold speed factor set by set_bpm
use_synth :blade
use_synth_defaults vibrato_depth: 0 #don't want any vibrato

define :set_bpm do |n|
  s=1.0/8*60/n.to_f
end

#set relative note duration variables
c = 8
m = 16
md = 24
b = 32
bd = 48

set_bpm(480) #set tempo
#define the three parts
n1=[:bb4,:bb4,:bb4,:bb4,:a4,:bb4,:a4,:g4,:f4,:f4,:bb4,:bb4,:a4,:g4,:f4,:g4,:fs4,:e4,:fs4,:g4]
d1=[bd,m,bd,m,md,c,m,m,bd,m,bd,m,bd,m,m,m,c,c,m,b*2]
n2=[:d4,:d4,:d4,:d4,:c4,:d4,:c4,:bb3,:a3,:r,:a3,:d4,:d4,:c4,:bb3,:a3,:bb3,:a3,:g3]
d2=[bd,m,bd,m,md,c,m,m,b,m,m,bd,m,bd,m,m,m,b,b*2]
n3=[:g3,:g3,:g3,:d3,:f3,:g3,:d3,:d3,:bb2,:bb2,:f3,:f3,:d3,:eb3,:d3,:g2]
d3=[bd,m,bd,m,bd,m,bd,m,bd,m,bd,m,m,m,b,b*2]
n1.concat [:bb4,:bb4,:bb4,:bb4,:a4,:bb4,:a4,:g4,:f4,:f4,:bb4,:bb4,:a4,:bb4,:a4,:g4,:f4,:g4,:f4,:e4,:f4,:g4,:r,:g4]
d1.concat [bd,m,bd,m,md,c,m,m,bd,m,bd,m,md,c,m,m,m,m,c,c,m,b,m,m]
n2.concat [:d4,:d4,:d4,:d4,:c4,:d4,:c4,:bb3,:a3,:r,:a3,:d4,:d4,:c4,:bb3,:a3,:bb3,:a3,:g3,:g3]
d2.concat [bd,m,bd,m,md,c,m,m,b,m,m,bd,m,bd,m,m,m,b,bd,m]
n3.concat [:g3,:g3,:g3,:d3,:f3,:g3,:d3,:d3,:bb2,:bb2,:f3,:f3,:d3,:eb3,:d3,:g2,:r,:g2]
d3.concat [bd,m,bd,m,bd,m,bd,m,bd,m,bd,m,m,m,b,b,m,m]
#b17
n1.concat [:g4,:a4,:bb4,:f4,:g4,:a4,:bb4,:bb4,:c5,:bb4,:a4,:g4,:f4,:f4,:g4,:a4,:bb4,:bb4,:g4,:a4,:bb4,:bb4,:a4,:g4]+[:f4,:g4,:a4,:f4,:g4]
d1.concat [b,b,bd,m,b,b,bd,m,md,c,m,m,bd,m,b,b,bd,m,b,b,bd,m,m,m]
d1a=[c,c,c,c,b*2] #no rall
d1b=[c*1.1,c*1.2,c*1.3,c*1.5,b*2*1.8] #ending with rallentando
n2.concat [:bb3,:c4,:d4,:d4,:bb3,:c4,:d4,:d4,:c4,:d4,:c4,:bb3,:a3,:r,:f3,:bb3,:c4,:d4,:d4,:bb3,:c4,:d4,:d4,:c4,:bb3]+[:a3,:g3]
d2.concat [b,b,bd,m,b,b,bd,m,md,c,m,m,b,m,m,b,b,bd,m,b,b,bd,m,m,m]
d2a=[b,b*2] #no rall
d2b=[b+c*(0.1+0.2+0.3+0.5),b*2*1.8] #rall ending
n3.concat [:eb3,:c3,:bb2,:bb2,:eb3,:c3,:bb2,:bb2,:f3,:g3,:d3,:d3,:eb3,:c3,:bb2,:bb2,:eb3,:c3,:bb2,:r,:g3,:c3,:eb3]+[:d3,:g2]
d3.concat [b,b,bd,m,b,b,bd,m,bd,m,bd,m,b,b,bd,m,b,b,b,m,m,m,m]
d3a=[b,b*2] #no rall
d3b=[b+c*(0.1+0.2+0.3+0.5),b*2*1.8] #rall ending

define :pa do |n1,d1,v| #function to play notes/durations
  n1.zip(d1).each do |n,d|
    #use full adsr envelope
    play n,attack: 0.1*d*s,attack_level: 0.8,decay: 0.2*d*s,sustain_level: 0.6,sustain: 0.6*d*s,release: 0.1*d*s,amp: v
    sleep d*s
  end
end

define :beatx do |d,v| #use bd_ada for beat rhythm: note time offset for better ensemble
  d.each do |d|
    sleep 0.05*d*s #offset timing by half the attack time for the other parts
    sample :bd_ada,amp: v*1.5
    sleep 0.95*d*s #make up the rest of the beat duration
  end
end

define :tune do |v,rall=0|
  if rall == 0 then
    in_thread do
      beatx(d3+d3a,v) #beat rhythm shadows part three
    end
    in_thread do
      pa(n1,d1+d1a,v) #use no-rall endings when rall == 0
    end
    in_thread do
      pa(n2,d2+d2a,v)
    end
    pa(n3,d3+d3a,v)
  else #otherwise do rallentando ending
    in_thread do
      beatx(d3+d3b,v)
    end
    in_thread do
      pa(n1,d1+d1b,v)
    end
    in_thread do
      pa(n2,d2+d2b,v)
    end
    pa(n3,d3+d3b,v)
  end
  sleep c*s #slight gap between verses
end

with_fx :reverb,room: 0.6,mix: 0.5 do #add some reverb
  tune(0.4) #vary volume in each verse
  use_synth :sine #change synth for interest in second verse
  tune(0.4)
  use_synth :blade
  tune(0.8,1) #set rallentando for last verse
end