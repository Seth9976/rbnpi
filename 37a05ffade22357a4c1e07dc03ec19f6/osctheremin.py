#!/usr/bin/env python3
#script to read vl53l1x sensor and send reading via OSC to Sonic Pi
#written by Robin Newman August 2018 updated August 2020 for version 0.0.5 of library
#with thanks to Pimoroni's Phil Howard @Gadgetoid for the graph.py example
#on which I based some of this script.
import time
import sys
import signal
from pythonosc import osc_message_builder
from pythonosc import udp_client
import argparse
import VL53L1X

MAX_DISTANCE_MM = 800 # Set upper range

"""
Open and start the VL53L1X ranging sensor
"""
tof = VL53L1X.VL53L1X(i2c_bus=1, i2c_address=0x29)
tof.open() # Initialise the i2c bus and configure the sensor
tof.set_timing(66000,70) #This line is added from the original version to set refresh timings
tof.start_ranging(2) # Start ranging, 1 = Short Range, 2 = Medium Range, 3 = Long Range (LINE UPDATED)

sys.stdout.write("\n")

running = True

def exit_handler(signal, frame):
    global running
    running = False
    tof.stop_ranging() # Stop ranging
    sys.stdout.write("\n")
    sys.exit(0)

signal.signal(signal.SIGINT, exit_handler)

def control(spip):
    sender=udp_client.SimpleUDPClient(spip,4560) #port updated to 4560
    while running:
        distance_in_mm = tof.get_distance() # Grab the range in mm
        distance_in_mm = min(MAX_DISTANCE_MM, distance_in_mm) # Cap at our MAX_DISTANCE
        sender.send_message('/range',distance_in_mm)
        sys.stdout.write("\r") # Return the cursor to the beginning of the current line
        sys.stdout.write ("range %3d " % (distance_in_mm))
        sys.stdout.flush() # Flush the output buffer, since we're overdrawing the last line
        #time.sleep(0.01)
    
if __name__=="__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--sp",
    default = "127.0.0.1", help="The ip of the Sonic Pi computer")
    args = parser.parse_args()
    spip=args.sp
    print("Sonic Pi on ip",spip)
    control(spip)