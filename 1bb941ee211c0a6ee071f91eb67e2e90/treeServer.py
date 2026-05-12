#!/usr/bin/env python3
#this script allows OSC control of ThePiHut RGBXmasTree
#it is intended for use with Sonic Pi 3
#written by Robin Newman, December 2019
#it utilises the python-osc library and also the colorzero library
#this latter is used because of its support for gradient commands
#and a large list of named colours.
#see API doc at https://colorzero.readthedocs.io/en/release-1.1/api_color.html
#Sonic Pi can be on same computer if using Pi3, but if using pizero must be on separate computer
from tree import RGBXmasTree
import colorzero as cz
from pythonosc import osc_message_builder
from pythonosc import udp_client
from pythonosc import osc_server
from pythonosc import dispatcher
import argparse
import time
import numpy as np
from random import choice

tree = RGBXmasTree()

cn= ["silver", "maroon", "red", "purple", "fuchsia", "green", "lime", "olive", "yellow", "navy", "blue", "teal", "aqua"]
def randColName():
    return [cz.Color(choice(cn)) for i in range(25)]
######## osc hander routines called by the dispatcher
def oscSetAll(unused_addr,args,cname='black',id=-1):
    t=cz.Color(cname).rgb
    tree.color=(t[0],t[1],t[2])
    if id > -1: sender.send_message('/setalldone'+str(id),"ok")
def oscBrightness(unused_address,args,b,id=-1):
    tree.brightness=max(min(b,0.8),0.0) #check in range 0 to 0.8
    if id>-1:  sender.send_message('/brightnessdone'+str(id),"ok")
def oscLeafCn(unused_args,args,cn1,cn2,cn3,cn4,cn5,id=-1):
    cv=[[0,0,0]]*25
    r=[[3],[19,20,21,22,23,24],[0,1,2,7,8,9],[13,14,15,16,17,18],[4,5,6,10,11,12]]
    for i in r[0]: cv[i]=cz.Color(cn1)
    for i in r[1]: cv[i]=cz.Color(cn2)
    for i in r[2]: cv[i]=cz.Color(cn3)
    for i in r[3]: cv[i]=cz.Color(cn4)
    for i in r[4]: cv[i]=cz.Color(cn5)
    cv2=np.array(cv).reshape((-1,3))
    tree.value=[tuple(row) for row in cv2]
    if id>-1:  sender.send_message('/leafcndone'+str(id),"ok")
def oscRandColName(unused_args,args,n=20,wait_ms=20,id=-1):
    for i in range(n):
        tree.value=randColName()
        time.sleep(wait_ms/1000.0)
    if id>-1:  sender.send_message('/randcolnamedone'+str(id),"ok")
if __name__ == "__main__":
    try:
        parser = argparse.ArgumentParser()
        parser.add_argument("-ip",
        default = '127.0.0.1', help="The ip of this computer")
        parser.add_argument("-sp",
        default = '127.0.0.1', help="The ip of the computer running Sonic Pi")
        #This is the port on which the server listens. Usually 8000 is OK
        #but you can specify a different one
        parser.add_argument("--port",
            type=int, default=8000, help="The port to listen on")
        args=parser.parse_args()
        spip=args.sp
        #######dispatchers which handle incoming osc calls. They pass the data received on to
        ####### the routine following the OSC address. eg "/setAll" calls oscSetAll with data cname and id
        ####### All routines can send optional message back to Sonic Pi if id param is > -1 (default)
        ####### steps, wait_ms and id all have default values if omitted
        dispatcher = dispatcher.Dispatcher()
        dispatcher.map("/setAll",oscSetAll,"cname","id")
        dispatcher.map("/brightness",oscBrightness,"b","id")
        dispatcher.map("/leafCn",oscLeafCn,"cn1","cn2","cn3","cn4","cn5","id")
        dispatcher.map("/randColName",oscRandColName,"n","wait_ms","id")
#now setup sender to return OSC messages to Sonic Pi
        print("Sonic Pi on ip",spip)
        sender=udp_client.SimpleUDPClient(spip,4559) #sender set up for specified IP
        #Now set up and run the OSC server
        server = osc_server.ThreadingOSCUDPServer(
            (args.ip, args.port), dispatcher)
        print("Serving on {}".format(server.server_address))
        #run the server "forever" (till stopped by pressing ctrl-C)
        server.serve_forever()
    except  KeyboardInterrupt:
        tree.color=(0.0, 0.0, 0.0) #clear display then exit
