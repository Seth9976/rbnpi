#Reich like drumming, by Robin Newman, January 2023
#I use hi and mid tomtoms for the two parts
#or you can set them both the same eg to hard snare
use_debug false
use_midi_logging false
use_midi_defaults channel: 1,port: "iac_driver_bus"
link #lets you adjust tempo as program is running
#set master pattern option with uniform amp or accented amp

#uncomment either the 12 beat or 16 beat patterns

qNoAccentAmp   = (ring 1,0,1,0,1,1,0,1,0,1,0,1)
qWithAccentAmp = (ring 2,0,1,0,2,1,0,1,0,1,0,1)

##| qNoAccentAmp   = (ring 1,0,0,1,0,0,1,1,0,0,1,0,1,0,0,1)
##| qWithAccentAmp = (ring 2,0,0,1,0,0,1,1,0,0,1,0,2,0,0,1)



#set parameters for accents,pan
set :with_amp,true
set :with_pan,true #set to true to separate parts left/right

if get(:with_amp) #choose accented or no accent pattern
  q=qWithAccentAmp
else
  q=qNoAccentAmp
end

define :patshift do |pat,shift| #return master pattern shifted "shift" positions
  r=pat
  shift.times do #rotate pattern
    r= r.take_last(1)+ r.take(pat.length-1)
  end
  return r
end

define :pl do |pat,shift| #play master and shifted patterns together
  sp=patshift(pat,shift)
  puts "current shift #{shift}"
  puts "master part #{pat}"
  puts "second part #{sp}"
  4.times do     #4 repeats per iteration (could be 2,8 or 12 etc)
    pat.length.times do #cycle through all bits of the pattern
      if get(:with_pan) #play with different pan settings
        
        sample :drum_tom_hi_hard,pan: -1,amp: pat.tick
        sample :drum_tom_mid_hard,pan: 1,amp: sp.look
        midi_cc 1,[pat.look,1].min
        midi_cc 2,[sp.look,1].min
      else #play with pan 0
        sample :drum_tom_hi_hard,amp: pat.tick
        sample :drum_tom_mid_hard,amp: sp.look
        midi_cc 1,[pat.look,1].min
        midi_cc 2,[sp.look,1].min
      end
      sleep 0.175
    end
  end
end

#playin section starts here
with_fx :reverb, room: 0.7,mix: 0.5 do
  (q.length+1).times do |i| #start offset zero and cycle round back to start offset
    pl(q,i)
  end
  puts "finish"
  q.length.times do |i| #finish with a coda of drumbeats of increasing volume
    sample :drum_tom_hi_hard,amp: (i+1)*0.2
    sleep 0.175
  end
end


##| //Sonic Pi drum patterns drive Hydra with audio and midi_cc controls
##| //by Robin Newman, January 2023
##| // register WebMIDI
##| navigator.requestMIDIAccess()
##|     .then(onMIDISuccess, onMIDIFailure);

##| function onMIDISuccess(midiAccess) {
##|     console.log(midiAccess);
##|     var inputs = midiAccess.inputs;
##|     var outputs = midiAccess.outputs;
##|     for (var input of midiAccess.inputs.values()){
##|         input.onmidimessage = getMIDIMessage;
##|     }
##| }

##| function onMIDIFailure() {
##|     console.log('Could not access your MIDI devices.');
##| }

##| //create an array to hold our cc values and init to a normalized value
##| var cc=Array(128).fill(0.5)

##| getMIDIMessage = function(midiMessage) {
##|     var arr = midiMessage.data
##|     var index = arr[1]
##|     //console.log('Midi received on cc#' + index + ' value:' + arr[2])    // uncomment to monitor incoming Midi
##|     //var val = (arr[2]+1)/128.0  // normalize CC values to 0.0 - 1.0
##|     var val = arr[2]
##|     cc[index]=val
##| }
##| shape(8,0.1,0.001).scale(()=>cc[1]*a.fft[1]*8,1,1.5).color(0.8,0,()=>1-cc[1]*a.fft[0]).scrollX(0.22).scrollY(0)
##|   .add(
##|  shape(8,0.1,0.001).scale(()=>cc[2]*a.fft[1]*8,1,1.5).color(0,0.8,()=>1-cc[1]*a.fft[0]).scrollX(-0.22).scrollY(0))
##|   .repeatX(2).repeatY(2).out()