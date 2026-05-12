#Jeremy Wentworth's voicesynth samples rfendered on Sonic Pi
#samples downloaded from http://jeremywentworth.com/speech-synth-sounds.zip
#download and uzip the samples and copy them into a folder specifed by the sdir variable

sdir="/home/pi/samples/SpeechSynth/"
dl=Dir.glob(sdir+"*.wav")
dl.sort! #sort array in place
dl.length.times do |n| #we play all the samples
  sd=(sample_duration dl[n]).round(2)
  puts n.to_s+": "+dl[n]+": duration "+sd.to_s
  #load sample with full pathname
  sample dl[n]
  sleep sd + 0.25 #0.25 gap
end