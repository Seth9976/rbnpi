#Ethereal guitars for Sonic Pi by Robin Newman January 2015
#mournful but addictive!
#run then wait until you've had enough. To stop uncomment #sync :finish and re-run
#after sound stops press STOP. Re-comment sync :finish before re-running

x= sample_duration :guit_em9
y= sample_duration :ambi_lunar_land
#puts (x*0.3+x*0.3/1.5+x*0.2/0.5+x*0.3/2+x*0.3/1.75+x*0.3/1.6)/y/2 #gives rate factor for second loop
define :ct do |ptr,lev,slid=0| #this reduces the typing required for the control commands
  control ptr,amp: lev,amp_slide: slid
end


with_fx :reverb,mix: 0.3 do
  live_loop :g do
    with_fx :echo,phase: [0.2,0.3,0.4,0.4,0.5].choose,mix: 0.4 do
      with_fx :level do |l|
        ct(l,0.4,0)
        sample :guit_em9,finish: 0.3,pan: 1
        sleep x * 0.3
        #sync :finish
        ct(l,0.6,x*0.3/1.5)
        sample :guit_em9,finish: 0.3,rate: 1.5,pan: -1
        sleep x*0.3/1.5
        ct(l,0.8,x*0.2/0.5)
        sample :guit_em9,finish: 0.2,rate: 0.5,pan: 0
        sleep x*0.2/0.5
        ct(l,1,x*0.3/2)
        sample :guit_em9,finish: 0.3,rate: 2,pan: 1
        sleep x*0.3/2
        ct(l,0.8,x*0.3/1.75)
        sample :guit_em9,finish: 0.3,rate: 1.75,pan: -1
        sleep x*0.3/1.75
        ct(l,0.6,x*0.3/1.6)
        sample :guit_em9,finish: 0.3,rate: 1.6,pan: 0
        sleep x*0.3/1.6
      end
    end
  end

  live_loop :d do
    sync :g
    with_fx :pan,pan: -1 do |p|
      sample :ambi_lunar_land,rate: 1.0/0.95 #0.95 calculated to give two samples in loop
      control p, pan: 1,pan_slide: 4
      sleep y*0.95
      sample :ambi_lunar_land,rate: 1.0/0.95
      control p, pan: -1,pan_slide: 4
      sleep y*0.95
    end
  end
end