#Fanfare for St Cecilia's Hall by Andrew Blair, first performed 29th November 2017
#at the official opening of St Cecilia's Hall  by HRH The Princess Royal, following a major refurbishment

#coded by Robin Newman, December 2017, with the composer's permission
use_bpm 85
use_synth :saw
with_fx :reverb, room: 0.8,mix: 0.8 do
  define :plarray do |notes,durations,pan=0,amp =0.5|
    notes.zip(durations).each do |n,d|
      play n,sustain: d*0.9,release: d*0.1,amp: amp,pan: pan
      sleep d
    end
  end
  b=4;md=3;m=2;cd=1.5;c=1;qd=0.75;q=0.5;sqd=0.375;sq=0.25;dsq=0.125
  
  n1=[:c4,:g4,:c5,:f5,:bb5,:f5,:c6,:g5,:g5,:bb5,:f5,:e5,:d5,:e5,:r]
  d1=[c,c,c,c,m,m,m,cd,q,m,md,q,q,m+md,c+c]
  n1b=[:c5,:g4,:c5,:c5,:c5,:c5,:g4,:c5,:c5,:d5,:e5,:d5,:e5,:d5,:c5,:g5,\
       :d5,:g4,:g4,:g4,:e5,:d5,:f5,:e5,:d5,:c5,:d5,:c5,:d5,:e5,:r,:c5,:g4,:c5,:c5,:c5,:c5,:g4,:c5]
  d1b=[q,q,qd,dsq,dsq,q,q,c,sq,sq,c,dsq/2,dsq/2,dsq,sq,m,\
       qd,dsq,dsq,q,q,cd,q,sq,sq,q,qd,dsq,dsq,m,q,q,q,qd,dsq,dsq,q,q,c]
  n1c=[:c5,:d5,:e5,:d5,:e5,:d5,:c5,:g5,:f5,:e5,:d5,:e5,:f5,:e5,:d5,:e5,:f5,:g5,:g5,:c6,:e5,:f5,:g5,:g5,:c5,:r,:g4]
  d1c=[sq,sq,c,dsq/2,dsq/2,dsq,sq,m,cd,sq,sq,dsq/2,dsq/2,dsq,sq,sq,sq,q,q,q,sq,sq,q,q,c,q,q]
  n1d=[:c5,:c5,:c5,:d5,:e5,:d5,:e5,:d5,:g4,:g4,:g4,:d5,:d5,:d5,:e5,:f5,:e5,:f5,:e5,:d5,:c5,:c5,\
       :af5,:f5,:f5,:g5,:af5,:g5,:e5,:g5,:c6,:g5,:r,:g4]
  d1d=[qd,sq,q,sq,sq,dsq/2,dsq/2,dsq+q,sq,q,q,qd,sq,q,sq,sq,dsq/2,dsq/2,dsq+q,sq,q,q,qd,sq,q,sq,sq,c+sq,sq,sq,sq,m+cd,sq,q]
  n1e=[:c5,:g4,:e4,:g4,:c5,:d5,:e5,:d5,:e5,:d5,:g4,:g4,:g4,:g4,:d5,:c5,:d5,:e5,:d5,:e5,:f5,\
       :e5,:f5,:e5,:d5,:e5,:d5,:c5,:c5,:c5,:g4,:c5,:e5,:d5,:e5,:d5,:c5,:d5,:e5,:d5,:e5,:g5]
  d1e=[sqd,dsq,sqd,dsq,q,sq,sq,dsq/2,dsq/2,dsq+sq,sqd,dsq,q,q,    sqd,dsq,sqd,dsq,q,sq,sq,dsq/2,dsq/2,dsq,sq,sq,sq,q,q,q,q,q,sq,sq,dsq,dsq,sq,sq,sq,q,sq,sq]
  n1f=[:c6,:e5,:f5,:g5,:g5,:c5,:r,:c4,:g4,:c5,:f5,:bb5,:ab5,:g5,:ab5,:g5,:f5,:c6,:g5,:g5,\
       :bb5,:f5,:e5,:f5,:e5,:d5,:e5,:r]
  d1f=[q,sq,sq,q,q,m,sq,c,c,c,c,cd,q,dsq/2,dsq/2,dsq+sq+q,c,m,cd,q,m,md,dsq/2,dsq/2,dsq+sq,q,b+q,q+c]
  
  n2=[:c4,:g4,:c5,:d5,:bb4,:c5,:g4,:g4,:bb4,:g4,:c5,:c4,:r]
  d2=[m,c,m,m,c,m,cd,q,md,c,b,md,c+c]
  n2b=[:r,:c4,:g4,:c4,:c4,:c4,:c4,:g4,:c5,:c5,:d5,:e5,:e5,:f5,:e5,:d5,:c5,:g4,:g4,:g4,:g4,:g4,:d5,:c5,:g4,:g4,:g4,:c4,\
       :r,:r,:c5,:g4,:c4,:c4,:c4]
  d2b=[c,cd,q,qd,dsq,dsq,q,q,c,sq,sq,q,dsq/2,dsq/2,dsq+sq,sq,sq,m,qd,dsq,dsq,q,q,q,q,qd,sq,m,q,    c,cd,q,qd,dsq,dsq]
  n2c=[:c4,:g4,:c5,:c5,:d5,:e5,:e5,:f5,:e5,:d5,:c5,:d5,:g4,:g4,:c5,:g4,:c5,:d5,:e5,:g4,:g4,:g3,:g3,:c4,:r,:g4]
  d2c=[q,q,c,sq,sq,q,dsq/2,dsq/2,dsq+sq,sq,sq,qd,sq,c,sq,sq,sq,sq,q,q,c,qd,sq,c,q,q]
  n2d=[:c4,:c4,:g3,:g3,:g3,:g3,:c4,:c4,:c4,:c4,:e4,:g4,:c5,:g4,:g4,:g4,:g4,:r,:g4]
  d2d=[cd,q,cd,q,cd,q,cd,q,cd,q,c,q,q,cd,sqd,dsq,cd,sq,q]
  n2e=[:c4,:e4,:c4,:g3,:g3,:g3,:g4,:e4,:c4,:c4,:c4,:g3,:c4,:e4,:g4,:c5,:g4,:g4,:g4]
  d2e=[c,qd,sq,cd,q,c,qd,sq,cd,q,q,q,q,q,qd,sq,q,sq,sq]
  n2f=[:c5,:e4,:g4,:g4,:c4,:r,:c4,:g4,:c5,:d5,:bb4,:c5,:g4,:g4,:bb4,:g4,:c5,:c4,:c4,:c4,:c4,:r]
  d2f=[q,q,q,q,m,sq,m,c,m,m,c,m,cd,q,md,c,md,qd,dsq,dsq,m+q,q+c]
  
  
  use_transpose -2
  in_thread do
    plarray(n1,d1,-0.5)
  end
  plarray(n2,d2,0.5)
  in_thread do
    plarray(n1b,d1b,-0.5)
  end
  plarray(n2b,d2b,0.5)
  in_thread do
    plarray(n1c,d1c,-0.5)
  end
  plarray(n2c,d2c,0.5)
  in_thread do
    plarray(n1d,d1d,-0.5)
  end
  plarray(n2d,d2d,0.5)
  in_thread do
    plarray(n1e,d1e,-0.5)
  end
  plarray(n2e,d2e,0.5)
  in_thread do
    plarray(n1f,d1f,-0.5)
  end
  plarray(n2f,d2f,0.5)
  
end #reverb