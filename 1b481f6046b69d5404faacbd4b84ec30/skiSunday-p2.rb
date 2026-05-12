#Ski Sunday arranged for SP by Robin Newman April 2016
#original piece Pop Looks Bach by Sam Fonteyn
#Run the sample loader program first, then this program.
#set_sched_ahead_time! 4  #uncomment for Pi2 or Pi3

path="~/Desktop/Sonatina Symphonic Orchestra/Samples/" #adjust as necessary
voices=[["1st Violins sus","1st Violins","1st-violins-sus-",1,:g3,:b6],\
        ["Clarinets","Clarinets","clarinets-sus-",2,:d3,:d6],\
        ["Flutes sus","Flutes","flutes-sus-",0,:c3,:bb5],\
        ["Trombones sus","Trombones","trombones-sus-",1,:ds2,:e5],\
        ["Trumpet","Trumpet","trumpet-",1,:e3,:f6],\
        ["Trumpets sus","Trumpets","trumpets-sus-",1,:e3,:f6],\
        ["Trumpets stc","Trumpets","trumpets-stc-rr1-",1,:e3,:f6],\
        ["Horns stc","Horns","horns-stc-rr1-",1,:e2,:e5],\
        ["Timpani f lh","Percussion","timpani-f-lh-",0,:c1,:c2]]
#######
q=0.15 #set note duration of quaver
qd=3*q/2 #dotted quaver
sq=q/2 #semiquaver
c=2*q #crotchet
cd=3*q #dotted crotchet
m=2*c #minim

sc= :drum_cymbal_closed #used for drum part
use_synth :supersaw #used for accompanying part
#set up note lists
d=(ring q,q,q,q,c,q,q) #drum rhythm
nt=[:a1,:a1,:d2,:r,:a1,:a1,:d2,:r,:a1,:a1,:d2] #timpani part
dt=[q,q,m,5*c,q,q,m,5*c,q,q,m]
#nv.nva,nvb violin parts
nv=[:r,:a5,:g5,:a5,  :fs5,:a5,:e5,:a5,  :d5,:a5,:cs5,:a5,  :d5,:a5,:e5,:a5,  :fs5,:a4,:d5,:cs5,  :b4,:d5,:a4,:d5,  :g4,:d5,:fs4,:d5,  :g4,:d5,:a4,:d5,  :b4,:d5,:g5,:fs5,  :e5,:g5,:d5,:g5,  :cs5,:g5,:b4,:g5,]
nva=[:cs5,:g5,:d5,:g5,  :e5,:a4,:a5,:g5,  :fs5,:e5,:fs5,:g5,  :a5,:fs5,:e5,:d5,  :e5,:a5,:fs5,:a5,  :g5,:e5,:cs5,:a4]
nvb=[:cs5,:g5,:d5,:g5,  :e5,:a4,:a5,:g5,  :fs5,:e5,:fs5,:gs5, :a5,:e5,:cs5,:e5,  :d5,:cs5,:b4,:cs5, :d5,:e5,:fs5,:gs5,:a5]
dva=[m+q]+[q]*(((nv+nva).length)-1)
dvb=dva+[q]
#hna,hnb harmony part played by supersaw synth
hn=[:r,:d5,:cs5,:d5,:e5,:fs5,:d5, :g5,:fs5,:e5,:d5,:e5,:fs5,:g5,:b5, :cs6,:b5,:a5,:g5,:a5,:b5]
hn2=[:cs6,:a5,:g5,:e5,:d5,:cs5,:d5,:e5,:fs5,:a5,:b5,:g5,:a5,:a4]
hn3=[:cs6,:a5,:g5,:e5,:d5,:cs5,:d5,:b4,:cs5,:a4,:e5,:fs5,:e5,:d5,:fs5,:gs5,:fs5,:gs5,:b5,:a5]
hna=hn+hn2
hnb=hn+hn3
hda=[6*c]+[c]*20 +[q]*12+[m,m]
hdb=[6*c]+[c]*20 +[q]*8+[c]+[q]*10+[m]
#cn,bn1,bn,cn2 with dur. dn1,cd2,dn brass chords
cn=[[:fs4,:a4,:d5],[:fs4,:a4,:d5],[:g4,:a4,:d5],[:g4,:a4,:d5],[:g4,:a4,:d5],[:fs4,:a4,:d5],[:fs4,:a4,:d5],[:fs4,:a4,:d5],[:g4,:a4,:d5]]
bn1=[:r]+cn
bn=bn1 * 2
dn1=[c,q,q,c,q,q,c,q,q,c,c]
cn2=[:r,[:a5,:c6],:r,[:d5,:g5,:b5],[:cs5,:e5,:a5]]
cd2=[q,q,c,cd,q]
dn=[2*c,q,q,c,q,q,c,q,q,c,m,q,q,c,q,q,c,q,q,q]
#nf,nf2 flute part middle section with dur df,df2
nf=[:r,:d5,:f5,:g5,:f5,:ab5,:f5,:g5,:f5,:d5,:f5,:g5]
df=[c,q,q,c,q,c,q,c,q,q,q,q]
nf2=[:r,:d5,:a4,:c5,:d5,:f5,:d5,:f5,:d5]
df2=[c,q,q,c,q,c,q,c,m]
#njab sustained and stac brass chords at end of middle section with dur djab
njabsus=[:r,:r,[:g4,:b4,:d5,:g6],:r,:r,[:g4,:b4,:d5,:g6],:r,   :r,[:f4,:a4,:c5,:f5],[:g4,:b4,:d5,:g5],:r,:r]
djab=[q,m,cd,q,m,cd,q,q,c,c,q,q]
njabst=[[:a4,:e5,:a6],:r,:r,[:a4,:e5,:a6],:r,:r,[:a4,:e5,:a6], :r,:r,:r,[:gs4,:c5,:ds5,:gs5],[:a4,:cs5,:e5,:a6]]
#last play-through and coda violin part ncoda, with dur dcoda
ncoda=nv+[:cs5,:g5,:d5,:g5,  :e5,:a4,:a5,:g5, :fs5,:e5,:fs5,:g5, :a5,:fs5,:e5,:d5, :e5,:fs5,:g5,:fs5, :g5,:a5,:b5,:cs6, :d6,:d5,:fs5,:a5, :g5,:e5,:g5,:a5]
ncoda.concat [:fs5,:d5,:fs5,:a5, :g5,:e5,:g5,:a5]*3+[:d6,:cs6,:b5,:a5, :b5,:a5,:b5,:cs6, :d6,:cs6,:b5,:a5, :b5,:a5,:b5,:cs6,[:fs5,:a5,:d6]]
dcoda=[m+q] +[q]*nv.length+[q]*71+[c]
#flute part final 7 bars nfcoda with dur dfcoda
nfcoda=([:d6]*12+[:d6,:cs6,:b5,:a5])*2+[:d6,:cs6,:b5,:a5, :b5,:a5,:b5,:cs6, :d6,:cs6,:b5,:a5, :b5,:a5,:b5,:cs6,[:fs5,:a5,:d6]]
dfcoda=[q]*48+[c]
#riffs used in plucked bass part (see functions in loader prog)
riffd=[c,q,q,q,q,q,q]
bsnbase=riff(:d2,:a1)*6+riff(:g1,:d2)+riff(:g2,:b1)+riff(:cs2,:e2)+riff2(:a2,:e2,:cs2)
bsna=bsnbase+[:d2,:cs2,:b1,:b1,:e1,:e1,:a2,:a2]
bsnb=bsnbase+[:d2,:b1,:cs2,:a2,:b1,:b1,:e2,:e2]
bsnc=bsnbase+[:d2,:d2,:b1,:b1,:e2,:e2,:a2,:a2]+riff(:d3,:a2)*6+[:d2]
bsd=riffd*10+[cd,q,cd,q,cd,q,c,c]
bsn2=riff(:a1,:e2)+riff(:a2,:e2)+[:a1,:c2,:r,:b1,:a1]
bsd2=riffd*2+[q,q,c,cd,q]
bsn3= [:r,:cs1,:e1,:a1,:e1]+riff3(:g1,:b1,:d2)*2+riff3(:d2,:f2,:a2)*2+riff3(:g1,:b1,:d2)*2+[:a1,:r,:g1,:a1,:r,:g1,:a1,:r,:f1,:g1,:gs1,:a1]
bsd3= [c*2,q,q,q,q]+riffd*6+[q,m,cd,q,m,cd,q,q,c,c,q,q]
#flute chords in last few bars nfc, nfinals with dur dfinals
nfc=[[:d4,:fs4,:a4],[:d4,:fs4,:a4],[:d4,:g4,:a4]]
nfinals=([:r]+nfc)*6+[[:d4,:a4,:d5]]
dfinals=[c,q,q,m]*6+[c]
#hn horn part final few bars hn with dur hd
hn=[:r,:fs4,:fs4,:g4,:fs4]*6
hd=[c,q,q,m]+[q,q,q,q,m]*5 + [c]

################ plarray and plnarray defined in loader prog
define :sec1 do #first repeated section bars 6-16,40-50,74-84
  in_thread do
    plarray(nv+nva,dva,"1st Violins sus",2)
  end
  in_thread do
    plnarray(hna,hda,0.22,-12)
  end
  sleep 35*c
  in_thread do
    plarray(bn,dn,'Trombones sus')
  end
  in_thread do
    plarray(bn,dn,'Trumpets sus')
  end
  in_thread do
    plarray(nt,dt,"Timpani f lh")
  end
  sleep 13*c
end
define :sec2 do #bars 17-39, 51-73 #second repeated section
  in_thread do
    plarray(nv+nvb,dvb,"1st Violins sus",2)
  end
  in_thread do
    plnarray(hnb,hdb,0.22,-12)
  end
  sleep 36*c
  in_thread do
    plarray(bn1,dn1,'Trombones sus',0.8,0.90,0.1,7) #transposed up 7
  end
  in_thread do
    plarray(bn1,dn1,'Trumpets sus',0.8,0.90,0.1,7)
  end
  sleep 8*c
  in_thread do
    plarray(cn2,cd2,'Trumpet',1.2)
  end
  in_thread do
    plarray(cn2,cd2,'Trumpets sus',1.2)
  end
  plarray(cn2,cd2,'Trombones sus',1.2,0.90,0.1,-12) #transposed down 12
  in_thread do
    drfall(:a2,sq,0.5) #drum fall (see loader prog)
  end
  sleep 4*c
  in_thread do
    plarray(nf+nf2+nf,df+df2+df,"Clarinets")
  end
  plarray(nf+nf2+nf,df+df2+df,"Flutes sus")
  in_thread do # drum roll acccompaniment next 2 bars
    2.times do
      sleep c
      dr(c,0.6) #drumroll
      sleep m
    end
  end
  in_thread do
    plarray(njabsus,djab,'Trumpets sus',1)
  end
  plarray(njabst,djab,'Trumpets stc',1,1.2,0.5)
  in_thread do
    drfall(:a2,sq,0.5) #drum fall
  end
end

###### start playing here ############
with_fx :level,amp: 3 do
  with_fx :reverb,room: 0.8 do
    live_loop :barnumbers do #print bar number info
      puts "Bar "+(tick + 1).to_s
      sleep 4*c
      if look== 99
        stop
      end
    end
    sleep 3*c #1st three beats bar 1
    live_loop :cm,delay: c do #closed cymbal riff starts bar 2
      sample sc,beat_stretch: c,amp: 0.3
      sleep d.tick
      if look==7*98 #notes in riff * bars: stop at end of bar 99
        stop
      end
    end
    #intro starts 4th beat bar 1
    in_thread do
      plarray(bn,dn,'Trombones sus')
    end
    in_thread do
      plarray(bn,dn,'Trumpets sus')
    end
    in_thread do
      plarray(nt,dt,"Timpani f lh")
    end
    in_thread do #start plucked bass
      with_synth :pluck do #bass pluck bars 1-39
        sleep c
        pluckarray(bsna+bsnb+bsn2+bsn3,bsd*2+bsd2+bsd3,0.3)
      end
    end
    sleep 13*c #time for intro to complete
    sec1 #bars 6-16
    sec2 #bars 17-39
    
    in_thread do
      with_synth :pluck do
        #bars 40-73 start bsna 4 bars in(after 28 elements):ignores intro
        pluckarray([:r]+bsna[28..-1]+bsnb+bsn2+bsn3,[c*4]+bsd[28..-1]+bsd+bsd2+bsd3,0.3)
        #bars 74-100 again ingore intro in bsna
        pluckarray([:r]+bsna[28..-1]+bsnc,[c*4]+bsd[28..-1]+bsd+riffd*6+[c],0.3)
      end
    end
    sec1 #bars 40-50
    sec2 #defined in part 1 bars 51-73
    sec1 #bars 74-84
    in_thread do
      plarray(ncoda,dcoda,"1st Violins sus",2) #bars 85-100
    end
    sleep 36*c #delay to bar 94
    in_thread do
      plarray(nfinals,dfinals,'Trumpets sus',1.2) #bars 94-100
    end
    in_thread do
      plarray(hn,hd,'Horns stc',0.7) #bars 94-100
    end
    in_thread do
      plarray(nfcoda,dfcoda,"Flutes sus") #bars 94-100
    end
  end
end
