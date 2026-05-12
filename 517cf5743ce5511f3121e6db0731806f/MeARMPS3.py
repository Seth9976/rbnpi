#Python2.7 program to drive MeArm robot, written by Robin Newman, May 2016
#Arm is connected to a picon zero board, which drives the four servos
#Control is by means of a PS3 wireless AFterGlow controller

import subprocess,sys #setup required phton libraries
import pygame
import piconzero as pz, time

pygame.init() #initialise items
clock = pygame.time.Clock()
ps3 = pygame.joystick.Joystick(0)
ps3.init()
# Define which pins are the servos
pan = 0
lower = 1
grip = 3
upper = 2

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
        #panVal=translate(llr,-1,1,180,0)
        #successive if statements mean more than one input can be actioned on each pass
        if bleft == 1: #check for pan to the left
            panVal=min(177,panVal + 3)
        if bright == 1: #check for pan to the right
            panVal=max(0, panVal - 3)
        if lud < -0.5: #check for left joystick reduce
            lowerVal=max(80,lowerVal -2)
        if lud > 0.5: #check for left joystick increase
            lowerVal = min(180,lowerVal + 2)
        if bopen == 1: #check for grip open
            gripVal=max( 90,gripVal - 5)
        if bclose == 1: #check for grip close
            gripVal=min(179,gripVal + 5)
        if rud < -0.5: #check for right joystick increase
            upperVal=min(162,upperVal+2)
        if rud > 0.5: #check for right joystick reduce
            upperVal=max(56,upperVal-2)
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
    except KeyboardInterrupt: #continue until ctrl-C
        print
        print ("Exiting")
        pygame.quit() #clean up pygame and reset picon zero board
        pz.cleanup()
        print ("Cleaned up")
        sys.exit(1) #use to ignore error retrace