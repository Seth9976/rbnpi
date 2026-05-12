#!/usr/bin/env python3
#program sets up two distance sensors and exports readings using OSC to localhost port 4560 (previously 4559)
#using gpiozero and python-osc libraries
#written by Robin Newman, May 2018 (port updated for latest SP to 4560)
#
from gpiozero import DistanceSensor
from time import sleep
from pythonosc import osc_message_builder
from pythonosc import udp_client
import argparse
import sys

def control(spip):
    sensor = DistanceSensor(echo=17, trigger=4,threshold_distance=0.5) 
    sensor2 = DistanceSensor(echo=23,  trigger=24,threshold_distance=0.5)
    sender = udp_client.SimpleUDPClient(spip,4560)

    while True:
        try:
            r1 = (sensor.distance* 100) #send numbers in range 0->100
            r2 = (sensor2.distance* 100)
            sender.send_message('/play_this',[r1,r2]) #sends list of 2 numbers
            print("r1:",round(r1,2),"r2:",round(r2,2))
            sleep(0.06)
        except KeyboardInterrupt:
            print("\nExiting")
            sys.exit()

if __name__=="__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--sp",
    default="127.0.0.1", help="The ip onic Pi listens on")
    args = parser.parse_args()
    spip=args.sp
    print("Sonic Pi on ip",spip)
    sleep(2)
    control(spip)