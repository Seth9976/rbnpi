#Game of Simon for Sonic Pi, swtiches and leds and LCD display
#by Robin Newman, February 2018
use_osc 'localhost',8000

use_debug false
use_osc_logging false
use_random_seed(Time.now.nsec/10000)

osc "/led/control","o"
osc "/sendscores",0,0
sleep 0.2
set :button,""
set :pattern,[]
set :score,0
set :hiscore,0
set :currentstep,0
use_real_time
define :ledon do |s|
  osc "/led/control",s
  case s
  when "g"
    play :e3,release: 0.3
  when "r"
    play :cs4,release: 0.3
  when "b"
    play :e4,release: 0.3
  when "y"
    play :a4,release: 0.3
  end
  sleep 0.3
  osc"/led/control","o"
  sleep 0.01
end

define :getbutton do
  b = sync "/osc/mon"
  set :button, b[1]
  puts "Pushed",b[1]
  if get(:inputmode)
    p=get(:pattern)
    c=get(:currentstep)
    if b[1] == p[c]
      ledon p[c]
      sleep 0.2
      c+=1
      if c == p.length
        sc=get(:score)
        hsc=get(:hiscore)
        set :score,sc+1
        hsc=sc+1  if sc+1 > hsc
        set :hiscore,hsc
        puts "Your score is",sc+1
        puts "Hi-score is",hsc
        osc "/sendscores",sc+1,hsc
        set :currentstep,0
        sample :perc_till
        puts "well done"
        sleep 1
        set :inputmode,false
      else
        set :currentstep, c
      end
    elsif
      b[1] != p[c]
      set :pattern,[]
      set :currentstep,0
      set :score,0
      sample :misc_crow
      puts "you made a mistake"
      osc  "/sendscores",0,get(:hiscore)
      use_random_seed(Time.now.nsec/10000) #reset random seed
      sleep 1
      set :inputmode,false
    end
  end
end

live_loop :game do
  use_real_time
  set :inputmode,false
  if get(:inputmode) == false
    p=get(:pattern)
    set :pattern, p+ [["g","r","b","y"].choose]
    p=get(:pattern)
    puts "pattern set to ",p
    p.length.times do |x|
      ledon p[x]
      sleep 0.2
    end
    set :inputmode,true
    until get(:inputmode)==false
      getbutton
      sleep 0.05
    end   
  end
end

