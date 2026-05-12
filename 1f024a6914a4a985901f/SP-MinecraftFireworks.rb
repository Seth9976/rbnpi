#Sonic Pi/Minecraft Firework display coded by Robin Newman, April 2015
#requires SP 2.5dev or later
#requires Pi(2)
#Used in conjunction with Handel's Royal Fireworks minuet coded for SP
#placed in a separate workspace and cued form this progarm.
use_debug false
mc_set_area :air,-127,-20,-127,127,127,127 #clear a large area in the world
mc_set_area :grass,-60,-1,-60,60,0,60 #to stand on

sleep 6 #wait for this all to complete.
cue :fireworks #cue the music program
#set up some variables
s=0 #gap between placing blocks set to 0 for max speed
angresolution=2 #angular increment between points in degrees

#use Ruby Math package to define some trig stuff
pi=Math::PI #from Ruby Math module
define :cos do |v| #set up call to Math cosine
  return Math.cos(v)
end
define :sin do |v| #set up call to Math sine
  return Math.sin(v)
end
define :rad do |v|
  return v * Math::PI/180
end

define :circle do |brick,xs,ys,zs,r,updown,ang=angresolution|
  if updown == 1 then
    0.step(360,ang) do |i|
      mc_set_block brick,xs + r*sin(rad(i)),ys+r*cos(rad(i)),zs
      sleep s
    end
  else
    360.step(0,-ang) do |i|
      mc_set_block :air,xs + r*sin(rad(i)),ys+r*cos(rad(i)),zs
      sleep s
    end
  end
  #sleep 0.1
end
define :target do |xs,ys,zs|
  1.downto(0) do |v|

    circle(:iron,xs,ys,zs,1,v,16)
    circle(:iron,xs,ys,zs,2,v,16)
    circle(:iron,xs,ys,zs,3,v,8)
    circle(:iron,xs,ys,zs,4,v,8)

    circle(:gold,xs,ys,zs,5,v,4)
    circle(:diamond,xs,ys,zs,6,v,4)
    circle(:iron,xs,ys,zs,7,v,4)

    2.times do |i|
      circle(:gold,xs,ys,zs,8+3*i,v)
      circle(:diamond,xs,ys,zs,9+3*i,v)
      circle(:iron,xs,ys,zs,10+3*i,v)
    end
  end
end
mc_teleport 0,30,0
flag=0
in_thread do
  sync :finish
  flag=1
  sleep 2
end
until flag == 1 do
    in_thread {sample :ambi_lunar_land,rate: 1.5,release: 3.5,amp: 2}
    sleep 2
    target(rrand_i(-15,15),30,rrand_i(8,35))
    sleep rrand_i(3,6)
  end
  mc_chat_post "Sonic Pi and Minecraft, perform Handel's Royal Fireworks Music"
  mc_chat_post "Coded by Robin Newman, April 2015"