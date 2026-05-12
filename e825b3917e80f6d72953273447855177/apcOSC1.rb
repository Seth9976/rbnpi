#apcOSC1.rb
#Sonic Pi 3 automated parameter control for fx calls controlled by TouchOSC
#developed from an idea by Martin Butz. Code developed by Robin Newman, November 2018
use_osc "192.168.1.240",9000 #address of TouchOSC and input port
#initialise some parameters
#these will be updated further by signals from TouchOSC
set :start,0
set :finish,0.5
set :dur,1
set :type,:fade
set :lvOSC,0
set :lvOSC2,0
set :lvOSC3,0
#initialise TouchOSC
osc"/param/led",1 #flash led on to show it is working
sleep 0.4
osc "/param/start/1/11",1
osc "/param/finish/1/6",1
osc "/param/dur/1/7",1
osc "/param/type/1/1",1

#adjust state of trigger highlight
define :setTriggerLight do |pointer,state|
  puts "pointer,state",pointer,state
  case pointer
  when :lvOSC
    osc "/param/trigger1",state
  when :lvOSC2
    osc "/param/trigger2",state
  when :lvOSC3
    osc "/param/trigger3",state
  when :lvOSC4
    osc "/param/trigger4",state
  end
end

setTriggerLight(:lvOSC,0)
setTriggerLight(:lvOSC2,0)
setTriggerLight(:lvOSC3,0)
setTriggerLight(:lvOSC4,0)

#function generates fade levels
define :fadeSteps do |min, max, len, type|
  case type
  when :fade
    b = (line min, max, steps: len, inclusive: true).stretch(2).drop(1).butlast.ramp
  when :wave
    b = (line min, max, steps: len, inclusive: true).stretch(2).drop(1).butlast.mirror
  end
  return b #will return without this statement, but more explicit to put it in
end

#This function controls parameter for an fx pointed to by pointer
#start and finish define fade points (range 0->1 each, duration is time in beats for fade
#tyoe is  :fade (start->finish) or :wave (start->finish->start)
#opt is parameter name to control eg :mix, :pan, :amp
define :fadeControl do |start,finish,duration,type,pointer,opt|
  #puts "first",start,finish,type #for debugging
  #adjust values to use according to fade time and direction
  #:up works as :down if start>finish
  #first check and stop if start==finish
  setTriggerLight(pointer,0) if start==finish
  return if start==finish
  l=fadeSteps start,finish,11,type #11 ensures 20 steps for each up/down, 40 for wave
  puts"l=#{l}"
  if type==:wave
    dt=duration/40.0 #adjust step interval to give correct total time
  else
    dt=duration/20.0
  end
  #puts l.length,type #uncomment for debugging to check number of steps
  #print current fade
  puts "fadeControl #{start} #{finish} #{duration} #{type} #{pointer} #{opt}"
  in_thread do
    t=vt
    tick_reset
    l.length.times do
      #note that amp: is equivalent to :amp=> This enables use of :amp stored in a variable
      # similarly for pan: or phase: or any other similar
      # note also how the corresponding _slide is created.
      control get(pointer),opt=> l.tick,(opt.to_s+"_slide").to_sym => dt
      sleep dt
    end
    #puts "duration was #{t-vt}" #for debugging
    setTriggerLight(pointer,0)
  end
end

#helper function extracts wild card matches from osc addresses
define :parse_sync_address do |address|
  v= get_event(address).to_s.split(",")[6]
  if v != nil
    return v[3..-2].split("/")
  else
    return ["error"]
  end
end

#section to update parameters from TouchOSC messages
live_loop :getStart do
  use_real_time
  b = sync "/osc*/param/start/1/*"
  if b[0]>0
    num=parse_sync_address("/osc*/param/start/1/*")[4].to_i
    start=[1.0,0.9,0.8,0.7,0.6,0.5,0.4,0.3,0.2,0.1,0.0][num-1] #lookup fade duration
    set :start,start
    puts "start set #{start}"
  end
end


live_loop :getFinish do
  use_real_time
  b = sync "/osc*/param/finish/1/*"
  if b[0]>0
    num=parse_sync_address("/osc*/param/finish/1/*")[4].to_i
    finish=[1.0,0.9,0.8,0.7,0.6,0.5,0.4,0.3,0.2,0.1,0.0][num-1] #lookup fade duration
    set :finish,finish
    puts "finish set #{finish}"
  end
end

live_loop :getDur do
  use_real_time
  b=sync "/osc*/param/dur/1/*"
  if b[0]>0
    num=parse_sync_address("/osc*/param/dur/1/*")[4].to_i
    dur=[16,8,6,4,3,2,1,0.5][num-1] #lookup fade duration
    puts "fade duration set to #{dur}"
    set :dur,dur
  end
end

live_loop :getType do
  use_real_time
  b = sync "/osc*/param/type/*/1"
  if b[0]>0
    num=parse_sync_address("/osc*/param/type/*/1")[3].to_i
    type=[:fade,:wave][num-1] #lookup type
    puts "type set to #{type}"
    set :type,type
  end
end
#end of section to set parameters by TouchOSC


with_fx :reverb,room: 0.8,mix: 0 do |lvOSC2|
  set :lvOSC2,lvOSC2 #store pointer to second fx
  with_fx :echo,phase: 0.5,mix: 0 do |lvOSC3| # store pointer to third fx
    set :lvOSC3,lvOSC3
    
    
    with_fx :level,amp: 0 do |lvOSC|
      set :lvOSC,lvOSC #store pointer to first fx
      #This live loop carries out the control of the paramter when triggered by TouchOSC
      live_loop :trigger do
        use_real_time
        trigger = sync "/osc*/param/trigger*"
        tnum=parse_sync_address("/osc*/param/trigger*")[2][-1].to_i #get trigger number
        if trigger[0]>0 and tnum==1
          puts"trigger1"
          #apply fade to first fx (level :amp)
          offset=0;mult=1 #offset and scaling if required
          fadeControl get(:start)*mult+offset,get(:finish)*mult+offset,get(:dur),get(:type),:lvOSC,:amp
        end
        if trigger[0]>0 and tnum==2
          #apply fade to second fx (reverb :mix)
          puts"trigger2"
          offset=0;mult=1 #offset and scaling if required
          fadeControl get(:start)*mult+offset,get(:finish)*mult+offset,get(:dur),get(:type),:lvOSC2,:mix
        end
        if trigger[0]>0 and tnum==3
          #apply fade to third fx (echo :mix)
          puts"trigger3"
          offset=0;mult=1 ##offset and scaling if required
          fadeControl get(:start)*mult+offset,get(:finish)*mult+offset,get(:dur),get(:type),:lvOSC3,:mix
        end
        if trigger[0]>0 and tnum==4
          puts "send trigger4"
          cue :trigger4
        end
      end
      #This is the live loop affected by the fx wrappers
      live_loop :osc do
        #16.times do
        sample :loop_breakbeat,beat_stretch: 1,amp: 2
        sleep 1
        #end
      end
      
    end #fx level (1)
    with_fx :level, amp: 0 do |lvOSC4|
      set :lvOSC4,lvOSC4
      live_loop :triggerb do
        use_real_time
        trigger = sync "/osc*/param/trigger*"
        tnum=parse_sync_address("/osc*/param/trigger*")[2][-1].to_i #get trigger number
        if trigger[0]>0 and tnum==4
          puts"trigger4"
          offset=0;mult=1 ##offset and scaling if required
          fadeControl get(:start)*mult+offset,get(:finish)*mult+offset,get(:dur),get(:type),:lvOSC4,:amp
        end
      end
      live_loop :playnotes do
        use_synth :tb303
        play scale(:e3,:minor_pentatonic,num_octaves:2).choose,release: 0.125,amp: 0.5,cutoff: rrand_i(50,120)
        sleep 0.125
      end
    end #fx level(2)
  end #fx pan
end #fx reverb
