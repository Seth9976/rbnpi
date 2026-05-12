#spacewibbles by Robin Newman coded August 2015
#relies heavily on sliding notes and sliding cutoffs. Requires SP 2.6

define :wibble do |syn,n,t=1,shift=12,p=0| #syn (synth to use) , n (starting pitch), t (duration of swoop up), shift (shift to top note) ,p pan
  use_synth syn
  with_fx :reverb,room: 0.8 do
    with_fx :level do |amp| #to control level of wibble. increases 0 to 1 then back to 0
      control amp,amp: 0 #set initial level
      sleep 0.05 #sttle time for initial level to prevetn clicks
      control amp,amp: 1,amp_slide: t #increase level over frist half
      s=play note: n,sustain: 2*t,release: t.to_f/16, cut_off: 100,amp: 4,pan: p #start note duration 2*t cutoff 100
      control s,note: note(n)+shift,note_slide: t,cutoff: 60,cutoff_slide: t #control note increase pitch by shift, decrease cutoff to 60
      sleep t
      control amp,amp: 0,amp_slide: t #decrease level to 0 over second half
      control s,note: n,note_slide: t,cutoff: 100,cutoff_slide: t #decrease pitch back to n and increase cuteoff back to 100
      sleep t
    end
  end
end
live_loop :drone do #produce drone  base
  with_fx :echo do
    sample  :ambi_drone, beat_stretch: 5,rate: [0.75,0.5,0.25].choose,amp: 8,attack: 1,release: 1 
    sleep rrand(5,10)
  end
end
sleep 5 #could replace by delay parameter in sp2.7dev
live_loop :space do #space swooshing sound
  with_fx :echo do
    sample :ambi_lunar_land, beat_stretch: 5,rate: [0.75,0.5,0.25].choose,amp: 4,attack: 1,release: 1
    sleep rrand(5,10)
  end
end
sleep 5 #could replace by delay parameter in sp2.7dev

live_loop :uppydownLeft do #wibbles on stereo left
#choose parameters for wibble
  n=(ring :c1, :c2,:g2,:c3,:g3,:c4).choose #used rings as also experimented with ticks here
  t=(ring 0.2,0.4,0.75,1,1.5,2).choose
  s=(ring :fm,:tri,:tb303,:zawa,:dsaw).choose
  shift=(ring 6,12,12,6,24,18).choose
  wibble(s,n,t,shift,-0.8) #call wibble function
  sleep rrand(0,4) #random delay before next llop
end

live_loop :uppydownRight do #wibbles on stereo right
  n=(ring :c1,  :c2,:g2,:c3,:g3,:c4).choose
  t=(ring 0.2,0.4,0.75,1,1.5,2).choose
  s=(ring :fm,:tri,:tb303,:zawa,:dsaw).choose
  shift=(ring 6,12,12,6,24,18).choose
  wibble(s,n,t,shift,0.8)
  sleep rrand(0,4)
end

live_loop :uppydownCentre do #wibbles in central stereo spectrum
  n=(ring :c1, :c2,:g2,:c3,:g3,:c4).choose
  t=(ring 0.2,0.4,0.75,1,1.5,2).choose
  s=(ring :fm,:tri,:tb303,:zawa,:dsaw).choose
  shift=(ring 6,12,12,6,24,18).choose
  wibble(s,n,t,shift,0)
  sleep rrand(0,4)
end