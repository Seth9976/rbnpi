#frenzied samples by Robin Newman, November 2015. Requires SP version 2.7 or later
numpasses=5 #adjust duration here: fades out during last pass of live_loop :s

if sample_loaded? :loop_mika then #check if samples already loaded by looking at last one
  ld = 1
else
  ld = 0
end

define :numsamples do #function returns total number of samples
  g=sample_groups
  n=0
  g.each do |s|
    n=n+sample_names(s).length
  end
  return n
end

define :numgroups do #function returns total number of sample groups
  return sample_groups.length
end

define :samplelist do
  sl=[]
  g=sample_groups
  g.each do |s|
    sl.concat sample_names(s)
  end
  return sl
end

load_samples(samplelist)
if ld==0 then #allow samples time to load if not there already
  sleep 20 #value for Pi2. on my mac 10 is sufficient. If timeout error just re-run and will work second run.
end

puts "duration set to "+numpasses.to_s+" passes"
puts numsamples.to_s + " samples in total"
puts numgroups.to_s + " groups of samples"
puts "sample names are: "+samplelist.to_s

with_fx :level do |v| #use level function to give fade out
  control v,amp: 1 #set initial amp to 1

  live_loop :s do #cycle through all samples by group
    t=0.2
    g= sample_groups.ring.tick
    #puts g
    #puts look(:loop) #uncomment for debugging
    #start fade after numpasses-1 ie during last loop pass
    control v,amp: 0,amp_slide: numsamples*t if look == numgroups*(numpasses-1)
    stop if look == numgroups*numpasses
    sample_names(g).each do |n| #select each sample in group in turn
      tick(:loop)
      #puts n
      sample n,beat_stretch: t,amp: 1.5,pan: [-1,0,1].choose  if spread(7,13).look(:loop)
      sample n,beat_stretch: t,rpitch: [-12,12].choose,amp: 1.5,pan: [-1,0,1].choose  if !spread(7,13).look(:loop)
      sleep t
    end
  end

  live_loop :t do #similar to live_loop :s but samples reversed
    t=0.2
    g= sample_groups.reverse.ring.tick
    #puts g
    stop if look == numgroups*numpasses
    sample_names(g).reverse.each do |n|
      tick(:loop)
      #puts n
      sample n,beat_stretch: t,amp: 1.5,pan: [-1,0,1].choose  if !spread(7,13).look(:loop)
      sample n,beat_stretch: t,rpitch: [-12,12].choose,amp: 1.5,pan: [-1,0,1].choose  if spread(7,13).look(:loop)
      sleep t
    end
  end

  live_loop :u do #drum rhythm loop
    t=0.2
    g= (ring :drum,:bass_drums).tick
    sample_names(g).reverse.each do |n|
      tick(:loop)
      stop if look(:loop) == numsamples*numpasses
      sample n,beat_stretch: t,rpitch: -12,amp: 1 #play each sample twice
      sleep t/2
      sample n,beat_stretch: t,rpitch: -12,amp: 1
      sleep t/2
    end
  end

end #with_fx :level