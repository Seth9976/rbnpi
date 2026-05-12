
#functions to aid connecting and disconnectiog SuperCollider under pipewire
define :getCurrentData do
  #first input ports
  inputs =  `pw-link -iI`.lines
  set :hdmiL,inputs.grep(/hdmi.*playback_FL$/).first.to_i
  set :hdmiR,inputs.grep(/hdmi.*playback_FR$/).first.to_i
  set :usbL,inputs.grep(/usb.*playback_FL$/).first.to_i
  set :usbR,inputs.grep(/usb.*playback_FR$/).first.to_i
  set :bluezL,inputs.grep(/bluez.*playback_FL$/).first.to_i
  set :bluezR,inputs.grep(/bluez.*playback_FR$/).first.to_i
  set :avJackL,inputs.grep(/audio.*playback_FL$/).first.to_i
  set :avJackR,inputs.grep(/audio.*playback_FR$/).first.to_i
  #now output ports
  outputs = `pw-link -oI`.lines
  scOutPorts=[]
  16.times do |i|
    scOutPorts[i] = outputs.grep(/SuperCollider:out_#{i+1}$/).first.to_i
  end
  set :scOutPorts,scOutPorts
  #now get all current links ids
  links = `pw-link -lI`.lines
  #extract SuperCollider:out links
  linkOutputs=links.grep(/-.*SuperCollider:out/)
  #extract id of each of these links to scLinks
  scLinks=[]
  linkOutputs.length.times do |i|
    scLinks[i]=linkOutputs[i].to_i
  end
  set :scLinks,scLinks
end

define :displayCurrentID do
  #update current data
  getCurrentData
  #display current link id#
  puts "Current data. Note: a 0 signifies no ID found"
  puts "hdmi L and R",get(:hdmiL),get(:hdmiR)
  puts "usb L and R",get(:usbL),get(:usbR)
  puts "avJack L and R",get(:avJackL),get(:avJackR)
  puts "bluez L and R",get(:bluezL),get(:bluezR)
  puts "sc output ports (16 max)",get(:scOutPorts)
  puts "current SuperCollider output link Ids2",get(:scLinks)
end

#display the data
displayCurrentID

###################################################
#function to connect or disconnect SuperCollider
define :connectStereo do |output,input,type=1|
  #puts "data",output,input,type
  portlist=get(:scOutPorts)
  case output
  when :usb
    if get(:usbL) == ""
      puts "not available"
      return
    end
    o1=get(:usbL);o2=get(:usbR)
  when :hdmi
    if get(:hdmiL) == ""
      puts "not available"
      return
    end
    o1=get(:hdmiL);o2=get(:hdmiR)
  when :avjack
    if get(:avJackL) == ""
      puts "not available"
      return
    end
    o1=get(:avJackL);o2=get(:avJackR)
  when :bluez
    if get(:bluezL) == ""
      puts "not available"
      return
    end
    o1=get(:bluezL);o2=get(:bluezR)
    #puts "bluez",o1,o2
  else
    puts "not available"
    return
  end
  if input == ""
    puts "input not available"
    return
  end
  if portlist[input-1] == "9" or portlist[input] == "0"
    puts "outputs not available"
    return
  end
  i1=portlist[input-1];i2=portlist[input]
  action=["pw-link -d ","pw-link -L "]
  cmd = action[type]+i1.to_s+" "+o1.to_s
  puts cmd
  system(cmd)
  cmd = action[type]+i2.to_s+" "+o2.to_s
  puts cmd
  system(cmd)
end

#function to delete all SuperCollider output connections
define :deleteSCout do
  getCurrentData
  links=get(:scLinks)
  return if links.length==0
  links.each do |n|
    cmd= "pw-link -d #{n}"
    puts cmd
    system(cmd)
  end
end

###########################################################
#four functions that let you easily swap the main Sonic Pi output audio routing

define :gohdmi do
  getCurrentData #they may have changed
  deleteSCout
  connectStereo :hdmi,1,1
end
define :gousb do
  getCurrentData#they may have changed
  deleteSCout
  connectStereo :usb,1,1
end
define :gobluez do
  getCurrentData#they may have changed
  deleteSCout
  connectStereo :bluez, 1,1
end
define :goavjack do
  getCurrentData#they may have changed
  deleteSCout
  connectStereo :avjack, 1,1
end

#PLACE BELOW WHERE YOU WANT SONIC PI TO CONNECT WHEN IT STARTS UP
#IF YOU HAVE MORE THAN ONE USB OR BLUETOOTH IT WILL CONNECT THE FIRST ONE IT FINDS
# choose from gohdmi, gousb, goavjack or gobluez (no audiojack on Pi5 or Pi400)
gohdmi