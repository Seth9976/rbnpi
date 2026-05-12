#FrereJaquesControlled-RF.rb
restart="~/Documents/SPfromXML/FrereJaquesControlled-RFAuto.rb"
use_debug false #turn off log_synths
use_arg_checks false #turn off log_cues
bs=1 #starting bar number: give it an initial value here
bpba=[4]*13 #setup up list of section beats per bar

#puts bpba
st=[] #holds info for start section and remaining bars to process: set global here
#part pan positions
p1=-1;p2=-0.33;p3=0.33;p4=2

############### define functions used in the script
define :numbeats do |durations| #return number of crotchet beats in a note durations list
  l=0.0
  durations.each do |d|
    l+=d
  end
  return l
end

#find starting section, and number of bars in that section to be processed
#to determine the starting note index
define :startDetails do |bn,bNumberSecStart,durations|
  startSecIndex=0
  remainingBars=bn
  #iterate until remaning bn is within the section
  while bn>bNumberSecStart[startSecIndex]
    remainingBars=bn-bNumberSecStart[startSecIndex]
    startSecIndex+=1
  end
  #return the section to start playing and number of bars to determine starting note index
  return startSecIndex-1,remainingBars
end

define :getmatchd do |bn,bpb,durations| #works out the note index for a given bar number
  matchbeat=(bn-1)*bpb #target number of beats to find
  l=0.0;x=0
  until l>=matchbeat || (l-matchbeat).abs < 0.0625 #0.0625 is smallest quantisation to consider
    l+=durations[x]
    x+=1
  end
  return [x ,l-matchbeat] #return the matched beat note index, plus sleep for tied note (if any)
  #nb if the bar start coincides with a tied note, then the part will start with the next
  #note and a sleep command will be issued for the remaining duration of the tied note
end

define :ver do
  return version.to_s.split('.')
end
##########################
#wait for an OSC cue to be received from the Processing GUI sketch
#This sends two parameters: First controls Play (1) Stop (-1)
#second gives requested bar start number
tr=0
until tr==1 #wait for PLAY cue from processing GUI (first parameter will be set to 1)
  s=sync '/transport'
  if version="v2.11.1" or ver[2].to_i > 11
    tr=s[0]
    bs=s[1]
  else
    tr=s[:args][0] #tr governs play/stop value is 1 for play -1 for stop
    bs=s[:args][1] #bs is start bar,the second parameter received
  end
end

puts "BS selected is "+bs.to_s
##########################
#start polling for an OSC cue to stop playing from the Processing GUI sketch
#this runs continuously in a thread
in_thread do #this thread polls for an OSC cue to stop the program
  tr=0
  until tr==-1 #the first parameter will be set to -1 for a STOP signal
    s=sync '/transport'
    if version="v2.11.1" or ver[2].to_i > 11
      tr=s[0]
      bs=s[1]
    else
      tr=s[:args][0] #tr governs play/stop value is 1 for play -1 for stop
      bs=s[:args][1] #bs is start bar,the second parameter received
    end
  end
  #stop command detected
  puts"stopping"
  puts "running sonic pi cli script to restart"
  
  system(restart+" &") #run the auto script to stop and rerun the code
end
##########################
with_fx :reverb, room: 0.8 do
  with_fx :level,amp: 0.7 do
    #part 1 data
    a1=[]
    b1=[]
    a1[0]=[:c4,:d4,:e4,:c4,:c4,:d4,:e4,:c4]
    a1[1]=[:e4,:f4,:g4,:e4,:f4,:g4]
    a1[2]=[:g4,:a4,:g4,:f4,:e4,:c4,:g4,:a4,:g4,:f4,:e4,:c4]
    a1[3]=[:c4,:g3,:c4,:c4,:g3,:c4]
    a1[4]=[:r]*8
    a1[5]=[:r]*8
    a1[6]=[:r]*8+a1[0]
    a1[7]=a1[1]
    a1[8]=a1[2]
    a1[9]=a1[3]
    a1[10]=a1[4]
    a1[11]=a1[5]
    a1[12]=[:r]*8
    b1[0]=[1,1,1,1,1,1,1,1]
    b1[1]=[1,1,2,1,1,2]
    b1[2]=[0.5,0.5,0.5,0.5,1,1,0.5,0.5,0.5,0.5,1,1]
    b1[3]=[1,1,2,1,1,2]
    b1[4]=[1]*8
    b1[5]=[1]*8
    b1[6]=[1]*8+b1[0]
    b1[7]=b1[1]
    b1[8]=b1[2]
    b1[9]=b1[3]
    b1[10]=b1[4]
    b1[11]=b1[5]
    b1[12]=[1]*8
    c1=[100,120,140,160,180,200,220,200,180,160,140,120,100]
    ###################### calculate starting data

    #calc bar offset for start of each tempo change. Held in bNumberSecStart list
    bNumberSecStart=[]
    bNumberSecStart[0]=0
    bNumber=0
    b1.length.times do |z|
      bNumber+= numbeats(b1[z])/bpba[z]
      bNumberSecStart[z+1]=bNumber
    end
    #puts bNumberSecStart #for debugging
    #calc number of bars inthe piece
    bmax=bNumberSecStart[b1.length]
    puts "Total number of bars="+bmax.to_s
    #adjust requested bar start number if too large
    if bs>bmax
      bs=bmax
      puts "Start bar exceeds piece length: changed to :"+bs.to_s
    end
    #calculate info for starting sector containing bar start requested,
    #and number of remaining bars to process to get starting index
    st=startDetails(bs,bNumberSecStart,b1)
    startSec=st[0]
    remainingBars=st[1]
    puts "Start Section="+st[0].to_s
    puts "Remaining Bars to find starting index="+st[1].to_s
    puts

    ################### now ready to process an play each part in turn (played together in threads)
    #each part is processed in exactly the same way

    #calc starting index and any sleep for tied notes for part 1
    sv1=getmatchd(remainingBars,bpba[startSec],b1[startSec])
 
    puts "1: "+sv1.to_s #print start index and sleep time
    use_synth :beep
    in_thread do
      for i in startSec..a1.length-1
        use_bpm c1[i]
        sleep sv1[1] #sleep for tied note (>0 if tied)
        for j in sv1[0]..a1[i].length-1
          play a1[i][j],sustain: b1[i][j]*0.9,release: b1[i][j]*0.1,pan: p1
          sleep b1[i][j]
        end
        sv1=[0,0] #reset so subsequent iterations of j loop in full and no tied sleep
      end
    end


    a2=[]
    b2=[]
    a2[0]=[:r]*8
    a2[1]=[:c4,:d4,:e4,:c4,:c4,:d4,:e4,:c4]
    a2[2]=[:e4,:f4,:g4,:e4,:f4,:g4]
    a2[3]=[:g4,:a4,:g4,:f4,:e4,:c4,:g4,:a4,:g4,:f4,:e4,:c4]
    a2[4]=[:c4,:g3,:c4,:c4,:g3,:c4]
    a2[5]=[:r]*8
    a2[6]=[:r]*8+a2[0]
    a2[7]=a2[1]
    a2[8]=a2[2]
    a2[9]=a2[3]
    a2[10]=a2[4]
    a2[11]=a2[5]
    a2[12]=[:r]*8
    b2[0]=[1]*8
    b2[1]=[1,1,1,1,1,1,1,1]
    b2[2]=[1,1,2,1,1,2]
    b2[3]=[0.5,0.5,0.5,0.5,1,1,0.5,0.5,0.5,0.5,1,1]
    b2[4]=[1,1,2,1,1,2]
    b2[5]=[1]*8
    b2[6]=[1]*8+b2[0]
    b2[7]=b2[1]
    b2[8]=b2[2]
    b2[9]=b2[3]
    b2[10]=b2[4]
    b2[11]=b2[5]
    b2[12]=[1]*8    
    c2=[100,120,140,160,180,200,220,200,180,160,140,120,100]
    #calc starting index and any sleep for tied notes for part 2
    sv2=getmatchd(remainingBars,bpba[startSec],b2[startSec])

    puts "2: "+sv2.to_s #print start index and sleep time
    use_synth :blade
    in_thread do
      for i in startSec..a2.length-1
        use_bpm c2[i]
        sleep sv2[1] #sleep for tied note (>0 if tied)
        for j in sv2[0]..a2[i].length-1
          play a2[i][j],sustain: b2[i][j]*0.9,release: b2[i][j]*0.1,pan: p2
          sleep b2[i][j]
        end
        sv2=[0,0] #reset so subsequent iterations of j loop in full and no tied sleep
      end
    end

    a3=[]
    b3=[]
    a3[0]=[:r]*8
    a3[1]=[:r]*8
    a3[2]=[:c4,:d4,:e4,:c4,:c4,:d4,:e4,:c4]
    a3[3]=[:e4,:f4,:g4,:e4,:f4,:g4]
    a3[4]=[:g4,:a4,:g4,:f4,:e4,:c4,:g4,:a4,:g4,:f4,:e4,:c4]
    a3[5]=[:c4,:g3,:c4,:c4,:g3,:c4]
    a3[6]=[:r]*8+a3[0]
    a3[7]=a3[1]
    a3[8]=a3[2]
    a3[9]=a3[3]
    a3[10]=a3[4]
    a3[11]=a3[5]
    a3[12]=[:r]*8
    b3[0]=[1]*8
    b3[1]=[1]*8
    b3[2]=[1,1,1,1,1,1,1,1]
    b3[3]=[1,1,2,1,1,2]
    b3[4]=[0.5,0.5,0.5,0.5,1,1,0.5,0.5,0.5,0.5,1,1]
    b3[5]=[1,1,2,1,1,2]
    b3[6]=[1]*8+b3[0]
    b3[7]=b3[1]
    b3[8]=b3[2]
    b3[9]=b3[3]
    b3[10]=b3[4]
    b3[11]=b3[5]
    b3[12]=[1]*8
    c3=[100,120,140,160,180,200,220,200,180,160,140,120,100]
    #calc starting index and any sleep for tied notes for part 3
    sv3=getmatchd(remainingBars,bpba[startSec],b3[startSec])

    puts "3: "+sv3.to_s #print start index and sleep time

    use_synth :tri
    in_thread do
      for i in startSec..a3.length-1
        use_bpm c3[i]
        sleep sv3[1] #sleep for tied note (>0 if tied)
        for j in sv3[0]..a3[i].length-1
          play a3[i][j],sustain: b3[i][j]*0.9,release: b3[i][j]*0.1,pan: p3
          sleep b3[i][j]
        end
         sv3=[0,0] #reset so subsequent iterations of j loop in full and no tied sleep
      end
    end

    a4=[]
    b4=[]
    a4[0]=[:r]*8
    a4[1]=[:r]*8
    a4[2]=[:r]*8
    a4[3]=[:c4,:d4,:e4,:c4,:c4,:d4,:e4,:c4]
    a4[4]=[:e4,:f4,:g4,:e4,:f4,:g4]
    a4[5]=[:g4,:a4,:g4,:f4,:e4,:c4,:g4,:a4,:g4,:f4,:e4,:c4]
    a4[6]=[:c4,:g3,:c4,:c4,:g3,:c4]+[:r]*6  #Tied note added here: to show how its dealt with start at bars 14 then 15
    a4[7]=a4[1]
    a4[8]=a4[2]
    a4[9]=a4[3]
    a4[10]=a4[4]
    a4[11]=a4[5]
    a4[12]=[:c4,:g3,:c4,:c4,:g3,:c4]
    b4[0]=[1]*8
    b4[1]=[1]*8
    b4[2]=[1]*8
    b4[3]=[1,1,1,1,1,1,1,1]
    b4[4]=[1,1,2,1,1,2]
    b4[5]=[0.5,0.5,0.5,0.5,1,1,0.5,0.5,0.5,0.5,1,1]
    b4[6]=[1,1,2,1,1,4]+[1]*6   #Tied note added here: to show how its dealt with start at bars 14 then 15
    b4[7]=b4[1]
    b4[8]=b4[2]
    b4[9]=b4[3]
    b4[10]=b4[4]
    b4[11]=b4[5]
    b4[12]=[1,1,2,1,1,2]
    c4=[100,120,140,160,180,200,220,200,180,160,140,120,100]
    #calc starting index and any sleep for tied notes for part 4
    sv4=getmatchd(remainingBars,bpba[startSec],b4[startSec])

    puts "4: "+sv4.to_s #print start index and sleep time

    use_synth :saw
    in_thread do
      for i in startSec..a4.length-1
        use_bpm c4[i]
        sleep sv4[1] #sleep for tied note (>0 if tied)
        for j in sv4[0]..a4[i].length-1
          play a4[i][j],sustain: b4[i][j]*0.9,release: b4[i][j]*0.1,pan: p4
          sleep b4[i][j]
        end
        sv4=[0,0] #reset so subsequent iterations of j loop in full and no tied sleep
      end
   end

  end #level
end #fx
