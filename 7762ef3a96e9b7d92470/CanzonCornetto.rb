#Canzon Coronetto by Samuel Scheidt1621, arranged for Sonic Pi by Robin Newman, May 2015
#based on Anton Hoger score for 4 guitars (licence imslp.org/wiki/IMSLP.Creative_Commons_Attribution_NonCommercial_4.0)
# http://javanese.imslp.info/files/imglnks/usimg/7/70/IMSLP336107-PMLP439715-_Scheidt__Samuel_-_Canzon_cornetto_-4Git.pdf
#voiced for 4 trumpets, transposed down 4 semitones.
#needs Pi. Too long for Mac
use_debug false
use_sample_pack_as '/home/pi/samples/Cornetto',:cornetto #adjust location as necessary

#first deal with selecting and setting up the samples
inst0=:cornetto__trumpet_cs5
samplepitch0=:cs5

load_samples [inst0]

s=0 #note duration scale factor


define :pl do |inst,samplepitch,nv,dv,vol=1,pan=0| #plays a sample note
  shift=note(nv)-note(samplepitch)
  sample inst,rate: (pitch_ratio shift),sustain: 0.8*dv,release: 0.2*dv,amp: vol,pan: pan
end

define :plarray do |inst,samplepitch,narray,darray,shift=0,vol=1,pan=0| #plays note/duration arrays
  narray.zip(darray) do |nv,dv|
    if nv != :r
      pl(inst,samplepitch,note(nv)+shift,dv*s,vol,pan)
    end
    sleep dv*s
  end
end

define :set_bpm do |n| #sets value of s according to desired bpm
  s=1.0/8*60/n.to_f
end

#relative note durations (not all used)
dsq = 1.0
sq = 2
sqd = 3
q = 4
qd = 6
c = 8
cd = 12
m = 16
md = 24
b = 32
bd = 48
sf=1.5
#dynamic settings 
p=0.06*sf
mp=0.2*sf
mf=0.5*sf
f=1.0*sf
ff=1.3*sf
levlookup=[[p,"p"],[mp,"mp"],[mf,"mf"],[f,"f"],[ff,"ff"]] #allows printing in plct function

define :ct do |ptr,lev,slid=0,timetonext=0,s,flag| #controls level
  control ptr,amp: lev,amp_slide: slid*s #times scalefactor for tempo
  if flag > 0 then #lets you print level variations
    puts "All parts Level change:"
    puts "level "+levlookup.assoc(lev)[1]
    puts "slide time "+ (slid*s).to_s
    puts " " #blank line
  end
  sleep timetonext*s #scale for tempo
end

define :plct do |pt,am,amsl,amd,s,flag=0| #controls level using values in three arrays
  #params pt control pointer,am amp level,amsl amp_slide:,amd delay to next command,s tempo scale factor,flag to print info
  am.zip(amsl,amd) do |amv,amslv,amdv|
    ct(pt,amv,amslv,amdv,s,flag)
  end
end

define :len do |d| #calcuates duration of a part or level control array
  tl=0
  d.each do |d|
    tl += d
  end
  return tl
end
#set up the part lists
n1=[:a5,:a5,:a5,:fs5,:d5,:e5,:fs5,:g5,:a5,:fs5,:b5,:g5,:a5,:fs5,:g5,:e5,:fs5,:d5,:e5,:d5,:e5,:d5]
d1=[c,q,q,q,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,q,c,b]
n1.concat [:r,:fs5,:d5,:e5,:cs5,:d5,:b4,:cs5,:d5,:cs5,:d5,:cs5,:d5,:e5,:cs5,:d5,:b4,:cs5,:a4,:b4,:cs5,:d5,:cs5,:d5,:a5]
d1.concat [q,sq,sq,sq,sq,sq,sq,q,c,q,cd,q,sq,sq,sq,sq,sq,sq,sq,sq,q,c,q,c,c]
#b7
n1.concat [:a5,:r,:a5,:a5,:a5,:a5,:b5,:g5,:a5,:fs5,:g5,:e5,:fs5,:gs5,:a5,:gs5,:a5,:a4,:d4,:a4]
d1.concat [m,b+q,q,q,q,sq,sq,sq,sq,sq,sq,sq,sq,q,c,q,cd,q,cd,q]
n1.concat [:e4,:a4,:fs5,:fs5,:fs5,:a5,:fs5,:g5,:fs5,:b5,:a5]
d1.concat [m,q,q,q,q,cd,q,q,q,q,q]
#b13
n1.concat [:a5,:r,:a5,:a5,:a5,:fs5,:r,:d5,:e5,:fs5,:g5,:a5,:fs5,:b5,:a5,:r]
d1.concat [m,q,q,q,q,m,q,sq,sq,sq,sq,sq,sq,c,c,m]
n1.concat [:r,:d5,:e5,:fs5,:g5,:a5,:fs5,:b5,:a5,:r,:a4,:b4,:cs5,:d5,:e5,:cs5]
d1.concat [q,sq,sq,sq,sq,sq,sq,c,c,bd+q,sq,sq,sq,sq,sq,sq]
#b19
n1.concat [:fs5,:d5,:e5,:cs5,:d5,:b4,:cs5,:a4,:b4,:a4,:b4,:a4,:e5,:fs5,:g5,:a5,:b5,:g5,:c6,:a5,:b5,:g5,:a5,:fs5,:g5,:e5,:fs5,:e5,:fs5,:e5,:r]
d1.concat [sq,sq,sq,sq,sq,sq,sq,sq,q,q,c,q,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,q,c,c,c]
n1.concat [:r,:d5,:e5,:fs5,:g5,:a5,:fs5,:b5,:g5,:a5,:fs5,:g5,:e5,:fs5,:d5,:e5,:d5,:e5,:d5,:r,:a5,:a5,:a5,:a5,:a5,:a5,:r,:a5,:a5,:a5,:a5,:a5]
d1.concat [b+q,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,q,c,c,q,q,sq,sq,sq,sq,c,q,q,sq,sq,sq,sq]
#b26
n1.concat [:a5,:r,:b5,:b5,:b5,:b5,:b5,:b5,:r,:b5,:b5,:b5,:b5,:b5,:b5,:r,:as5,:as5,:as5,:as5,:as5,:as5,:r,:b5,:b5,:e5,:a5,:a5,:a5]
d1.concat [c,q,q,sq,sq,sq,sq,c,q,q,sq,sq,sq,sq,c,q,q,sq,sq,sq,sq,c,q,q,c,q,q,c,m]
n1.concat [:r,:a5,:a5,:g5,:fs5,:e5,:r,:a5,:a5,:g5,:fs5,:e5,:d5,:cs5,:d5,:d5,:d5,:c5,:b4,:a4,:d5,:d5,:d5,:c5,:b4,:a4,:g4,:fs4]
d1.concat [sq,sq,sq,sq,q,q,sq,sq,sq,sq,q,c,c,q,sq,sq,sq,sq,q,q,sq,sq,sq,sq,q,c,c,q]
#b33
n1.concat [:g4,:r,:a5,:g5,:fs5,:fs5,:e5,:d5,:r,:g5,:fs5,:e5,:r,:a5,:g5,:fs5]
d1.concat [c,b+md+q,sq,sq,q,sq,sq,m,q,sq,sq,c,q,sq,sq,c]
n1.concat [:r,:b5,:a5,:g5,:a5,:g5,:fs5,:e5,:fs5,:gs5,:a5,:gs5,:a5,:a5,:b5,:a5,:fs5,:d5,:e5,:fs5,:g5,:a5,:a5,:a5,:g5,:fs5,:r]
d1.concat [q,sq,sq,c,q,sq,sq,q,q,q,c,q,c,m,c,m,q,dsq,dsq,dsq,dsq,sq,sq,sq,sq,c,c]
#b41
n1.concat [:r,:e5,:fs5,:g5,:a5,:b5,:b5,:b5,:a5,:gs5,:r,:b4,:cs5,:d5,:e5,:fs5,:fs5,:fs5,:e5,:ds5,:r]
d1.concat [q,dsq,dsq,dsq,dsq,sq,sq,sq,sq,c,cd,dsq,dsq,dsq,dsq,sq,sq,sq,sq,c,c]
n1.concat [:r,:d5,:e5,:fs5,:g5,:a5,:a5,:a5,:g5,:fs5,:r,:a5,:g5,:fs5,:e5,:d5,:cs5,:fs5,:g5,:a5,:fs5,:gs5,:a5,:b5,:gs5,:as5,:b5,:a5]
d1.concat [q,dsq,dsq,dsq,dsq,sq,sq,sq,sq,c,cd,c,c,c,c,c,q,q,q,q,q,q,q,q,q,q,c,c] #q over
#b47 +q
n1.concat [:g5,:fs5,:gs5,:a5,:g5,:fs5,:e5,:d5,:r]
d1.concat [q,c,q,c,c,q,c,m,b*2]
n1.concat [:r,:b5,:a5,:g5,:fs5,:e5,:d5,:cs5,:b4,:a4,:r,:d5,:e5,:a4,:d5,:cs5,:b4,:g5] #+ q
d1.concat [c,cd,c,c,c,c,c,q,c,c,cd,q,c,q,c,q,q,c] #+ q
#b55 +q
n1.concat [:fs5,:e5,:d5,:r,:fs5,:d5,:e5,:cs5,:d5,:b4,:cs5,:d5,:cs5,:d5,:cs5,:d5,:e5,:cs5,:d5,:b4,:cs5,:a4,:b4,:cs5,:d5,:cs5]
d1.concat [q,c,b,q,sq,sq,sq,sq,sq,sq,q,c,q,cd,q,sq,sq,sq,sq,sq,sq,sq,sq,q,c,q]
n1.concat [:d5,:a5,:a5,:r,:a5,:a5,:a5,:a5,:b5,:g5,:a5,:fs5,:g5,:e5,:fs5]
d1.concat [c,c,m,b+q,q,q,q,sq,sq,sq,sq,sq,sq,sq,sq]
#b62
n1.concat [:gs5,:a5,:gs5,:a5,:a4,:d4,:a4,:e4,:a4,:r,:fs5,:fs5,:fs5,:a5,:fs5]
d1.concat [q,c,q,cd,q,cd,q,m,sqd,dsq,q,q,q,cd,q]
n1.concat [:g5,:fs5,:b5,:a5,:a5,:fs5,:r,:a5,:a5,:a5,:fs5,:d5,:e5,:fs5,:g5,:a5,:fs5,:b5,:g5,:a5,:fs5,:g5,:e5,:fs5,:d5,:e5,:d5,:e5,:fs5]
d1.concat [q,q,q,q,m,sqd,dsq,q,q,q,q,sq,sq,sq,sq,sq,sq,sq*1.1,sq*1.1,sq*1.2,sq*1.2,sq*1.3,sq*1.3,sq*1.4,sq*1.4,q*1.5,q*1.6,q*1.7+q*1.8,b*1.3]
#end

n2=[:r,:a5,:a5,:a5,:fs5,:d5,:e5,:fs5,:g5,:a5,:fs5,:b5,:g5,:a5,:fs5,:g5,:e5,:fs5,:d5,:e5,:d5,:e5]
d2=[2*b,c,q,q,q,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,q,c]
n2.concat [:d5,:fs5,:g5,:a5,:fs5,:g5,:e5,:fs5,:d5,:e5,:cs5,:d5,:g5,:fs5,:g5,:fs5]
d2.concat [q,sq,sq,c,sq,sq,sq,sq,sq,sq,sq,sq,q,q,c,m]
#b7
n2.concat [:e5,:r,:e5,:e5,:e5,:cs5,:a4,:b4,:cs5,:d5,:e5,:cs5,:fs5,:d5,:e5,:cs5,:d5,:b4,:cs5,:a4,:b4,:a4,:b4]
d2.concat [m,m,c,q,q,q,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,q,c]
n2.concat [:a4,:a5,:a5,:a5,:a5,:b5,:g5,:a5,:fs5,:g5,:e5,:fs5,:gs5,:a5,:gs5,:a5,:a5,:a5,:a5,:fs5,:d5,:e5,:fs5,:g5,:a5,:fs5,:b5,:g5,:a5,:fs5,:g5,:e5,:fs5,:d5]
d2.concat [q,q,q,q,sq,sq,sq,sq,sq,sq,sq,sq,q,c,q,q,q,q,q,q,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq]
#b13
n2.concat [:e5,:d5,:e5,:d5,:r,:a5,:a5,:a5,:fs5,:r,:d5,:e5,:fs5,:g5,:a5,:fs5,:b5,:a5]
d2.concat [q,q,c,m,q,q,q,q,m,q,sq,sq,sq,sq,sq,sq,c,c]
n2.concat [:g5,:a5,:r,:d5,:e5,:fs5,:g5,:a5,:fs5,:b5,:g5,:a5,:fs5,:g5,:e5,:fs5,:d5,:e5,:d5,:e5,:d5,:e5]
d2.concat [c,c,m+q,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,q,c,c,c]
#b19
n2.concat [:d5,:cs5,:b4,:a4,:gs4,:a4,:gs4,:a4,:b4,:e5,:e5,:fs5,:d5,:e5,:cs5,:d5,:b4,:cs5,:ds5,:e5,:ds5,:e5,:r]
d2.concat [q,q,q,q,q,c,q,c,q,q,sq,sq,sq,sq,sq,sq,sq,sq,q,c,q,c,c]
n2.concat [:r,:b4,:fs4,:b4,:b5,:a5,:a5,:g5,:fs5,:b5,:a5,:a5,:a5,:r,:fs5,:fs5,:fs5,:fs5,:fs5,:fs5,:r,:e5,:e5,:e5,:e5,:e5]
d2.concat [cd,q,m,q,q,qd,sq,q,q,q,q,m,c,q,q,sq,sq,sq,sq,c,q,q,sq,sq,sq,sq]
#b26
n2.concat [:e5,:r,:g5,:g5,:g5,:g5,:g5,:g5,:r,:fs5,:fs5,:fs5,:fs5,:fs5,:fs5,:r,:fs5,:fs5,:fs5,:fs5,:fs5,:fs5,:r,:fs5,:g5,:g5,:fs5,:e5,:fs5]
d2.concat [c,q,q,sq,sq,sq,sq,c,q,q,sq,sq,sq,sq,c,q,q,sq,sq,sq,sq,c,q,q,c,q,q,c,m]
n2.concat [:r,:a5,:a5,:g5,:fs5,:e5,:r,:a5,:a5,:g5,:fs5,:e5,:r,:d5,:d5,:c5,:b4,:a4,:r,:d5,:d5,:c5,:b4,:a4]
d2.concat [c+sq,sq,sq,sq,q,q,sq,sq,sq,sq,c,c,c+sq,sq,sq,sq,q,q,sq,sq,sq,sq,c,c]
#b33
n2.concat [:g4,:d5,:c5,:b4,:r,:e5,:d5,:cs5,:r,:fs5,:e5,:d5,:r,:g5,:fs5,:e5,:d5,:r,:a5,:g5,:fs5,:g5,:r]
d2.concat [q,sq,sq,c,q,sq,sq,c,q,sq,sq,c,q,sq,sq,c,c,q,sq,sq,c,c,b]
n2.concat [:r,:e5,:e5,:a5,:b5,:c6,:b5,:a5,:e5,:fs5,:g5,:fs5,:e5,:d5,:d5,:d5,:cs5,:d5,:r]
d2.concat [cd,q,c,c,q,q,c,c,c,c,cd,q,c,q,q,q,q,c,c]
#b41
n2.concat [:r,:e5,:ds5,:e5,:r,:b4,:as4,:b4,:r]
d2.concat [q,q,c,c,cd,q,c,c,c]
n2.concat [:r,:d5,:cs5,:d5,:fs5,:e5,:d5,:fs5,:e5,:d5,:cs5,:b4,:a4,:a4,:d5,:cs5,:b4,:e5,:d5,:cs5,:fs5]
d2.concat [q,q,c,q,q,c,q,c,c,c,sq,sq,m,c,cd,q,q,c,q,q,q]
#b47
n2.concat [:ds5,:e5,:d5,:cs5,:b4,:e5,:d5,:c5,:b4,:a4,:d5,:cs5,:b4,:e5,:d5,:cs5,:fs5,:e5,:d5,:g5,:fs5,:e5,:a5]
d2.concat [q,c,c,q,q,c,c,c,q,q,c,q,q,c,q,q,c,q,q,c,q,q,c]
n2.concat [:g5,:fs5,:e5,:d5,:cs5,:b4,:a4,:a4,:e5,:d5,:e5,:a4,:g4,:fs4,:b4,:a4,:b4,:e5] #+q
d2.concat [q,c,c,c,c,c,q,q,m,c,c,c,c,c,q,q,q,c]
#b55+q
n2.concat [:d5,:cs5,:d5,:a5,:a5,:a5,:fs5,:d5,:e5,:fs5,:g5,:a5,:fs5,:b5,:g5,:a5,:fs5,:g5,:e5,:fs5,:d5,:e5,:d5,:e5,:d5,:fs5,:g5,:a5,:fs5,:g5,:e5,:fs5,:d5,:e5,:cs5,:d5,:g5,:fs5,:g5]
d2.concat [c,q,q,q,q,q,q,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,q,c,q,sq,sq,c,sq,sq,sq,sq,sq,sq,sq,sq,q,q,c]
n2.concat [:fs5,:e5,:r,:e5,:e5,:e5,:cs5,:a4,:b4,:cs5,:d5,:e5,:cs5,:fs5,:d5,:e5,:cs5,:d5,:b4,:cs5,:a4]
d2.concat [m,m,m+q,q,q,q,q,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq]
#b62
n2.concat [:b4,:a4,:b4,:a4,:a5,:a5,:a5,:a5,:b5,:g5,:a5,:fs5,:g5,:e5,:fs5,:gs5,:a5,:gs5,:a5,:r,:a5,:a5,:a5,:fs5,:d5,:e5,:fs5,:g5,:a5,:fs5]
d2.concat [q,q,c,q,q,q,q,sq,sq,sq,sq,sq,sq,sq,sq,q,c,q,sqd,dsq,q,q,q,q,sq,sq,sq,sq,sq,sq]
n2.concat [:b5,:g5,:a5,:fs5,:g5,:e5,:fs5,:d5,:e5,:d5,:e5,:d5,:r,:fs5,:fs5,:fs5,:a5,:fs5,:g5,:fs5,:b5,:a5,:a5,:a5]
d2.concat [sq,sq,sq,sq,sq,sq,sq,sq,q,q,c,sqd,dsq,q,q,q,cd,q,q*1.1,q*1.2,q*1.3,q*1.4,q*1.5+q*1.6+q*1.7+q*1.8,b*1.3]
#end

n3=[:r,:d5,:d5,:d5]
d3=[b*5+m,c,q,q]
#b7
n3.concat [:cs5,:a5,:b5,:cs5,:d5,:e5,:cs5,:fs5,:d5,:e5,:cs5,:d5,:b4,:cs5,:a4,:b4,:a4,:b4,:a4,:d4,:a4,:e4]
d3.concat [q,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,q,c,m,cd,q,m]
n3.concat [:a4,:r,:d5,:d5,:d5,:d5,:fs5,:e5,:d5,:d5,:d5,:d5]
d3.concat [m,b+q,q,q,q,q,sq,sq,q,q,cd,q]
#b13
n3.concat [:cs5,:d5,:cs5,:d5,:fs5,:d5,:a4,:g4,:a4,:r,:d4,:e4,:fs4,:g4,:a4,:fs4]
d3.concat [q,c,q,c,c,md,c,c,c,q,sq,sq,sq,sq,sq,sq]
n3.concat [:b4,:a4,:g4,:fs4,:g4,:a4,:b4,:cs5,:a4,:d5,:cs5,:d5,:r,:cs5,:d5,:b4,:cs5,:d5,:cs5,:d5,:a4]
d3.concat [c,c,q,sq,sq,sq,sq,sq,sq,c,c,c,sq,sq,sq,sq,q,c,q,c,c]
#b19
n3.concat [:r,:a4,:e4,:a4,:r,:b4,:cs5,:d5,:e5,:fs5,:d5]
d3.concat [cd,q,m,c,b+cd,sq,sq,sq,sq,sq,sq]
n3.concat [:g5,:e5,:fs5,:d5,:e5,:cs5,:d5,:b4,:cs5,:b4,:cs5,:b4,:b4,:cs5,:d5,:d5,:d5,:d5,:d5,:cs5,:d5,:cs5,:d5,:r,:d5,:d5,:d5,:d5,:d5,:d5,:r,:cs5,:cs5,:cs5,:cs5,:cs5]
d3.concat [sq,sq,sq,sq,sq,sq,sq,sq,q,q,c,q,q,qd,sq,q,q,q,q,q,c,q,c,q,q,sq,sq,sq,sq,c,q,q,sq,sq,sq,sq]
#b26
n3.concat [:cs5,:r,:e5,:e5,:e5,:e5,:e5,:e5,:r,:d5,:d5,:d5,:d5,:d5,:d5,:r,:cs5,:cs5,:cs5,:cs5,:cs5,:cs5,:r,:b4,:b4,:cs5,:d5,:cs5,:d5]
d3.concat [c,q,q,sq,sq,sq,sq,c,q,q,sq,sq,sq,sq,c,q,q,sq,sq,sq,sq,c,q,q,c,q,c,q,m]
n3.concat [:cs5,:cs5,:d5,:e5,:a4,:a4,:fs4,:fs4,:fs4,:g4,:a4,:d5,:c5]
d3.concat [m,m+q,q,q,q,c,c,m,q,q,q,sq,sq]
#b33
n3.concat [:b4,:r,:e5,:d5,:cs5,:r,:fs5,:e5,:d5,:r,:g5,:fs5,:e5,:r,:a5,:g5,:fs5,:r,:d5,:cs5,:b4,:r,:e5,:d5,:cs5,:r,:fs5,:e5,:d5]
d3.concat [c,q,sq,sq,c,q,sq,sq,c,q,sq,sq,c,q,sq,sq,c,c+q,sq,sq,c,q,sq,sq,c,q,sq,sq,c]
n3.concat [:r,:g5,:fs5,:e5,:c5,:b4,:c5,:e5,:e5,:cs5,:d5,:d5,:cs5,:d5,:cs5,:d5,:r,:d4,:e4,:fs4,:g4,:a4,:a4,:a4,:g4]
d3.concat [q,sq,sq,c,q,q,c,m,cd,q,c,c,q,c,q,c,cd,dsq,dsq,dsq,dsq,sq,sq,sq,sq]
#b41
n3.concat [:fs4,:r,:e4,:fs4,:g4,:a4,:b4,:b4,:b4,:a4,:gs4,:r,:b4,:cs5,:d5,:e5,:fs5,:fs5,:fs5,:e5]
d3.concat [c,cd,dsq,dsq,dsq,dsq,sq,sq,sq,sq,c,cd,dsq,dsq,dsq,dsq,sq,sq,sq,sq]
n3.concat [:ds5,:b4,:a4,:d4,:d5,:cs5,:d5,:cs5,:a4,:g4,:g5,:fs5,:e5,:d5,:fs5,:b4,:a4,:gs4,:cs5,:b4,:cs5]
d3.concat [q,q,c,q,q,c,c,c,c,q,c,q,c,c,c,q,q,q,c,q,c]
#b47
n3.concat [:b4,:b4,:a4,:b4,:cs5,:d5,:e5,:a4,:fs4,:g4,:fs4,:gs4,:a4,:gs4,:as4,:b4,:as4,:b4,:c5,:b4,:cs5,:d5,:cs5]
d3.concat [c,cd,q,c,q,q,q,q,q,c,q,q,c,q,q,c,q,q,c,q,q,c,q]
n3.concat [:ds5,:e5,:d5,:cs5,:b4,:a4,:g4,:fs4,:gs4,:a4,:g4,:fs4,:e4,:d4,:cs4,:d4,:a4,:gs4,:a4,:gs4,:b4]
d3.concat [q,c,c,c,c,c,c,q,q,c,c,c,c,c,q,q,q,q,q,q,q]
#b55
n3.concat [:cs5,:d5,:e5,:a4,:a4,:r]
d3.concat [q,q,q,q,b,2*b+m]
n3.concat [:d5,:d5,:d5,:cs5,:a4,:b4,:cs5,:d5,:e5,:cs5,:fs5,:d5,:e5,:cs5,:d5,:b4,:cs5,:a4,:b4,:a4,:b4,:a4,:d4,:a4]
d3.concat [c,q,q,q,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,q,c,m,cd,q]
#b62
n3.concat [:e4,:a4,:r,:d4,:d4,:d4,:d4]
d3.concat [m,m,b+q,q,q,q,m]
n3.concat [:g4,:d4,:g4,:d4,:a4,:d4,:r,:d5,:d5,:d5,:d5,:fs5,:e5,:d5,:d5,:d5,:d5,:cs5,:d5,:cs5,:d5]
d3.concat [q,q,q,q,m,sqd,dsq,q,q,q,q,sq,sq,q,q,q*1.1+q*1.2+q*1.3,q*1.4,q*1.5,q*1.6+q*1.7,q*1.8,b*1.3]
#end

n4=[:r,:a4,:a4,:a4,:fs4,:d4,:e4,:fs4,:g4,:a4,:fs4,:b4,:g4,:a4,:fs4,:g4,:e4,:fs4,:d4,:e4,:d4,:e4,:d4]
d4=[3*b+m,c,q,q,q,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,q,c,m]
#b7
n4.concat [:a3,:r,:cs5,:a4,:b4,:gs4,:a4,:fs4,:gs4,:a4,:gs4,:a4,:r,:e5,:e5,:e5]
d4.concat [m,q,sq,sq,sq,sq,sq,sq,q,c,q,m,m+q,q,q,q]
n4.concat [:cs5,:a4,:b4,:cs5,:d5,:e5,:cs5,:fs5,:d5,:e5,:cs5,:d5,:b4,:cs5,:a4,:b4,:a4,:b4,:a4,:d4,:d4,:d4,:d4,:g4,:d4,:g3,:d4]
d4.concat [q,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,q,c,q,q,q,q,m,q,q,q,q]
#b13
n4.concat [:a3,:d4,:d4,:g3,:d4,:b3,:cs4,:d4]
d4.concat [m,m,b,c,c,qd,sq,c]
n4.concat [:g4,:d4,:g4,:d4,:e4,:fs4,:g4,:a4,:fs4,:b4,:a4,:g4,:fs4,:e4,:d4,:a3,:d4,:r]
d4.concat [c,c,q,sq,sq,sq,sq,sq,sq,c,c,q,q,q,q,m,c,c]
#b19
n4.concat [:r,:e4,:a4,:g4,:fs4,:e4,:b4,:e4,:b4]
d4.concat [b+c,c,q,q,q,q,m,c,c]
n4.concat [:e5,:cs5,:d5,:b4,:cs5,:b4,:as4,:b4,:as4,:b4,:fs4,:g4,:d4,:g3,:d4,:a3,:d4,:r,:d4,:d4,:d4,:d4,:d4,:d4,:r,:a4,:a4,:a4,:a4,:a4]
d4.concat [sq,sq,sq,sq,q,q,q,c,q,c,c,q,q,q,q,m,c,q,q,sq,sq,sq,sq,c,q,q,sq,sq,sq,sq]
#b26
n4.concat [:a4,:r,:e4,:e4,:e4,:e4,:e4,:e4,:r,:b4,:b4,:b4,:b4,:b4,:b4,:r,:fs4,:fs4,:fs4,:fs4,:fs4,:fs4,:r,:ds4,:e4,:a3,:d4]
d4.concat [c,q,q,sq,sq,sq,sq,c,q,q,sq,sq,sq,sq,c,q,q,sq,sq,sq,sq,c,q,q,c,m,m]
n4.concat [:a4,:a4,:d4,:d4]
d4.concat [m,b,m,b]
#b33
n4.concat [:g4,:gs4,:a4,:as4,:b4,:b4,:c5,:cs5,:d,:r,:g4,:fs4,:e4,:r,:a4,:g4,:fs4,:r,:b4,:a4]
d4.concat [c,c,c,c,c,c,c,c,m,cd,sq,sq,c,q,sq,sq,c,q,sq,sq]
n4.concat [:g4,:r,:c5,:b4,:a4,:e4,:a3,:a4,:d4,:e4,:fs4,:d4,:g4,:a4,:b4,:g4,:a4,:d4,:r,:d4,:cs4]
d4.concat [c,q,sq,sq,m,m,cd,q,sq,sq,sq,sq,sq,sq,sq,sq,m,c,cd,q,c]
#b41
n4.concat [:d4,:r,:e4,:ds4,:e4,:r,:b4,:as4]
d4.concat [c,cd,q,c,c,cd,q,c]
n4.concat [:b4,:r,:d4,:e4,:fs4,:g4,:a4,:fs4,:g4,:a4,:d4,:e4,:fs4,:g4,:a4,:d4,:e4,:fs4]
d4.concat [c,cd,dsq,dsq,dsq,dsq,sq,sq,sq,sq,c,c,c,c,m,m,m,m]
#b47
n4.concat [:b3,:e3,:a3,:d4,:e4,:fs4,:g4,:a4]
d4.concat [m,m,m,m,m,m,m,m]
n4.concat [:b4,:gs4,:a4,:fs4,:g4,:e4,:fs4,:d4,:e4,:cs4,:d4,:e4,:a4,:g4,:fs4,:e4,:d4,:e4]
d4.concat [m,q,q,q,q,q,q,q,q,q,q,m,c,c,c,c,c,m]
#b55
n4.concat [:a3,:d4,:r,:a4,:a4,:a4,:fs4,:d4,:e4,:fs4,:g4,:a4,:fs4,:b4,:g4,:a4,:fs4,:g4,:e4,:fs4,:d4,:e4,:d4,:e4]
d4.concat [m,b,m,c,q,q,q,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,q,c]
n4.concat [:d4,:a3,:r,:cs5,:a4,:b4,:gs4,:a4,:fs4,:gs4,:a4,:gs4,:a4,:r]
d4.concat [m,m,q,sq,sq,sq,sq,sq,sq,q,c,q,m,m]
#b62
n4.concat [:r,:e5,:e5,:e5,:cs5,:a4,:b4,:cs5,:d5,:e5,:cs5,:fs5,:d5,:e5,:cs5,:d5,:b4,:cs5,:a4,:b4,:a4,:b4,:a4,:r,:d5,:d5,:d5,:d5,:fs5,:e5,:d5,:d5]
d4.concat [q,q,q,q,q,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,sq,q,q,c,sqd,dsq,q,q,q,q,sq,sq,q,q]
n4.concat [:d5,:d5,:cs5,:d5,:cs5,:d5,:r,:d4,:d4,:d4,:d4,:g4,:d4,:g3,:d4,:a3,:d4]
d4.concat [cd,q,q,c,q,sqd,dsq,q,q,q,m,q*1.1,q*1.2,q*1.3,q*1.4,q*1.5+q*1.6+q*1.7+q*1.8,b*1.3]
#end

#level control arrays
a=[mf,ff,mf,f,ff,mf,f,mf,f,mf,f,mf,f,ff] #dynamic target
as=[0,0,0,0,0,0,3*b-c,0,4*b,2*b-m,3*b,5*b-m,0,0] #slide times
#ad contains times between each level change
ad=[10*b+m+q,2*b,7*b-m,3*b,b+3*c-q,2*b-m,4*b-c,3*b,13*b,2*b+m,3*b,13*b+q-m,2*b,3*b-q+(3.6*q+0.3*b)] #rit time 3.6*q+0.3*b added

set_bpm(85)
puts "check equal..."
puts len(d1)
puts len(d2)
puts len(d3)
puts len(d4)
puts len(ad)

with_fx :reverb,room: 0.6,mix: 0.4 do #add reverb
  with_fx :level do |amp|
    in_thread do
      plct(amp,a,as,ad,s,1) #control level (with printed output)
    end

    in_thread do
      plarray(inst0,samplepitch0,n1,d1,-4,0.7,-0.7) #trmpt 1
    end
    in_thread do
      plarray(inst0,samplepitch0,n2,d2,-4,0.7,-0.3) #trmpt 2
    end
    in_thread do
      plarray(inst0,samplepitch0,n3,d3,-4,0.7,0.3) #trmpt 3
    end
    plarray(inst0,samplepitch0,n4,d4,-4,0.7,0.7) #trmpt 4
  end
end