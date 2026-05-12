#!/usr/bin/env python3
#TouchOSC jukebox interface for Sonic Pi by Robin
#Newman, Aug 2017
##################USER CONFIGURATION#########################
#specify full folder path containing playable SP3 files
SPfolder="/home/pi/Documents/SPfromXML/" #with trailing /
#specify full run path for sonic_pi Command Line Interface
c="/usr/local/bin/sonic_pi "
#################END OF USER CONFIGURATION############
from pythonosc import osc_message_builder
from pythonosc import udp_client
from pythonosc import dispatcher
from pythonosc import osc_server
import os,time
from os.path import isfile,join
import argparse
import sys

#optional addition to getserver IP addres automatically
import socket
import signal
AF_INET=2
SOCK_DGRAM=2
def my_ip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect(('172.24.1.1',1027))
    return s.getsockname()[0]


#Read file names from selected folder, ignorgin subfolders and hidden files
list=sorted([f for f in os.listdir(SPfolder) if not f.startswith('.') if isfile(join(SPfolder, f))], key=lambda f: f.lower())
print("\nTouchOSC controlled Jukebox server for Sonic Pi")
print("Written by Robin Newman, August 2017\n")
print("Folder is at ",SPfolder)
print("Nunber of files in folder ",len(list))
smax=len(list) #max setting for start

start=0;finish=9 #initialise start/finish pointers
audioFlag=0

def getargs(): #do getargs as a function which can be called from this namespace and from __main___
    try:
        #first set up and deal with input args when program starts
        parser = argparse.ArgumentParser()
        
        #This arg gets the server IP address to use. 127.0.0.1 or
        #The local IP address of the PI, required when using external TouchOSC
        parser.add_argument("--ip",
        default="127.0.0.1", help="The ip to listen on")
        
        #This is the port on which the server listens. Usually 8000 is OK
        #but you can specify a different one
        parser.add_argument("--sport",
              type=int, default=8000, help="The port the server listens on")
              
        #This is the IP address of the machine running TouchOSC if remote
        #or you can omit if using TouchOSC on the local Pi (very unlikely!!).
        parser.add_argument("--tip",
              default="127.0.0.1", help="The ip TouchOSC is on")
              
        #This is the port that TouchOSC is listening on. Usually 9000 is OK
        #but you can specify a differnt one
        parser.add_argument("--tport",
               type=int, default=9000, help="The port TouchOSC listens on")
               
        args = parser.parse_args()
        #return args #return without further processing if called
        if args.ip=="127.0.0.1" and args.tip !="127.0.0.1":
            #You must specify the local IP address of the Pi if trying to use
            #the program with a remote TouchOSC on an external computer
            raise AttributeError("--ip arg must specify actual local machine ip if using remote TouchOSC, not 127.0.0.1")
        #Provide feed back to the user on the setup being used    
        if args.tip == "127.0.0.1":
            touchip=args.tip
            print("local machine used for TouchOSC: unlikely this is what you want",touchip)  
        else:
            touchip=args.tip
            #print("remote_host for TouchOSC is",args.tip)
            touchport=args.tport
            #print("remote TouchOSC listent on port",touchport)
            #first two values needed by server, last two by sender
        return args#(args.ip,args.sport,touchip,tport)
    #Used the AttributeError to specify problems with the local ip address
    except AttributeError as err:
        print(err.args[0])
        sys.exit(0)
    
    
vals=getargs() #call getargs here to get touchip and touchport values for sender

touchip=(vals.tip)

#optional adjust if using auto select for server IP address
#you can uncomment and amend next four lines to suit your situation
##if my_ip()=='172.24.1.10':
##    touchip='172.24.1.130' #adjust for my iPhone client
##elif my_ip()=='172.24.1.89:
##    touchip='172.24.1.127' #adjust for my iPad client

touchport=int(vals.tport)        
print("Sending to TouchOSC on ('{}', {})".format(touchip,touchport))
sender=udp_client.SimpleUDPClient(touchip,touchport) #to send data to TouchOSC

sender.send_message('/jb/audio-in',0)

def update(): #updates display after one of the buttons is pushed
    i=1
    for n in range(start,start+10):
        #print('/jb/f'+str(i),[list[n]])
        if n<=smax-1:
            sender.send_message('/jb/n'+str(i),[list[n]]) #print valid file name 
        else:
            sender.send_message('/jb/n'+str(i)," ") #print blank filename
        i +=1
        time.sleep(0.01)
    sender.send_message('/jb/start',start+1) #update numeric values
    sender.send_message('/jb/finish',finish+1)
    sender.send_message('/jb/total',smax)

def updateleds(n): #update leds to reflect which file is playing
    for x in range(1,11):
        if x==n:
            sender.send_message('/jb/led'+str(x),1)
        else:
            sender.send_message('/jb/led'+str(x),0)
        
time.sleep(1)
update()
updateleds(0)


def handle_next(unused_addr,args,n): #deal with next button pushed
  global start,finish
  if n == 1: #only act on push, not release
      if start < smax-11: #inc start if more than 10 left
          start +=10
          finish = start+9 #update finish
          finish = min(finish,smax-1) #check if reached last file
          print("next",n,start,finish) #print updated values on terminal
      update() #update display
      updateleds(0) #clear all leds
      
def handle_prev(unused_addr,args,p): #deal with previous button pushed
  global start,finish
  if p ==1: #only react to push, not release
      start -= 10 #set new start value
      start = max(start,0) #check not back at the beginning of list
      finish=start+9 #set new finish value
      finish = min(finish,smax-1)
      print("prev",p,start,finish) #print new values on terminal
      update() #update display
      updateleds(0) #clear all leds

def handle_stop(unused_addr,args,s): # send stop signal to SP
  if s ==1: #only on press, not release
      os.system(c+"stop")
      os.system(c+"midi_sound_off")#in case of any oprphan midi notes
      updateleds(0) #clear all leds
      print("stopped") #on terminal window
      
def handle_f1(unused_addr,args,n): #deal with button f1 (under first filename) pushed
  global audioFlag
  if n == 1: #only push not release
    if start <= smax: #check there is a file there
        if audioFlag==0:
            os.system(c+"stop") #stop previous file (if any)
        updateleds(1) #set led for position 1
        time.sleep(0.2)
        if audioFlag==1:
              os.system(c+"\'run_code \"with_fx :compressor,amp: 2 do;live_audio :sin;end\"\'")  
        f=SPfolder+list[start] #get full filename
        os.system(c+"\'"+"run_file"+"\""+f+"\"'") #send run_file command via sonic_pi cli

def handle_f2(unused_addr,args,n): # as per other buttons adjust for position 2
  global audioFlag
  if n == 1:
    if start+1 <= smax: #is it valid?
        if audioFlag==0:
            os.system(c+"stop") #stop previous file (if any)
        updateleds(2)
        time.sleep(0.2)    
        if audioFlag==1:
             os.system(c+"\'run_code \"with_fx :compressor,amp: 2 do;live_audio :sin;end\"\'")  
        f=SPfolder+list[start+1]
        os.system(c+"\'"+"run_file"+"\""+f+"\"'")

def handle_f3(unused_addr,args,n):
  global audioFlag
  if n == 1:
    if start+2 <= smax:
        if audioFlag==0:
            os.system(c+"stop") #stop previous file (if any)
        updateleds(3)
        time.sleep(0.2)    
        if audioFlag==1:
             os.system(c+"\'run_code \"with_fx :compressor,amp: 2 do;live_audio :sin;end\"\'")  
        f=SPfolder+list[start+2]
        os.system(c+"\'"+"run_file"+"\""+f+"\"'")

def handle_f4(unused_addr,args,n):
  global audioFlag
  if n == 1:
    if start+3 <= smax:
        if audioFlag==0:
            os.system(c+"stop") #stop previous file (if any)
        updateleds(4)
        time.sleep(0.2)    
        if audioFlag==1:
              os.system(c+"\'run_code \"with_fx :compressor,amp: 2 do;live_audio :sin;end\"\'")  
        f=SPfolder+list[start+3]
        os.system(c+"\'"+"run_file"+"\""+f+"\"'")

def handle_f5(unused_addr,args,n):
  global audioFlag
  if n == 1:
    if start+4 <= smax:
        if audioFlag==0:
            os.system(c+"stop") #stop previous file (if any)
        updateleds(5)
        time.sleep(0.2)    
        if audioFlag==1:
             os.system(c+"\'run_code \"with_fx :compressor,amp: 2 do;live_audio :sin;end\"\'")  
        f=SPfolder+list[start+4]
        os.system(c+"\'"+"run_file"+"\""+f+"\"'")

def handle_f6(unused_addr,args,n):
  global audioFlag
  if n == 1:
    if start+5 <= smax:
        if audioFlag==0:
            os.system(c+"stop") #stop previous file (if any)
        updateleds(6)
        time.sleep(0.2)    
        if audioFlag==1:
             os.system(c+"\'run_code \"with_fx :compressor,amp: 2 do;live_audio :sin;end\"\'")  
        f=SPfolder+list[start+5]
        os.system(c+"\'"+"run_file"+"\""+f+"\"'")

def handle_f7(unused_addr,args,n):
  global audioFlag
  if n == 1:
    if start+6 <= smax:
        if audioFlag==0:
            os.system(c+"stop") #stop previous file (if any)
        updateleds(7)
        time.sleep(0.2)    
        if audioFlag==1:
             os.system(c+"\'run_code \"with_fx :compressor,amp: 2 do;live_audio :sin;end\"\'")  
        f=SPfolder+list[start+6]
        os.system(c+"\'"+"run_file"+"\""+f+"\"'")

def handle_f8(unused_addr,args,n):
  global audioFlag
  if n == 1:
    if start+7 <= smax:
        if audioFlag==0:
            os.system(c+"stop") #stop previous file (if any)
        updateleds(8)
        time.sleep(0.2)    
        if audioFlag==1:
              os.system(c+"\'run_code \"with_fx :compressor,amp: 2 do;live_audio :sin;end\"\'")  
        f=SPfolder+list[start+7]
        os.system(c+"\'"+"run_file"+"\""+f+"\"'")

def handle_f9(unused_addr,args,n):
  global audioFlag
  if n == 1:
    if start+8 <= smax:
        if audioFlag==0:
            os.system(c+"stop") #stop previous file (if any)
        updateleds(9)
        time.sleep(0.2)    
        if audioFlag==1:
              os.system(c+"\'run_code \"with_fx :compressor,amp: 2 do;live_audio :sin;end\"\'")  
        f=SPfolder+list[start+8]
        os.system(c+"\'"+"run_file"+"\""+f+"\"'")

def handle_f10(unused_addr,args,n):
  global audioFlag
  if n == 1:
    if start+9 <= smax:
        if audioFlag==0:
            os.system(c+"stop") #stop previous file (if any)
        updateleds(10)
        time.sleep(0.2)    
        if audioFlag==1:
              os.system(c+"\'run_code \"with_fx :compressor,amp: 2 do;live_audio :sin;end\"\'")  
        f=SPfolder+list[start+9]
        os.system(c+"\'"+"run_file"+"\""+f+"\"'")

def handle_audioIn(unused_addr,args,a):
  global audioFlag
  if a == 1:
    audioFlag=1
    print("Audio Flag is ",audioFlag)
  if a == 0:
    audioFlag=0
    print("Audio Flag is ",audioFlag)
    os.system(c+"\'run_code \"live_audio :sin,:stop\"\'")

def handle_clear(unused_addr,args,cl):
  if cl == 1: #only on press, not release
    print("Clearing..")
    com="clear;sample_free_all"
    os.system(c+"\'"+"run_code"+"\""+com+"\"'")

#The main routine called when the program starts up follows
if __name__ == "__main__":
    try: #use try...except to handle possible errors
        args=getargs() #call args parsing to get ip and port for server
        sip=args.ip;sport=int(args.sport) #extract required itens

        #dispatcher reacts to incoming OSC messages and then allocates
        #different handler routines to deal with them
        dispatcher = dispatcher.Dispatcher()
        #set up the handler calls
        dispatcher.map("/jb/prev",handle_prev,"p")
        dispatcher.map("/jb/next",handle_next,"n")
        dispatcher.map("/jb/stop",handle_stop,"s")
        dispatcher.map("/jb/f1",handle_f1,"n")
        dispatcher.map("/jb/f2",handle_f2,"n")
        dispatcher.map("/jb/f3",handle_f3,"n")
        dispatcher.map("/jb/f4",handle_f4,"n")
        dispatcher.map("/jb/f5",handle_f5,"n")
        dispatcher.map("/jb/f6",handle_f6,"n")
        dispatcher.map("/jb/f7",handle_f7,"n")
        dispatcher.map("/jb/f8",handle_f8,"n")
        dispatcher.map("/jb/f9",handle_f9,"n")
        dispatcher.map("/jb/f10",handle_f10,"n")
        dispatcher.map("/jb/audio-in",handle_audioIn,"a")
        dispatcher.map("/jb/clear",handle_clear,"cl")
        #The following handler responds to the OSC message /testprint
        #and prints it plus any arguments (data) sent with the message
        #can be used for testing without doing anything
        dispatcher.map("/testprint",print)
        
        #Now set up and run the OSC server
        
        #optionally determine IP address of server: uncomment next line
        ##sip=my_ip() #overwrites sip value obtained from input args

        server = osc_server.ThreadingOSCUDPServer(
              (sip, sport), dispatcher)
        print("Serving messages from TouchOSC on {}".format(server.server_address))
        #run the server "forever" (till stopped by pressing ctrl-C)
        server.serve_forever()
    #deal with some error events
    except KeyboardInterrupt:
        print("\nServer stopped") #stop program with ctrl+C
    #handle errors generated by the server
    except OSError as err:
       print("OSC server error",	err.args)
    #anything else falls through
