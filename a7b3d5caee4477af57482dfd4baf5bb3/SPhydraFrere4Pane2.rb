#Sonic Pi 4.4dev with built in Hydra
#Hydra sketch shows Frere Jaques 2 part round notes in real time
#coded by Robin enwman February 2023
use_debug false

define :clearPanes do
  hydra "
solid(0,0,0).out(o0)
solid(0,0,0).out(o1)
solid(0,0,0).out(o2)
solid(0,0,0).out(o3)
render()"
end

use_bpm 220

clearPanes #clears all four output panes

#frere jaques note/duration data
nl1=[:c4,:d4,:e4,:c4]*2
nl2=[:e4,:f4,:g4]*2
nl3=[:g4,:a4,:g4,:f4,:e4,:c4]*2
nl4=[:c4,:g3,:c4]*2
dl1=[1,1,1,1]*2
dl2=[1,1,2]*2
dl3=[0.5,0.5,0.5,0.5,1,1]*2
dl4=[1,1,2]*2
nA1=nl1+nl2+nl3+nl4+nl1
dA1=dl1+dl2+dl3+dl4+dl1
nB1=nl1+nl2+nl3+nl4
dB1=dl1+dl2+dl3+dl4
nA2=nl2+nl3+nl4
dA2=dl2+dl3+dl4
nB2=nB1
dB2=dB1

#function to generate code to place a square dot on the sketch
define :dot do |x,y,r|
  xs=(-x*0.95+0.475).to_s #adjust xrange input 0->1 Lto R
  ys=(-0.475+y*0.95).to_s #adjust yrange input 0->1 bottom to top
  rs=(r/100.0).to_s
  
  hb=".add(shape(4,"+rs+").scrollX("+xs+").scrollY("+ys+"))
"
  return hb
end

#set start and middle code for outputs  to A and B
hstartA="speed = 11
solid(0.2,0,0)
"
hmiddleA="" #set middle section to blank initially

hstartB="speed = 1
solid(0,0.4,0)

"
hmiddleB=""
#set up code to direct output to approrpiate pane
hend0=".out(o0)
render()" #sends output to pane 0
hend1=".out(o1)
render()" #sends output to pane 1
hend2=".out(o2)
render()" #sends output to pane 2
hend3=".out(o3)
render()" #sends output to pane 3
sleep 0.1
##| hydra hstartA+dot(0,0.5,0.2)+hend0
##| stop
##| #start playiong 2 part tune, and creating synchronised sketch
live_loop :playFrere do
  use_synth [:tri,:pulse,:saw].tick(:syn)
  in_thread do #thread to play/display first part in pane 0 and then pane 2
    2.times do |hEnd|
      tick_reset
      if hEnd==0
        hendA=hend0
        notes=nA1
        durations=dA1
      else
        hendA=hend2
        notes=nA2
        durations=dA2
      end
      dtot=0
      notes.length.times do
        n=note(notes.tick)
        d=durations.look
        play notes.look,release: durations.look,pan: -1
        x=0.0262*dtot
        hmiddleA=hmiddleA+dot(x,(n-50)/100.0,0.2)
        hA= hstartA+hmiddleA+hendA
        hydra hA
        sleep durations.look
        dtot=dtot+durations.look
      end
      hmiddleA=""
      dtot=0
    end
  end
  #stop
  sleep 8 #delay before part 2
  use_synth [:blade,:sine,:tb303].look(:syn)
  2.times do |hEnd| #play/display second part in panes 1 and 3
    tick_reset
    if hEnd==0
      hendB=hend1
      notes=nB1
      durations=dB1
      offset=8 #becuase of 2 bar rest
    else
      hendB=hend3
      notes=nB2
      durations=dB2
      offset=0 #starts immediately no rest
    end
    dtot2=0 #reset start to left of pane (elapsed time is 0 + offset)
    notes=nB1
    durations=dB1
    notes.length.times do
      n=note(notes.tick)
      d=durations.look
      play notes.look,release: durations.look,pan: 1
      x=0.0262*(dtot2+offset) #calc x position of next note
      hmiddleB=hmiddleB+dot(x,(n+28)/100.0,0.2) #calc code to display next note
      hB= hstartB+hmiddleB+hendB #assemble updated sketch
      
      hydra hB #display sketch
      sleep durations.look
      dtot2=dtot2+durations.look #update total elapsed time for part
    end
    hmiddleB="" #reset middle setion for nect pass
    dtot=0 #reset elapsed time for next pass
  end
  sleep 4
  clearPanes #intialise ports before next pass of live-loop
end