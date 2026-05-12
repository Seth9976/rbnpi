#Tchaikovsky's March from Nutcracker Suite coded for Sonic Pi by Robin Newman
#December 31st 2015
#although live_loops are used to play the notes taking advantage of the tick operator
#the notes and duration lists do not need to be in rings, as each live_loop is stopped
#after it has traversed all the loop notes data once, so no elements are referenced
#outside the lists.

#You can use various synths to play this.
#as supplied :piano is used. If you use a different synth uncomment the sustain and release
#parameters in the first TWO and last TWO live loops.

use_synth :piano

s=0.1 #tempo scale factor
#note durations
dsq=0.5*s
sq=2*dsq
q=2*sq
qt=2*q/3.0
c=2*q
cd=3*q
m=2*c
md=3*c
#now create all the note and duration lists!!!!
#bar 1-2.5
rhna=[[:b4,:d5],:r,[:b4,:d5],[:b4,:d5],[:b4,:d5],[:b4,:e5],:r,[:b4,:e5],:r,[:b4,:fs5],:r,[:b4,:d5],:r]
#bar1-5 3rd beat (end of) also bar9 - bar 13 end of 3rd beat
rhn1a=rhna+[[:b4,:e5]]+rhna+[[:b4,:e5],:r,:e4,:c5,:r,:d5,:c5,:r,:b4,:a4,:r,:g4]
#bar 5 last beat - end of bar 8
rhn1b=[:fs4,:r,:d4,:b4,:r, :c5,:b4,:r,:a4,:g4,:r,:fs4,:e4,:r,:g4,:fs4,:r,:e4,:ds4,:r,:a4,:g4,:r,:fs4,:e4,:r,:b4, \
       :c5,:r,:b4,:a4,:r,:g4,[:fs4,:a4,:d4],:a5,:b5,:c6,:cs6,:d6,:r]
#bar 1-5 3rd beat (end of) also bar9 - bar 13 ende of 3rd beat
rhd1a=[q,q,qt,qt,qt,q,q,q,q,q,q,q,q,m,q,q,qt,qt,qt,q,q,q,q,q,q,q,q,cd,sq,sq]+[q,sq,sq]*3
#bar 5 last beat - end of bar 8
rhd1b=[q,sq,sq]*11+[q]+[dsq]*4+[q,q]
#bar 13 last beat - bar 15 end of 5th quaver
rhn2a=[:fs4,:r,:a4,:d5,:r,:e5,:d5,:r,:c5,:b4,:r,:a4,:g4,:r,:b4,:e5,:r,:d5,:c5,:r,:e5,:fs5]
#bar 15 from 6th quaver to end of bar 16
rhn2b=[:r,:e5,:d5,:r,:fs5,:g5,:r,:fs5,:e5,:r,:fs5,:ds5,:fs5,:g5,:a5,:as5,:b5,:r]
rhn2=rhn2a+rhn2b #bar 13 last beat to end of bar 16
#bar 13 last beat - bar 15 end of 5th quaver
rhd2a=[q,sq,sq]*7+[q]
#bar 15 from 6th quaver to end of bar 16
rhd2b=[sq,sq]+[q,sq,sq]*3+[q]+[dsq]*4+[q,q]
rhd2=rhd2a+rhd2b #bar 13 last beat to end of bar 16
rhn1=rhn1a+rhn1b+rhn1a+rhn2 #all page 1
rhd1=rhd1a+rhd1b+rhd1a+rhd2 #all page 1

#position descriptions same for lh as rh
lhna=[:g4,:r,:g4,:g4,:g4,[:e4,:g4],:r,[:e4,:g4],:r,[:b4,:d4,:fs4],:r,:g4,:r]
lhn1a=lhna+[[:g4,:e4]]+lhna+[[:g4,:e4],:r,[:a1,:a2],[:gs1,:gs2],[:a1,:a2],[:b1,:b2],[:c2,:c3],[:cs2,:cs3]]
lhn1b=[[:d2,:d3],[:fs1,:fs2],[:g1,:g2],[:fs1,:fs2],[:g1,:g2],[:a1,:a2],[:as1,:as2],[:b1,:b2],[:c2,:c3], \
       [:e1,:e2],[:a1,:a2],[:as1,:as2],[:b1,:b2], [:c2,:c3],[:cs2,:cs3],[:ds2,:ds3],[:e2,:e3],[:g2,:g3], \
       [:a2,:a3],[:b2,:b3],[:c3,:c4],[:cs3,:cs4],[:d3,:d4],:r,[:d4,:fs4,:a4,:d5],:r]
lhd1a=[q,q,qt,qt,qt,q,q,q,q,q,q,q,q,m,q,q,qt,qt,qt,q,q,q,q,q,q,q,q,cd,q,q,q,q,q,q,q]
lhd1b=[q]*26

lhn2a=[[:d2,:d3],[:c2,:c3],[:b1,:b2],[:as1,:as2],[:b1,:b2],[:c2,:c3],[:d2,:d3],[:ds2,:ds3], \
       [:e2,:e3],[:d2,:d3],[:c2,:c3],[:b1,:b2],[:a1,:a2],[:c2,:c3],[:d2,:d3]]
lhn2b=[[:c2,:c3],[:b1,:b2],[:d2,:d3],[:e2,:e3],[:g2,:g3],[:a2,:a3],[:as2,:as3],\
       [:b2,:b3],:r,[:b3,:ds4,:fs4,:b4],:r]
lhn2=lhn2a+lhn2b
lhd2a=[q]*15
lhd2b=[q]*11
lhd2=lhd2a+lhd2b
lhn1=lhn1a+lhn1b+lhn1a+lhn2 #all page 1
lhd1=lhd1a+lhd1b+lhd1a+lhd2 #all page 1

#page 2 b1- b2 end 4th quaver
rhp2na=[[:ds4,:b4],:r,[:ds4,:b4],[:ds4,:b4],[:ds4,:b4],[:e4,:g4],:r,:e4,:r,:c4,:r,[:e3,:a3],:r]
#p2 b1-b8 end
rhp2n=rhp2na+[:fs3,:r,[:as5,:e5],[:b5,:e5],:r,[:b4,:fs5],[:b4,:g5],:r,[:ds5,:b4],[:e5,:b4],:r,\
              [:b4,:e4],[:c5,:e4],:r,[:gs4,:e4],[:a4,:e4],:r,[:fs4,:b4],[:fs4,:c5],:r,[:c5,:ds5],[:c5,:e5],:r,\
[:b4,:es5],[:b4,:fs5],:r,[:ds5,:as5],[:ds5,:b5],:r]+rhp2na+[:r,:b5,:as5,:a5,:g5,:fs5,:e5,:d5,:c5,:b4,:a4,:g4,:fs4,:e4,:d4,:r,\
                                                            [:fs5,:cs6],[:fs5,:d6],:r,[:a3,:c4,:d4],:r] #up to mid line3 page2
#p2 b1-b2 end 4th quaver
rhp2da=[q,q,qt,qt,qt,q,q,q,q,q,q,q,q]
#p2 b1-b8 end
rhp2d=rhp2da+[q,q]+[dsq,q-dsq,q]*9+rhp2da+[q]*16+[dsq,q-dsq,q,q,q]
#p2 b1-b2 end 4th quaver
lhp2na=[[:fs3,:b3],:r,[:fs3,:b3],[:fs3,:b3],[:fs3,:b3],[:e3,:b3],:r,[:c3,:g3,:a3],:r,[:a2,:e3,:g3],:r,[:fs2,:c3],:r]
#p2 b1-b8 end
lhp2n=lhp2na+[[:ds2,:b2],:b2,:cs3,:ds3,:e3,:fs3,:g3,:gs3,:a3,:b3,:c4,:b3,:a3,:g3,:fs3,:e3,:ds3,:cs3,:b2,:r]+lhp2na+ \
  [[:ds2,:b2,:fs3],:r,[:ds2,:fs2],:r,[:e2,:b2],:r,[:g2,:e3],:r,[:a2,:e2],:r,[:c3,:e3],:r,[:d3,:a3],:r,[:d3,:fs3,:a3],\
   [:c3,:c4],[:b2,:b3],[:a2,:a3],[:g2,:g3],[:fs2,:fs3]] #mid 3rd line p2
lhp2da=[q,q,qt,qt,qt,q,q,q,q,q,q,q,q] #same timings as rh
lhp2d=lhp2da+[q]*20+lhp2da+[q]*20

#p2 b9-b16 end
rhp2bn=[[:d4,:g4,:b4,:d5]]+rhn1a[1..-1]+[:fs4,:r,:d4,:b4,:r,:c5,:b4,:r,:a4,\
                                         :g4,:r,:fs4,:e4,:r,:g4,:fs4,:r,:e4,:ds4,:r,:a4,:g4,:r,:fs4,:e4,:r,:b4,\
                                         :c5,:r,:b4,:a4,:r,:g4,[:fs4,:a4,:d5],:a5,:b5,:c6,:cs6,:d6,:r]
rhp2bd=rhd1a+[q,sq,sq]*11+[q,dsq,dsq,dsq,dsq,q,q]
#p2 b9-b16 end
lhp2bn=[[:g2,:g3]]+lhn1a[1..-1]+[[:d2,:d3],[:fs1,:fs2],[:g1,:g2],[:fs1,:fs2],\
                                 [:g1,:g2],[:a1,:a2],[:as1,:as2],[:b1,:b2],[:c2,:c3],[:e1,:e2],[:a1,:a2],\
                                 [:as2,:as3],[:b1,:b2],[:c2,:c3],[:cs2,:cs3],[:ds2,:ds3],[:e2,:e3],[:g2,:g3],\
                                 [:a2,:a3],[:b2,:b3],[:c3,:c4],[:cs3,:cs4],[:d3,:d4],:r,[:d4,:fs4,:a4,:d5],:r]
lhp2bd=lhd1a+[q]*26

rhp2cn=rhn1a+rhn2a+[:r,:e5,:d5,:r,:fs5,[:d5,:g5],:r,:fs5,[:c5,:e5],:r,:fs5,[:b4,:d5,:g5],:r,:d6,:e6,:fs6,:g6,:r]
rhp2cd=rhd1a+rhd2a+[sq,sq,q]*4+[dsq]*4+[q,q]
lhp2cn=lhn1a+lhn2a+[[:e2,:e3],[:fs2,:fs3],[:d2,:d3],[:b1,:b2],:b2,:a2,[:d2,:d3],[:g2,:g3],:r,[:g4,:b4,:d5],:r]
lhp2cd=lhd1a+lhd2a+[q]*11

rhp3anbit=[:fs6,:e6,:d6,:c6,:b5,:b4,:b5,:b4,:b5,:c6,:b5,:c6,:a5,:a4,:a5,:a4,\
           :a5,:b5,:a5,:b5,:g5,:a5,:fs5,:g5,:e5,:fs5,:ds5,:fs5,[:e5,:g5],:g4,[:e5,:g5],:g4,\
           :fs5,:e5,:d5,:c5,:b4,:e4,:b4,:e4,:b4,:c5,:b4,:c5,:a4,:e4,:a4,:e4,:a4,:b4,:a4,:b4,\
           :g4,:a4,:fs4,:g4]
rhp3an=[:g6,:g5,:g6,:g5]+rhp3anbit+[:e4,:g4,:b4,:e5,:g5,:g6,:g6,:g5]+\
  rhp3anbit+[:e4,:fs4,:g4,:b4]
rhp3ad=[sq]*16*8
lhp3antop=[:e4,:d4,:cs4,:c4,:b3,:e3,:g3,:d4,:cs4,:c4,:b3,[:a3,:b3],:b3,:r]*2
lhp3anbot=[[:e3,:g3,:b3]]*6+[[:e3,:gs3,:b3]]*2+[[:e3,:a3]]*2+[[:e3,:fs3,:a3]]*2+\
  [[:e3,:g3]]*2+[[:e3,:fs3,:a3]]*2+[[:e2,:b2]]*4+[:e4]*11+[:r]
lhp3anbot=lhp3anbot*2
lhp3adtop=[md,c,c,c,m,m,c,c,c,c,q,q,q,q]*2
lhp3adbot=[q]*8*8

rn=rhn1+rhp2n+rhp2bn+rhp2cn #assemble parts to play for first two live_loops
rd=rhd1+rhp2d+rhp2bd+rhp2cd
ln=lhn1+lhp2n+lhp2bn+lhp2cn
ld=lhd1+lhp2d+lhp2bd+lhp2cd

####### start playing here ###############
#nb uncomment sustain and release parameters in first 2 and last 2 live_loops if you change the synth
live_loop :rh do
  play rn.tick#,sustain: 0.7*rd.look,release: 0.3*rd.look
  sleep rd.look
  stop if look==rd.length - 1
end
live_loop :lh do
  play ln.tick#,sustain: 0.7*ld.look,release: 0.3*ld.look
  sleep ld.look
  stop if look==ld.length - 1
end
sleep 40*4*c #delay following live_loops until first two complete (40 bars)

#intermediate section. Three parts play

live_loop :rhp3 do
  play rhp3an.tick,sustain: 0.7*rhp3ad.look,release: 0.3*rhp3ad.look
  sleep rhp3ad.look
  stop if look==rhp3ad.length - 1
end
live_loop :lhp3top do
  play lhp3antop.tick,sustain: 0.7*lhp3adtop.look,release: 0.3*lhp3adtop.look
  sleep lhp3adtop.look
  stop if look==lhp3adtop.length - 1
end
live_loop :lhp3bot do
  play lhp3anbot.tick,sustain: 0.7*lhp3adbot.look,release: 0.3*lhp3adbot.look
  sleep lhp3adbot.look
  stop if look==lhp3adbot.length - 1
end
sleep 8*4*c #delay reprise until intermediate loops have finished (8 bars)
#for reprise change ending chord
rn=rn[0..-6]+[[:g3,:d4,:g4],:r]
rd=rd[0..-7]+[q,q,q]
ln=ln[0..-3]+[[:g1,:d2,:g2],:r]

live_loop :rh2 do
  play rn.tick#,sustain: 0.7*rd.look,release: 0.3*rd.look
  sleep rd.look
  stop if look==rd.length - 1
end
live_loop :lh2 do
  play ln.tick#,sustain: 0.7*ld.look,release: 0.3*ld.look
  sleep ld.look
  stop if look==ld.length - 1
end