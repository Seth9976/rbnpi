#program to illustrate interaction between HELM synth and Sonic Pi
#using midi, written by Robin Newman, December 2017
# HELM is a fantastic donateware synth, and you can control its settings
#using midi_cc messages, using HELM's learn midi assignment feature.
#this example uses an arpeggiating synth setting, and adjusts
#the arpeggio rate and the volume, synced to adjusting
#the BPM setting in Sonic Pi.
#The audio from HELM is fed back to Sonic Pi using live_audio


use_midi_defaults channel: 1, port: "iac_driver_sonicpi"
##| midi_all_notes_off #uncomment to stop all
##| stop
#assign HELM BPM control to midi_cc 10
#assign HELM VOLUME control to midi_cc 20
#do this my right clicking control in HELM, selecting midi learn midi assignment
  #then sending a midi_cc from SOnic Pi on the relevant cc number
  #eg set VOLUME to learn, then execute midi_cc 20,80;stop
  #set BPM to learn, then execute midi_cc 10,40;stop
  
  
  define :bpmv do |v| #scale bpm value to send to HELM
    return ((v-20)*127/280.0).to_i
  end
  set :bpm, 20 #set initial tempo
  set :tflag,1 #set flag for tempo adjustments
  
  define :vset do |v| #scale volume value to send to HELM
    return (v*127/2.0).to_i
  end
  midi_cc 20,vset(0)
  sleep 0.1 #settling time
  
  
  live_loop :mt do #play top partt in HELM
    use_bpm get(:bpm)# set local BPM for Sonic Pi
    #midi_cc 10,bpmv(get(:bpm)) #set BPM for HELM #commnented out so only ONE note playing loop alters the bpm
    midi scale(:c4,:minor_pentatonic).choose,sustain: 0.5
    sleep 0.25
  end
  
  live_loop :mt2 do #play second part in HELM
    use_bpm get(:bpm) #set local BPM for Sonic Pi
    midi_cc 10,bpmv(get(:bpm)) #set BMP for HELM
    midi scale(:c1,:minor_pentatonic).choose,sustain: 1
    sleep 1
  end
  
  set :v,0 #initialise values for volume
  set :flag,1
  live_loop :volvary do # adjust volumes for HELM
    vol=get(:v)+get(:flag)*0.1 #set next volume value
    midi_cc 20,vset(vol) #send Vol to HELM
    set :v,vol #set local value
    if vol>1.9 or vol <0.1 #switch flag at limits
      set :flag,get(:flag)*-1
    end
    sleep 0.75
  end
  
  
  
  live_loop :varytempo do #loop to vary tempo
    tempo=get(:bpm)+get(:tflag)*20 #set next tempo value
    midi_cc 10,bpmv(tempo) #send it to HELM
    set :bpm,tempo #set it locally
    if tempo > 180 or tempo < 40 #switch flag at limits
      set :tflag,get(:tflag)*-1
    end
    sleep 0.5
  end
  
  with_fx :compressor,amp: 2 do #audio in section
    with_fx :reverb, room: 0.8,mix: 0.6 do
      live_audio :helmin #get audio from HELM
      
      live_loop :drums do #accompanying drum loop in SP
        use_bpm get(:bpm) #set bpm
        sample :bd_sone,amp: get(:v) if spread(5,8).tick
        sleep 0.5
      end
    end
  end