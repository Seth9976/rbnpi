#Sonic Pi Conductor by Robin Newman written for Sonic-Pi 2.1 onwards December 2014
#consists of two functions, slave and conductor, which make extensive use of the :cue and :sync system in Sonic Pi
#The program works becuase these commands can work between workspaces as well as within a single workspace.

#Instructions for use:

#1      In each workspace that you want to control, put as the FIRST LINE slave(ws number)
#       eg in workspace two put slave(2), workspace 5 put slave(5) etc.

#2      Put as the LAST LINE of each workspace to be conducted the command   cue :wsN    where N is the workspace number:
#       eg in workspace 2 put   cue :ws2, in worksapce 5 put     cue :ws5

#3      Now switch to the conductor workspace containing THIS program.
#4      Adjust the line sline = [3,7,4] to contain a list of the workspaces to be conducted in the order you want them to play

#5      Now RUN this workspace. It will not appear to do anything as it is waiting for a cue fron the first conducted workspace.
#6      Now switch to each of the workspaces to be conducted IN ASCENDING ORDER, not necessary to same as the playing order
#       and press RUN. You amy see some output messages, and when the last workspace in the list is run,
#       the conductor will start the first one in the PLAY ORDER list slist playing, and they will continue automatically from there.

#a 2 second delay is included between each workspace playing and the next one.
#you can comment this out if you want them to play without a break at all

# Note this will only work with linear programs. If you have a program that runs continuosly eg a live_loop then this program will not work
# because the conducted program never gets to an end until you press the stop button.

#================= The two function definitions ========================
define :slave do |i|
  cue ("slave"+i.to_s).to_sym
  sync ("start"+i.to_s).to_sym
end

define :conduct do |slist|
  (slist.sort).each do |ws|
    sync ("slave"+ws.to_s).to_sym #generates the cue name to sync with

    puts ws.to_s+" started"
  end
  slist.each do |ws|
    cue ("start"+ws.to_s).to_sym #generates the cue name to be sent
    sync ("ws"+ws.to_s).to_sym #waits for the conducted program to send a cue back again when it is finished
    sleep 2 #Delay between conducted programs. Comment or adjust this line to alter the delay between programs playing.
  end
end
#====================================================================

slist = [2,4,6,5,3] # The list of workspaces to be played

conduct(slist)  #   The maestro conducts the list!
