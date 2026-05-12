#apcPROG.rb
#Sonic Pi 3 automated parameter control for fx calls controlled by TouchOSC
#inspired by Martin Butz. Code developed by Robin Newman, November 2018
#programatically controlled fadeing of fx opt levels
use_random_seed 886543

#setup some starting values
set :kill,false
set :finishTime,120 #duration set for the piece
#start values for next input AFTER the initial fade of the 5 fx used
set :sv1,0.5;set :sv2,0.5;set :sv3,0.5;set :sv4,0.5;set :sv5,0.5

#This next section implements the end phase of the piece
#where all the fx effects are faded out
at [get(:finishTime)-20] do
  set :kill,true
  fadeControl get(:sv2),0,8,:fade,:lv2,:mix #reverb
  sleep 4
  fadeControl get(:sv4),0,8,:fade,:lv4,:amp #playnotes level
  sleep 4
  fadeControl get(:sv3),0,8,:fade,:lv3,:mix #echo
  sleep 4
  fadeControl get(:sv1),0,8,:fade,:lv1,:amp #rhythm level
  sleep 4
  fadeControl get(:sv5),0,4,:fade,:lv5,:mix #panslicer
  sleep 4
  #next command is the same as pushing the stop playing button programatically
  osc_send "localhost",4557,"/stop-all-jobs","rbnguid"
end

#Martin Butz's original fade function renamed, and simplified
#for only two fade types fade and wave
#fade up or down is selected automatically from the relation#
#between start and finish values
define :fadeSteps do |start, finish, len, type|
  case type
  when :fade
    b = (line start, finish, steps: len, inclusive: true).stretch(2).drop(1).butlast.ramp
  when :wave
    b = (line start, finish, steps: len, inclusive: true).stretch(2).drop(1).butlast.mirror
  end
  return b #will return without this statement, but more explicit to put it in
end

#functions gives fx info related to a given pointer
define :fxname do |pointer|
  case pointer
  when :lv1
    return ":level (rhythm) :amp"
  when :lv2
    return ":reverb :mix"
  when :lv3
    return ":echo :mix"
  when :lv4
    return ":level (playnotes) :amp"
  when :lv5
    return ":panslicer (playnotes) :mix"
  end
end

#This function controls a parameter for an fx pointed to by pointer
#start and finish define fade points (range 0->1 each, duration is time in beats for fade
#type is  :fade (start->finish) or :wave (start->finish->start)
#opt is parameter name to control eg :mix, :pan, :amp
define :fadeControl do |start,finish,duration,type,pointer,opt|
  #first check and stop if start==finish
  return if start==finish #as nothing to do
  l=fadeSteps start,finish,11,type #11 ensures 20 steps for each up/down, 40 for wave
  #puts"l=#{l}" #print the steps for debugging
  if type==:wave
    dt=duration/40.0 #adjust step interval to give correct total time
  else
    dt=duration/20.0
  end
  #puts l.length,type #uncomment for debugging to check number of steps
  #print current fade
  puts  fxname(pointer) #info about what is being controlled
  puts "fadeControl #{start} #{finish} #{duration} #{type} #{pointer} #{opt}"
  in_thread do
    #t=vt #for debugging purposes
    tick_reset
    l.length.times do
      #note that amp: is equivalent to :amp=> This enables use of :amp stored in a variable
      # similarly for pan: or phase: or any other similar
      # note also how the corresponding _slide is created.
      control get(pointer),opt=> l.tick,(opt.to_s+"_slide").to_sym => dt
      sleep dt
    end
    #puts "duration was #{t-vt}" #for debugging
  end
end

with_fx :reverb,room: 0.8,mix: 0 do |lv2|
  set :lv2,lv2 #store pointer to second fx
  with_fx :echo,phase: 0.5,mix: 0 do |lv3| # store pointer to third fx
    set :lv3,lv3
    with_fx :level,amp: 0 do |lv1|
      set :lv1,lv1 #store pointer to 1st fx
      
      #start initial fades for level,reverb and echo. All fade from 0->0.5 in sequence
      at [0,4,8,16],[[0,0.5,4,:fade,:lv1,:amp],[0,0.5,4,:fade,:lv2,:mix],[0,0.5,4,:fade,:lv5,:mix],[0,0.5,4,:fade,:lv3,:mix]] do |param|
        fadeControl param[0],param[1],param[2],param[3],param[4],param[5]
      end
      
      #loop starts random fades for level fx. Each start set to previous finish
      live_loop :beatlevel,delay: 20 do #(delayed start)
        #stop
        t=[2,4,6].choose #choose duration of fade
        nextType=[:fade,:fade,:wave].choose # choose fader type
        if get(:sv1)<0.5 #select finish value
          start=get(:sv1);finish=rrand(0.6,1)
        else
          start=get(:sv1);finish=rrand(0.1,0.4)
        end
        #set :sv1 value for start value next time
        if nextType==:fade
          set :sv1,finish
        else
          set :sv1,start
        end
        #perform the fade
        fadeControl start,finish,t,nextType,:lv1,:amp
        sleep t+[2,4,6].choose #sleep byond the end of the fade
        stop if get(:kill) #stops loop during end phase
      end
      
      #loop starts random fades for reverb fx. Each start set to previous finish
      live_loop :reverblevel,delay: 24 do #(delayed start)
        #stop
        t=[2,4,6].choose #choose duration of fade
        nextType=[:fade,:fade,:wave].choose
        if get(:sv2)<0.5 #select a finish value
          start=get(:sv2);finish=rrand(0.6,1)
        else
          start=get(:sv2);finish=rrand(0.1,0.4)
        end
        #set sv2 value for start value next time
        if nextType==:fade
          set :sv2,finish
        else
          set :sv2,start
        end
        #perform the fade
        fadeControl start,finish,t,nextType,:lv2,:mix
        #sleep until after the end of teh dade
        sleep t+[2,4,6].choose
        stop if get(:kill) #stops loop during end phase
      end
      
      #loop starts random fades for echo fx Each start set to previous finish
      live_loop :echolevel,delay: 28 do #(delayed start)
        #stop
        t=[2,4,6].choose #choose duration of fade
        nextType=[:fade,:fade,:wave].choose
        if get(:sv3)<0.5 #select a finish value
          start=get(:sv3);finish=rrand(0.6,1)
        else
          start=get(:sv3);finish=rrand(0.1,0.4)
        end
        #set sv2 value for start value next time
        if nextType==:fade
          set :sv3,finish
        else
          set :sv3,start
        end
        fadeControl start,finish,t,nextType,:lv3,:mix
        #sleep until after the end of the fade
        sleep t+[2,4,6].choose
        stop if get(:kill) #stops loop during end phase
      end
      #next fx only affects live loop rhythm
      with_fx :panslicer,phase: 0.25,mix: 0 do |lv5|
        set :lv5,lv5
        #loop starts random fades for panslicer fx.
        live_loop :panslicerlevel,delay: 32 do
          #stop
          t=[2,4,6].choose #choose duration of fad
          nextType=[:fade,:fade,:wave].choose
          if get(:sv5)<0.5 #select a finish value
            start=get(:sv5);finish=rrand(0.6,1)
          else
            start=get(:sv5);finish=rrand(0.1,0.4)
          end
          #set sv5 value for start value next time
          if nextType==:fade
            set :sv5,finish
          else
            set :sv5,start
          end
          fadeControl start,finish,t,nextType,:lv5,:mix
          #sleep until after the end of the fade
          sleep t+[2,4,6].choose
          stop if get(:kill) #stops loop during end phase
        end
        
        live_loop :rhythm do
          sample :loop_breakbeat,beat_stretch: 1,amp: 2
          sleep 1
        end
      end #fx panslicer
    end #fx level (rhythm)
    
    with_fx :level, amp: 0 do |lv4| #fx level just effects  playnotes loop
      set :lv4,lv4 #store pointer to lv4
      
      at [12], [[0,1,4,:fade,:lv4,:amp]] do |param|
        fadeControl param[0],param[1],param[2],param[3],param[4],param[5]
      end
      live_loop :noteslevel,delay: 32 do
        #stop
        t=[2,4,6].choose
        nextType=[:fade,:fade,:wave].choose
        if get(:sv4)<0.5
          start=get(:sv4);finish=rrand(0.6,1)
        else
          start=get(:sv4);finish=rrand(0.1,0.4)
        end
        if nextType==:fade
          set :sv4,finish
        else
          set :sv4,start
        end
        fadeControl start,finish,t,nextType,:lv4,:amp
        sleep t+[2,4,6].choose
        stop if get(:kill)
      end
      
      live_loop :playnotes do
        use_synth :tb303
        play scale(:e3,:minor_pentatonic,num_octaves:2).choose,release: 0.125,amp: 0.5,cutoff: rrand_i(50,120)
        sleep 0.125
      end
    end #fx level(playnotes)
  end #fx echo
end #fx reverb