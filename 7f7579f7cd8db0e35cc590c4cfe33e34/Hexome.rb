#hexome.rb based on a project by Mike Smith in The Magpi issue 58, replacing processing with Sonic Pi 3
#Written by Robin Newman
use_debug false
use_midi_logging false
use_cue_logging false
use_arg_checks false
use_osc_logging true
use_osc "172.20.10.5",9000 #change to match address of your TouchOSC device
#setup up sample locations
path="~/Documents/Processing/hexome/Hexome_Sim/data" #adjust to suit your system
p1=path+"/harp"
p2=path+"/marimba"
p3=path+"/percussion"
t=[0,0,0,0,0,0,0,0,0,0]
button=[]
61.times do|i|
  button[i]="\b"+i.to_s
  set button[i] ,false
end
buttonNumber="/buttonNumber"
flag="/flag"
LEDcolour="/LEDcolour"

ringR0 = (ring 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30 )
ringR1 = (ring 31, 39, 38, 29, 21, 22, 31, 39, 38, 29, 21, 22, 31, 39, 38, 29, 21, 22, 31, 39, 38, 29, 21, 22 )
ringR2 = (ring 32, 40, 47, 46, 45, 37, 28, 20, 13, 14, 15, 23, 32, 40, 47, 46, 45, 37, 28, 20, 13, 14, 15, 23 )
ringR3 = (ring 33, 41, 48, 54, 53, 52, 51, 44, 36, 27, 19, 12,  6,  7,  8,  9, 16, 24, 33, 41, 48, 54, 53, 52 )
ringR4 = (ring 34, 42, 49, 55, 60, 59, 58, 57, 56, 50, 43, 35, 26, 18, 11,  5,  0,  1,  2,  3,  4, 10, 17, 25 )

noteLookUp0=[0,2,4,6] #harp: set path to p1
noteLookUp1=[1,3,5,7]
noteLookUp2=[2,4,6,8]
noteLookUp3=[3,5,7,9]
noteLookUp4=[0,2,4,6] #repeat same offsets for marimba: set path instead to p2
noteLookUp5=[1,3,5,7]
noteLookUp6=[2,4,6,8]
noteLookUp7=[3,5,7,9]
noteLookUp8=[0,1,2,3] #repeat offsets from zero for percussion: set path p3
noteLookUp9=[4,5,6,7]

noteLookUp=[noteLookUp0,noteLookUp1,noteLookUp2,noteLookUp3,noteLookUp4,noteLookUp5,noteLookUp6,noteLookUp7,noteLookUp8,noteLookUp9]
#button = [false]*64
set LEDcolour,0 #red
colours=["red","green","blue","yellow","purple","orange","gray"]
page="/1" #TouchOSC page name
bank="\bank";set bank,0 #for selecting samples using toggle switches
setGain=0.5
activeToggle="/activeToggle";set activeToggle,0
frameLimit="/frameLimit";set frameLimit,9 #controls the speed of the step sequence
set flag,false #flag for button clear

define :getbtn do |address| #address="/osc/1/push*", or "/osc/1/toggle*" etc
  return get_event(address).to_s.split(",")[6][address.length+1..-2].to_i
end

define :setLED do |n,s,intensity|
  if s
    osc page+"/led"+n.to_s+"/color",colours[get(LEDcolour)]
    osc page+"/led"+n.to_s,intensity.to_s
  else
    osc page+"/led"+n.to_s,"0.2"
    osc page+"/led"+n.to_s+"/color","gray"
  end
end

set LEDcolour,6 #gray
61.times do |i|
  setLED(i,true,0.2)
  sleep 0.01
end

set LEDcolour,0 #red
setLED(30,true,0.8)

define :toggleSet do |n,val|
  osc page+"/toggle"+n.to_s,val.to_s
end

define :toggleClear do
  10.times do |i|
    toggleSet(i,0)
  end
end

toggleClear
sleep 0.05
toggleSet(0,1)

define :messageFader do |n,val|
  osc page+"/fader"+n.to_s,val.to_s
end
messageFader(1,get(frameLimit))
messageFader(2,-6.0)

define :clearSetButtons do
  puts "clearing"
  61.times do |i|
    if get(button[i])==true
      setLED(i,false,1) #turn off LED
      set button[i],false
    end
  end
  cue :restart
  set flag,false
end

define :doLEDclick do |buttonNumber|
  if buttonNumber != 30
    if get(button[buttonNumber]) ==true
      set(button[buttonNumber], false)
      setLED(buttonNumber, false, 1)
    else
      set(button[buttonNumber],true)
      set LEDcolour,2 #set to Blue
      setLED(buttonNumber, true, 1)
    end
  else
    set flag,true
    sleep 0.3 #wait for cue for animate stopped
    clearSetButtons
  end
end

live_loop :oscfader1,auto_cue: false do
  use_real_time
  b = sync "/osc/1/fader1"
  set frameLimit,b[0]
end
live_loop :oscfader2,auto_cue: false do
  use_real_time
  b = sync "/osc/1/fader2"
  setGain = (40+b[0]).to_f/15
  puts setGain
end

############################### PUSH BUTTONS ###################
live_loop:pb do
  use_real_time
  b = sync "/osc/1/push*"
  puts b
  bn=getbtn("/osc/1/push*")
  if b[0]>0 and bn!=30
    set buttonNumber,bn.to_i
    puts bn
    #set buttonNumber,b[0].to_i-1
    doLEDclick(get(buttonNumber))
  end
end

live_loop :p30 do
  use_real_time
  b = sync "/osc/1/push30"
  if b[0]>0
    set buttonNumber,30
    doLEDclick(get(buttonNumber))
    osc page+"/led30","0.3"
  else
    sleep 0.4
    osc page+"/led30","0.8"
  end
end
################### TOGGLE SWITCHES ####################

live_loop :toggle do  use_real_time
  b=sync "/osc/1/toggle*"
  tg=getbtn("/osc/1/toggle*")
  puts "toggle",tg
  #puts "b[0] is",b[0]
  t[tg.to_i]=1 if b[0]>0
  updateToggles(tg.to_i)# if t[b[0]-1]>0
  puts t
end

define :updateToggles do |toggleNumber|
  #look at toggle switches
  tt=get(activeToggle)
  toggleSet(tt,0) #turn off previous toggle
  set activeToggle,toggleNumber
  puts"active",toggleNumber
  tt=get(activeToggle)
  set bank,tt
  toggleSet(tt,1)
end

define :checkSetLED do |num,state,hring|
  #puts "Num here",num
  if get(button[num]) #collision has occured
    oldColour = get(LEDcolour)
    #g=currentG
    #b=currentB
    if state == 0
      set LEDcolour,2 #restore Blue colour
      #sleep 0.01
    else
      # collision has occured
      #generate note Sonic Pi variation here
      p=p1 #select correct set of samples
      p=p2 if get(bank)>3
      p=p3 if get(bank)>7
      sample p,noteLookUp[get(bank) ][hring-1],amp: setGain,pan: [-0.9,-0.3,0.3,0.9].choose #play sample
      set LEDcolour,5 #orange
      ##| sleep 0.01
    end
    setLED(num,true,1)
    #sleep 0.01
    set LEDcolour,oldColour #restore old colour
  else
    setLED(num,state==1,1)
    #sleep 0.01
  end
end

define :animate do |lookp|
  lookv=lookp #take local copy of lookp
  set LEDcolour,1 #green
  checkSetLED(ringR4[lookv],0,4)
  checkSetLED(ringR3[lookv],0,3)
  checkSetLED(ringR2[lookv],0,2)
  checkSetLED(ringR1[lookv],0,1)
  lookv+=1
  sleep 0.02
  checkSetLED(ringR4[lookv],1,4)
  checkSetLED(ringR3[lookv],1,3)
  checkSetLED(ringR2[lookv],1,2)
  checkSetLED(ringR1[lookv],1,1)
end

live_loop :draw,auto_cue: false do
  sync :restart if get(flag) #wait for restart signal
  tick
  if look > get(frameLimit) #then animate
    tick_reset
    animate(tick(:foo))
  end
  sleep 0.025
end
