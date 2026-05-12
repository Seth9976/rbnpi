#!/usr/bin/env python3
#SPoschandler.py written by Robin Newman, July 2017 amended for this project Feb 2018 
#Provides the "glue" to enable the GPIO on Raspberry Pi
#to communicate with Sonic Pi. Sonic Pi can control LEDs etc,and receive
#input from devices like push buttons connected to GPIO pins
#Sonic Pi can be running either on the Raspberry Pi,
#or on an external networked computer

#The program requires gpiod daemon to be running. Yu can install this with
#sudo apt-get update followed by sudo apt-get install pigpio if you don't have it
#best to set it up to auto start on boot using
#sudo systemctl enable pigpiod.service          (followed by a reboot)
#The program also requires gpiozero to be installed and python-osc


from gpiozero import LED, Button
from pythonosc import osc_message_builder
from pythonosc import udp_client
from pythonosc import dispatcher
from pythonosc import osc_server
from time import sleep
import argparse
import sys
from Adafruit_CharLCD import *  #add library to deal with lcd display
#for connection details see https://learn.adafruit.com/drive-a-16x2-lcd-directly-with-a-raspberry-pi/wiring
#library available from https://github.com/adafruit/Adafruit_Python_CharLCD download to same folder as this file

lcd=Adafruit_CharLCD()  #set up instance for lcd display

#Specify connections for leds and buttons
#You can specify your own pin numbers if different

green = LED(14)
red =   LED(16)
blue =  LED(19)
yellow = LED(21)
dummy = LED(8)
button  = Button(13)
button2 = Button(15)
button3 = Button(18)
button4 = Button(20)

#This function is called when the button connected to the GPIO is pushed
def mon1():
    sender.send_message('/mon', [1,"g"])
def mon2():
    sender.send_message('/mon', [2,"r"])
def mon3():
    sender.send_message('/mon', [3,"b"])
def mon4():
    sender.send_message('/mon', [4,"y"])

button.when_pressed = mon1
button2.when_pressed = mon2
button3.when_pressed = mon3
button4.when_pressed = mon4

 
 #This is activated when /led/control OSC message is received by the server.
 #two arguments r and b contain 0 or 1 and are used to control the red and blue leds
def handle_leds(unused_addr,args,v):
    print("Sent from Sonic Pi",v)
    if v=="g":
        green.on()
    else:
        green.off()
    if v=="r":
        red.on()
    else:
        red.off()      
    if v=="b":
        blue.on()
    else:
        blue.off()
    if v=="y":
        yellow.on()
    else:
        yellow.off()

def handle_score(unused_addr,args,sc,hsc):
      print("Sent from Sonic Pi scores ",sc,hsc)
      lcd.clear()
      lcd.message("Your score "+str(sc)+"\nHi-score "+str(hsc))

#The main routine called when the program starts up follows
if __name__ == "__main__":
    try: #use try...except to handle possible errors
        #first set up and deal with input args when program starts
        parser = argparse.ArgumentParser()
        #This arg gets the server IP address to use. 127.0.0.1 or
        #The local IP address of the PI, required when using external Sonic Pi
        parser.add_argument("--ip",
        default="127.0.0.1", help="The ip to listen on")
        #This is the port on which the server listens. Usually 8000 is OK
        #but you can specify a different one
        parser.add_argument("--port",
              type=int, default=8000, help="The port to listen on")
        #This is the IP address of the machine running Sonic Pi if remote
        #or you can omit if using Sonic Pi on the local Pi.
        parser.add_argument("--sp",
              default="127.0.0.1", help="The ip Sonic Pi is on")
        args = parser.parse_args()
        if args.ip=="127.0.0.1" and args.sp !="127.0.0.1":
            #You must specify the local IP address of the Pi if trying to use
            #the program with a remote Sonic Pi aon an external computer
            raise AttributeError("--ip arg must specify actual local machine ip if using remote SP, not 127.0.0.1")
        #Provide feed back to the user on the setup being used    
        if args.sp == "127.0.0.1":
            spip=args.ip
            print("local machine used for SP",spip)  
        else:
            spip=args.sp
            print("remote_host for SP is",args.sp)
        #setup a sender udp-client to send out OSC messages to Sonic Pi
        #Sonic Pi listens on port 4559 for incoming OSC messages
        sender=udp_client.SimpleUDPClient(spip,4559) #sender set up for specified IP
        #dispatcher reacts to incoming OSC messages and then allocates
        #different handler routines to deal with them
        dispatcher = dispatcher.Dispatcher()
        #A handler routine handle_leds is specified
        #which deals with the OSC message /led/control being received
        dispatcher.map("/led/control",handle_leds,"v")
        # handler routie handle_receives the score and hiscore
        dispatcher.map("/sendscores",handle_score,"sc","hsc")
        #The following handler responds to the OSC message /testprint
        #and prints it plus any arguments (data) sent with the message
        dispatcher.map("/testprint",print)
        #Now set up and run the OSC server
        server = osc_server.ThreadingOSCUDPServer(
              (args.ip, args.port), dispatcher)
        print("Serving on {}".format(server.server_address))
        #run the server "forever" (till stopped by pressing ctrl-C)
        server.serve_forever()
    #deal with some error events
    except KeyboardInterrupt:
        print("\nServer stopped") #stop program with ctrl+C
    #Used the AttributeError to specify problems with the local ip address
    except AttributeError as err:
        print(err.args[0])
    #handle errors generated by the server
    except OSError as err:
       print("OSC server error",err.args)
    #anything else falls through