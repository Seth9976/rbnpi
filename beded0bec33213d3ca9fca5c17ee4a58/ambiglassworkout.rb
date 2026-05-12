#ambi_glass workout by Robin Newman, July 2016
#features retriggering samples before they end in live loops, killing the previous sample by setting its amp: to 0
#three live loops, one using ambi+glass+rub, a second featiuring tomtoms and the third using loop_amen
#a fourth live_loop (:audio) allows fade in and fade out using an fx_level control, and kills the other live loops at the end
# you can alter the numbers in the audio loop to control the duration
with_fx :reverb,room: 0.8,mix: 0.5 do
  with_fx :level do |v|
    control v,amp: 0
    kill=0
    sleep 0.1 #settling time to prevent clicks
    live_loop :audio do
      tick
      kill=1 if look > 600 #total time 60 seconds
      stop if look > 600
      control v,amp: (look.to_f)/200 if (look <= 200) #initial crecsendo (20 secs)
      control v,amp: (600-look).to_f/200 if (look >=400)   #diminuendo at the end (last 20 secs)   
      sleep 0.1
    end
    
    live_loop :ambi do
      s=sample :ambi_glass_rub, rpitch: -12+scale(:minor_pentatonic,num_octaves: 3).choose,amp: 2
      sleep 0.1
      control s,amp: 0 #set the amplitude to 0 to stop it sounding. It still plays, but you don't hear it
      stop if kill==1
    end
    
    live_loop :tomtom do
      tick
      vol=0
      vol=2 if look%8==0
      s=sample :drum_tom_hi_hard,rpitch: scale(:minor_pentatonic,num_octaves: 3).choose,amp: 0.6+vol,pan:  rrand_i(-1,1) if spread(5,13).look
      q= sample :drum_tom_mid_hard,rpitch: -12+scale(:minor_pentatonic,num_octaves: 3).choose,amp: 0.6+vol,pan: rrand_i(-1,1) if !spread(5,13).look
      sleep 0.1
      control s,amp: 0
      control q,amp: 0
      stop if kill==1
    end
    
    live_loop :amen do
      d=sample :loop_amen_full,rpitch: -2+scale(:minor_pentatonic).choose
      sleep 1
      control d,amp: 0
      stop if kill==1
    end
  end
end