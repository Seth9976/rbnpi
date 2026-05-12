#CoventryCarol.rb
#controlling ThePiHut RGBXmasTree via OSC commands
#these are sent from Sonic Pi to a python OSC server running on the Pi
#which then controls the leds on the tree
#written by Robin Newman, Decemeber 2019
use_real_time
use_osc"192.168.1.34",8000
use_bpm 120
##| osc"/setAll",'black'
##| stop
#colour names
cn= ["darkred", "maroon", "red", "purple", "fuchsia", "green", "lime", "olive", "yellow", "navy", "blue", "brown", "aqua","orange","darkgreen","violet","indigo", "maroon", "red", "purple", "turquoise", "green", "lime","blue","purple","black"]
#lookup table for colour index in cn
lu={55=>0, 57=>1, 60=>2, 62=>3, 64=>4, 65=>5, 66=>6, 67=>7, 68=>8,
    69=>9, 71=>10, 72=>11, 73=>12, 74=>13, 76=>14, 77=>15, 79=>16,
    80=>17, 81=>18, 83=>19, 84=>20, 86=>21, 88=>22, 92=>23, 93=>24,0=>25}
#set brightness
osc"/brightness",0.05,1 #adjust brightness as desired. (Here set low for video: can be set up to 0.8 instead of 0.05)
sync"/osc*/brightnessdone1"
##| stop
2.times do #play complete carol specified number of times
  set :kill,false #kills tree loop
  with_fx :reverb,room: 0.8,mix: 0.6 do
    use_synth :tri
    a1=[:A5,:A5,:Gs5,:A5,:C6,:B5,:A5,:Gs5,:A5,:B5,:C6,:D6,:B5,:A5,:A5,:E6,:D6,:C6,:B5,:C6,:B5,:A5,:Gs5,:A5,:Gs5,:A5,:D6,:B5,:A5,:A5,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:r,:A5,:Gs5,:A5,:D6,:B5,:A5,:A5,:r,:A5,:A5,:Gs5,:A5,:C6,:B5,:A5,:Gs5,:A5,:B5,:C6,:D6,:B5,:A5,:A5,:B5,:C6,:D6,:E6,:D6,:C6,:B5,:C6,:B5,:A5,:Gs5,:A5,:B5,:C6,:D6,:E6,:Gs6,:A6,:A5]
    b1=[1.0,1.0,1.0,2.0,1.0,2.0,1.0,3.0,1.0,1.0,1.0,1.0,2.0,3.0,2.0,1.0,2.0,1.0,2.0,1.0,2.0,1.0,3.0,1.0,1.0,1.0,1.0,2.0,3.0,2.0,1.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,1.0,1.0,1.0,1.0,2.0,3.0,2.0,1.0,1.0,1.0,1.0,2.0,1.0,2.0,1.0,3.0,1.0,1.0,1.0,2.0,1.0,3.0,0.5,0.5,0.5,0.5,1.0,2.0,1.0,2.0,1.0,2.0,1.0,3.0,1.0,1.0,1.0,1.0,1.0,1.0,3.0,3.0]
    in_thread do
      for i in 0..a1.length-1
        set :n1,note(a1[i]) #store current note value
        play a1[i],sustain: b1[i]*0.9,release: b1[i]*0.1,pan: -0.6
        sleep b1[i]
      end
      set :n1,nil #reset note to turn off leds on next pass
    end
    
    a2=[:E5,:E5,:A5,:G5,:E5,:E5,:E5,:G5,:G5,:A5,:Gs5,:A5,:A5,:G5,:B5,:A5,:G5,:E5,:G5,:D5,:E5,:E5,:E5,:E5,:A5,:Gs5,:A5,:A5,:r,:r,:r,:r,:r,:r,:r,:r,:A4,:C5,:E5,:D5,:C5,:B4,:C5,:B4,:A4,:Gs4,:E5,:E5,:E5,:A5,:Gs5,:E5,:E5,:r,:E5,:E5,:E5,:E5,:C5,:D5,:C5,:E5,:E5,:F5,:E5,:D5,:C5,:B4,:C5,:D5,:E5,:G5,:A5,:Gs5,:E5,:C5,:D5,:E5,:F5,:G5,:B5,:A5,:B5,:A5,:G5,:F5,:E5,:G5,:D5,:B4,:A4,:B4,:C5,:D5,:E5,:G5,:G5,:F5,:A5,:Gs5,:A5,:A4]
    b2=[3.0,2.0,1.0,2.0,1.0,3.0,1.0,1.0,1.0,2.0,1.0,3.0,2.0,1.0,2.0,1.0,2.0,1.0,2.0,1.0,3.0,1.0,1.0,1.0,2.0,1.0,3.0,2.0,1.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,1.0,1.0,1.0,2.0,1.0,2.0,1.0,2.0,1.0,3.0,1.0,1.0,1.0,2.0,1.0,3.0,2.0,1.0,2.0,1.0,1.0,1.0,1.0,2.0,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,1.0,1.0,0.5,0.5,2.0,1.0,3.0,0.5,0.5,0.5,0.5,1.0,2.0,1.0,0.5,0.5,0.5,0.5,1.0,2.0,1.0,1.0,0.5,0.5,0.5,0.5,1.0,1.0,1.0,1.0,1.0,1.0,3.0,3.0]
    in_thread do
      for i in 0..a2.length-1
        set :n2,note(a2[i])
        play a2[i],sustain: b2[i]*0.9,release: b2[i]*0.1,pan: -0.3
        sleep b2[i]
      end
      set :n2,nil
    end
    
    a3=[:C5,:B4,:C5,:F5,:D5,:C5,:B4,:C5,:D5,:E5,:F5,:E5,:E5,:E5,:E5,:G5,:E5,:E5,:C5,:D5,:A4,:B4,:C5,:B4,:C5,:F5,:E5,:E5,:E5,:r,:r,:r,:r,:r,:A4,:B4,:C5,:D5,:B4,:A4,:C4,:E4,:G4,:B4,:A4,:B4,:A4,:G4,:F4,:E4,:G4,:D5,:B4,:A4,:B4,:C5,:D5,:C5,:B4,:C5,:F5,:E5,:C5,:C5,:r,:C5,:B4,:C5,:E5,:A4,:G4,:C5,:E5,:D5,:C5,:B4,:A4,:Gs4,:A4,:B4,:C5,:E5,:A4,:A4,:B4,:C5,:D5,:C5,:C5,:E5,:G5,:E5,:G5,:F5,:E5,:D5,:C5,:D5,:A4,:E4,:F4,:Gs4,:A4,:B4,:C5,:D5,:C5,:A4,:E5,:Cs5,:Cs5]
    b3=[2.0,1.0,2.0,1.0,2.0,1.0,3.0,1.0,1.0,1.0,1.0,2.0,3.0,2.0,1.0,2.0,1.0,2.0,1.0,2.0,1.0,3.0,1.0,1.0,1.0,1.0,2.0,3.0,2.0,1.0,3.0,3.0,3.0,3.0,1.0,1.0,1.0,2.0,1.0,3.0,1.0,1.0,1.0,2.0,1.0,0.5,0.5,0.5,0.5,1.0,2.0,1.0,1.0,0.5,0.5,0.5,0.5,1.0,1.0,1.0,1.0,2.0,3.0,2.0,1.0,2.0,1.0,1.0,1.0,1.0,2.0,1.0,0.5,0.5,0.5,0.5,0.5,0.5,1.0,1.0,0.5,0.5,1.0,0.5,0.5,0.5,0.5,3.0,2.0,1.0,2.0,1.0,0.5,0.5,0.5,0.5,1.0,2.0,1.0,1.0,0.5,0.5,0.5,0.5,1.0,1.0,1.0,1.0,2.0,3.0,3.0]
    in_thread do
      for i in 0..a3.length-1
        set :n3,note(a3[i])
        play a3[i],sustain: b3[i]*0.9,release: b3[i]*0.1,pan: 0.3
        sleep b3[i]
      end
      set :n3,nil
    end
    
    a4=[:A4,:A4,:E4,:A3,:F4,:G4,:A4,:r,:E4,:A4,:G4,:E4,:D4,:E4,:A4,:A4,:A4,:C5,:G4,:A4,:E4,:A4,:G4,:Fs4,:E4,:Fs4,:Gs4,:A4,:E4,:A4,:D4,:E4,:A4,:A4,:r,:A4,:A4,:Gs4,:A4,:C5,:B4,:A4,:Gs4,:A3,:G4,:E4,:D4,:E4,:A4,:A3,:E4,:A4,:C5,:G4,:A4,:E4,:A4,:G4,:Fs4,:E4,:Fs4,:Gs4,:A4,:E4,:A4,:D4,:E4,:A4,:A4,:r,:A3,:C4,:E4,:A4,:G4,:F4,:G3,:D4,:G4,:A4,:E4,:A3,:G4,:E4,:D4,:E4,:A4,:A3,:E4,:A4,:C5,:r,:B4,:A4,:r,:G4,:A4,:r,:G4,:Fs4,:E4,:A4,:G4,:E4,:D4,:E4,:A4,:A4]
    b4=[1.0,1.0,1.0,2.0,1.0,2.0,1.0,1.0,2.0,1.0,1.0,1.0,1.0,2.0,1.0,2.0,2.0,1.0,2.0,1.0,2.0,1.0,2.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,2.0,3.0,2.0,1.0,1.0,1.0,1.0,2.0,1.0,2.0,1.0,3.0,1.0,1.0,1.0,1.0,2.0,1.0,1.0,1.0,2.0,1.0,2.0,1.0,2.0,1.0,2.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,2.0,3.0,2.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,0.5,0.5,1.0,1.0,3.0,1.0,1.0,1.0,1.0,2.0,1.0,1.0,1.0,2.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,3.0,1.0,1.0,1.0,1.0,2.0,3.0,3.0]
    in_thread do
      for i in 0..a4.length-1
        set :n4,note(a4[i])
        play a4[i],sustain: b4[i]*0.9,release: b4[i]*0.1,pan: 0.6
        sleep b4[i]
      end
      set :n4,nil
      set :top,'black' #clear top at end of carol
      sleep 0.5 #allow one more pass t reset
      set :kill,true #then kill tree loop
      cue :done #cue end of carol ready for loop to start again
    end
    set :top,'white' #set colour for top led
    live_loop :tree do
      stop if get(:kill) #stop loop at the end of each play
      n1=get(:n1)
      n1=0 if n1==nil #deal with rests => nill
      n2=get(:n2)
      n2=0 if n2==nil
      n3=get(:n3)
      n3=0 if n3==nil
      n4=get(:n4)
      n4=0 if n4==nil
      top=get(:top)
      #print selected colourts for each leaf
      puts cn[lu[n1]],cn[lu[n2]],cn[lu[n3]],cn[lu[n4]]
      #send info to tree server
      osc "/leafCn",top,cn[lu[n1]],cn[lu[n2]],cn[lu[n3]],cn[lu[n4]]
      sleep 0.2
    end
  end #reverb
  sync :done #cued when carol finished
  osc"/randColName",100,25,1 #sparkling display
  sync"/osc*/randcolnamedone1"
  osc"/setAll",'black',1 #all leds off
  sync"/osc*/setalldone1"
  sleep 2 #pause
end

