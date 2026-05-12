#Python2.7 program to drive MeArm robot, written by Robin Newman, May 2016
#Arm is connected to a picon zero board, which drives the four servos
#Control is by means of a PS3 wireless AFterGlow controller
#version 2 adds facility to record and playback and save robo actions
#version 3 adds facility to pause and restart playback, also gfastplayback mode
#In addition failsafe locks are added to ensure recording and playback start from zeroed position
#Finally a command is added to signal whether there is a recorded sequence stored in memory ready for playback

import subprocess,sys #setup required python libraries
import pygame
import piconzero as pz, time
import cPickle #to save the coms list

pygame.init() #initialise items
clock = pygame.time.Clock()
ps3 = pygame.joystick.Joystick(0)
ps3.init()

# Define which pins are the servos
pan = 0
lower = 1
grip = 3
upper = 2

coms=[] #used to store recorded sequence
recordflag=0 #used to signify recording in progress
playflag=0 #used to signify playback in progress
interrupted=0 #used to signify playback has been paused when 1. NB set to 0 by any manual command which alters servos
fastPlayback=0 #used to signify fastplayback has been selected

pz.init() #initialise the piconzero board

# Set output mode to Servo
pz.setOutputConfig(pan, 2)
pz.setOutputConfig(lower, 2)
pz.setOutputConfig(grip, 2)
pz.setOutputConfig(upper, 2)


# Initialise all servo positions NB these also have to be set at start of playback and fastplayback commands
panVal = 90
lowerVal = 160
gripVal = 150
upperVal = 78

def valUpdate (output,val): #used to update Val variables and output next recorded state to servos
    global panVal,lowerVal,upperVal,gripVal
    if output==0:
        panVal=val
    if output==1:
        lowerVal=val
    if output==2:
        upperVal=val
    if output==3:
       gripVal=val
    pz.setOutput(output,val)  


while True: #main loop runs until ctrl-c detected
    try:
        pygame.event.pump() #make sure event queue is current
        llr=ps3.get_axis(0) #read the four axes (in fact don't use llr values or rlr in this version)
        lud=ps3.get_axis(1) #used for lower arm
        rlr=ps3.get_axis(2)
        rud=ps3.get_axis(3) #used for upper arm
        bopen=ps3.get_button(6) #open grip
        bclose=ps3.get_button(7)   #close grip
        bleft=ps3.get_button(4) #pan left
        bright=ps3.get_button(5) #pan right
        brecordstop=ps3.get_button(8) #record_stop
        brecordstart=ps3.get_button(9) #record start
        breplay=ps3.get_button(2) #playback
        breplayfast=ps3.get_button(3) #playback in fast mode
        breset=ps3.get_button(10) #set servos to start position
        bsavepickle=ps3.get_button(11) #used to save coms list
        bloadpickle=ps3.get_button(0) #used to load coms list
        hatstate=ps3.get_hat(0) #used to pause/restart playback
        bquerycoms=ps3.get_button(12) #used to check if there is a recorded sequence in memory

        #successive if statements mean more than one input can be actioned on each pass

        #check in reset position before allowing record. Check "recording" displayed on screen
        if brecordstart==1 and panVal ==90 and lowerVal == 160 and gripVal == 150 and upperVal ==78: #setup to start recording
            del coms[:] #delete any existing commands saved
            recordflag=1
            print("recording") #disappears fast from screen but useful for debugging if button held
            pygame.time.wait(200)           
            timeoffset=pygame.time.get_ticks() #get starting time
        if brecordstop==1:
            print("record stop")
            recordflag=0 #reset recordflag
        #check arm is in reset position before allowing playback
        if (breplay==1) and (len(coms)&gt;0) and panVal ==90 and lowerVal == 160 and gripVal == 150 and upperVal ==78: #only start replay if something recorded ie coms has an entry
            fastplayBack=0 #set normal playback mode
            playflag=1 #set playback flag
            interrupted=0 #set interrupt flag to 0 (not interrupted)
            playcount=0 #set playback starting position
            sval=coms[0][0] #get initial time
        #check arm is in reset position before allowing fastplayback
        if (breplayfast==1) and (len(coms)&gt;0) and panVal ==90 and lowerVal == 160 and gripVal == 150 and upperVal ==78: #only start replay if something recorded ie coms has an entry
            fastPlayback=1 #set fastplayback mode
            playflag=1 #set playback flag
            interrupted=0 #set interrupt flag to 0 (not interrupted)
            playcount=0 #set playback starting position
            sval=coms[0][0] #get initial time
        if hatstate[1]==-1 and playflag==1:
            playflag=0 #stop playback
            interrupted = 1 #set interrupted state flag
        if hatstate[1]==1 and interrupted==1: #if interrupted then restore playback
           playflag=1 #set playback flag again
           interrupted=0 #reset interrupted state
        if breset ==1:
            interrupted=0 #reset interrupted for all commands that alter servo positions
            print("Reset") 
            panVal = 90
            if recordflag==1: #then record reset commands
                coms.append([pygame.time.get_ticks()-timeoffset,pan,panVal])
            lowerVal = 160
            if recordflag==1:
                coms.append([pygame.time.get_ticks()-timeoffset,lower,lowerVal])
            gripVal = 150
            if recordflag==1:
                coms.append([pygame.time.get_ticks()-timeoffset,grip,gripVal])
            upperVal = 78
            if recordflag==1:
                coms.append([pygame.time.get_ticks()-timeoffset,upper,upperVal])
        if bsavepickle == 1: #save comslist to a file
            cPickle.dump(coms, open('comsave.p', 'wb'))
        if bloadpickle == 1: #load comslist from file
            coms=cPickle.load(open('comsave.p','rb'))
        if bquerycoms==1: #check if recorded program in coms. Hold button down to see this
            if len(coms)&gt;0:
                print "Recorded sequence in memory"
            else:
                print "No recorded sequence"               
        if bleft == 1: #check for pan to the left
            interrupted=0
            panVal=min(177,panVal + 3)
            if recordflag==1:
                coms.append([pygame.time.get_ticks()-timeoffset,pan,panVal])
        if bright == 1: #check for pan to the right
            interrupted=0
            panVal=max(0, panVal - 3)
            if recordflag==1:
                coms.append([pygame.time.get_ticks()-timeoffset,pan,panVal])
        if lud &lt; -0.5: #check for left joystick reduce             interrupted=0             lowerVal=max(80,lowerVal -2)             if recordflag==1:                 coms.append([pygame.time.get_ticks()-timeoffset,lower,lowerVal])         if lud &gt; 0.5: #check for left joystick increase
            interrupted=0
            lowerVal = min(180,lowerVal + 2)
            if recordflag==1:
                coms.append([pygame.time.get_ticks()-timeoffset,lower,lowerVal])
        if bopen == 1: #check for grip open
            interrupted=0
            gripVal=max( 90,gripVal - 5)
            if recordflag==1:
                coms.append([pygame.time.get_ticks()-timeoffset,grip,gripVal])
        if bclose == 1: #check for grip close
            interrupted=0
            gripVal=min(179,gripVal + 5)
            if recordflag==1:
                coms.append([pygame.time.get_ticks()-timeoffset,grip,gripVal])
        if rud &lt; -0.5: #check for right joystick increase             interrupted=0             upperVal=min(162,upperVal+2)             if recordflag==1:                 coms.append([pygame.time.get_ticks()-timeoffset,upper,upperVal])         if rud &gt; 0.5: #check for right joystick reduce
            interrupted=0
            upperVal=max(56,upperVal-2)
            if recordflag==1:
                coms.append([pygame.time.get_ticks()-timeoffset,upper,upperVal])

        #now update the servos, either in normal and record mode, or in replay mode
        if playflag==0:  #normal use. Execute inputs directly                   
            pz.setOutput (pan, panVal) #now send updated signals to the 4 servos
            pz.setOutput (lower, lowerVal)
            pz.setOutput (grip, gripVal)
            pz.setOutput (upper, upperVal)
            print "panVal "+str(panVal) #now print updated values in the terminal
            print "gripVal "+str(gripVal)
            print "lowerVal "+str(lowerVal)
            print "upperVal "+str(upperVal)
            clock.tick(20) #wait for a bit
            subprocess.call("clear") #clear the screen

        else: #replay mode. get inputs from coms list
            if fastPlayback==1:
                pygame.time.wait(50) #playback with constant 50ms between updates
            else:
                pygame.time.wait(coms[playcount][0]-sval) #playback with recorded times between updates
            sval=coms[playcount][0]
            valUpdate(coms[playcount][1],coms[playcount][2])
            print ("step: "+str(playcount)+ " output servo channel: "+str(coms[playcount][1])+ " servo setting: "+str(coms[playcount][2]))
            playcount +=1
            if playcount==len(coms):
                playflag=0
                fastPlayback=0
              
      
    except KeyboardInterrupt: #continue until ctrl-C
        print
        print ("Exiting")
        #print coms  #uncomment for debugging
        pygame.quit() #clean up pygame and reset picon zero board
        pz.cleanup()
        print ("Cleaned up")
        sys.exit(1) #use to ignore error retrace