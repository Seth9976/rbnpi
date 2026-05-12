#In Dulci Jubilo transcribed for Sonic Pi 2.1.1 by Robin Newman December 2014
#this piece features the use of a separate dynamics track adjusting the amplitude of the parts
#This utilises the use of the fx_level effect, and also uses the amp_slide: parameter to achive
#crescendos and diminuendos
#
set_sched_ahead_time! 2
use_debug false
use_synth :tri

s=0 #set s here with dummy value so that its scope is global

define :setbpm do |n| #set bpm equivalent
  s = (1.0 / 8) *(60.0/n.to_f)
end

setbpm(200)

dsq = 1 * s #note length definitions (not all used)
sq = 2 * s
q= 4 * s
qd = 6 * s
c = 8 * s
cd = 12 * s
m = 16 * s
md = 24 * s
b = 32 * s
bd = 48 * s

p = 0.1 #set dynamic levels here
mp = 0.2
mf = 0.3
f = 0.5
ff = 0.7

ps=m #adjust elongation for pauses

define :pl do |notes,durations,vol=1| #default volume 1, multiplied by level setting
  notes.zip(durations).each do |n,d|
    play n,attack: dsq*0.2,sustain: 0.9*d-dsq*0.2,release: 0.1*d,amp: vol
    sleep d
  end
end

#define the four pairs of note and duration parts
n1=[:f4,:f4,:f4,:a4,:bb4,:c5,:d5,:c5,:c5,:f4,:f4,:a4,:bb4,:c5,:d5,:c5]
d1=[c,m,c,m,c,m,c,m,c,m,c,m,c,m,c,md+ps]
#b9
n1.concat [:c5,:d5,:c5,:bb4,:a4,:f4,:f4,:g4,:g4,:a4,:g4,:f4,:g4,:a4,:a4,:c5,:d5,:c5,:bb4,:a4]
d1.concat [m,c,m,c,md,m,c,m,c,m,c,m,c,m,c,m,c,m,c,md]
#b20
n1.concat [:f4,:f4,:g4,:g4,:a4,:g4,:f4,:g4,:a4,:d4,:d4,:e4,:e4,:f4,:c5,:a4,:bb4,:g4,:g4,:f4]
d1.concat [m,c,m,c,m,c,m,c,md,m,c,m,c,md,md,m,c,m,c,m+ps]
#end
n2=[:c4,:d4,:c4,:f4,:e4,:d4,:c4,:f4,:e4,:f4,:d4,:c4,:f4,:e4,:d4,:c4,:f4,:e4]
d2=[c,m,c,cd,q,c,m,c,m,c,m,c,cd,q,c,m,c,md+ps]
#b9
n2.concat [:f4,:f4,:e4,:g4,:c4,:f4,:f4,:f4,:f4,:f4,:e4,:f4,:f4,:f4,:f4,:e4,:g4,:c4]
d2.concat [m,c,m,c,md,m,c,m,c,m,c,md+m,c,m,c,m,c,md]
#b20
n2.concat [:f4,:f4,:f4,:f4,:f4,:e4,:f4,:d4,:d4,:e4,:e4,:d4,:e4,:f4,:f4,:f4,:e4,:f4]
d2.concat [m,c,m,c,m,c,md*2,m,c,m,c,md,md,m,c,m,c,m+ps]
#end
n3=[:a3,:bb3,:a3,:c4,:d4,:a3,:bb3,:g3,:a3,:bb3,:a3,:c4,:d4,:a3,:bb3,:g3]
d3=[c,m,c,m,c,m,c,m,c,m,c,m,c,m,c,md+ps]
#b9
n3.concat [:c4,:bb3,:g3,:e3,:f3,:a3,:a3,:d4,:d4,:c4,:d4,:bb3,:a3,:bb3,:c4,:d4,:c4,:bb3,:g3,:e3,:f3]
d3.concat [m,c,m,c,md,m,c,m,c,cd,q,c,m,c,m,c,m,c,m,c,md]
#b20
n3.concat [:a3,:a3,:d4,:d4,:c4,:d4,:bb3,:a3,:bb3,:c4,:a3,:a3,:g3,:g3,:a3,:bb3,:g3,:f3,:bb3,:d4,:c4,:a3]
d3.concat [m,c,m,c,cd,q,c,m,c,md,m,c,m,c,m,c,md,m,c,m,c,m+ps]
#end
n4=[:f3,:f3,:f3,:f3,:f3,:f3,:f3,:f3,:f3,:f3,:f3,:f3,:c3]
d4=[c,m,c,m,c,md+m,c,m,c,m,c,md,md+ps]
#b9
n4.concat [:a2,:bb2,:c3,:c3,:f3,:d3,:d3,:bb2,:bb2,:c3,:c3,:f3,:d3,:a2,:bb2,:c3,:c3,:f3]
d4.concat [m,c,m,c,md,m,c,m,c,m,c,md+m,c,m,c,m,c,md]
#b20
n4.concat [:d3,:d3,:bb2,:bb2,:c3,:c3,:f3,:f3,:f3,:e3,:e3,:d3,:c3,:f3,:d3,:bb2,:c3,:f2]
d4.concat [m,c,m,c,m,c,md*2,m,c,m,c,md,md,m,c,m,c,m+ps]
#end

#These check that the note and duration pairs all match in length: uncomment for debugging
comment do
  puts n1.length
  puts d1.length
  puts n2.length
  puts d2.length
  puts n3.length
  puts d3.length
  puts n4.length
  puts d4.length
end

define :ct do |ptr,lev,slid=0| #this reduces the typing required for the control commands
  control ptr,amp: lev,amp_slide: slid
end
with_fx :reverb,room: 0.4,mix: 0.5 do
  with_fx :level do |x| #use fx level to give dynamic volume setting
    1.upto(4) do |i| #four verses. Index i used to change dynamic ending for the last verse
      puts "verse "+i.to_s
      sleep m #gives slight gap between verses
      in_thread do #volume control thread
        ct(x,p,0) #set the first dynamic level
        sleep c+md*2 #these sleep commands space out the dynamic changes to the correct points
        ct(x,mp,md+m) #b3
        sleep md+m
        ct(x,p,0) #b4 (3rd beat)
        sleep c+md*2
        ct(x,mf,md) #b7
        sleep md*2+ps
        ct(x,p,0) #b9
        sleep md*6
        ct(x,mf,md*3) #b15
        sleep md*3
        ct(x,p,md*2) #b18
        sleep md*5
        ct(x,f,md*2) #b23
        sleep md*4
        ct(x,ff,md*2) #b27
        if i<4
        then
          sleep md*2
          ct(x,mp,md*2) #b29
          sleep md*3+ps
        else
          sleep md*5+ps
        end
      end #end of volume level control thread

      #all 4 parts play together in seperate threads
      in_thread do
        pl(n1,d1)
      end
      in_thread do
        pl(n2,d2)
      end
      in_thread do
        pl(n3,d3)
      end
      pl(n4,d4)
    end #of 4 times loop
  end #end with fx_level
end #end with fx_reverb
