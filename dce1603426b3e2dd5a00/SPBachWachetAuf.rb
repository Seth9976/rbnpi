#Sonic Pi Wachet Auf by J.S. Bach arranged for Violin and Cello. Coded by Robin Newman, March 2015
#score from http://www.freegigmusic.com
#download sample pack from http://r.newman.ch/rpi/WachetAuf.zip
use_debug false
use_sample_pack_as '/pi/home/samples/WachetAuf',:wachet #adjust location as necessary
#first deal with selecting and setting up the samples

inst0=:wachet__violin_as4
samplepitch0=:as4
inst1=:wachet__cello_ds3
samplepitch1=:ds3

#preload all the samples
load_flag=0
if sample_loaded? inst0 then #check if sample already loaded
  flag=1
end
load_samples [inst0,inst1]
if load_flag==0 then #samples not loaded so allow time
  sleep 3
end

#put the sample names and pitches into an array i
i=[[inst0,samplepitch0],[inst1,samplepitch1]]

define :ntosym do |n| #this returns the equivalent note symbol to an input integer e.g. 59 => :b4
  #nb no error checking on integer range included
  #only returns notes as n or n sharps.But will sound ok for flats
  note=n % 12
  octave = n / 12 - 1
  #puts octave #for debugging
  #puts note
  lookup_notes = {0 =>:c, 1 =>:cs,2 =>:d,3 =>:ds,4 =>:e,5 =>:f,6 =>:fs,7 =>:g,8 =>:gs,9 =>:a,10 =>:as,11 =>:b}
  return (lookup_notes[note].to_s + octave.to_s).to_sym #return the required note symbol
end

#define variables that need to be used globally
s=dsq=sq=sqd=q=qt=qd=qdd=c=cd=cdd=m=md=mdd=b=bd=0 #note duration variables

vln=[];vld=[];vcn=[];vcd=[]
#prior to the release of version 2.5 you need the next function
#if you get an error message saying it exists then delete it or comment it out
uncomment do
  define :pitch_ratio do |n|
    return 2**(n.to_f/12)
  end
end

#this function plays the sample at the relevant pitch for the note desired
#the note duration is used to set up the envelope parameters
define :pl do |inst,samplepitch,nv,dv,vol=1,st=0|
  shift=note(nv)-note(samplepitch)
    #start: param used with very small value to give more immediate attack to the notes for cello
    sample inst,rate: (pitch_ratio shift),sustain: 0.8*dv,release: 0.2*dv,amp: vol,start: st
end

#this function plays an array of notes and associated array of durations
#also uses sample name (inst), sample normal pitch,sample start and shift (transpose) parameters
define :plarray do |inst,samplepitch,narray,darray,vol=1,st=0,shift=0|
  narray.zip(darray) do |nv,dv|
    if nv != :r
      pl(inst,samplepitch,note(nv)+shift,dv,vol,st)
    end
    sleep dv
  end
end

#set_bpm sets bpm required adjusting note duration variables accordingly
define :set_bpm do |n|
  s=1.0/8*60/n.to_f
  dsq = 1 * s #demisemiquaver
  sq = 2 * s #semiquaver
  sqd = 3 * s #semi quaver dotted
  q = 4 * s
  qt = 2.0/3*q
  qd = 6 * s
  qdd = 7 * s
  c = 8 * s
  cd = 12 * s
  cdd = 14 * s
  m = 16 * s
  md = 24 * s
  mdd = 28 * s
  b = 32 * s
  bd = 48 * s
end

#this section sets the bpm then defines the note and duration arrays

define :setupparts do |bpmvalue|
  set_bpm(bpmvalue)
  vln=[:bb3,:eb4,:f4,:g4,:g4,:f4,:ab4,:g4,:bb3,:ab3,:g4,:eb4,:f4,:ab3,:g3,:d4,:eb4,:r]*2
  vld=[q,sq,sq,q,q,q,q,q,q,q,sq,sq,q,q,q,q,q,q]*2
  vln.concat [:bb4,:bb4,:ab4,:g4,:f4,:eb4,:f4,:eb4,:d4,:c4,:bb3,:c4,:d4,:eb4,:f4,:g4,:f4,:ab4,:g4,:f4,:eb4,:g4,:f4,:r,:bb3,:g4,:a4,:bb4,:eb4,:d4,:eb4,:r,:c4]
  vld.concat [q,c,sq,sq,sq,sq,sq,sq,sq,sq,q,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,q,q,q,q,c,q,sq,sq,q,q,q]
  #b8
  vln.concat [:a4,:bb4,:c5,:eb4,:d4,:eb4,:r,:eb5,:d5,:c5,:bb4,:a4,:bb4,:a4,:g4,:f4,:eb4,:d4,:c4,:bb3,:c4,:d4,:eb4,:eb4,:f4,:eb4,:d4,:eb4,:a4,:bb4,:c5,:bb4,:a4,:g4,:f4]
  vld.concat [q,c,q,sq,sq,q,q,q,sq,sq,qd,sq,qd,sq,sq,sq,sq,sq,sq,sq,sq,sq,  q,dsq/2.0,dsq/2.0,sq-dsq,sq,qd,sq,sq,sq,sq,sq,sq,sq]
  #b11
  vln.concat [:bb4,:f4,:d4,:eb4,:d4,:c4,:bb3,:bb3,:eb4,:d4,:c4,:d4,:bb3,:g3,:a3,:a3,:g3,:a3,:bb3,:r,:bb3]
  vld.concat [q,q,dsq/2,dsq/2,q-dsq,sq,sq,sq,sq,sq,sq,q,q,qd,sq,qd,dsq,dsq,c,q,q]
  #b13
  vln.concat [:eb4,:f4,:g4,:g4,:f4,:ab4,:g4,:bb3,:ab3,:g4,:eb4,:f4,:ab3,:g3,:d4,:eb4,:r,:bb3,:eb4,:f4,:g4,:g4,:f4,:ab4,:g4,:bb3,:ab3]
  #b16
  vln.concat [:g4,:eb4,:f4,:ab3,:g3,:d4,:eb4,:r,:bb4,:bb4,:ab4,:g4,:f4,:eb4,:f4,:eb4,:d4,:c4,:bb3,:c4,:d4,:eb4,:f4,:g4,:f4,:ab4,:g4,:f4,:eb4,:g4,:f4,:r,:f4]
  vld.concat [sq,sq,q,q,q,q,q,q,q,sq,sq,q,q,q,q,q,q,q,sq,sq,q,q,q,q,q,q,q,sq,sq,q,q,q,q,q,q,q]
  vld.concat [c,sq,sq,sq,sq,sq,sq,sq,sq,q,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,q,q,q]
  #b19
  vln.concat [:g4,:a4,:bb4,:eb4,:f4,:eb4,:d4,:eb4,:r,:c4,:a4,:bb4,:c5,:eb4,:f4,:eb4,:d4,:eb4,:r,:eb5]
  vln.concat [:d5,:c5,:bb4,:bb4,:c5,:bb4,:a4,:bb4,:a4,:g4,:f4,:eb4,:d4,:c4,:bb3,:c4,:d4,:eb4,:eb4,:f4,:eb4,:d4,:eb4,:a4,:bb4,:c5,:bb4,:a4,:g4,:f4]
  vld.concat [q,c,q,dsq/2.0,dsq/2.0,sq-dsq,sq,q,q,q,q,c,q,dsq/2,dsq/2,sq-dsq,sq,q,q,q,sq,sq,q,dsq/2,dsq/2,sq-dsq,sq,qd,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,dsq/2,dsq/2,sq-dsq,sq,qd,sq,sq,sq,sq,sq,sq,sq]
  #b23
  vln.concat [:bb4,:f4,:d4,:eb4,:d4,:c4,:bb3,:bb3,:eb4,:d4,:c4,:d4,:bb3,:g3,:a3,:a3,:g3,:a3,:bb3,:r,:d4,:eb4,:f4,:g4,:bb3,:c4,:bb3,:ab3,:bb3,:r,:bb4]
  vld.concat [q,q,dsq/2,dsq/2,q-dsq,sq,sq,sq,sq,sq,sq,q,q,qd,sq,qd,dsq,dsq,c,q,q,q,c,q,dsq/2,dsq/2,sq-dsq,sq,q,q,q]
  #b26
  vln.concat [:bb4,:ab4,:g4,:f4,:eb4,:f4,:eb4,:d4,:c4,:bb3,:c4,:d4,:eb4,:f4,:g4,:f4,:ab4,:g4,:f4,:eb4,:g4,:f4,:r,:g4]
  vld.concat [c,sq,sq,sq,sq,sq,sq,sq,sq,q,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,q,q,q]
  #b28
  vln.concat [:c5,:d5,:eb5,:eb5,:d5,:f5,:eb5,:g4,:f4,:eb5,:c5,:d5,:f4,:eb4,:b4,:c5,:r,:g4,:g4,:f4,:eb4,:d4,:c4,:d4,:c4,:b3,:a3,:g3,:a3,:b3]
  vln.concat [:c4,:d4,:eb4,:d4,:f4,:eb4,:d4,:c4,:eb4,:d4,:r,:g3,:eb4,:fs4,:g4,:c4,:bb3,:c4,:r,:a3]
  #b33
  vld.concat [sq,sq,q,q,q,q,q,q,q,sq,sq,q,q,q,q,q,q,q,c,sq,sq,sq,sq,sq,sq,sq,sq,q,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,q,q,q,q,c,q,sq,sq,q,q,q]
  #b33
  vln.concat [:fs4,:g4,:a4,:c4,:bb3,:c4,:r,:c5,:bb4,:a3,:g4,:fs4,:g4,:f4,:eb4,:d4,:c4,:bb3,:a3,:g3,:a3,:bb3,:c4,:bb3,:c4,:fs4,:g4,:a4,:g4,:fs4,:e4,:d4]
  vld.concat [q,c,q,sq,sq,q,q,q,sq,sq,qd,sq,qd,sq,sq,sq,sq,sq,sq,sq,sq,sq,qd,sq,qd,sq,sq,sq,sq,sq,sq,sq]
  #b36
  vln.concat [:g4,:d4,:bb3,:c4,:bb3,:a3,:g3,:g3,:r,:r,:bb3,:eb4,:f4,:g4,:g4,:f4,:ab4,:g4,:bb3,:ab3,:g4,:eb4,:f4,:ab3,:g3,:d4,:eb4,:r,:bb4,:bb4,:ab4,:g4,:f4,:eb4]
  vln.concat [:f4,:eb4,:d4,:c4,:bb3,:c4,:d4,:eb4,:f4,:g4,:f4,:ab4,:g4,:f4,:eb4,:g4,:f4,:r,:eb4,:c5,:d5,:eb5,:ab4,:bb4,:ab4,:g4,:ab4,:r,:c5,:d5,:eb5,:f5]
  vld.concat [q,q,dsq/2,dsq/2,q-dsq,sq,sq,c,c,cd,q,sq,sq,q,q,q,q,q,q,q,sq,sq,q,q,q,q,q,q,q,c]+[sq]*8+[q]+[sq]*10+[q,q,q,q,q,c,q,dsq/2,dsq/2,sq-dsq,sq,q,q,q,q,c,q]
  #b43
  vln.concat [:ab4,:g4,:ab4,:r,:f4,:g4,:f4,:eb4,:d4,:eb4,:db5,:c5,:bb4,:ab4,:g4,:f4,:eb4,:f4,:g4,:ab4,:ab4,:bb4,:ab4,:g4,:ab4]
  vln.concat [:d4,:eb4,:f4,:eb4,:d4,:c4,:bb3,:bb4,:eb4,:g4,:f4,:eb4,:d4,:eb4,:ab4,:g4,:f4,:g4,:eb4,:c4,:d4,:d4,:eb4,:eb4]
  vld.concat [sq,sq,q,q,q,sq,sq,qd,sq,qd,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,dsq/2,dsq/2,sq-dsq,sq,qd,sq,sq,sq,sq,sq,sq,sq,q,q,sq,sq,sq,sq,sq,sq,sq,sq,q,q,qd,sq,qd*(1+2.0/15),sq*1.2,b] #add small rit
  #puts vln.length #for debugging purposes
  #puts vld.length
  vcn.concat [:r]+[:eb2,:eb2,:eb2,:g2,:ab2,:bb2,:eb2,:r]*2+[:g2,:c3,:bb2,:ab2,:g2,:eb2,:bb2,:d3,:eb3,:d3,:c3,:eb3,:f3,:g3,:a3,:f3]
  vcd.concat [q]+[c,c,c,c,c,c,c,c]*2+[c]*4*4
  #b9
  vcn.concat [:bb3,:a3,:g3,:f3,:eb3,:d3,:c3,:eb3,:d3,:bb2,:f3,:f2,:g2,:a2,:bb2,:d2,:eb2,:c2,:f2,:bb2,:c3,:bb2,:ab2]
  vcd.concat [c,c,c,c,c,c,c,c,q,q,q,q,q,q,q,q,q,q,c,q,q,q,q]
  #b13
  vcn.concat [:g2,:eb2,:d2,:eb2,:ab2,:bb2,:eb2,:r,:eb2,:eb2,:eb2,:g2,:ab2,:bb2,:eb2,:r,:g2,:c3,:bb2,:ab2,:g2,:eb2,:bb2,:d3]
  vcd.concat [c]*4*6
  #b19
  vcn.concat [:eb3,:d3,:c3,:eb3,:f3,:g3,:a3,:f3,:bb3,:a3,:g3,:f3,:eb3,:d3,:c3,:eb3]
  vcd.concat [c]*4*4
  #b23
  vcn.concat [:d3,:bb2,:f3,:f2,:g2,:a2,:bb2,:d2,:eb2,:c2,:f2,:bb2,:c3,:bb2,:ab2,:g2,:f2,:eb2,:d2,:eb2,:g2,:ab2,:bb2]
  vcd.concat [q,q,q,q,q,q,q,q,q,q,c,q,q,q,q,q,q,q,q,q,q,q,q]
  #b26
  vcn.concat [:c3,:d3,:eb3,:bb2,:ab2,:g2,:eb2,:bb2,:c3,:d3,:b2]
  vcd.concat [q,q,c,c,c,c,c,q,q,q,q]
  #b28
  vcn.concat [:c3,:g3,:c4,:bb3,:ab3,:eb3,:f3,:g3,:ab3,:g3,:f3,:eb3,:f3,:eb3,:d3,:c3,:b2,:g2,:g3,:f3,:eb3,:c3,:g3,:b3,:c4,:bb3,:a3,:c4]
  vcd.concat [q,q,q,q,c,c,c,c,q,q,q,q,q,q,q,q,q,q,q,q,c,c,c,c,c,c,c,c]
  #b33
  vcn.concat [:d3,:eb3,:fs2,:d2,:g2,:f2,:eb3,:d3,:c3,:bb2,:a2,:c3]
  vcd.concat [c]*4*3
  #b36
  vcn.concat [:bb2,:g21,:d3,:d2,:g2,:eb2,:f2,:g2,:ab2,:g2,:ab2,:bb2,:c3,:bb2,:c3,:d3,:eb3,:c3,:ab2,:bb2,:c3,:bb2,:c3,:d3,:eb3,:d3,:eb3,:f3]
  vcn.concat [:d3,:bb2,:bb3,:ab3,:g3,:eb3,:bb3,:ab3,:g3,:ab3,:g3,:f3,:eb3,:f3,:bb2]
  vcd.concat [q]*16+[c,c,c,c]+[q]*12+[c,c,q,q,c,c,c,c,c,c,c]
  #b43
  vcn.concat [:c3,:ab2,:bb2,:g2,:ab2,:g2,:f2,:eb2,:d2,:f2,:bb2,:c3,:bb2,:ab2,:g2,:c3,:ab2,:bb2,:c3,:d3,:eb3,:g3,:ab3,:f3,:bb3,:bb2,:eb3]
  vcd.concat [c,c,c,c,q,q,q,q,c,c,q,q,q,q,q,q,q,q,q,q,q,q,q,q,q*1.1,q*1.2,b] #add small rit
  #puts vcn.length #for debugging purposes
  #puts vcd.length
end

setupparts(76) #create note and duration lists with bpm 76
with_fx :reverb,room: 0.6,mix: 0.5 do
  with_fx :level,amp: 1.75 do
    in_thread {plarray(i[1][0],i[1][1],vcn,vcd,0.5,0.008)}#start parameter set for cello, as slow to sound
    plarray(i[0][0],i[0][1],vln,vld)
  end
end