#spRecordPlayerSaver.rb
#Record save and playback load for Sonic Pi player/recorder
#written by Robin Newman March 2018
#release version 1.0
use_osc "192.168.1.240",9000 #adjust for the address of your TouchOSC device
use_osc_logging false
#setup some flags
set :slot,01;set :bank,0;set :saveFlag,0;set :minFileSize,190
#intialise display page 2
osc "/archive/slot/1/1",1
osc "/archive/slotbank/1/1",1
osc "/archive/ledSave",0
osc "/archive/missing"," "
#set path for json files location
JSONfilePath="/Users/rbn/Documents/SPfromXML/recordplayer/"
osc "/archive/path",JSONfilePath

define :restoreHash do #restore values to arrays for other program
  restore=get(:restore)
  puts restore
  set :timn, restore["Vtimn"]
  set :recn, restore["Vrecn"]
  set :timp, restore["Vtimp"]
  set :recp, restore["Vrecp"]
  set :timm, restore["Vtimm"]
  set :recm, restore["Vrecm"]
  set :tims, restore["Vtims"]
  set :recs, restore["Vrecs"]
end

define :writeJson do |n| #write Json file using current data
  vals=Hash.new #initialise vals hash
  #now load values from the other program arrays
  vals[:Vtimn]=get(:timn)
  vals[:Vrecn]=get(:recn)
  vals[:Vtimp]=get(:timp)
  vals[:Vrecp]=get(:recp)
  vals[:Vtimm]=get(:timm)
  vals[:Vrecm]=get(:recm)
  vals[:Vtims]=get(:tims)
  vals[:Vrecs]=get(:recs)
  #now write hash to json file
  File.open(JSONfilePath+(n).to_s+".json", 'w') do |f|
    f.write(MultiJson.dump(vals, pretty: true))
    f.close
    sleep 0.2
    setFileIndicator n #(indicate whether file contains data)
  end
end

define :readJson do |n| #read Json file
  if File.exist?(JSONfilePath+n.to_s+".json")==false
    sample :misc_crow
    osc "/archive/missing",n.to_s+".json file missing"
  else
    osc "/archive/missing",n.to_s+".json file found"
    content =File.read(JSONfilePath+n.to_s+".json")
    #store retrieved content in time state
    set :restore,MultiJson.load(content)
    sleep 0.2
    #extract the data for use in the other program
    restoreHash
  end
end

#This is actually defined in both programs
define :parse_sync_address do |address|
  v= get_event(address).to_s.split(",")[6]
  if v != nil
    return v[3..-2].split("/")
  else
    return ["error"]
  end
end

define :setFileIndicator do |n| #show whether file contains data
  if File.exists?(JSONfilePath+(n).to_s+".json")
    if File.size(JSONfilePath+(n).to_s+".json") > get(:minFileSize)
      osc "/archive/d"+n.to_s,1
    else
      osc "/archive/d"+n.to_s,0
    end
  end
end

20.times do |n| #initialise file content indicators
  setFileIndicator n+1
end

define :clearLastAccess do #clear all last access indicators
  20.times do |n|
    osc "/archive/a"+(n+1).to_s,0
  end
end

define :setLastAccess do |n| #set last file accessed indicator
  clearLastAccess
  osc "/archive/a"+n.to_s,1
end

clearLastAccess #initial clear of all last access states

live_loop :setReadSlot do #deal with slot (pattern select) changes
  use_real_time
  b = sync "/osc/archive/slot/1/*"
  if b[0]==1
    res=parse_sync_address "/osc/archive/slot/1/*"
    slot=res[4].to_i
    set :slot,slot
    puts "slot is #{slot}"
  end
end

live_loop :writeData do #deal with Save Pattern button, using write enable
  use_real_time
  b = sync "/osc/archive/write"
  if get(:saveFlag)==0
    puts "Save not enabled"
    osc "/archive/missing","Enable Save First!"
    sample :misc_crow #warning noise
  else
    if b[0]==1
      slot=get(:slot)+10*get(:bank)
      writeJson(slot)
      setLastAccess slot
      puts "data written to slot #{slot}"
      osc "/archive/missing","File #{slot}.json saved"
    end
  end
end

live_loop :readData do #deal with Load slot button
  use_real_time
  b = sync "/osc/archive/read"
  if b[0]==1
    slot=get(:slot)+10*get(:bank)
    readJson(slot)
    setLastAccess(slot)
    puts "data read from slot #{slot}"
  end
end

live_loop :slotbank do #deal with Slot Bank select
  b = sync "/osc/archive/slotbank/*/1"
  if b[0]==1
    res = parse_sync_address "/osc/archive/slotbank/*/1"
    bank= res[3].to_i - 1 #value will be 0 or 1
    set :bank,bank
    puts "bank selected is #{bank}"
  end
  
end

live_loop :enablesave do #deal with enable save button
  use_real_time
  b = sync "/osc/archive/enablesave"
  if b[0]==1
    osc "/archive/ledSave",1
    set :saveFlag,1 #enable save
    sleep  rt(1.5) #1.5 seconds regardless of any tempo
    osc "/archive/ledSave",0
    set :saveFlag,0 #disable save
  end
end


