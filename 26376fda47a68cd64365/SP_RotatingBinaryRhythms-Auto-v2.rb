#Rotating binary rhythms by Robin Newman (v2), January 2016
#see rbnrpi.wordpress.com for details

use_debug false

define :bpm do
  return 60.0/Thread.current.thread_variable_get(:sonic_pi_spider_sleep_mul)
end

#function rotates ring entries
define :rv do |r,dir=1| #if dir = -1 then the rotation is backwards
  return ring( r[0].rotate(dir),r[1].rotate(dir),r[2].rotate(dir),r[3].rotate(dir))
end

loop do
  rs=Random.new_seed
  puts "random seed "+rs.to_s+"\n"
  use_random_seed(rs)

  sname=scale_names.choose
  ######### user settings below ###########
  rvol=0.4 #vol sets for left and right
  lvol=0.6
  kr=0.4 #accent inc right
  kl=0.4 #accent inc left
  numpasses=2 #should be even
  t=0.1
  tempochange=[0,10,16,20].choose
  plscale=[TRUE,TRUE,FALSE,TRUE].choose #TRUE scale based: FALSE chord notes
  entryexit=[TRUE,FALSE].choose #control entry/exit notes
  y=0.25 #adjust attack/release ratio
  startlevel=0.7
  loops=["1234","13","24","12","34"].choose#set loops to play x1...x4
  rhythm=["ni","ni","n","i"].choose  #n normal i=inverse
  ##############################################
  puts "USER DATA SETTINGS"
  puts "Number of 256 'tick' passes set to "+numpasses.to_s
  puts "playing major chords" if plscale==FALSE
  puts"playing notes from "+sname.to_s+" scale" if plscale==TRUE
  puts"playing loop numbers "+loops
  puts "playing rhythms "+rhythm+" (n normal, i inverse)"
  puts "entryexit note selected " if entryexit
  use_bpm 60

  bn=[ring(:c3,:f3,:g3,:g2 ),ring(:c3,:g3,:g2,:c3)].choose.shuffle #base notes
  puts"base notes "+bn.to_s
  bs=scale(0,sname).shuffle #get sequence of notes in scale shuffled
  #tempo changes
  fac1= (1-tempochange.to_f/100)**(1.0/(numpasses*4/2)) #calculate bmp_mul factor for slow down
  #puts fac1
  puts "tempo reduction set to "+((1-fac1**(numpasses*4/2))*100).round.to_s+"%" #check
  fac5=fac4=fac3=fac2=fac1 #set individual starting fac values for each loop

  #start with 4 16 bit rhythm patterns based on the binary numbers 0-15
  #set up binary rhythms r1 0-3,r2 4-7,r3 8-11,r4 12-15
  br=["0000000100100011","0100010101100111","0100010101100111","1100110111101111"].shuffle
  r1=[br[0],br[0].reverse].choose
  r2=[br[1],br[1].reverse].choose
  r3=[br[2],br[2].reverse].choose
  r4=[br[3],br[3].reverse].choose
  puts "Starting Rhythms "+r1+" "+r2+" "+r3+" "+r4 #currently selected rhythms

  #now convert to rings
  r1= r1.split('').map(&:to_i).ring
  r2= r2.split('').map(&:to_i).ring
  r3= r3.split('').map(&:to_i).ring
  r4= r4.split('').map(&:to_i).ring

  #make 4 selection rings
  rl1=ring(r1,r2,r3,r4)
  rl2=rl1.rotate
  rl3=rl2.rotate
  rl4=rl3.rotate


  if entryexit then #optional fm "wind up" note to start
    use_synth :fm
    p=play 36,sustain: 5,divisor: 12,amp: 0.3
    control p,note_slide: 3,note: 56,amp_slide: 4,amp: 1
    sleep 3
    control p,amp_slide: 2,amp:0
  end

  with_fx :level do |v| #used to fade out rhythms at the end
    control v,amp: startlevel #set initial level
    with_fx :reverb do
      live_loop :audio do
        tick
        if look >= (numpasses-1)*256+128 #start fading during last pass
        then
          limit=1 #set level endpoint
          limit=0.7 if entryexit #leave 30% if exit note
          control v,amp: startlevel*( 1.0-limit*(look-128-(numpasses-1)*256).to_f/128) #fade to 30% or 0%
        end
        fac5=1.0/fac5 if look==numpasses*256/2 #change fac to speed up at half way point
        use_bpm_mul fac5 if (32-look%64)==0
        sleep t
        stop if look==numpasses*256 #stop after numpasses completed
      end

      live_loop :x1 do
        use_synth :blade
        tick
        tick_set :rc1,look/256 #used to select current ring from selection ring
        tick_set :bs1,look/64 #used to select base note pitch
        tick_set :flipper1,look/32 #used to flip pan settings

        base=bn.look(:bs1) #get base note
        r=rl1.look(:rc1) #get current ring

        if look%16==0 then #set emphasis for first beat of 16 (added to amp: setting)
          krv=kr;klv=kl
        else
          krv=klv=0
        end

        if look(:flipper1)%2==0 then #set pan flip
          flip=1
        else
          flip=-1
        end

        fac1=1.0/fac1 if look==numpasses*256/2 #change fac to speed up at half way point

        use_bpm_mul fac1 if (32-look%64)==0#apply bpm_mul every 64 beats
        puts "initial tempo=100%" if look == 0
        puts "tempo now reduced to "+(((bpm.to_f/60*10000).round).to_f/100).to_s+"% will increase back to 100%" if look == numpasses/2*256 - 32 and (tempochange !=0)
        if plscale then #select note according to whether scale or chord selected
          n=note(base+bs.look)
        else
          n=base
        end
        if loops.include?"1" then
          play n+12,amp: rvol+krv,attack: y*t,release: (1-y)*t,pan: 0.8*flip if (r.look == 1) and rhythm.include?"n"#main rhythm
          play n,amp: lvol+klv,attack: y*t,release: (1-y)*t,pan: -0.8*flip if (r.look != 1) and rhythm.include?"i" #inverse rhythm
        end
        sleep t

        rl1=rv(rl1) if look%16==0 #rotate all the rings in the selection ring

        if look(:rc1)==numpasses then
          cue :go
          stop
        end
        puts "Current pass "+(look(:rc1)+1).to_s if look%256==0 #print current cycle on the screen
      end

      live_loop :x2 do
        use_synth :pulse
        tick
        tick_set :rc2,look/256
        tick_set :bs2,look/64
        tick_set :flipper2,look/32 #used to slip pan settings
        base=bn.look(:bs2)
        r=rl2.look(:rc2)
        #puts r if look%256==0
        if look%16==0 then
          krv=kr;klv=kl;flip=1
        else
          krv=klv=0;flip=-1
        end
        if look(:flipper2)%2==0 then
          flip=1
        else
          flip=-1
        end
        fac2=1.0/fac2 if look==numpasses*256/2
        use_bpm_mul fac2 if (32-look%64)==0

        if plscale then
          n=note(base+bs.reverse.look)
        else
          n=base+4
        end
        if loops.include?"2" then
          play n+12,amp: rvol+krv,attack: y*t,release: (1-y)*t,pan: 0.8*flip if (r.look == 1)and rhythm.include?"n"
          play n,amp: lvol+klv,attack: y*t,release: (1-y)*t,pan: -0.8*flip if (r.look != 1) and rhythm.include?"i"
        end
        sleep t
        rl2=rv(rl2,-1) if look%16==0
        stop if look(:rc2)==numpasses
      end

      live_loop :x3 do
        use_synth :saw
        tick
        tick_set :rc3,look/256
        tick_set :bs3,look/64
        tick_set :flipper3,look/32 #used to slip pan settings
        base=bn.look(:bs3)
        r=rl3.look(:rc3)
        if look%16==0 then
          krv=kr;klv=kl;flip=1
        else
          krv=klv=0;flip=-1
        end
        if look(:flipper3)%2==0 then
          flip=1
        else
          flip=-1
        end
        fac3=1.0/fac3 if look==numpasses*256/2
        use_bpm_mul fac3 if (32-look%64)==0
        if plscale then
          n=note(base+bs.look)
        else
          n=base+7
        end
        if loops.include?"3" then
          play n+12,amp: rvol+krv,attack: y*t,release: (1-y)*t,pan: 0.8*flip if (r.look == 1)and rhythm.include?"n"
          play n,amp: lvol+klv,attack: y*t,release: (1-y)*t,pan: -0.8*flip if (r.look != 1) and rhythm.include?"i"
        end
        sleep t
        rl3=rv(rl3) if look%16==0
        stop if look(:rc3)==numpasses
      end

      live_loop :x4 do
        use_synth :tri
        tick
        tick_set :rc4,look/256
        tick_set :bs4,look/64
        tick_set :flipper4,look/32 #used to slip pan settings
        base=bn.look(:bs4)
        r=rl4.look(:rc4)
        #puts r if look%256==0
        if look%16==0 then
          krv=kr;klv=kl;flip=1
        else
          krv=klv=0;flip=-1
        end
        if look(:flipper4)%2==0 then
          flip=1
        else
          flip=-1
        end
        fac4=1.0/fac4 if look==numpasses*256/2
        use_bpm_mul fac4 if (32-look%64)==0
        if plscale then
          n=note(base+bs.reverse.look)
        else
          n=base+12
        end
        if loops.include?"4" then
          play n+12,amp: rvol+krv,attack: y*t,release: (1-y)*t,pan: 0.8*flip if (r.look == 1)and rhythm.include?"n"
          play n,amp: lvol+klv,attack: y*t,release: (1-y)*t,pan: -0.8*flip if (r.look != 1) and rhythm.include?"i"
        end
        sleep t
        rl4=rv(rl4,-1) if look%16==0
        cue :fin if look==(numpasses*256)-20 #trigger finish loop
        stop if look(:rc4)==numpasses
      end
    end #reverb

    #end piece.....fm "wind down" finishes.
    if entryexit then
      sync :fin
      use_synth :fm
      p=play 56,attack: 0.1,sustain_level: 0.9,sustain: 6,divisor: 12,amp: 1
      sleep 1 #sustain for 1 sec before changing
      control p,note_slide: 6,note: 36
      sleep 3
      puts "finished!"
      sleep 1
    end
    sync :go if !entryexit #wait for sync from loop x1
    sleep 1
  end#end level
end#loop