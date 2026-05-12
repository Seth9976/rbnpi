#Sonic Pi does Boogie by Robin Newman, May 2015 (tested on ver 2.5 on Pi and Mac)

use_debug false

boog1=[:g2,:b2,:d3,:e3,:g3,:e3,:d3,:b2] 
boog2=[:c2,:e2,:g2,:a2,:bb2,:a2,:g2,:e2]
boog3=[:a2,:b2,:c3,:cs3,:d3,:c3,:b2,:a2]

tune=boog1*3+boog2+boog1+boog3 #tune for boogie bass

define :pd do |n,d,a=1| #plays the boogie bass part with rhythm!
  n.each do |v|
    play v,release: 2*d/3,amp: a
    sleep 2*d/3
    play v,release: d/3,amp: a
    sleep d/3
  end
end

#These three functions can be replaced by invert_chord when ver 2.6 is released
#syntax invert_chord(chord,inv_num)
define :chordinv1 do |r,type|
  #generates 1st inversion of chord
  c = chord(r,type)
  return c[1..-1]+[c[0]+12]
end
define :chordinv2 do |r,type|
  #generates 2nd inversion of chord
  c = chord(r,type)
  c1= c[1..-1]+[c[0]+12]
  return c1[1..-1]+[c1[0]+12]
end
define :chordinv3 do |r,type|
  #generates 3rd inversion of chord
  c = chord(r,type)
  c1= c[1..-1]+[c[0]+12]
  c2=c1[1..-1]+[c1[0]+12]
  return c2[1..-1]+[c2[0]+12]
end

c=chordinv1(:c5,:major)
#when invert_chord available replace line above with invert_chord(chord(:c5,:major),1)
f=chord(:f5,:major)
g=chordinv3(:g4,:major)
#when invert_chord available replace line above with invert_chord(chord(:g4,:major),3)
clist=[c,c,c,c,c,c,f,f,c,c,g,g] #top accompaniment chords in c...transpose to g

define :cplay do |c,d|
  with_transpose [-5,-5,7,-17].choose do
    c.each do |v|
      with_fx :ixi_techno,phase: [d/8,d/4,d/2].choose do

        play v,release: d/2,amp: 3
        sleep d/2
        play v,release: d/2,amp: 1
        sleep d/2
      end
    end
  end
end

d=sample_duration :loop_mika #this will be a float so no need to convert

with_fx :level do |amp| #set initial level volume here to allow settling and no glitch
  control amp,amp: 1

  live_loop :beat do |y| #set drum pulse..plays 5 out of 8 beats
    sample :bd_haus,amp: 3 if spread(5,8)[y]
    sleep d /16
    inc y
  end

  sync :beat #stagger start of each live loop
  sleep d

  live_loop :rhythm,auto_cue: false do #drum loop rhythm section
    sync :beat
    r=[-1,1,2,4].choose
    sample :loop_mika,rate: r,amp: 2
    sleep d / r.abs
  end

  sync :beat #stagger start of next loop
  sleep d.to_f

  live_loop :bass,auto_cue: false do #boogie bass part
    sync :beat
    with_fx :ixi_techno,phase: d/8 do
      use_synth :tb303
      pd(tune,d/32,2)
    end
  end

  sync :beat #stagger start of top (d*1.5 is duration of one pass of bass sequence
  sleep d*1.5

  live_loop :top,auto_cue: false do #top line chords
    sync :beat
    use_synth :saw
    cplay(clist,d/8)
  end
  sync :beat
  sleep d*1.5 *5 #run for a further 5 passes of bass sequence

  96.times do |x| #now reduce volume to 0 over 2 passes of bass sequence
    control amp,amp: 1-(x+1).to_f/96,amp_slide: d*1.5/48
    sleep d*1.5/48
  end
end

sleep d/32 #allow level to stabilise
use_synth :tb303 #now play final chord
with_fx :ixi_techno ,phase: d/4 do
  play [:g3,:b3,:d4,:e4],sustain: d.to_f/4,release: d/8
end
sleep 3*d.to_f/8
sample :bd_sone,amp: 3 #and drum finish!

puts "Now press stop!" #to stop non sounding live_loops which are still running!