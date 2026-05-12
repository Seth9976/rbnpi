#Sonic Pi Bach themes floating on bass notes by Robin Newman, April 2017.
#This piece was inspired by the Music Generator by JLDiaz https://talicopow.blogspot.co.uk/
#I used similar sounds, but superimposed 7 fragments of Bach themes on top. My structure was altogether
#simpler, but I think the end effect is quite pleasing.
use_random_seed 1948 #change this to get different versions
m=2;c=1;q=0.5;sq=0.25 #note relative length values
b1=[:c4,:e4,:g4,:c5,:d4,:b4,:c5,:c4,:c4]
d1=[q]*6+[c]*3
b2=[:e4,:fs4,:g4,:fs4,:gs4,:a4,:gs4,:fs4,:e4,:a4,:g4,:fs4,:g4,:e4,:fs4,:g4,:fs4,:e4,:e5,:as4,:b4,:a4,:g4,:a4]
d2=[m,q,q,m,q,q,q,q,q,m,q,q,q,q,q,q,q,q,c,q,m,q,q,m]
b3=[:e5,:a5,:f5,:d5,:c5,:b4,:c5,:b4,:a4,:g4,:g5,:e5,:bb4,:a4,:d5,:cs5,:g5,:f5,:f5]
d3=[m*2+c,q,q,q,q,q,q,m,q,c+q,m+m+c,q,q,q,q,q,q,q,m]
b4=[:f5,:c5,:a4,:bb4,:c5,:a4,:bb4,:c5,:f5,:c5,:f5,:c5,:a4,:bb4,:c5,:a4,:bb4,:c5,:f5,:c5,:f5,:g5]
d4=[q,q,sq,sq,q,sq,sq,q,q,q,q,q,sq,sq,q,sq,sq,q,q,q,q,c]
b5=[:g4,:fs4,:g4,:a4,:b4,:c5,:d5,:e5,:d5,:c5,:b4,:a4,:b4,:d5,:g5,:fs5,:g5,:fs5,:e5,:d5,:c5,:b4]
d5=[sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,q,q,sq,sq,sq,sq,sq,sq,c+q]
b6=[:d4,:e4,:f4,:g4,:a4,:d5,:cs5,:a4,:e4,:g4,:fs4,:d4,:c5,:b4,:a4,:b4,:g4,:e4,:g4,:bb4,:d4,:cs4,:a4,:d4,:g4,:f4,:e4,:d4]
d6=[sq,sq,sq,sq,q,q,q,q,q,q,q,q,c+q,sq,sq,q,q,q,q,q,q,q,q,q,q,c,c,c]
b7=[:a4,:e5,:c5,:b4,:a4,:c5,:b4,:a4,:gs4,:b4,:e4,:a4,:e4,:b4,:e4,:c5,:b4,:a4,:b4,:e4,:a4,:e4,:a4,:b4,:e4,:b4,:c5,:b4,:a4,:b4,:e4,:e5,:d5,:c5]
d7=[c,c,c+q,q,q,q,q,q,q,q,c,q,q,q,q,q,sq,sq,q,q,q,sq,sq,q,sq,sq,q,sq,sq,sq,sq,sq,sq,c]

define :pl do |p,ppos| #play Bach fragment with crescendo then decrescendo
  #p holds note array, duration array and tempo in a list.
  puts "Bach fragment number",p[3]
  l=p[0].length #no of notes
  delta= 3.0/l #increments per note for amp:
  use_bpm p[2] #tempo
  a=0.4 #initial amp: setting
  tick_reset
  p[0].zip(p[1]).each do |nv,dv| #p[0] notes, p[1] durations
    tick
    if look<(l.to_f/2) #crescendo for first half
      a+= delta
    else #decrescendo for second half
      a -= delta
    end
    play nv,release: dv,amp: a,pan: ppos
    sleep dv
  end
end


#list of bach fragments data (holds the p values for the pl function)
l=[[b1,d1,90,1],[b2,d2,80,2],[b3,d3,80,3],[b4,d4,100,4],[b5,d5,80,5],[b6,d6,90,6],[b7,d7,90,7]]
kill=0 #flag to kill live loops at the end
order=(0..6).to_a.shuffle.ring

with_fx :level do |attenuate| #used to create fade out
  av=1
  control attenuate,amp: av #set initial volumne to 1
  in_thread do
    sleep 170 #run for 170 beats then attenuate
    50.times do #start attentuation
      av -= 0.02 #decrement 50 times
      control attenuate,amp: [av,0].max,amp_slide: 0.2 #.max prevents amp: < 0
      sleep 0.2
    end
    kill=1 #set flag to kill live_loops
  end
  
  with_fx :gverb,room: 25,mix: 0.4 do #add some gverb
    live_loop :bach do #play bach fragment
      use_synth :fm
      sync :bass #wait for next bass note
      p=l[order[tick(:frag)]] #choose fragment by ticking through order list
      pl(p,[-0.5,0,0.5].choose) #play it
      stop if kill==1 #check if time to stop
    end
    
    bn=[:c2,:e3,:g3,:c4,:e4,:g4,:c5] #base note selection
    s=[:prophet,:hoover,:blade] #base synth selection
    
    live_loop :bass do
      n=bn.choose #choose bass note
      sn=s.choose #choose synth
      use_synth sn
      puts "Bass note",n,"Synth",sn
      #play bass note with build up then fade
      play n,attack: rrand(3,6),decay: rrand(2,4),cutoff: rrand(60,110),amp: 1,pan: [-0.7,0.7].choose
      sleep rrand(2,5) #wait random time 2-5 beats
      stop if kill==1 #check if time to stop
    end
  end
end
