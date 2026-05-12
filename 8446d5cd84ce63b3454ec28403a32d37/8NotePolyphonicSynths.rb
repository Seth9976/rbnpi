#8 note polyphony gated synth for Sonic Pi 3
#by Robin Newman, August 2017
TouchOSC_IP="192.168.1.50"
use_osc TouchOSC_IP,9000

use_debug false
use_cue_logging false
use_osc_logging false
set :vol,0.75
set :co,100
set :syn,:tri
set :trset,0

define :setLed do |n,i|
  use_real_time
  osc "/nc/"+n,i
end
osc "/nc/synthmaster/2/1",1
osc "/nc/vol",0.75
osc "/nc/cutoff",0.5
osc "/nc/transpose/1/8",1 # equiv 0 transpose
osc "/nc/reverb",0.5

define :getsyn do |address|
  return get_event(address).to_s.split(",")[6][address.length-2..-4].to_i
end

live_loop :get_synthmaster do
  use_real_time
  b= sync "/osc/nc/synthmaster/**/1"
  if b[0]==1
    slist=[:chipbass, :chiplead,:dsaw, :fm,:mod_fm,:mod_pulse, :mod_saw,:prophet, :pulse, :saw, :square, :supersaw, :tb303, :tech_saws, :tri, :zawa]
    p= 16-getsyn("/osc/nc/synthmaster/**/1")
    set :syn,slist[p]
    puts "synth",get(:syn)
  end
end
define :book_synth do
  s=0
  if get(:use1)==0
    set :use1,1
    s=1
  elsif get(:use2)==0
    set :use2,1
    s=2
  elsif get(:use3)==0
    set :use3,1
    s=3
  elsif get(:use4)==0
    set :use4,1
    s=4
  elsif get(:use5)==0
    set :use5,1
    s=5
  elsif get(:use6)==0
    set :use6,1
    s=6
  elsif get(:use7)==0
    set :use7,1
    s=7
  elsif get(:use8)==0
    set :use8,1
    s=8
  end
  puts get(:use1),get(:use2),get(:use3),get(:use4),get(:use5),get(:use6),get(:use7),get(:use8)
  return s
end
live_loop :resetnotes do
  b= sync "/osc/nc/resetnotes"
  if b[0]>0
    set :use1,0
    set :use2,0
    set :use3,0
    set :use4,0
    set :use5,0
    set :use6,0
    set :use7,0
    set :use8,0
    set :on1,0
    set :on2,0
    set :on3,0
    set :on4,0
    set :on5,0
    set :on6,0
    set :on7,0
    set :on8,0
  end
end
define :getTranspose do |address|
  return get_event(address).to_s.split(",")[6][address.length+1..-2].to_i
end
live_loop :setTranspose do
  use_real_time
  b= sync "/osc/nc/transpose/1/*"
  if b[0]==1
    tr= getTranspose("/osc/nc/transpose/1/*")-1
    puts "tr is",tr
    set(:trset,[-12,-10,-8,-7,-5,-3,-1,0,2,4,5,7,9,11,12][tr])
    puts "Transpose",get(:trset)
  end
end
define :pdec2 do |n|
  return (n.to_f*100).round.to_f/100
end
live_loop :get_cutoff do
  use_real_time
  b= sync "/osc/nc/cutoff"
  set :co,b[0]*40+80
  puts "Cutoff:",pdec2(get(:co))
end
live_loop :getvol do
  use_real_time
  b= sync "/osc/nc/vol"
  set :vol,b[0]
  puts "vol:",pdec2(get(:vol))
end
### PLAYING SECTION BELOW ###
with_fx :reverb,room: 0.8,mix: 0.5 do |rv|
  in_thread do
    loop do
      b=sync  "/osc/nc/reverb"
      control rv,mix: b[0],mix_slide: 0.05
      puts"Reverb mix",pdec2(b[0])
    end
  end
  
  live_loop :c_synth1 do
    use_real_time
    while get(:on1)==0
      sleep 0.02
    end
    setLed("led1",1)
    use_synth get(:syn)
    n = play get(:cnt1)+get(:trset),sustain: 6000,cutoff: get(:co),amp: 0,release: 0
    while get(:on1)==1
      sleep 0.02
      control n,note: get(:cnt1)+get(:trset),amp: get(:vol)*get(:vm1),amp_slide: 0.01,cutoff: get(:co),cutoff_slide: 0.01
    end
    sleep 0.02
    setLed("led1",0)
    control n, amp: 0,amp_slide: 0.01
    sleep 0.02
    n.kill
    #sleep 0.01
  end
  
  live_loop :c_synth2 do
    use_real_time
    while get(:on2)==0
      sleep 0.02
    end
    setLed("led2",1)
    use_synth get(:syn)
    n= play get(:cnt2)+get(:trset),sustain: 6000,cutoff: get(:co),amp: 0,release: 0
    while get(:on2)==1
      sleep 0.02
      control n,note: get(:cnt2)+get(:trset),amp: get(:vol)*get(:vm2),amp_slide: 0.01,cutoff: get(:co),cutoff_slide: 0.01
    end
    sleep 0.02
    setLed("led2",0)
    control n, amp: 0,amp_slide: 0.01
    sleep 0.02
    n.kill
    #sleep 0.01
  end
  live_loop :c_synth3 do
    use_real_time
    while get(:on3)==0
      sleep 0.02
    end
    setLed("led3",1)
    use_synth get(:syn)
    n= play get(:cnt3)+get(:trset),sustain: 6000,cutoff: get(:co),amp: 0,release: 0
    while get(:on3)==1
      sleep 0.02
      control n,note: get(:cnt3)+get(:trset),amp: get(:vol)*get(:vm3),amp_slide: 0.01,cutoff: get(:co),cutoff_slide: 0.01
    end
    sleep 0.02
    setLed("led3",0)
    control n, amp: 0,amp_slide: 0.01
    sleep 0.02
    n.kill
    #sleep 0.01
  end
  live_loop :c_synth4 do
    use_real_time
    while get(:on4)==0
      sleep 0.02
    end
    setLed("led4",1)
    use_synth get(:syn)
    n= play get(:cnt4)+get(:trset),sustain: 6000,cutoff: get(:co),amp: 0,release: 0
    while get(:on4)==1
      sleep 0.02
      control n,note: get(:cnt4)+get(:trset),amp: get(:vol)*get(:vm4),amp_slide: 0.01,cutoff: get(:co),cutoff_slide: 0.01
    end
    sleep 0.02
    setLed("led4",0)
    control n, amp: 0,amp_slide: 0.01
    sleep 0.02
    n.kill
    #sleep 0.01
  end
  live_loop :c_synth5 do
    use_real_time
    while get(:on5)==0
      sleep 0.02
    end
    setLed("led5",1)
    use_synth get(:syn)
    n= play get(:cnt5)+get(:trset),sustain: 6000,cutoff: get(:co),amp: 0,release: 0
    while get(:on5)==1
      sleep 0.02
      control n,note: get(:cnt5)+get(:trset),amp: get(:vol)*get(:vm5),amp_slide: 0.01,cutoff: get(:co),cutoff_slide: 0.01
    end
    sleep 0.02
    setLed("led5",0)
    control n, amp: 0,amp_slide: 0.01
    sleep 0.02
    n.kill
    #sleep 0.01
  end
  live_loop :c_synth6 do
    use_real_time
    while get(:on6)==0
      sleep 0.02
    end
    setLed("led6",1)
    use_synth get(:syn)
    n= play get(:cnt6)+get(:trset),sustain: 6000,cutoff: get(:co),amp: 0,release: 0
    
    while get(:on6)==1
      sleep 0.02
      control n,note: get(:cnt6)+get(:trset),amp: get(:vol)*get(:vm6),amp_slide: 0.01,cutoff: get(:co),cutoff_slide: 0.01
    end
    sleep 0.02
    setLed("led6",0)
    control n, amp: 0,amp_slide: 0.01
    sleep 0.02
    n.kill
    #sleep 0.01
  end
  live_loop :c_synth7 do
    use_real_time
    while get(:on7)==0
      sleep 0.02
    end
    setLed("led7",1)
    use_synth get(:syn)
    n= play get(:cnt7)+get(:trset),sustain: 6000,cutoff: get(:co),amp: 0,release: 0
    while get(:on7)==1
      sleep 0.02
      control n,note: get(:cnt7)+get(:trset),amp: get(:vol)*get(:vm7),amp_slide: 0.01,cutoff: get(:co),cutoff_slide: 0.01
    end
    sleep 0.02
    setLed("led7",0)
    control n, amp: 0,amp_slide: 0.01
    sleep 0.02
    n.kill
    #sleep 0.01
  end
  live_loop :c_synth8 do
    use_real_time
    while get(:on8)==0
      sleep 0.02
    end
    setLed("led8",1)
    use_synth get(:syn)
    n= play get(:cnt8)+get(:trset),sustain: 6000,cutoff: get(:co),amp: 0,release: 0
    while get(:on8)==1
      sleep 0.02
      control n,note: get(:cnt8)+get(:trset),amp: get(:vol)*get(:vm8),amp_slide: 0.01,cutoff: get(:co),cutoff_slide: 0.01
    end
    sleep 0.02
    setLed("led8",0)
    control n, amp: 0,amp_slide: 0.01
    sleep 0.02
    n.kill
    #sleep 0.01
  end
end #fx

live_loop :midi_on do
  use_real_time
  b=sync "/midi/**/*/*/note_on"
  if b[1]>0
    msyn=book_synth
    puts "SYNTH",msyn
    if !(msyn == 0)
      if msyn==1
        set :lk1,b[0]
        set :cnt1 ,b[0]
        set :vm1,b[1].to_f/127
        set :on1,1
      elsif msyn==2
        set :lk2,b[0]
        set :cnt2 ,b[0]
        set :vm2,b[1].to_f/127
        set :on2,1
      elsif msyn==3
        set :lk3,b[0]
        set :cnt3 ,b[0]
        set :vm3,b[1].to_f/127
        set :on3,1
      elsif msyn==4
        set :lk4,b[0]
        set :cnt4 ,b[0]
        set :vm4,b[1].to_f/127
        set :on4,1
      elsif msyn==5
        set :lk5,b[0]
        set :cnt5 ,b[0]
        set :vm5,b[1].to_f/127
        set :on5,1
      elsif msyn==6
        set :lk6,b[0]
        set :cnt6 ,b[0]
        set :vm6,b[1].to_f/127
        set :on6,1
      elsif msyn==7
        set :lk7,b[0]
        set :cnt7 ,b[0]
        set :vm7,b[1].to_f/127
        set :on7,1
      elsif msyn==8
        set :lk8,b[0]
        set :cnt8 ,b[0]
        set :vm8,b[1].to_f/127
        set :on8,1
      end
    end
  else
    if b[0]== get(:lk1)
      set :on1,0
      set :use1,0
    elsif b[0]==get(:lk2)
      set :on2,0
      set :use2,0
    elsif b[0]==get(:lk3)
      set :on3,0
      set :use3,0
    elsif b[0]==get(:lk4)
      set :on4,0
      set :use4,0
    elsif b[0]==get(:lk5)
      set :on5,0
      set :use5,0
    elsif b[0]==get(:lk6)
      set :on6,0
      set :use6,0
    elsif b[0]==get(:lk7)
      set :on7,0
      set :use7,0
    elsif b[0]==get(:lk8)
      set :on8,0
      set :use8,0
    end
    puts "In use",get(:use1),get(:use2),get(:use3),get(:use4),get(:use5),get(:use6),get(:use7),get(:use8)
  end
end