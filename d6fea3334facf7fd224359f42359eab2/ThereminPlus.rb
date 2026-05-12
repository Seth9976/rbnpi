#Theremin plus, controlling pitch and ixi_techno phase by Robin Newman May 2018
#/osc/ changed to /osc*/ in line 24 to work with latest Sonic Pi Aug 2021
#I control a continously playing note (length 2000)
use_debug false

define :putsPretty do |n,p|
  num=(n*10**p).round/(10**p).to_f
  return num
end

define :scalev do |v,l,h|
  return (l+v).to_f*(h-l)/100
end


with_fx :reverb,room: 0.8,mix: 0.8 do
  with_fx :ixi_techno,phase: 4,phase_offset: 1,mix: 0.8 do |p|
    set :p, p
    use_synth :subpulse
    k=play octs(0,2),sustain: 10000,amp: 0
    set :k,k
    live_loop :theremin do
      use_real_time
      b = sync "/osc*/play_this"
      r1=scalev(b[0],30,100)
      r2=scalev(b[1],0.1,1)
      puts putsPretty(r1,2),putsPretty(r2,2)
      if r1  <  60 then #adjust note pitch, and restore volume to 0.7
        control get(:k),note: octs(r1+12,2),note_slide: 0.06 ,amp: 0.7,amp_slide: 0.2
      else #set output vol to 0
        control get(:k),amp: 0,amp_slide: 0.2
      end
      if r2 < 0.8 then #adjust phase modulation rate, and restore mix to 0.8
        control get(:p),phase: r2,phase_slide: 0.06,mix: 0.8,mix_slide: 0.2
      else #switch off phase modulation by setting mix to zero
        control get(:p),mix: 0,mix_slide: 0.2
      end
    end
  end
end