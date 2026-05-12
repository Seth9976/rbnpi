#!/usr/bin/env python3
#this script allows OSC control of the PiBorg TroPi
#it is intended for use with Sonic Pi 3
#written by Robin Newman, October 2018
#it utilises the python-osc library and also the colorzero library
#this latter is used because of its report for gradient commands
#and a large list of named colours.
#see API doc at https://colorzero.readthedocs.io/en/release-1.1/api_color.html
#Sonic Pi can be on same computer if using Pi3, but if using pizero must be on separate computer
from tropi import TroPi
import colorzero as cz
from pythonosc import osc_message_builder
from pythonosc import udp_client
from pythonosc import osc_server
from pythonosc import dispatcher
import argparse
import time
TroPi=TroPi()

def gradientAll(c1,c2,steps=50,wait_ms=50):
    for c in cz.Color(c1).gradient(cz.Color(c2),steps):
        tv=c.rgb #get rgb values
        TroPi.SetAllColours(tv[0],tv[1],tv[2])
        time.sleep(wait_ms/1000.0)

def gradientSlide(c1,c2,steps=50,wait_ms=50):
    i=0
    for c in cz.Color(c1).gradient(cz.Color(c2),steps):
        tv=c.rgb
        TroPi.SetSingleColour(i,tv[0],tv[1],tv[2])
        i=(i+1)%5
        if i==0: TroPi.SetAllColours(0.0,0.0,0.0)
        time.sleep(wait_ms/1000.0)

def gradientToFro(c1,c2,steps=50,wait_ms=50):
    i=0;dir=1
    for c in cz.Color(c1).gradient(cz.Color(c2),steps):
        tv=c.rgb #get rgb values
        TroPi.SetSingleColour(i,tv[0],tv[1],tv[2])
        i=i+dir
        if i>4 or i < 0:
            TroPi.SetAllColours(0.0,0.0,0.0)
            dir=-dir
            i=i+dir
        time.sleep(wait_ms/1000.0)

def gradientOne(n,c1,c2,steps=50,wait_ms=50):
    for c in cz.Color(c1).gradient(cz.Color(c2),steps):
        tv=c.rgb #get rgb values for next step
        TroPi.SetSingleColour(n,tv[0],tv[1],tv[2])
        time.sleep(wait_ms/1000.0)

def gradientUpDown1(n,c1,c2,steps=50,wait_ms=50):
    gradientOne(n,c1,c2,steps,wait_ms)
    gradientOne(n,c2,c1,steps,wait_ms)

def gradientUpDownAll(c1,c2,steps=50,wait_ms=50):
    gradientAll(c1,c2,steps,wait_ms)
    gradientAll(c2,c1,steps,wait_ms)
######## osc hander routines called by the dispatcher
def oscSetAll(unused_addr,args,cname='black',id=-1):
    t=cz.Color(cname).rgb
    TroPi.SetAllColours(t[0],t[1],t[2])
    if id > -1: sender.send_message('/setalldone'+str(id),"ok")
def oscClearAll(unused_addr,args,id=-1):
    TroPi.SetAllColours(0.0,0.0,0.0)
    if id > -1: sender.send_message('/clearalldone'+str(id),"ok")
def oscSetOne(unused_addr,args,n,cname,id=-1):
    t=cz.Color(cname).rgb
    TroPi.SetSingleColour(n,t[0],t[1],t[2])
    if id > -1: sender.send_message('/setonedone'+str(id),"ok")      
def oscGradientAll(unused_addr,args,c1,c2,steps=50,wait_ms=50,id=-1):
    gradientAll(c1,c2,steps,wait_ms)
    if id > -1: sender.send_message('/gradientalldone'+str(id),"ok")      
def oscGradientOne(unused_addr,args,n,c1,c2,steps=50,wait_ms=50,id=-1):
    gradientOne(n,c1,c2,steps,wait_ms)
    if id > -1: sender.send_message('/gradientonedone'+str(id),"ok")      
def oscGradientSlide(unused_addr,args,c1,c2,steps=50,wait_ms=50,id=-1):
    gradientSlide(c1,c2,steps,wait_ms)
    if id > -1: sender.send_message('/gradientslidedone'+str(id),"ok")      
def oscGradientToFro(unused_addr,args,c1,c2,steps=50,wait_ms=50,id=-1):
    gradientToFro(c1,c2,steps,wait_ms)
    if id > -1: sender.send_message('/gradienttofrodone'+str(id),"ok")      
def oscGradientUpDown1(unused_address,args,n,c1,c2,steps=50,wait_ms=50,id=-1):
    gradientUpDown1(n,c1,c2,steps,wait_ms)
    if id > -1: sender.send_message('/gradientupdown1done'+str(id),"ok")      
def oscGradientUpDownAll(unused_address,args,c1,c2,steps=50,wait_ms=50,id=-1):
    gradientUpDownAll(c1,c2,steps,wait_ms)
    if id > -1: sender.send_message('/gradientupdownalldone'+str(id),"ok")      
def oscHexCol1(unused_address,args,n,cv,id=-1):
    t= cz.Color(cv).rgb #get rgb values
    TroPi.SetSingleColour(n,t[0],t[1],t[2])
    if id>-1:  sender.send_message('/hexcol1done'+str(id),"ok")
def oscHexColAll(unused_address,args,cv,id=-1):
    t= cz.Color(cv).rgb #get rgb values
    TroPi.SetAllColours(t[0],t[1],t[2])
    if id>-1:  sender.send_message('/hexcolalldone'+str(id),"ok")

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
        dispatcher.map("/clearAll",oscClearAll,"id")
        dispatcher.map("/setOne",oscSetOne,"n","cname","id")
        dispatcher.map("/gradientAll",oscGradientAll,"c1","c2","steps","wait_ms","id")
        dispatcher.map("/gradientOne",oscGradientOne,"n","c1","c2","steps","wait_ms","id")
        dispatcher.map("/gradientSlide",oscGradientSlide,"c1","c2","steps","wait_ms","id")
        dispatcher.map("/gradientToFro",oscGradientToFro,"c1","c2","steps","wait_ms","id")
        dispatcher.map("/gradientUpDown1",oscGradientUpDown1,"n","c1","c2","steps","wait_ms","id")
        dispatcher.map("/gradientUpDownAll",oscGradientUpDownAll,"c1","c2","steps","wait_ms","id")
        dispatcher.map("/hexCol1",oscHexCol1,"n","cv","id")
        dispatcher.map("/hexColAll",oscHexColAll,"cv","id")
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
        TroPi.SetAllColours(0.0, 0.0, 0.0) #clear display then exit
