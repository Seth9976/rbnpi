#!/usr/bin/env python3
#ps3 wireless controller interface by Robin Newman July 2017
#converts controller inputs to OSC messages
#which can be output to Sonic Pi 3, running on the local computer, or on an external machine
#rtested with ps3 "afterglow" wireless controller, dongle in Pi usb socket
#needs sudo apt-get install joystick after sudo apt-get update
#also needs sudo pip3 install python-osc
#Version 2. Modified to ensure clean exit on Ubuntu

import subprocess,pygame,sys
from signal import pause
from pythonosc import osc_message_builder
from pythonosc import udp_client
import argparse
from time import sleep

pygame.display.init()
pygame.joystick.init()
clock=pygame.time.Clock()
ps3 = pygame.joystick.Joystick(0)

ps3.init()

def control(spip):
 gate=0.1
 sender=udp_client.SimpleUDPClient(spip,4559) #sender set up for specified IP

 while True:
    try:
        print("ps3.py: Python ps3-> OSC interface")
        print ("Specify external Sonic Pi with  ./ps3.py --sp [SP3 IP ADDRESS] on command line")
        print("For local Sonic Pi 3 just use ./ps3.py")
        print ("Ctrl-C to exit")

        pygame.event.pump()
        lud=ps3.get_axis(1)
        llr=ps3.get_axis(0)
        rud=ps3.get_axis(3)
        rlr=ps3.get_axis(2)

        if abs(rud) > gate:
            sender.send_message('/rud',-rud)
        if abs(lud) > gate:
            sender.send_message('/lud',-lud)
        if abs(rlr) > gate:
            sender.send_message('/rlr',rlr)
        if abs(llr) > gate:
            sender.send_message('/llr',llr)


        b0=ps3.get_button(0)
        if b0>0:
            sender.send_message('/b0',b0)
        b1=ps3.get_button(1)
        if b1>0:
            sender.send_message('/b1',b1)
        b2=ps3.get_button(2)
        if b2>0:
            sender.send_message('/b2',b2)
        b3=ps3.get_button(3)
        if b3>0:
            sender.send_message('/b3',b3)
        b4=ps3.get_button(4)
        if b4>0:
            sender.send_message('/b4',b4)
        b5=ps3.get_button(5)
        if b5>0:
            sender.send_message('/b5',b5)
        b6=ps3.get_button(6)
        if b6>0:
            sender.send_message('/b6',b6)
        b7=ps3.get_button(7)
        if b7>0:
            sender.send_message('/b7',b7)
        b8=ps3.get_button(8)
        if b8>0:
            sender.send_message('/b8',b8)
        b9=ps3.get_button(9)
        if b9>0:
            sender.send_message('/b9',b9)
        b10=ps3.get_button(10)
        if b10>0:
            sender.send_message('/b10',b10)
        b11=ps3.get_button(11)
        if b11>0:
            sender.send_message('/b11',b11)
        b12=ps3.get_button(12)
        if b12>0:
            sender.send_message('/b12',b12)

        hat=ps3.get_hat(0)
        if hat[0]!=0 and hat[1]!=0:
            sender.send_message('/hat',hat)

        clock.tick(20)
        subprocess.call("clear")
    except KeyboardInterrupt:
        print("\nExiting")
        sys.exit()

if __name__=="__main__":
    parser = argparse.ArgumentParser()
    #This arg gets the server IP address to use. 127.0.0.1 or
    #The local IP address of the Pi, required when using external Sonic Pi
    parser.add_argument("--sp",
    default="127.0.0.1", help="The ip to listen on")
    args = parser.parse_args()
    spip=args.sp
    print("Sonic Pi on ip",spip)
    sleep(2)
    control(spip)
