#!/usr/bin/env python3

#OSCserver for The PiHut Christmas Tree, driven from Sonic Pi 3
#written by Robin Newman
import argparse
import math
from gpiozero import LEDBoard
from gpiozero.tools import random_values 
from time import sleep

from pythonosc import dispatcher
from pythonosc import osc_server

treelights=[ 18, 5, 9, 11, 21, 10, 7, 12, 6, 1,14, 3, 20, 24, 13, 15,2, 17, 16, 23,8, 22, 4, 19 ] #list of leds
tl1=[1,10,19,11,20,2] #6 subsets of leds
tl2=[6,16,22,21,7,15]
tl3=[9,3,17,18,12,4]
tl4=[14,24,8,5,13,23]
tl5=tl1+tl2
tl6=tl3+tl4
treemap={ 1:4, 7:5, 16:6, 22:7, 6:8 , 14:9, 8:10, 21:11, 15:12, 3:13, 19:14, 2:15, 9:16, 10:17, 20:18, 18:19,17:20, 4:21, 24:22, 23:23, 13: 
24, 5:25, 12:26, 11:27 
} 

leds=LEDBoard(*range(4,28), pwm=True) #set up led board

def labelToPin(l): 
  return treemap[l] 

def toBoard(l): 
  return labelToPin(l)-4 


def xmas_handler(unused_addr, args, part):
  if part==0:
    for led in leds:
      led.source_delay = 0.05
      led.source = led.off()
  if part==1:
    for i in tl1:
      leds.on(toBoard(i))
    sleep(0.01)
    for i in tl1:
      leds.off(toBoard(i))
  if part==2:
    for i in tl2:
      leds.on(toBoard(i))  
    sleep(0.01)
    for i in tl2:
      leds.off(toBoard(i))
  if part==3:
    for i in tl3:
      leds.on(toBoard(i))
    sleep(0.01)
    for i in tl3:
      #sleep(0.01)
      leds.off(toBoard(i))
  if part==4:
    for i in tl4:
      leds.on(toBoard(i))
    sleep(0.01)
    for i in tl4:
      leds.off(toBoard(i))
  if part==5:
    for i in tl5:
      leds.on(toBoard(i))
    sleep(0.01)
    for i in tl5:
      leds.off(toBoard(i))
  if part==6:
    for i in tl6:
      leds.on(toBoard(i))
    sleep(0.01)
    for i in tl6:
      leds.off(toBoard(i))
  if part==7:
    for i in treelights:
      leds.on(toBoard(i))
    sleep(0.01)
    for i in treelights:
      leds.off(toBoard(i))
  if part==8:
    for led in leds:
      led.source_delay = 0.05
      led.source = random_values()
    


if __name__ == "__main__":
  parser = argparse.ArgumentParser()
  parser.add_argument("--ip",
      default="127.0.0.1", help="The ip to listen on")
  parser.add_argument("--port",
      type=int, default=5005, help="The port to listen on")
  args = parser.parse_args()

  dispatcher = dispatcher.Dispatcher()
  dispatcher.map("/xmas/pulse",xmas_handler,"part")

  server = osc_server.ThreadingOSCUDPServer(
      (args.ip, args.port), dispatcher)
  print("Serving on {}".format(server.server_address))
  server.serve_forever()
