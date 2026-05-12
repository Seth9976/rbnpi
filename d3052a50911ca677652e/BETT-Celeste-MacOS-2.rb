#second half of program to play Tchaikovsy's Sugar Plum Fairy tune by Robin Newman (PART 2)
#run this part, then switch ws to first part and run that
sync :second
#re define variables required in this half
s=0
r=2**(1.0/12)
ir=1.0/r
define :setbpm do |n| #set bpm equivalent
  s = (1.0 / 8) *(60.0/n.to_f)
end
setbpm(57)
shift = 0 #set transpose if required
use_sample_pack "/Users/rbn/Desktop/samples/CEL"

#define note relative durations. Factor s sets the speed
dsq = 1 * s
sq = 2 * s
sqd = 3 * s
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
#now define note and duration arrays
#first for Celeste part
n1=[:g6,:e6,:g6,:fs6,:ds6,:e6,:d6,:d6,:d6,:cs6,:cs6,:cs6,:c6,:c6,:c6,:b5,:e6,:c6,:e6,:b5,:r]
d1=[sq,sq,q,q,q,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,sq,sq,q,c]
n2=[:b5,:e6,:b5,:a5,:fs5,:g5,:gs5,:gs5,:gs5,:g5,:g5,:g5,:fs5,:fs5,:fs5,:b5,:g5,:c6,:fs5,:b5,:r]
d2=[sq,sq,q,q,q,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,sq,sq,q,c]
n3=[:e5,:g5,:e5,:e5,:c5,:cs5,:f5,:f5,:f5,:e5,:e5,:e5,:ds5,:ds5,:ds5,:e5,:b4,:e5,:c5,:e5,:r]
d3=[sq,sq,q,q,q,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,sq,sq,q,c]
n4=[:e5,:b4,:e5,:c5,:a4,:as4,:b4,:b4,:b4,:as4,:as4,:as4,:a4,:a4,:a4,:g4,:b4,:b4,:c5,:g4,:r]
d4=[sq,sq,q,q,q,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,sq,sq,q,c]

n1.concat [:g5,:e5,:g5,:fs5,:c6,:b5,:g6,:g6,:g6,:f6,:f6,:f6,:e6,:e6,:e6,:ds6,:fs6,:e6,:fs6,:ds6,:r]
d1.concat [sq,sq,q,q,q,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,sq,sq,q,c]
n2.concat [:c5,:e5,:c5,:c5,:fs5,:g5,:cs6,:cs6,:cs6,:d6,:d6,:d6,:as5,:as5,:as5,:b5,:fs6,:as5,:fs6,:b5,:r]
d2.concat [sq,sq,q,q,q,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,sq,sq,q,c]
n3.concat [:r,:ds5,:e5,:as5,:as5,:as5,:gs5,:gs5,:gs5,:fs5,:fs5,:fs5,:fs5,:r,:r,:r,:fs5,:r]
d3.concat [cd,q,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,sq,sq,q,c]
n4.concat [:e4,:g4,:e4,:ds4,:a4,:g4,:e5,:e5,:e5,:d5,:d5,:d5,:cs5,:cs5,:cs5,:b4,:ds5,:fs5,:fs4,:b4,:r]
d4.concat [sq,sq,q,q,q,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,sq,sq,q,c]
n2b=[:r,:fs5,:fs5,:fs5]
d2b=[cd+5*m,sq,sq,q]
n3b=[:r,:d5,:d5,:d5]
d3b=[cd+5*m,sq,sq,q]

n1.concat [:g6,:e6,:g6,:fs6,:ds6,:e6,:d6,:d6,:d6,:cs6,:cs6,:cs6,:c6,:c6,:c6,:b5,:e6,:c6,:e6,:b5,:r]
d1.concat [sq,sq,q,q,q,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,sq,sq,q,c]
n2.concat [:b5,:e6,:b5,:a5,:fs5,:g5,:gs5,:gs5,:gs5,:g5,:g5,:g5,:fs5,:fs5,:fs5,:b5,:g5,:c6,:fs5,:b5,:r]
d2.concat [sq,sq,q,q,q,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,sq,sq,q,c]
n3.concat [:e5,:g5,:e5,:e5,:c5,:cs5,:f5,:f5,:f5,:e5,:e5,:e5,:ds5,:ds5,:ds5,:e5,:b4,:e5,:c5,:e5,:r]
d3.concat [sq,sq,q,q,q,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,sq,sq,q,c]
n4.concat [:e5,:b4,:e5,:c5,:a4,:as4,:b4,:b4,:b4,:as4,:as4,:as4,:a4,:a4,:a4,:g4,:b4,:b4,:c5,:g4,:r]
d4.concat [sq,sq,q,q,q,q,sq,sq,q,sq,sq,q,sq,sq,q,sq,sq,sq,sq,q,c]

n1.concat [:e6,:cs6,:e6,:ds6,:r,:d6,:b5,:d6,:cs6,:r,:c6,:a5,:c6,:b5,:r,:b5,:ds6,:fs6,:b6,:e6,:r]
d1.concat [sq,sq,q,q,q,sq,sq,q,q,q,sq,sq,q,q,q,dsq,dsq,dsq,dsq,q,q]
n2.concat [:as5,:fs5,:as5,:b5,:r,:gs5,:e5,:gs5,:a5,:r,:fs5,:d5,:fs5,:g5,:r,:b5,:r]
d2.concat [sq,sq,q,q,q,sq,sq,q,q,q,sq,sq,q,q,c,q,q]
n3.concat [:cs5,:e5,:cs5,:fs5,:r,:b4,:d5,:b4,:e5,:r,:a4,:c5,:a4,:d5,:r,:a5,:fs5,:ds5,:b4,:g5,:r]
d3.concat [sq,sq,q,q,q,sq,sq,q,q,q,sq,sq,q,q,q,dsq,dsq,dsq,dsq,q,q]
n4.concat [:fs4,:as4,:fs4,:b4,:r,:e4,:gs4,:e4,:a4,:r,:d4,:fs4,:d4,:g4,:r,:e5,:r]
d4.concat [sq,sq,q,q,q,sq,sq,q,q,q,sq,sq,q,q,c,q,q]
#now for strings parts
nv1 = [:r,:e4,:r,:fs4,:r,:g4,:r,:ds4,:r,:e4,:r,:fs4,:r,:g4,:r,:ds4,:r,:e4,:r,:fs4,:r,:g4,:r,:gs4,:r,:as4,:r,:c5,:b4,:c5,:b4,:r]
dv1=[q]*4*8
nv2=[:r,:b3,:r,:c4,:r,:cs4,:r,:c4,:r,:b3,:r,:c4,:r,:cs4,:r,:c4,:r,:b3,:r,:c4,:r,:cs4,:r,:d4,:r,:e4,:r,:fs4,:g4,:fs4,:g4,:r]
dv2=[q]*4*8
nb1= [:e3,:r,:e3,:r,:e3,:r,:e3,:r,:e3,:r,:e3,:r,:e3,:r,:e3,:r,:e3,:r,:e3,:r,:e3,:r,:e3,:r,:e3,:r,:e3,:r,:e4,:e4,:e4,:r]
db1= [q]*4*8
nv1.concat [:r,:c4,:r,:ds4,:r,:e4,:r,:e4,:r,:d4,:r,:e4,:ds4,:e4,:ds4,:r,:r,:e4,:r,:fs4,:r,:g4,:r,:gs4,:r,:as4,:r,:c5,:b4,:c5,:b4,:r]
dv1.concat [q]*4*8
nv2.concat [:r,:g3,:r,:c4,:r,:b3,:r,:as3,:r,:fs4,:r,:fs4,:fs4,:fs4,:fs4,:r,:r,:b3,:r,:c4,:r,:cs4,:r,:d4,:r,:e4,:r,:fs4,:g4,:fs4,:g4,:r]
dv2.concat [q]*4*8
nb1.concat [:as2,:r,:a2,:r,:g2,:r,:fs2,:r,:fs3,:r,:fs2,:r,:b2,:c3,:b2,:r,:e3,:r,:e3,:r,:e3,:r,:e3,:r,:e3,:r,:e3,:r,:e4,:e4,:e4,:r,:e2]
db1.concat [q]*31+[q+3*m+cd,q]
#arco strings parts: use extra l in note symbols to differentiate them in the strings samples array
nlv1=[:r,:lfs4,:lfs5,:lfs4,:r,:le4,:le5,:le4,:r,:ld4,:ld5,:ld4,:lds5,:lds4,:le5,:r]
dlv1=[16*m+q]+[q]*15

#===================== now start playing ==========================
uncomment do #for testing. Normally leave uncommented
  #play bass clarinet and clarinet parts with pulse synth
  with_synth :pulse do
    in_thread do #bass clarinet
      sleep 7*m+cd
      pln([:e3,:d3,:c3,:b2,:as2,:a2,:g2,:fs2],[dsq,dsq,dsq,dsq,c,c,c,cd]) #bass cl 1
      sleep 3*c
      pln([:b2,:a2,:g2,:fs2,:e2],[dsq,dsq,dsq,dsq,3*m+cd]) #bass cl 2
      #clarinet 1 part follows straight on
      pln([:g5,:fs5,:e5,:d5,:cs5,:ds5],[dsq,dsq,dsq,dsq,cd,sq]) #cl 1 a
      sleep sq+cd
      pln([:e5,:d5,:cs5,:b4,:a4,:g4,:r,:a5,:g5,:r],[dsq,dsq,dsq,dsq,cd,sq,sq+q,q,q,q]) #cl 1 b
    end

    in_thread do #second clarinet part
      sleep 16*m+cd #from start
      pln([:fs5,:e5,:ds5,:cs5,:b4,:c5,:r],[dsq,dsq,dsq,dsq,cd,sq,sq+cd]) #cl 2 a
      pln([:d5,:c5,:b4,:a4,:g4,:r,:a4,:g4,:r],[dsq,dsq,dsq,dsq,sq,sq,q,q,q]) #cl 2 b
    end
  end
end

#play pizzicato string parts
in_thread do
  plarraypiz(nv1,dv1)
end
in_thread do
  plarraypiz(nv2,dv2)
end
in_thread do
  plarraypiz(nb1,db1)
end
#play arco string part
in_thread do
  plarraypiz(nlv1,dlv1)
end

uncomment do #for testing purposes. Normally leave uncommented
  #play celeste parts
  sleep 4*m+q
  in_thread do
    plarray(n1,d1)
  end
  in_thread do
    plarray(n2,d2)
  end
  in_thread do
    plarray(n3,d3)
  end
  in_thread do
    plarray(n2b,d2b)
  end
  in_thread do
    plarray(n3b,d3b)
  end
  plarray(n4,d4)
end