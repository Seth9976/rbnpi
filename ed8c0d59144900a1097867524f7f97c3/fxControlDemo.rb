#fxControlDemo.rb
#This program demonstrates the control of fx parameters to give smooth fades
#in their effects. Prompted by a thread https://in-thread.sonic-pi.net/t/smooth-parameter-automation/1626
#started by Martin Butz

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

at [0,8,16],[[0,1,8,:fade,:lv1,:amp],[0,0.8,16,:wave,:lv2,:mix],[1,0,8,:fade,:lv1,:amp]] do |param|
  fadeControl param[0],param[1],param[2],param[3],param[4],param[5]
end


at [24] do
  #next command is equivalent to pushing stup playing button
  #note 4557 is the server listen port
  # "rbnguid" is a required globally unique id (can be anything in this case)
  osc_send "localhost",4557,"/stop-all-jobs","rbnguid"
end


with_fx:level,amp: 0 do |lv1|
  set :lv1,lv1
  with_fx :reverb,room: 0.8,mix: 0 do |lv2|
    set :lv2,lv2
    live_loop :notes do
      play scale(:e3,:minor_pentatonic,num_octaves: 3).choose,release: 0.125
      sleep 0.125
    end
  end
end