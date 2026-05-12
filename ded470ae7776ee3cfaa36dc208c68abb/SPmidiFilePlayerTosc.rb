#Multi-channel midi file player for Sonic Pi 3.1 or 3.2
#this program attempts to play midi events for up to 16 channels
#also can handle channel 10 as GM percussion
#handles both note_off and note_on with vel=0 for note stopping
#experimental program by Robin Newman, January 2020
#this version supports TouchOSC synth select, and volume selection

use_debug false
use_midi_logging false
use_cue_logging false
use_osc_logging false

####******** USER SETTINGS ******
#use_real_time  #not recommended
#use_sched_ahead_time 0.75 #possible use for very demanding midi files
use_osc "192.168.1.240",9000 #address of TouchOSC controller
percpath="~/Downloads/DrumsetSamplesFlac" #path to GM drumset samples
#drums is a hash table linking note value to sample name
drums={35=>"35 Acoustic Bass Drum",36=>"36 Bass Drum 1",37=>"37 Side Stick",
       38=>"38 Acoustic Snare",39=>"39 hand clap",40=>"40 Electric Snare",
       41=>"41 Low Floor Tom",42=>"42 Closed Hi-hat",43=>"43 High Floor Tom",
       44=>"44 Pedal Hi-hat",45=>"45 Low Tom",46=>"46 Open Hi-hat",
       47=>"47 Low-Mid tom",48=>"48 Hi Mid Tom",49=>"49 Crash Cymbal 1",
       50=>"50 High Tom",51=>"51 Ride Cymbal 1",52=>"52 Chinese Cymbal",
       53=>"53 Ride Bell",54=>"54 Tambourine",55=>"55 Splash Cymbal",
       56=>"56 Cowbell",57=>"57 Crash Cymbal 2",58=>"58 Vibraslap",
       59=>"59 Ride Cymbal 2",60=>"60 Hi Bongo",61=>"61 Low Bongo",
       62=>"62 Mute Hi Conga",63=>"63 Open Hi Conga",64=>"64 Low Conga",
       65=>"65 High Timbale",66=>"66 Low Timbale",67=>"67 High Agogo",
       68=>"68 Low Agogo",69=>"69 Cabasa",70=>"70 Maracas",
       71=>"71 Short Whistle",72=>"72 Long Whistle",73=>"73 Short Guiro",
       74=>"74 Long Guiro",75=>"75 Claves",76=>"76 Hi Wood Block",
       77=>"77 Low Wood Block",78=>"78 Mute Cuica",79=>"79 Open Cuica",
       80=>"80 Mute Triangle",81=>"81 Open Triangle"}

use_transpose 0 #add optional transpose manually
pan=[0,-0.1,0.1,-0.2,0.2,-0.3,0.3,-0.4,0.4,0,
     -0.5,0.5,-0.6,0.6,-0.7,0.7] #pan settings for 16 channels
synthRing=(ring :piano) #:pulse,:saw,:tri,:blade select synth(s) to use indexed by channel
sList=[:piano,:tri,:saw,:pluck,:tb303,:blade] #selectable synths using TouchOSC
single= true #intialise single mode selection for touchOSC
ampAtten=0.5 #manual setting for fx :level amp:
#####******** END USER SETTINGS *****

#osc calls to intialise TouchOSC display
osc "/mplayer/singleadd/1/1",1.0
osc "/mplayer/vol",0.5
osc "/mplayer/currentSynths","(ring :piano)"
osc "/mplayer/currentSynths2",""
osc "/mplayer/currentSynths3",""
osc "/mplayer/currentSynths4",""

#np holds state of all notes values for 16 channels whether playing 1 or silent 0
np = Array.new(16){Array.new([0]*128)}
nr= Array.new(16){Array.new(128)}#lists to store reference to notes currently playing
klist = Array.new(16)#list to contain references to playing note to be killed for each channel

sleep 1 #allow arrays time to be built

define:parse_sync_address do |address| #gets info on wild cards used in sync address
  v= get_event(address).to_s.split(",")[6]
  if v != nil
    #return a list of address elements with wild cards substituted by actual values
    return v[3..-2].split("/")
  else
    return ["error"]
  end
end

live_loop :getSingleAdd do #TouchOSC sets single or additional synth selection
  use_real_time
  val=sync "/osc*/mplayer/singleadd/*/*"
  if val[0]==1.0 #switch is on
    #set single true when it is switch 1 that is on
    single = parse_sync_address("/osc*/mplayer/singleadd/*/*")[3].to_i == 1
  end
end

define :update do #updates TouchOSC synth display
  dd=synthRing.to_s
  #split dd into list of "words"
  #eg "(ring :piano, :saw, :pluck)" becomes ["", "ring", "piano", "saw", "pluck"]
  sdd=dd.split(/[^[[:word:]]]+/)
  #clear synth labels on display
  osc "/mplayer/currentSynths",""
  osc "/mplayer/currentSynths2",""
  osc "/mplayer/currentSynths3",""
  osc "/mplayer/currentSynths4",""
  sleep 0.2
  #repopulate with current values
  osc "/mplayer/currentSynths",sdd[2..5] #first 4
  osc "/mplayer/currentSynths2",sdd[6..9] if sdd.length > 6 #5-8
  osc "/mplayer/currentSynths3",sdd[10..13] if sdd.length > 10 #9-12
  osc "/mplayer/currentSynths4",sdd[14..17] if sdd.length > 14 #13-16
end

live_loop :getSynths do #allows selection of synth ring by TouchOSC
  use_real_time
  val=sync "/osc*/mplayer/synths/*/*"
  if val[0]==1.0
    sn = parse_sync_address("/osc*/mplayer/synths/*/*")[4].to_i - 1
    if single
      synthRing=(ring sList[sn])
    elsif synthRing.length<16
      synthRing = ((synthRing.to_a).push sList[sn]).ring #add new synth
    end
    update #the TouchOSC display
  end
end

live_loop :removeLast do
  use_real_time
  val=sync "/osc*/mplayer/remove"
  #puts "removing latest synth"
  if synthRing.length > 1
    #convert to array, drop last entry and set to ring again
    synthRing = (synthRing.to_a).reverse.drop(1).reverse.ring
    update #update the display
  end
end

define :notekill do |ch| #fade and kill the note specified by this channel
  in_thread do #perform in thread to minimise delays in main live_loop
    k=klist[ch] #retreive the note reference for channel ch to be killed
    control k,amp: 0,amp_slide: 0.01 if k!=nil#fade note out in 0.01 seconds
    sleep 0.01
    kill k #kill the note with reference k
    #end
  end
end

with_fx :reverb, room: 0.8, mix: 0.7 do #add reverb to taste
  #set overall volume to minimise distortion when using 16 channel input
  with_fx :level,amp: ampAtten do |vol|
    set :vol,vol
    live_loop :getVol do
      use_real_time
      val = sync "/osc*/mplayer/vol"
      ampNew=[0.1,val[0],1.0].sort[1] #sets range 0.1=>1
      #puts ampNew,get(:vol)
      control get(:vol),amp: ampNew
    end
    
    
    live_loop :midi_in,auto_cue: false do
      note, vel = sync "/midi/*/*/*/note_*" #change to match controller if you wish
      r=parse_sync_address("/midi/*/*/*/note_*") #get full parsed address string
      ch=r[3].to_i - 1 #extract channel that triggered sync (channel offset from 0)
      if r[4]=="note_on" and vel > 0 #check if note_on with +ve velocity
        if np[ch][note]==0 #check if new start for the note
          np[ch][note]=1  #mark note as started for this pitch
          use_synth synthRing[ch] #:pulse,:saw,:tri,:blade select synth to use
          #max duration of note set to 5 on next line. Can increase if you wish.
          if ch !=9#ignore percussion track
            #start a 5 second duration note for the specified pitch
            x = play note, sustain: 5,amp: vel/127.0,pan: pan[ch] #+offset
            #puts nr[ch][note]
            nr[ch][note]=x #store reference x to in nr array for given channel
          else  #otherwise channel 10 so play sample
            sample percpath,drums[note],amp: 0.5
          end
        end
      else #note_off or vel == 0
        if np[ch][note]==1 #check if this pitch is on
          klist[ch] = nr[ch][note] #add to list for killing for this channel
          np[ch][note]=0 #now set this pitch off
          notekill ch #call notekill function
        end
      end
    end
  end #fx level
end #fx reverb