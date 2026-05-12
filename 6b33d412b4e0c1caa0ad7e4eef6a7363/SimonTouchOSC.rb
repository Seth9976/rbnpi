#Game of Simon for Sonic Pi with TouchOSC interface
#by Robin Newman, February 2018
use_osc '192.168.1.240',9000 #address of TouchOSC device. Adjust to suit your setup
use_real_time
use_debug false
use_osc_logging false
osc "/touch/score",0 #intialise scores on TouchOSC device
osc "/touch/hiscore",0
sleep 0.2
set :button,"" #set up initial time state values
set :pattern,[]
set :score,0
set :hiscore,0
set :currentstep,0

use_random_seed(Time.now.nsec) #set random seed for new game

define :ledon do |s| #function to flash "led" on TouchOSC device and play note
  use_real_time
  case s
  when "g"
    osc "/touch/ledg",1
    play :e3,release: 0.3
  when "r"
    osc "/touch/ledr",1
    play :cs4,release: 0.3
  when "b"
    osc "/touch/ledb",1
    play :e4,release: 0.3
  when "y"
    osc "/touch/ledy",1
    play :a4,release: 0.3
  end
  sleep 0.3
  osc "/touch/ledg",0 #turn all TouchOSC leds off
  osc "/touch/ledr",0
  osc "/touch/ledb",0
  osc "/touch/ledy",0
  sleep 0.01
end

define :flashall do |d|
  osc "/touch/ledg",1 #turn all TouchOSC leds on
  osc "/touch/ledr",1
  osc "/touch/ledb",1
  osc "/touch/ledy",1
  sleep d
  osc "/touch/ledg",0 #turn all TouchOSC leds off
  osc "/touch/ledr",0
  osc "/touch/ledb",0
  osc "/touch/ledy",0
  sleep d if d<0.1
end


define :decodebutton do |address| #extracts wild card info from address /osc/touch/push/*/*
  #uses undocumented function getevent
  #getevent("/osc/touch/push/*/*") will return output like:
  #<SonicPi::CueEvent:[[1519217795.274847, 0, #<SonicPi::ThreadId [-1]>, 0, 0.0, 60.0], "/osc/touch/push/2/2", [1.0]]
  #from which the substitutes for the wildcard * can be extracted using the strign functions below
  s= get_event(address).to_s.split(",")[6][address.length-1..-2].split("/")
  column=s[0].to_i
  row=s[1].to_i
  res= "g" if column==1 and row==1
  res= "b" if column==1 and row==2
  res= "r" if column==2 and row==1
  res= "y" if column==2 and row==2
  return res
end

define :getbutton do
  use_real_time
  b = sync "/osc/touch/push/*/*"
  if b[0]==1 #pushed
    pushed=decodebutton("/osc/touch/push/*/*")
    set :button, pushed
    puts "Pushed",pushed
    if get(:inputmode) #check if button input mode
      p=get(:pattern)#get current pattern
      c=get(:currentstep) #get step in pattern
      ledon pushed #flash led for pushed button
      sleep 0.2
      if pushed== p[c] #check if correct button pushed
        c+=1 #increase step pointer
        if c == p.length #see if reached end of pattern ie winning state
          sc=get(:score) #et current score
          hsc=get(:hiscore) ##get current hi-score
          set :score,sc+1 ##increase score by one and store
          hsc=sc+1  if sc+1 > hsc #increase hi-score if necessary
          set :hiscore,hsc
          puts "Your score is",sc+1 #publish scores on screen and touch device
          puts "Hi-score is",hsc
          osc "/touch/score",sc+1
          osc "/touch/hiscore",hsc
          set :currentstep,0 #reset step for next run
          sample :perc_till #sound winning cash register
          puts "well done"
          flashall 0.5
          use_random_seed(Time.now.nsec) #set random seed for new game
          sleep 0.5
          set :inputmode,false #disable input mode
        else
          set :currentstep, c #not end of pattern so bump pointer
        end
      else
        set :pattern,[] #reset time state variables
        set :currentstep,0
        set :score,0
        sample :misc_crow #play loosing crow sound
        puts "you made a mistake"
        3.times do
          flashall 0.025
        end
        
        osc  "/touch/score",0 #reset user score
        osc "/touch/hiscore",get(:hiscore)
        use_random_seed(Time.now.nsec) #set random seed for new game
        sleep 1
        set :inputmode,false #disable input mode
      end
    end
  end
end

define :displayturn do #function updates label to display tunr information
  if get(:inputmode) #if input mode set "YOur Turn"
    osc "/touch/turn","Your Turn"
  else #otherwise set "Computer Turn"
    osc "/touch/turn","Computer Turn"
  end
  sleep 0.2
end

live_loop :game do #main game loop
  use_real_time
  set :inputmode,false #start with input mode false (ie computers turn)
  if get(:inputmode) == false
    displayturn #update turn indfo
    p=get(:pattern) #get current pattern
    set :pattern, p+ [["g","r","b","y"].choose]#add new random choice
    p=get(:pattern)
    puts "pattern set to ",p #display current pattern on screen
    p.length.times do |x| #output pattern data as led flashes and sounds
      ledon p[x]
      sleep 0.3
    end
    set :inputmode,true #set input mode true (ie uaser's turn)
    displayturn #update turn info
    until get(:inputmode)==false #wait for input to complete
      getbutton #get input from user
      sleep 0.05
    end
  end
  #gets here when get(:inputmode) is true
  #Time delay not necessary, as always delay waiting for input sync
end
