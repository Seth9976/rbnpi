#Frere Jaques using sliding notes
#This piece explores the use of functions generating named args for synths
#by Robin Newman December 12th 2014

#The program explores the use of sliding notes in chord scales and a rendition of Frere Jaques

use_debug false
s=0 #set s here with dummy value so that its scope is global
define :setbpm do |n| #set bpm equivalent
  s = (1.0 / 8) *(60.0/n.to_f)
end

setbpm(150)

q= 4 * s #define some note durationsa
c = 8 * s
m = 16 * s


define :sl do |note,slidetime=0| #set up note slide
  {note: note, note_slide: slidetime}
end

define :ncontrol do |node,pitch,slidetime,gap| #set up control and sleep gap
  control node,sl(pitch,slidetime)
  sleep gap
end

#notes for Frere Jaques
n1=[:c4,:d4,:e4,:c4]*2 #define here to be global in scope
d1=[c]*8
n2=[:e4,:f4,:g4]*2
d2=[c,c,m]*2
n3=[:g4,:a4,:g4,:f4,:e4,:c4]*2
d3=[q,q,q,q,c,c]*2
n4=[:d4,:g3,:c4]*2
d4=[c,c,m]*2
n=n1+n2+n3+n4
d=d1+d2+d3+d4

define :playline do |n,d| #play a single line of the tune
  total=0
  d.each do |d| #calculate the total duration of the line
    total= total + d
  end

  env = {attack: q*0.2,sustain: total,release: c} #for a long slideable note of duration total

  node=play n[0],env  #start long note
  sleep d[0] #sleep for the duration of the first note in the line
  n.zip(d).each.with_index do |v,i| #now deal with sliding the remainikng notes inteh line
    if i>0 #miss out first note, already playing if i=0
      ncontrol(node,v[0],v[1]*0.3,v[1]) #slide the next note: slide time 30% of duration
    end
  end
end

define :frerejaques do #play all four lines in Frere Jaques
  playline(n1,d1)
  playline(n2,d2)
  playline(n3,d3)
  playline(n4,d4)
end

define :round do #set up a round
use_synth :saw
  playline(n1,d1) #play first line of first part (set to :saw)
  in_thread do #start second part using :tri
    with_synth :tri do
      frerejaques
    end
  end
  playline(n2,d2) #second line of apart 1
  in_thread do #start third part using :fm
    with_synth :fm do
      frerejaques
    end
  end
  playline(n3,d3) #third line of part 1
  in_thread do #start fourth part using :pulse
    with_synth :pulse do
      frerejaques
    end
  end
  playline(n4,d4) #last line of part 1
  sleep c*8*3 #allow last thread part to complete
end


#====================================
#now play something!
with_fx :reverb,room: 0.6,mix: 0.5 do #wrap with some reverb
  with_fx :level, amp: 0.5 do #set an overall amp: level
    round #play the round of FrereJaques
  end
end