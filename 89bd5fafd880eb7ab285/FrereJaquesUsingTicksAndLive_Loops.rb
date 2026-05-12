#Frere Jaques 4 part round using live loops by Robin Newman, December 2015
#Syntax here needs SP2.8 Will work on 2.6 and 2.7 if you follow the instructions below
#The delay parameter in the live_loops will be ignored in versions before 2.8
#The program will work in 2.6 and 2.7 if you uncomment the sleep 8*c lines
#which are before the last three live_loops
s=0.2 #adjust the tempo here by varying s Try 0.1 to 0.4
q=1*s #define quaver (q) duration
c=2*q #define crotchet (c) duration
m=2*c #define minim (m) duration
#define rings for the tune notes and the note durations
#by using rings, we can access the contents with the tick and look functions
t = (ring :c4,:d4,:e4,:c4,:c4,:d4,:e4,:c4,:e4,:f4,:g4,:e4,:f4,:g4, \
     :g4,:a4,:g4,:f4,:e4,:c4,:g4,:a4,:g4,:f4,:e4,:c4,:c4,:g3,:c4,:c4, \
     :g3,:c4)
d= (ring c,c,c,c,c,c,c,c,c,c,m,c,c,m,q,q,q,q,c,c,q,q,q,q, \
    c,c,c,c,m,c,c,m)

define :fplay do |syn|
  use_synth syn #set the current synth
  #now play the next note selected by tick and the duration selected by look
  play t.tick,sustain: d.look*0.9,release: d.look*0.1 #sustains note for 90% of duration
  #sleep for the duration of the note selected by d.look
  sleep d.look
  stop if look >= d.length*2 - 1 #stop after 2 cycles. Note look starts from 0, so subtract 1
end

live_loop :tune do
  fplay(:tri)
end
#sleep 8*c #uncomment if using sp 2.6 or 2.7
live_loop :tune2,delay: 8*c do
  fplay(:saw)
end
#sleep 8*c #uncomment if using sp2.6 or 2.7
live_loop :tune3,delay: 16*c do
  fplay(:fm)
end
#sleep 8*c #uncomment if using sp2.6 or 2.7
live_loop :tune4,delay: 24*c do
  fplay(:tb303)
end