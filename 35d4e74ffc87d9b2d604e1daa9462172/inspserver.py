#!/usr/bin/env python3

"""Small example OSC server

This program listens to several addresses, and prints some information about
received packets.
"""
import argparse
from time import sleep
import apa
import os
numleds = 24
delay = 0.04

ledstrip = apa.Apa(numleds)
ledstrip.flush_leds()
ledstrip.write_leds()

from pythonosc import dispatcher
from pythonosc import osc_server

def handle_shutdown(unused_addr):
  ledstrip.led_set(1,20,255,0,0)
  ledstrip.write_leds()
  sleep(0.5)
  ledstrip.zero_leds()
  ledstrip.reset_leds()
  os.system("halt")

def handle_kill(unused_addr):
  ledstrip.zero_leds()
  ledstrip.reset_leds()

def handle_play(unused_addr,args, delay,n,
d,v,s,current_bpm,ledoffset,partoffset,iteration,leave):
  print(n,d,v,s,current_bpm,ledoffset,partoffset,iteration,leave)
  curLed=(int(n)-ledoffset)+partoffset*(iteration-1)
  curLed=abs(curLed%24)
  brightness=int(v*30)
  sleep(delay)
  if iteration == 0:
    ledstrip.led_set(curLed,brightness,0,0,0)
    ledstrip.write_leds()
    if leave == 0:
      sleep(d*60/current_bpm*0.9)
      ledstrip.led_set(curLed,0,0,0,255)
      ledstrip.write_leds()    
  if iteration == 1:
    ledstrip.led_set(curLed,brightness,0,0,255)
    ledstrip.write_leds()
    if leave == 0:
      sleep(d*60/current_bpm*0.9)
      ledstrip.led_set(curLed,0,0,0,255)
      ledstrip.write_leds()  
  elif iteration == 2:
    ledstrip.led_set(curLed,brightness,0,255,0)
    ledstrip.write_leds()
    if leave == 0:
      sleep(d*60/current_bpm*0.9)
      ledstrip.led_set(curLed,0,0,255,0)
      ledstrip.write_leds()      
  elif iteration == 3:
    ledstrip.led_set(curLed,brightness,255,0,0)
    ledstrip.write_leds()
    if leave == 0:
      sleep(d*60/current_bpm*0.9)
      ledstrip.led_set(curLed,0,255,0,0)
      ledstrip.write_leds() 
  elif iteration == 4:
    ledstrip.led_set(curLed,brightness,50,0,50)
    ledstrip.write_leds()
    if leave == 0:
      sleep(d*60/current_bpm*0.9)
      ledstrip.led_set(curLed,0,50,0,50)
      ledstrip.write_leds() 
  elif iteration == 5:
    ledstrip.led_set(curLed,brightness,50,50,0)
    ledstrip.write_leds()
    if leave == 0:
      sleep(d*60/current_bpm*0.9)
      ledstrip.led_set(curLed,0,50,50,0)
      ledstrip.write_leds() 
  elif iteration == 6:
    ledstrip.led_set(curLed,brightness,0,50,50)
    ledstrip.write_leds()
    if leave == 0:
      sleep(d*60/current_bpm*0.9)
      ledstrip.led_set(curLed,0,0,50,50)
      ledstrip.write_leds()
  elif iteration ==7:
    ledstrip.led_set(curLed,brightness,255,255,255)
    ledstrip.write_leds()
    if leave == 0:
      sleep(d*60/current_bpm*0.9)
      ledstrip.led_set(curLed,0,255,255,255)
      ledstrip.write_leds() 

if __name__ == "__main__":
  parser = argparse.ArgumentParser()
  parser.add_argument("--ip",
      default='127.0.0.1', help="The ip to listen on")
  parser.add_argument("--port",
      type=int, default=8000, help="The port to listen on")
  args = parser.parse_args()
  dispatcher = dispatcher.Dispatcher()
  dispatcher.map("/hello/play",handle_play,"delay", "n","d","v","s","current_bpm","ledoffset","partoffset","iteration","leave")
  dispatcher.map("/hello/kill",handle_kill)
  dispatcher.map("/hello/shutdown",handle_shutdown)
  server = osc_server.ThreadingOSCUDPServer(
     (args.ip, args.port), dispatcher)
 
 print("Serving on {}".format(server.server_address))
  server.serve_forever()
