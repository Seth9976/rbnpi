#Python2.7 program to drive MeArm robot, written by Robin Newman, May 2016
#Arm is connected to a picon zero board, which drives the four servos
#Control is by means of a PS3 wireless AFterGlow controller
#version 2 adds facility to record and playback and save robot actions

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

coms=[]
recordflag=0
playflag=0

pz.init() #initialise the piconzero board

# Set output mode to Servo
pz.setOutputConfig(pan, 2)
pz.setOutputConfig(lower, 2)
pz.setOutputConfig(grip, 2)
pz.setOutputConfig(upper, 2)


# Initialise all servo positions
panVal = 90
lowerVal = 160
gripVal = 150
upperVal = 78
pz.setOutput (pan, panVal)
pz.setOutput (lower, lowerVal)
pz.setOutput (grip, gripVal)
pz.setOutput (upper, upperVal)

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
        breset=ps3.get_button(10) #set servos to start position
        bsavepickle=ps3.get_button(11) #used to save coms list
        bloadpickle=ps3.get_button(0) #used to load coms list
        #successive if statements mean more than one input can be actioned on each pass

        if brecordstart==1: #setup to start recording
            del coms[:] #delete any existing commands saved
            recordflag=1
            print("recording")
            timeoffset=pygame.time.get_ticks() #get starting time
        if brecordstop==1:
            print("record stop")
            recordflag=0
        if (breplay==1) and (len(coms)>0): #only start replay if something recorded ie coms has an entry
            playflag=1
            playcount=0 #set playback starting position
            sval=coms[0][0] #get initial time
        if breset ==1:
            print("Reset") 
            panVal = 90
            lowerVal = 160
            gripVal = 150
            upperVal = 78
        if bsavepickle == 1: #save comslist to a file
            cPickle.dump(coms, open('comsave.p', 'wb'))
        if bloadpickle == 1: #load comslist from file
            coms=cPickle.load(open('comsave.p','rb'))  
        if bleft == 1: #check for pan to the left
            panVal=min(177,panVal + 3)
            if recordflag==1:
                coms.append([pygame.time.get_ticks()-timeoffset,pan,panVal])
        if bright == 1: #check for pan to the right
            panVal=max(0, panVal - 3)
            if recordflag==1:
                coms.append([pygame.time.get_ticks()-timeoffset,pan,panVal])
        if lud < -0.5: #check for left joystick reduce
            lowerVal=max(80,lowerVal -2)
            if recordflag==1:
                coms.append([pygame.time.get_ticks()-timeoffset,lower,lowerVal])
        if lud > 0.5: #check for left joystick increase
            lowerVal = min(180,lowerVal + 2)
            if recordflag==1:
                coms.append([pygame.time.get_ticks()-timeoffset,lower,lowerVal])
        if bopen == 1: #check for grip open
            gripVal=max( 90,gripVal - 5)
            if recordflag==1:
                coms.append([pygame.time.get_ticks()-timeoffset,grip,gripVal])
        if bclose == 1: #check for grip close
            gripVal=min(179,gripVal + 5)
            if recordflag==1:
                coms.append([pygame.time.get_ticks()-timeoffset,grip,gripVal])
        if rud < -0.5: #check for right joystick increase
            upperVal=min(162,upperVal+2)
            if recordflag==1:
                coms.append([pygame.time.get_ticks()-timeoffset,upper,upperVal])
        if rud > 0.5: #check for right joystick reduce
            upperVal=max(56,upperVal-2)
            if recordflag==1:
                coms.append([pygame.time.get_ticks()-timeoffset,upper,upperVal])
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
            pygame.time.wait(coms[playcount][0]-sval)
            sval=coms[playcount][0]
            pz.setOutput(coms[playcount][1],coms[playcount][2])
            print ("step: "+str(playcount)+ " output servo channel: "+str(coms[playcount][1])+ " servo setting: "+str(coms[playcount][2]))
            playcount +=1
            if playcount==len(coms):
                playflag=0
              
      
    except KeyboardInterrupt: #continue until ctrl-C
        print
        print ("Exiting")
        #print coms  #uncomment for debugging
        pygame.quit() #clean up pygame and reset picon zero board
        pz.cleanup()
        print ("Cleaned up")
        sys.exit(1) #use to ignore error retrace