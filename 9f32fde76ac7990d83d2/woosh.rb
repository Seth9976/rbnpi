#Whoosh! fun using the new :misc_rand_noise sample in Sonic Pi dev 2.6 by Robin Newman, May 2015
#This sample was introduced almost by accident. It is intended to aid the operation of the fx :slicer command
#It is however fun to use, and I have here two functions developed to exploit it.
#The first noisepulse plays the sample with its volume starting from 0, rising to a plateau
#and then reducing to zero again. The sample rate is adjusted so that the overall length of the pulse
#can be set. It also has an optional parameter that can pan it across the spectrum if required.
#
#This is then developed in the second function whoosh which wraps noisepulse in fx commands for echo, reverb and ixi_techno
#The result is a very flexible routine for producing a large range of noise effects.
#samples can be uncommented to try out the range.

#As written this needs SP 2.6dev, but it is easily adapted to earlier versions by downloading the sample
#and putting it in a folder samples created in your pi home folder, using cd ~ followed by mkdir samples
#Enter the samples folder with cd samples and then download the sample using 
# wget https://github.com/samaaron/sonic-pi/blob/master/etc/samples/misc_rand_noise.wav?raw=true
#Then rename the downloaded file using mv misc_rand_noise.wav\?raw\=true misc_rand_noise.wav
#you then uncomment the next line to specify the sample location
#use_sample_pack "/home/pi/samples"

#The stop command used in the live_loop is also different in operation in SP 2.6dev
#it will work here, but will generate errors which you can ignore
use_debug false
define :noisepulse do |t,pstart = 0| #t pulse duration, pstart starting pan position
  dur = sample_duration :misc_rand_noise
settletime=0.03 #lengthen a bit if you hear clicks at start
  rt = dur/(t.to_f-settletime) #rate for sample adjusted for amp level settle time
  lptime=t.to_f-settletime #loop time for one iteration adjusted for amp level settle time
  #puts rt #for debugging
  with_fx :level do |amp| #control pulse amplitude
    control amp,amp: 0 #intial value set to 0
    sleep settletime #allow time for initial amp level to settle
    live_loop :l,auto_cue: false do |x| #this loop controls the amplitude, raising from 0 to 1 and after a pause back to 0 again
      if x < 80 then
        control amp,amp: x.to_f/80,amp_slide: lptime/200
      end
      if x > 120
        #puts (200 -x.to_f)/80#for debugging
        control amp,amp: (200 -x.to_f)/80,amp_slide: lptime/200
      end
      sleep lptime/200
      if x == 200 then stop #stops the loop when amplitude back to 0 again
      end
      inc x
    end
    p = sample :misc_rand_noise,rate: rt, pan: pstart #sets up control to adjust pan position
    control p,pan: (pstart * -1) ,pan_slide: t,pan_slide_shape: 3 #sweep pan across spectrum for pstart to -pstart
  end
  sleep lptime #sets overall time of noisepulse to t
end

define :whoosh do |numpulses,plength=5,gap=1,panstart=-1,technoblips=1|
#parameters numberofpusles,dureation of each pulse, gap between pulses, panstart position,no technoblips per pulse
  with_fx :echo do #add some echo
    with_fx :reverb,room: 0.8 do #add some reverb

      numpulses.times do
        with_fx :ixi_techno, phase: plength.to_f/technoblips do #setup ixi_techno adjusting phase setting
          noisepulse(plength,panstart) #do a noisepulse with pan
        end
        panstart=-panstart #set next pan start
        if numpulses > 1 then sleep gap #sleep gap if another pusle to come
        end
      end
    end
  end
end


#start demo here. You can comment out individual bits are required
uncomment do #single noise pulse 15 seconds, central position
  noisepulse(15,0)
  sleep 1
end
uncomment do #single noise pulse 8 seconds, pans -0.8 to +0.8
  noisepulse(8,-0.8)
  sleep 1
end

uncomment do #double whoosh, 10 seconds, 1 sec gap between, 1st pan sweep -1 to 1,1 "technoblip"
  whoosh(2,10,1,-1,1)
  sleep 1
end
uncomment do #6 whoosh, 4 seconds, 0.5 sec gap between, 1st pan sweep  1 to -1, 4 "technoblips"
  whoosh(6,4,0.5,1,4)
  sleep 1
end
uncomment do #2 whoosh 5 seconds,2 sec gap between, 1st pan sweep  -0.8 to 0.8, 10 "technoblips"
  whoosh(2,5,2,-0.8,10)
  sleep 1
end
uncomment do
  whoosh(1,12,1,0,2) #1 whoosh, 12 seconds, 1 sec gap between (ignored) ,pan constant 0, 2 "technoblips"
sleep 1
end
#that's all folks!
use_synth :prophet
play_pattern_timed [:g4,:d4,:ds4,:d4,:ds4,:d4,:fs4,:g4],[0.3,0.1,0.1,0.1,0.3,0.6,0.3,0.6],release: 0.2
