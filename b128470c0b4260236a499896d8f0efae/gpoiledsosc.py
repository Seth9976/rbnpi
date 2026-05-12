#!/usr/bin/env python3
#by Robin Newman, 28th March 2020
from gpiozero import LED
from pythonosc import osc_server
from pythonosc import dispatcher
import argparse

red=LED(4)
white=LED(10)
green=LED(16)
blue=LED(21)
yellow=LED(27)
leds=[red,white,green,blue,yellow]

def setLedNum(unusedAddr,args,num,state):
    print("Received ",num,state)
    if state==1:
        leds[num].on()
    else:
        leds[num].off()

def stopLeds():
    for led in leds:
        led.off()

if __name__=="__main__":
  try:
    parser = argparse.ArgumentParser()
    parser.add_argument("--ip",
    default="127.0.0.1", help="The ip to listen on")
    parser.add_argument("--port",
        type=int, default=8000, help="The port to listen on")
    args=parser.parse_args()
    dispatcher=dispatcher.Dispatcher()
    dispatcher.map("/ledNum",setLedNum,"num","state")
    server = osc_server.ThreadingOSCUDPServer(
        (args.ip, args.port), dispatcher)
    print("Serving on {}".format(server.server_address))
    server.serve_forever()
  except KeyboardInterrupt:
    print("\nServer stopped")
    stopLeds
    