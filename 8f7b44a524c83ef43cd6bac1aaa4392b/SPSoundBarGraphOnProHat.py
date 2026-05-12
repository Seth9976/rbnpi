#! /usr/bin/env python
#sound sensitive led array, for use with sonic pi
#using an RPiO ProHat and components from the RPiO Explorer Kit
#two 10uF capacitors required in additon, plus a 3.5mm jack audio lead
#written by Robin Newman, June 11th 2016
from gpiozero import MCP3008, LEDBarGraph
from sys import argv,exit
#do some rudimentary arg checking
if len(argv)<2:
    print("Need sensitivity argument e.g. soundledbar.py 40 (try range 30-100)")
    exit(2)
else:
    sensitivity=int(argv[1])#get sensitivity from arg as an integer
print("sensitivity set to: "+str(sensitivity)) #print sensitivity value set
print("Adjust potentiometer until all leds just out, then start music input")
print("ctrl+C to exit the program")
inp=MCP3008(channel=0,device = 0) #adc input channel 0 used
#4 leds plugged between the GPIO pins below and ground.
#No series resitors required on ProHat board
yellow=19
green=20
blue=21
red=22
#set up GPIOZERO LEDBarGraph: referenced by graph
graph=LEDBarGraph(red,yellow,green,blue,pwm=True) #4 led bargraph with pwm mode
try: #use try with exceptions to give clean exit
    while True: #main loop
        #calculate graph input value 4 from adc reading. Offset by 0.5
        #multiply by sensitivity value
        v=sensitivity*(inp.value - 0.5)
        #graph input value max and min keep it between 0 and 1
        #min(1,v) sets a to ceiling value of 1
        #max(0,  {VALUE}) prevents {VALUE} from going below 0
        graph.value=max(0,min(1,v))

except KeyboardInterrupt:
    print "\nExiting"
#except:
#    print "An error occured" #uncomment when programm debugged OK
finally:
    print "\nFinished" 